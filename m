Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1559 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752524Ab2F0IhW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 04:37:22 -0400
Message-ID: <4FEAC62F.4000400@broadcom.com> (sfid-20120627_103735_630230_1D15BE0B)
Date: Wed, 27 Jun 2012 10:37:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com
Subject: Re: Question about BCM43228 and outdated description in
 MAINTAINERS
References: <4FE886B3.7020202@lwfinger.net>
In-Reply-To: <4FE886B3.7020202@lwfinger.net>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/25/2012 05:41 PM, Larry Finger wrote:
> Hi,
> 
> I recently received a donated BCM43228 (14e4:4359) mini-PCIe card. At
> the moment, neither b43 nor brcmsmac support it. Although, grepping the
> proprietary driver wl shows that it would recognize that PCI ID, that
> driver does not load as it requires routine lockdep_init_map(), which is
> exported only for GPL modules. As a result, owners of this device can
> only use it with Linux if they can find a suitable Windows driver for
> use with ndiswrapper. In my experience, that means that 64-bit users are
> out of luck.

I noticed your email on the lockdep_init_map() function. Maybe the
hybrid driver will be modified, but I leave that to Brett.

My personal experience with ndiswrapper on 64-bit kernels is different,
but I tend to consider ndiswrapper as a last resort. Most issues I had
were between ndiswrapper and wpa_supplicant (when using dbus ipc).

> Reverse engineering this device to be able to drive it with b43 would
> involve a lot of effort. If your group is planning on adding it to
> brcmsmac, then I would not undertake this project. To the fullest extent
> that you can, please advise me regarding this matter.

Our focus is currently on extending brcmfmac. We had requests for 43228
support before, but did not start that task. Will inform internally what
the plan is here and let you know to the fullest extent ;-)

> When getting your addresses from file MAINTAINERS, I noticed that it was
> not updated for the name change from brcm80211 to brcmsmac. The current
> info is as follows:
> 
> BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
> M:
> M:      Roland Vossen <rvossen@broadcom.com>
> M:      Arend van Spriel <arend@broadcom.com>
> M:      Franky (Zhenhui) Lin <frankyl@broadcom.com>
> M:      Kan Yan <kanyan@broadcom.com>
> L:      linux-wireless@vger.kernel.org
> L:      brcm80211-dev-list@broadcom.com
> S:      Supported
> F:      drivers/net/wireless/brcm80211/

Under the folder drivers/net/wireless/brcm80211/ are both brcmfmac and
brcmsmac (and shared module brcmutil). So maybe patch it like this:

- BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
+ BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVERS

Gr. AvS

