Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1118 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab3C1LXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 07:23:25 -0400
Message-ID: <5154281F.8040509@broadcom.com> (sfid-20130328_122329_887197_0D9D2570)
Date: Thu, 28 Mar 2013 12:23:11 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John Talbut" <jt@dpets.co.uk>
cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Hauke Mehrtens" <hauke@hauke-m.de>, linux-wireless@vger.kernel.org
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
References: <51514F1B.1080207@dpets.co.uk>
 <5151639F.4010700@broadcom.com> <51516BC2.5010004@dpets.co.uk>
 <515173A4.7030607@broadcom.com> <515179C5.50406@dpets.co.uk>
 <51517E28.5000303@broadcom.com> <515182C6.5030305@dpets.co.uk>
 <51518682.7060503@broadcom.com> <515189C6.7070003@dpets.co.uk>
 <51518E14.3050500@broadcom.com>
 <CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com>
 <5151EC49.9030109@dpets.co.uk> <5151F088.2040408@hauke-m.de>
 <5151FB85.5080007@dpets.co.uk> <51521A8A.6060900@broadcom.com>
 <CACna6rwWNtPBJDShe1ia9dB_o40V_zZ1DFv677VSpmOmw083-A@mail.gmail.com>
 <5152C8DB.4080105@dpets.co.uk>
 <CACna6ry5A+HfOoDDW6rDy=rj7k913N8qdWhnS3Oacx21gece_g@mail.gmail.com>
 <5152CDDB.4010504@dpets.co.uk> <5152D670.3000707@broadcom.com>
 <5152E0DD.3000001@broadcom.com> <5152E45F.9050003@dpets.co.uk>
 <51531B18.7060909@broadcom.com> <51541557.5050207@dpets.co.uk>
In-Reply-To: <51541557.5050207@dpets.co.uk>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/28/2013 11:03 AM, John Talbut wrote:
> On 27/03/13 16:15, Arend van Spriel wrote:
>>> cd /sys/bus/bcma/drivers/brcmsmac
>>> echo bcma0:0 > bind
>>>
>>> And I now have wlan0.
>>>
>>> So, how to get the firmware loaded after the root filesystem is mounted?
>>
>> You just did. I admit this is a bit tricky way to do it. The driver
>> would need to be reworked to defer firmware loading, but there is not
>> clear API. I believe the general recommendation is to attempt firmware
>> loading upon IFFUP, because you can assume the actual root filesystem is
>> mounted upon receiving that notification. Let me try to come up with a
>> patch.
>>
> With dependency based booting it would seem to me that it should be
> possible to make the creation of this driver dependent on the root
> filesystem being mounted.  Alternatively the firmware could be included
> in the initramfs.

It actually needs a user-space helper. As I understood things there is
no way for the kernel to know whether user-space has everything in place
to handle the firmware request.

> Or the firmware could be incorporated into the driver.
> 
> Anyway, thanks for your help, and Rafał and Hauke.  I have put the
> information at http://wiki.debian.org/brcm80211.

I tried to get a patch to you yesterday. Did you get that?

Gr. AvS


