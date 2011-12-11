Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4372 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346Ab1LKTys (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 14:54:48 -0500
Message-ID: <4EE50A71.90509@broadcom.com> (sfid-20111211_205452_205613_7037EEA2)
Date: Sun, 11 Dec 2011 20:54:25 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/23] brcm80211: fullmac 4430 support and softmac
 switch to bcma
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
 <4EE3D936.4070707@hauke-m.de>
In-Reply-To: <4EE3D936.4070707@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2011 11:12 PM, Hauke Mehrtens wrote:
> Hi,
> 
> nice patches for brcmsmac. I tried them on my bcm4716 device (wireless
> core on the system bus), but brcmsmac does not work there, I am getting
> a kernel oops. aiutils.c does does not work for SoCs e.g.
> ai_setcoreidx() does not handle that all cores are mapped on SoCs at the
> same time, just under different addresses. I hope you are working on
> removing aiutils.c and moving the parts missing in bcma into it.
> 

Hi Hauke,

Thanks for the compliment ;-) Let me explain the steps set out to get
brcmsmac using bcma,

1) convert to use bcma functions in all brcmsmac source files.
2) cleanup aiutils.c as it is redundant.
3) look for opportunities to move code to bcma (eg. nicpci.c, srom.c)

For steps 1) and 2) we have patches queued up of which the first batch
was submitted. Keep an eye on the mailing list for more to come ;-)

Gr. AvS

