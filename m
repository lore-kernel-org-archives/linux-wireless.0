Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.3eti.com ([65.220.88.139]:56253 "EHLO 3eSpam.3eti.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753494Ab1CJXIb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 18:08:31 -0500
From: Chaoxing Lin <CLin@3eti.com>
To: "'Chen, Xianwen'" <xianwen.chen@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: Status of Broadcom 4353?
Date: Thu, 10 Mar 2011 23:08:28 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D05722584@RockMX01.rock.corp>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
 <AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
In-Reply-To: <AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Is it possible that the firmware file your card needs is not in your Linux distribution? Upgrading kernel does not give you firmware file.

Usually, if this is the case, you may see some error log in "dmesg"

Just through a possibility, I don't have broadcom radios. But this scenario happened to me for my Intel "Ultimate N 6300"


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Chen, Xianwen
Sent: Thursday, March 10, 2011 6:04 PM
To: linux-wireless@vger.kernel.org
Subject: Re: Status of Broadcom 4353?

Thanks a lot guys!

I tried both latest stable kernel (linux-2.6.37) and latest mainline
kernel (linux-2.6.38-rc8) with
  CONFIG_BRCM80211=y
  CONFIG_BRCM80211_PCI=y
. No wlan0 turns up yet.

Any more hint please?

Xianwen


On Thu, Mar 10, 2011 at 8:14 PM, Brett Rudley <brudley@broadcom.com> wrote:
> Its not intuitive, but 0x4353 is the PCI device ID of the 43224 dual band card which does run under brcm80211.
>
> Regards
> Brett


On Thu, Mar 10, 2011 at 7:54 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> There are two ways that Broadcom chips are connected to a PCIe interface -
> one uses the SSB interconnect, and the other does not. In b43, only chips
> with SSB are supported. As the 4353 device does not use SSB, b43 does not
> work with it. Whether it ever will is being discussed.
>
> You should use either the brcm80211 driver from compat-wireless or kernels
> 2.6.37, or later. You may also use the wl driver from Broadcom if you are
> willing to run closed-source software. That driver does not use mac80211.
>
> Larry
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
