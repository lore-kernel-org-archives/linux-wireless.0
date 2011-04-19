Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:54704 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1DSF4j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 01:56:39 -0400
Received: from mail.atheros.com ([10.234.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 22:56:13 -0700
Date: Tue, 19 Apr 2011 11:26:20 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Kalle Valo <kvalo@adurom.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 02/22] ath9k_hw: Take care of few host interface
	register changes for AR9340
Message-ID: <20110419055620.GC21802@vasanth-laptop>
References: <1302613042-1754-1-git-send-email-vasanth@atheros.com> <1302613042-1754-3-git-send-email-vasanth@atheros.com> <87sjtml8cw.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <87sjtml8cw.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 13, 2011 at 04:35:19PM +0530, Kalle Valo wrote:
> Vasanthakumar Thiagarajan <vasanth@atheros.com> writes:
> 
> > -#define AR_WA                		0x4004
> > +#define AR_WA			(AR_SREV_9340(ah) ? 0x40c4 : 0x4004)
> 
> So now allthe macros require this ah variable? That's confusing as
> that's not visible when using the macro.

All register read/write functions require ath9k hw structure (ah) to
be available anyway, so it is reasonable to assume that ah will be available to
determine that register offset as well.

Vasanth
