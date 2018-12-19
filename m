Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B849C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 264FB20874
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="yRyNa0zU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbeLSNMc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 08:12:32 -0500
Received: from mail.toke.dk ([52.28.52.200]:54629 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbeLSNMc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 08:12:32 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1545225149; bh=ue5HP6/E/M6QMPht6KAfJl+qYK3AK+eVPMfbdQLXZ8s=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=yRyNa0zU9D+PXKlCV4sHnRUc2S94iK60ftlVfD1gAS02drA1QFtuu1c4hGEOCdDTx
         NWHfOTsVCOZKDieJ+VJgLjN/s2oj/zCI/XoDmmu4EWPHC7kfmkvGbUlPYOnVKmW2+F
         JL2nTKVCvzNWzEvREaJ5GjwV4jThHabdIw+Un4gAgI/nqjkXTt2OSKXxJ8qDDKnxDU
         oyhf34Tkuy2JU0m2nOK8zlVqwpTVut8MG8SaShsxtlSld5YZ0m7JQPoZVFHHcB3b/p
         vIdSliNqR6uVNYL1/WqacFD/H32B+Y3MegHwa7WNZbSu7BGew6vAlI8kjX/I5CNIGz
         +q111gdjHdA0A==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     make-wifi-fast@lists.bufferbloat.net,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH v5 0/6] Move TXQ scheduling and airtime fairness into mac80211
In-Reply-To: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
Date:   Wed, 19 Dec 2018 14:12:27 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <877eg5hd8k.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> All,
>
> Sorry for the long delay. Here is the consolidated series of mac80211,
> ath9k and ath10k changes for moving TXQ scheduling and airtime fairness
> into mac80211 and support airtime fairness.

Thanks for taking care of the respin!

Johannes, I think it's safe for you to review this version. I have
started working on another approach for the scheduler algorithm itself,
but it is fine to do as an incremental patch on top of this as it
shouldn't impact the API. Having a separate patch also makes testing
easier anyway. I'll see if I can't get it to a working state over the
holidays...

-Toke
