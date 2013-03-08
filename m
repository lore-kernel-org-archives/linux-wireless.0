Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from momout1-smtp.messagingengine.com ([66.111.4.229]:42589 "EHLO
	momout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757848Ab3CHRF3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 12:05:29 -0500
Message-Id: <1362762328.4848.140661201779653.7D9CB988@webmail.messagingengine.com> (sfid-20130308_180533_154034_0ED6CCEE)
From: =?UTF-8?Q?K=C3=A9vin=20THIERRY?= <kevinthierry@myopera.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: Re: Fwd: Unable to activate WiFi p2p / WiFi Direct
Date: Fri, 08 Mar 2013 17:05:28 +0000
In-Reply-To: <CABPxzYK3Y-deNnqt65m=n8P6nrxYGoHZN2cU5CG4zfKe6UFk_w@mail.gmail.com>
References: <1362663176.11919.140661201212753.170BABA0@webmail.messagingengine.com>
 <1362666346.22280.140661201248433.42E3B535@webmail.messagingengine.com>
 <5138C641.5030004@lwfinger.net>
 <CABPxzYK3Y-deNnqt65m=n8P6nrxYGoHZN2cU5CG4zfKe6UFk_w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I successfully got all features to work after discovering that the wifi
dongle works out of the box on the raspberrypi 3.6.11+ with all
features.
To make it work I had to :

1) Download the latest driver source from realtek :
http://www.realtek.com.tw/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true
(RTL8192CU)

2) Modify a source file as it is done here :
https://github.com/ksclarke/rtl8192cu/commit/49568f94513ce945984a8a2f27457c6278ee674d

3) Build it.

4) Unload the rtl8192cu module (rmmod rtl8192cu)

5) Load the new-built module (insmod 8192cu.ko)

Note that I did that on a x86_64 architecture with kernel 3.5.0-25 and
that I could'nt get the driver to be built with kernel 3.8.2.

On Thu, Mar 7, 2013, at 09:25 PM, Krishna Chaitanya wrote:
> 

> 
> > On Thu, Mar 7, 2013 at 10:24 PM, Larry Finger <Larry.Finger@lwfinger.net[mailto:Larry.Finger@lwfinger.net]> wrote:
> 
> 


> 
>> >> On 03/07/2013 08:25 AM, Kévin THIERRY wrote:
>> 
>> 

>> 
>>> 
Hi,
>>> 
>>> 
I've been unable to activate the p2p feature on my WiFi dongle (which
>>> 
>>> 
otherwise works fine).
>>> 
>>> 
iwpriv command returns "wlan1 no private ioctls."
>>> 
>>> 
I'm running Ubuntu 12.04 with kernel 3.5.0-25 and the WiFi dongle is a
>>> 
>>> 
Netgear model wna1000m (driver rtl8192cu).
>>> 
>>> 
I've also tried with kernel 3.8.2 with the same result.
>>> 
>>> 
Thanks,
>>> 
>>> 

>>> 
>> 

>> 
>> 
P2P is not yet implemented in rtl8192cu. The method is being added to
rtlwifi and the PCI-based drivers in patches that are now undergoing
tests. They will likely be in kernel 3.10. Once that is done, I will be
able to consider P2P for the USB-based driver.
>> 
>> 



>> 
>> 

>> 
> 
> 
> As P2P is more of a mac feature which is already 
> 
> supported by mac80211 currently (Including p2p find),
> 
> what additional support we need in the driver, Leaving NoA?


> 


Kévin THIERRY
