Return-Path: <SRS0=atQY=NB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AF55ECDE44
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Oct 2018 11:28:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFB212083E
	for <linux-wireless@archiver.kernel.org>; Sun, 21 Oct 2018 11:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="ryx+ad75"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFB212083E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727501AbeJUTmC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 21 Oct 2018 15:42:02 -0400
Received: from mail.toke.dk ([52.28.52.200]:39633 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbeJUTmC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Oct 2018 15:42:02 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1540121280; bh=paC/OpN7LN/pf3K/j0eLn1wb/LY/uOYSNwd1FD2crd4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ryx+ad756fIhSPnp4PRifF2pdPtP7yGaokb5V5VEHUupg0S2Dg66huJVrW5tREr1i
         OEsYUu2BE1dME8+AAmOb0g9x93bzB8pniKPMMjvzeP9L2riFspPsG2FpDUjnL6bj4U
         b453WCvwW48Ik1MjEAJEcLqvS8d6ca7xN+aEPKLaLfEQONXBlywVxNE7eq6ACkrgo3
         niQ5/+nh8UTDBshTw/hm98oLYFwPuSpOIp3/3wYIp7QLUwOK9xiYAVYPO6jQjaqiJI
         bMZcPrB1GV38dLM2a/Z1jp1wkyviOaXnktPyoX3GcZO+cB9rdkXq7Q+ZmCB44rtWf2
         bcr2xWDBvD1VA==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH 0/6] Move TXQ scheduling and airtime fairness into mac80211
In-Reply-To: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
Date:   Sun, 21 Oct 2018 13:27:58 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <875zxvo7y9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> Toke,
>
> It is been a while since mac80211 TXQ discussion started. Here is the consolidated
> series of mac80211, ath9k and ath10k changes to move TXQ scheduling and airtime
> fairness into mac80211. The major changes w.r.t 5th RFC version are in may_transmit()
> API. Whenever the driver checks deficit for given TXQ, the list will be
> reordered so that driver/firmware RR quickly becomes in sync with mac80211
> list. Also airtime tasklet approach cumbersome and causing regression
> in multi client performance.

Cool, thanks. I'll look at this in more detail later, but in the
meantime, do you have any test results to share? Specifically, how did
you measure that the fairness part actually works? :)

-Toke
