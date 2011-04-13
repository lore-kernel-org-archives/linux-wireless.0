Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:49535 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362Ab1DMLFW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 07:05:22 -0400
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/22] ath9k_hw: Take care of few host interface register changes for AR9340
References: <1302613042-1754-1-git-send-email-vasanth@atheros.com>
	<1302613042-1754-3-git-send-email-vasanth@atheros.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 13 Apr 2011 14:05:19 +0300
In-Reply-To: <1302613042-1754-3-git-send-email-vasanth@atheros.com> (Vasanthakumar Thiagarajan's message of "Tue\, 12 Apr 2011 18\:27\:02 +0530")
Message-ID: <87sjtml8cw.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:

> -#define AR_WA                		0x4004
> +#define AR_WA			(AR_SREV_9340(ah) ? 0x40c4 : 0x4004)

So now allthe macros require this ah variable? That's confusing as
that's not visible when using the macro.

-- 
Kalle Valo
