Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:39426 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805AbZLTGvi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Dec 2009 01:51:38 -0500
Received: by iwn1 with SMTP id 1so3053556iwn.33
        for <linux-wireless@vger.kernel.org>; Sat, 19 Dec 2009 22:51:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4b2daf91.VB5IdAW/+fSDNPPV%Larry.Finger@lwfinger.net>
References: <4b2daf91.VB5IdAW/+fSDNPPV%Larry.Finger@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sat, 19 Dec 2009 22:51:17 -0800
Message-ID: <43e72e890912192251r4de4a3c3idb5e4c3723ef87aa@mail.gmail.com>
Subject: Re: [PATCH] b43: Clear PCI configuration reg. 0x41 to avoid
	interference with C3 processor state
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 19, 2009 at 9:01 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In exploring the cause of DMA errors for BCM4312 devices on Atom
> processors, other drivers that work write to PCI configuration
> register 0x40. The code fragment below was found in the open-code
> portion of the Broadcom hybrid wl driver. It is also used in the
> ipw2100 and ath9k drivers. In the latter case, it had been removed
> and later restored to prevent fatal interrupt errors.

I should note 0x40 starts with vendor specific PCI config space so you
cannot guarantee different PCI devices use 0x41 will be used the same
for different devices. The documentation for the ath9k PCI-E devices
used that entry for something completely different but what I did not
do is try to very and ensure PCI devices do not use it it for the
same. I am told though that although this is PCI vendor space some
devices may still use similar private PCI config spaces on different
devices which just follows a practice. At this point we now have not
only b43, ipw and ath9k follow this but also prism54 and I think p54
uses this. I'll note I *highly* doubt this is used for the same thing
on all these devices and was just code copied from other Linux
drivers. In the case of Atheros Linux drivers I know it was copied
form Intel drivers, which is why I started questioning it all.

Anyway, if it helps, that's great :) but it cannot be concluded its
all for the same thing unless you have proper documentation as this is
in PCI vendor space which *can* vary depending on device and vendor.

  Luis
