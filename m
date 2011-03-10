Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49046 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab1CJXDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 18:03:44 -0500
Received: by yia27 with SMTP id 27so888632yia.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2011 15:03:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
References: <AANLkTimrW002Q86KWOdh0SYsZ5xLDve+gxmwehe4tc6N@mail.gmail.com>
	<7A94256FD72B884D9E7C55586C3CBCEE15B0286A4E@SJEXCHCCR01.corp.ad.broadcom.com>
Date: Fri, 11 Mar 2011 00:03:43 +0100
Message-ID: <AANLkTimViaDbvpTEmRR=Te=TGUMjc76-g5Nu-E7dYEff@mail.gmail.com>
Subject: Re: Status of Broadcom 4353?
From: "Chen, Xianwen" <xianwen.chen@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
