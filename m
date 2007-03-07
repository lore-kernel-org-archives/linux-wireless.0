Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55336
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992468AbXCGW3E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2007 17:29:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Problem with USB1.1 Host cores with the mb tree for bcm43xx_mac80211
Date: Wed, 7 Mar 2007 23:28:06 +0100
Cc: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
References: <45EF2015.8000802@lwfinger.net>
In-Reply-To: <45EF2015.8000802@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703072328.06195.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 07 March 2007 21:27, Larry Finger wrote:
> If you have a BCM4311 and are seeing an oops that looks like this when loading bcm43xx_mac80211:
> 
> ssb: Switching to ChipCommon core, index 0
> ssb: Switching to PCI-E core, index 3
> ssb: Switching to USB 1.1 Host core, index 2
> 
> Unable to handle kernel NULL pointer dereference at 00000000000002d0 RIP:
>  [<ffffffff8812fcfd>] :usbcore:usb_create_hcd+0x3b/0xe8
> PGD 3e792067 PUD 3ed66067 PMD 0
> Oops: 0002 [1] SMP
> ...
> 
> there is a temporary, unofficial patch at
> ftp://lwfinger.dynalias.org/patches/mac80211_usb_problem.patch. Although it works, it attacks the
> symptom, not the cause, and will never be adopted into the code. Once a proper fix is applied, it
> will no longer be needed.

A patch to disable the USB core on non-embedded devices is in my tree now.
The actual bug is still there, but nobody (except OpenWRT developers ;) )
should be able to hit it anymore now. :)

-- 
Greetings Michael.
