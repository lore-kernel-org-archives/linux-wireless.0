Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:53665 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095Ab3C1KDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Mar 2013 06:03:06 -0400
Message-ID: <51541557.5050207@dpets.co.uk> (sfid-20130328_110310_150483_62DC8998)
Date: Thu, 28 Mar 2013 10:03:03 +0000
From: John Talbut <jt@dpets.co.uk>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac in kernel driver on a Samsung NC110
References: <51514F1B.1080207@dpets.co.uk> <5151639F.4010700@broadcom.com> <51516BC2.5010004@dpets.co.uk> <515173A4.7030607@broadcom.com> <515179C5.50406@dpets.co.uk> <51517E28.5000303@broadcom.com> <515182C6.5030305@dpets.co.uk> <51518682.7060503@broadcom.com> <515189C6.7070003@dpets.co.uk> <51518E14.3050500@broadcom.com> <CACna6ryjYroPdWoKhz25KUtURpSGDta0UvGeOLms9jy1tnw1Xg@mail.gmail.com> <5151EC49.9030109@dpets.co.uk> <5151F088.2040408@hauke-m.de> <5151FB85.5080007@dpets.co.uk> <51521A8A.6060900@broadcom.com> <CACna6rwWNtPBJDShe1ia9dB_o40V_zZ1DFv677VSpmOmw083-A@mail.gmail.com> <5152C8DB.4080105@dpets.co.uk> <CACna6ry5A+HfOoDDW6rDy=rj7k913N8qdWhnS3Oacx21gece_g@mail.gmail.com> <5152CDDB.4010504@dpets.co.uk> <5152D670.3000707@broadcom.com> <5152E0DD.3000001@broadcom.com> <5152E45F.9050003@dpets.co.uk> <51531B18.7060909@broadcom.com>
In-Reply-To: <51531B18.7060909@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/03/13 16:15, Arend van Spriel wrote:
>> cd /sys/bus/bcma/drivers/brcmsmac
>> echo bcma0:0 > bind
>>
>> And I now have wlan0.
>>
>> So, how to get the firmware loaded after the root filesystem is mounted?
> 
> You just did. I admit this is a bit tricky way to do it. The driver
> would need to be reworked to defer firmware loading, but there is not
> clear API. I believe the general recommendation is to attempt firmware
> loading upon IFFUP, because you can assume the actual root filesystem is
> mounted upon receiving that notification. Let me try to come up with a
> patch.
> 
With dependency based booting it would seem to me that it should be
possible to make the creation of this driver dependent on the root
filesystem being mounted.  Alternatively the firmware could be included
in the initramfs.

Or the firmware could be incorporated into the driver.

Anyway, thanks for your help, and Rafał and Hauke.  I have put the
information at http://wiki.debian.org/brcm80211.

Regards

John
