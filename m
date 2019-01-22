Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E06AC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:23:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CEC420870
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 14:23:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfAVOXL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 09:23:11 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40841 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbfAVOXL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 09:23:11 -0500
Received: by mail-ed1-f67.google.com with SMTP id g22so19423533edr.7
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2019 06:23:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=FnWMso9Vk8AMzqevF7HXk0yBTGOj0AJULkcRWebb7Vg=;
        b=bkhpoJDkr72cc1q5nxNAIUU0Anrpr42bz6s8EFeRcJxRYrjSPB55YzmnFelVPL0+VP
         CLe3NvLaqhQn91pnXxbDhkqdB9JK/r8/jU9rfNjpCO0mhwUc0UFG1divQ08RznoffGVi
         AsZIZmB8UHmXwqvY8oz3RNVrfMr0GlX1NIXcjmdqPtUDotDwWzWsuAr/iJUCEoKJpREc
         6Y7ku52CdfSDnOQFI7eaLuLa45nTOGGx58T44gXVoemPUBD1UjadmxayKdjWc3MJPca2
         i+MITtwF5YChdSrY8j9ehmt+w5OVMaaUc5maf6F/DmMKuGg1ogXsVWdytHxkhG1ecBor
         q7gg==
X-Gm-Message-State: AJcUukeNEA/G3Fl9dwpZvsS62nkYtumOnSaSn5XpqStCnRQM/MQVdj2v
        T65lJVBiiEu2G01dfWtdGTGgFQ==
X-Google-Smtp-Source: ALg8bN7WfYLQHK/edfRIsSWl3W7U3nEJYQP3wrjc1tl1bw8fEahQ780DMboguq6zqZsq+nQjDCDhfA==
X-Received: by 2002:a17:906:b243:: with SMTP id ce3-v6mr28322878ejb.87.1548166989403;
        Tue, 22 Jan 2019 06:23:09 -0800 (PST)
Received: from tohojo-x1-rh.localdomain (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id z13-v6sm5208673ejx.4.2019.01.22.06.23.08
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 22 Jan 2019 06:23:08 -0800 (PST)
Received: by tohojo-x1-rh.localdomain (Postfix, from userid 1000)
        id 584F01833C1; Tue, 22 Jan 2019 15:23:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        ath10k@lists.infradead.org, make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v7 1/4] mac80211: Expose ieee80211_schedule_txq() function
In-Reply-To: <20190122142019.21417-2-toke@redhat.com>
References: <20190122142019.21417-1-toke@redhat.com> <20190122142019.21417-2-toke@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 22 Jan 2019 15:23:07 +0100
Message-ID: <87r2d422lw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke Høiland-Jørgensen <toke@redhat.com> writes:

> Since we reworked ieee80211_return_txq() so it assumes that the caller
> takes care of logging, we need another function that can be called without
> holding any locks. Introduce ieee80211_schedule_txq() which serves this
> purpose.

Hmm, messed up the version number on this one, sorry about that. It was
supposed to be v6 along with the rest...

-Toke
