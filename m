Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:34440 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab2BXHwp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 02:52:45 -0500
Received: by werb13 with SMTP id b13so1250347wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 23:52:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330033977-5741-1-git-send-email-arend@broadcom.com>
References: <1330033977-5741-1-git-send-email-arend@broadcom.com>
Date: Fri, 24 Feb 2012 08:52:39 +0100
Message-ID: <CACna6rwk8xbjbX7uisqAv_y_JYn636orR-VLgNQ908yOYS+i1A@mail.gmail.com> (sfid-20120224_085248_646452_5D7A06C0)
Subject: Re: [RFC] bcma: add support for on-chip OTP memory used for SPROM storage
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	"Saul St. John" <saul.stjohn@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/2/23 Arend van Spriel <arend@broadcom.com>:
> Wireless Broadcom chips can have either their SPROM data stored
> on either external SPROM or on-chip OTP memory. Both are accessed
> through the same register space. This patch adds support for the
> on-chip OTP memory.
>
> Tested with:
> BCM43224 OTP and SPROM
> BCM4331 SPROM
> BCM4313 OTP
>
> This patch is in response so gmane article [1].
>
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/85426

Great, thanks a lot for your work! I'll give it a try with my cards.

May I ask how did you test this with BCM4331? What card (slot) /
machine did you use for your test?


> +       if (bus->drv_cc.core->id.rev >= 31) {
> +               if (!(bus->drv_cc.capabilities & BCMA_CC_CAP_SPROM))
> +                               return false;

One less indent will be fine ;)


> +               srom_control = bcma_read32(bus->drv_cc.core,
> +                                          BCMA_CC_SROM_CONTROL);
> +               return !!(srom_control & BCMA_CC_SROM_CONTROL_PRESENT);

Does any compiler complain on returning sth like 0xF as a bool?


> +       return (chip_status & present_mask) == present_mask;

Same :)


> +       u16 offset = BCMA_CC_SPROM;

I guess we can drop second define offset now?


-- 
Rafał
