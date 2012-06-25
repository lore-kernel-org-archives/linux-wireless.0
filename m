Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f51.google.com ([209.85.213.51]:39951 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab2FYPlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 11:41:44 -0400
Received: by yhnn12 with SMTP id n12so3472394yhn.10
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jun 2012 08:41:44 -0700 (PDT)
Message-ID: <4FE886B3.7020202@lwfinger.net> (sfid-20120625_174150_593774_CCF36035)
Date: Mon, 25 Jun 2012 10:41:39 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Question about BCM43228 and outdated description in MAINTAINERS
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I recently received a donated BCM43228 (14e4:4359) mini-PCIe card. At the 
moment, neither b43 nor brcmsmac support it. Although, grepping the proprietary 
driver wl shows that it would recognize that PCI ID, that driver does not load 
as it requires routine lockdep_init_map(), which is exported only for GPL 
modules. As a result, owners of this device can only use it with Linux if they 
can find a suitable Windows driver for use with ndiswrapper. In my experience, 
that means that 64-bit users are out of luck.

Reverse engineering this device to be able to drive it with b43 would involve a 
lot of effort. If your group is planning on adding it to brcmsmac, then I would 
not undertake this project. To the fullest extent that you can, please advise me 
regarding this matter.

When getting your addresses from file MAINTAINERS, I noticed that it was not 
updated for the name change from brcm80211 to brcmsmac. The current info is as 
follows:

BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
M:
M:      Roland Vossen <rvossen@broadcom.com>
M:      Arend van Spriel <arend@broadcom.com>
M:      Franky (Zhenhui) Lin <frankyl@broadcom.com>
M:      Kan Yan <kanyan@broadcom.com>
L:      linux-wireless@vger.kernel.org
L:      brcm80211-dev-list@broadcom.com
S:      Supported
F:      drivers/net/wireless/brcm80211/

Thanks,

Larry
