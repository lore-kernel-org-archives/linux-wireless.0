Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC997C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 22:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF00E2087C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 22:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfCMWzh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 18:55:37 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:33741 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbfCMWzh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 18:55:37 -0400
Received: by mail-ed1-f44.google.com with SMTP id d12so3004173edp.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 15:55:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ThEzivQajH3MEZnXuOcJ60aDGQ8LHJnqBac7DXicpN0=;
        b=qdoQPxXG4ORuXvDpU9WE/EUlfB1fwL36C7Pr/FN8w+oCtsVUl+FHyUeJBKnLeCHcwE
         jehCe+DfDYZvdAtK+/Z+lLSBVB6fuowbWaETHcJ9sr58WE8YlRR3ACeDwQeauuVILMZc
         WWIWWhPA3uI2pPVUNd4c999EtGZ2Evi/U35HBSGmxKlCaEfaevcSl/DPYt+NT4Cmgo//
         ctS+j7q77BBi5stjrauZjmMZKqK4ZbcJbu8EmJnj6C/QGJU2P7AbWL815bU67uR6RkXW
         v8Z1od0FzseqKyuOKLY1xYwjAvJfYtQpqim3jLUumeRqLQ3igc11WWzNhYtix+8I0Ls9
         augA==
X-Gm-Message-State: APjAAAU8rtuHMMqMHE3Ic6mAcBAATAVWyveCuNi5KBMkQwNI7xnmqH3P
        1ayD9A440OJLFFXFSoCvDBAR8RadYzs=
X-Google-Smtp-Source: APXvYqwnuarBSJEasYQvVcVKOSrUoBdeDe8rxjM1LdD978PcfjcWTGKwh770NQ9C0TnGcRohOwt/cw==
X-Received: by 2002:a17:906:7711:: with SMTP id q17mr30839781ejm.174.1552517735667;
        Wed, 13 Mar 2019 15:55:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id w6sm712231eja.50.2019.03.13.15.55.34
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 13 Mar 2019 15:55:34 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CDC6B18200E; Wed, 13 Mar 2019 23:55:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net
Subject: Re: [RFC] mac80211: rework locking for txq scheduling / airtime fairness
In-Reply-To: <20190313181531.62539-1-nbd@nbd.name>
References: <20190313181531.62539-1-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 13 Mar 2019 23:55:33 +0100
Message-ID: <87va0mz8nu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Holding the lock around the entire duration of tx scheduling can
> create some nasty lock contention, especially when processing airtime
> information from the tx status or the rx path.

Right, I can see how that could become an issue at higher loads than
what I tested with :)

> Improve locking by only holding the active_txq_lock for lookups /
> scheduling list modifications.

So the (potential) issue I see with this modification is that it
requires the driver to ensure that it will not interleave two different
scheduling rounds for the same acno. I.e., another call to
schedule_start() will reset the round counter and something needs to
guarantee that this doesn't happen until the driver has actually
finished the previous round.

I am not sure to what extent this would *actually* be a problem. For
ath9k, for instance, there's already the in-driver chan_lock (although
the call to ieee80211_txq_schedule_start() would then have to be moved
into the section covered by that lock). But it does introduce an
implicit dependency in the API, which should at least be documented.

If memory serves, avoiding this implicit dependency was the original
reason I had for adding the full lock around everything. I can't think
of any other reason right now, but if I do think of something I'll be
sure to let you know :)

-Toke
