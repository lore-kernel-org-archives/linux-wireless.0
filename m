Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37575 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab2DFWoN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2012 18:44:13 -0400
Message-ID: <4F7F71A2.40105@hauke-m.de> (sfid-20120407_004416_719638_D56BBD00)
Date: Sat, 07 Apr 2012 00:43:46 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: brcmsmac on BCM47XX SoCs
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I am currently trying to get brcmsmac running on my SoC (bcm4718 +
bcm43224). Using the sprom from bcma and not fetching it in brcmsmac was
not a big problem, are you interested in the patch?
I want to remove the pci code from brcmsmac as it should go into bcma
and some/most parts of the code are already there. I already did some of
this but I still have problems with my device, have you already started
this? I do not know if these problems  are related to my changes or some
other problems with my devices and brcmsmac.

I want to get AP mode working on these device with brcmsmac, but for now
I do not even get station mode running. ;-)

Are there any devices with a ccrev < 20 supported by brcmsmac, the
lowest version I saw was 31 and there are some conditions in brcmsmac
for < 6, < 10 and < 20?

What are your plans to support phy_ht in brcmsmac, for now it is just
supported by b43?

I am a little confused by the vendorid/vid and vendorid/did and the
boardvendor and boardtype members. brcms_c_chipmatch() uses vendorid and
vendorid from the pci config space, but what is the equivalent for SoCs
not on pci bus? boardvendor and boardtype are fetched in
ai_nvram_process and are fetched from nvram when an SoC is used and from
pci config space on a pci device at least that is the way it is done in
the Boradcom SDK.

Hauke
