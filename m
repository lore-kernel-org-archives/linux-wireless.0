Return-Path: <SRS0=qAu2=SM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07B16C10F14
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 10:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D969A2083E
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Apr 2019 10:16:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730032AbfDJKQa convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Apr 2019 06:16:30 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35147 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728160AbfDJKQa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Apr 2019 06:16:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id s39so1533489edb.2
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2019 03:16:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=8CbFBaBYVxMqwh9I1FsBIBDllvtqpIxlQuUErL2PCZ8=;
        b=p/3GuO3aOec+jIIPIfuDVn0uS+lrXKd+Me/NxCI3nGegQRTdZQzTawOR51aSqycekp
         f4NopGI9446i4i6wZ44POqkJqZ4RhZeUU50O8e2tvXlnflp8hlDwaeex1JWOwwudXbSv
         yUrlWrM80g7o19izP0ZOZlSusxeMrS5NoENlyv1G9nk7twXmmOAKIPuFJoZfqv5/yLZR
         LletIokIO6n2SEfmnqCVao5MyPWttWCUYiPu0nooEQdK+BmYRKFJwr0j/xChy6Wsdv8E
         x6uEQaRlQu7nBpr7X7Oeqveko8aaiA8oD+EFskAJWrZuWcidOo7vRitQ67792bs+AdAC
         BeAw==
X-Gm-Message-State: APjAAAXOLuP3klDg9Z/L/4UCrqiQcejYAP7K4nYFlOP0r9iOMnW66Prv
        SpSmcy51i1KwOIR7FccOV5HwAg==
X-Google-Smtp-Source: APXvYqx6FAO27YT31YnTnLNg8qLIGjXV/5y5JW//hhB5eqY8b1VScTTwpNW1ZJoOsCHu2XLzzMuMpA==
X-Received: by 2002:a50:a5e5:: with SMTP id b34mr26138245edc.260.1554891388888;
        Wed, 10 Apr 2019 03:16:28 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id p16sm10176376eds.61.2019.04.10.03.16.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Apr 2019 03:16:28 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B80F81804A4; Wed, 10 Apr 2019 12:16:27 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     John Crispin <john@phrozen.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
Subject: Re: [RFC V3 1/2] mac80211: add hw 80211 encapsulation offloading support
In-Reply-To: <46dfe65c-3bbf-7923-d358-9acec030f572@phrozen.org>
References: <20190401131416.22646-1-john@phrozen.org> <20190401131416.22646-2-john@phrozen.org> <87k1gcpwgy.fsf@toke.dk> <46dfe65c-3bbf-7923-d358-9acec030f572@phrozen.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 10 Apr 2019 12:16:27 +0200
Message-ID: <87ftqqw4g4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

John Crispin <john@phrozen.org> writes:

> On 02/04/2019 11:50, Toke Høiland-Jørgensen wrote:
>> ieee80211_queue_skb() calls ieee80211_get_txq() which treats skb->data
>> like it contains an 802.11 header. That is probably not the intention
>> here, is it?
>>
>> I guess we could augment the TXQ stuctures to also handle 802.3 frames
>> (and introduce ieee80211_queue_skb_8023())? Or would it be better to
>> have a qdisc on 802.3-mode interfaces and push packets back to that? I
>> guess we'd still benefit from per-station queueing of packets even if
>> they are Ethernet frames, which would mean amending the TXQs would be
>> better?
>>
>> -Toke
>
> Hi Toke
>
> This patch guards the usage of the hdr pointer. hdr is only used for non 
> data frames which are not relevant when doing encap mode. The code will 
> then drop into the same path as for 80211 encapsulated frames. IMHO the 
> patch is correct and we do not need an additional 
> ieee80211_queue_skb_8023()  to benefit from per station TXQs. Let me 
> know if i missed something.

Ah, right, sorry, missed the change to ieee80211_get_txq() :)

-Toke
