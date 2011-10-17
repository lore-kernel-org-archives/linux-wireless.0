Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4006 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab1JQU0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 16:26:23 -0400
Message-ID: <4E9C8F60.1030209@broadcom.com> (sfid-20111017_222627_617177_88C24009)
Date: Mon, 17 Oct 2011 13:26:08 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: brcmfmac driver implementation: Questions
References: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com>
In-Reply-To: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andres,

On 10/17/2011 10:59 AM, Andrés García Saavedra wrote:
> Hi all,
>
> I would like to test some custom powersaving algorithms for 802.11abg
> WLANs on some current android smartphone (e.g., nexus one). My
> question is regarding the brcmfmac driver implementation for BCM4329
> chipsets:

Android drive is a little different from brcmfmac. We do have plan to 
add android support on a fullmac based code. But it's not going to 
happen in short time. I would suggest you could start with the android 
driver to save the time of porting fullmac to Android.

> * The current open source implementation of the driver, brcmfmac, does
> ONLY support 11n PHY?

No. 11g is supported as well.

> * Does this driver interfaces the mac80211 operations or "acts as" a
> mac80211 driver itself talking to cfg80211/nl80211?

We implement the callback and talk to cfg80211 directly.

> * Does the chipset/current implementation support sleep/awake
> triggers? (or at least quiet elements?)

I don't think there is any interface available to bypass the firmware 
and control the RF directly.

Hope this can help.

Regards,
Franky




