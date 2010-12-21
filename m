Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:23275 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481Ab0LUH34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 02:29:56 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 20 Dec 2010 23:29:40 -0800
Date: Tue, 21 Dec 2010 12:59:43 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Dan Carpenter <error27@gmail.com>
CC: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: smatch stuff: potential read past the end of the buffer
Message-ID: <20101221072943.GA8369@vasanth-laptop>
References: <20101220083041.GQ1936@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20101220083041.GQ1936@bicker>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 20, 2010 at 02:00:41PM +0530, Dan Carpenter wrote:
> Hello Vasanthakumar,
> 
> Smatch complains that in linux-next 60e0c3a7 "ath9k_hw: Eeeprom changes
> for AR9485" means there is a potential read past the end of the buffer
> int ar9300_eeprom_restore_internal().
> 
> drivers/net/wireless/ath/ath9k/ar9003_eeprom.c +3381
> 	ar9300_eeprom_restore_internal(81)
> 	error: buffer overflow 'word' 2048 <= 4099
> 
> "word" is allocated with 2048 bytes:
>         word = kzalloc(2048, GFP_KERNEL);
> 
> "length" can be up to 4099:
>                 if ((!AR_SREV_9485(ah) && length >= 1024) ||
>                     (AR_SREV_9485(ah) && length >= (4 * 1024))) {

Yeah, this looks buggy, the eeprom data length for AR9485 is 1088
bytes only, I'll send out a patch, thanks for reporting this.

Vasanth
