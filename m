Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f171.google.com ([209.85.221.171]:51459 "EHLO
	mail-qy0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab0EOJwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 May 2010 05:52:06 -0400
Received: by qyk1 with SMTP id 1so4404888qyk.5
        for <linux-wireless@vger.kernel.org>; Sat, 15 May 2010 02:52:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BEE689A.9060102@openwrt.org>
References: <1273842938-3401-1-git-send-email-tom.leiming@gmail.com>
	 <1273842969-3435-1-git-send-email-tom.leiming@gmail.com>
	 <4BED5E08.3050000@openwrt.org>
	 <AANLkTikVkBdTopPJlU2lGkafLIkiiviUHe8J-lTy67y9@mail.gmail.com>
	 <4BED7809.3090204@openwrt.org>
	 <AANLkTikV8cAc4Njpa1cXq1BHRExkwbaKwjlyyH52rgqO@mail.gmail.com>
	 <4BEE689A.9060102@openwrt.org>
Date: Sat, 15 May 2010 17:52:03 +0800
Message-ID: <AANLkTikFtb1j7x9-d-SpV8AAODQAxNAobIZePCQNLbip@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: fix dma sync in rx path
From: Ming Lei <tom.leiming@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/5/15 Felix Fietkau <nbd@openwrt.org>:
> The second part of your patch might be OK then (I'm not really sure).
> But the first part is definitely wrong, since with EDMA Rx, the
> descriptor data is part of the buffer, so the cache needs to be
> invalidated for every access until the status bit shows that it has been
> completed.
> This could probably be fixed by running dma_sync_single_for_device after
> an unsuccessful status bit check and also after the descriptor part has

Yes, dma_sync_single_for_device is needed to return buffer to device
if an unsuccessful status bit check is found.

> been zero'd out before passing the buffer on to the hw.

The patch does not touch this dma_sync_single_for_device.


-- 
Lei Ming
