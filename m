Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1038 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419Ab2AYUcX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 15:32:23 -0500
Message-ID: <4F20663C.3030500@broadcom.com> (sfid-20120125_213227_857950_57A0109F)
Date: Wed, 25 Jan 2012 12:29:48 -0800
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Renzo Navas" <renzoefra@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [bcm4329] brcmfmac on kernel 2.6.35 (Andorid)
References: <CAD2CPUEu2ha6TeYrQ4WUdXU0-hdSAAJZR5PGWagSguE1DtBSfQ@mail.gmail.com>
In-Reply-To: <CAD2CPUEu2ha6TeYrQ4WUdXU0-hdSAAJZR5PGWagSguE1DtBSfQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Renzo,

First of all, is it really a good choice to use a fullmac dongle to do 
the scan algorithm investigation? For brcmfmac, all scanning 
implementation is in dongle firmware which is not open source. There is 
nothing much you can do with it. A softmac pci nic probably can meet you 
requirement.

On 01/25/2012 10:03 AM, Renzo Navas wrote:
>    * Is it factible to use the brcmfmac driver on a kernel 2.6.35,
> specifically one made for Android (CyanogenMod 7) kernel?

brcmfmac doesn't have any android support for sure(wake lock, bt coex, 
WIFI_CONTROL_FUNC and etc.).

> For the next 4 following months I will be modifying the bcm4329 driver
> for a Nexus S cellphone (aliases: samsung Ccespo, herring),
> particularly the scanning algorithm.
>
> So far all the android kernel versions for android use a deprecated
> driver called the "bcm4329" -which uses WirelessExtensions-:

For ICS we switch to a newer driver bcmdhd which use cfg80211 instead of 
wext. If you want to use cfg80211 instead of wext, this should be a 
better choice.

> On both testimonies seems to conclude that porting "brcmfmac" for
> android has not been successful.

We do have android support on the roadmap but it's not a high priority 
task because of several reasons.

Franky

