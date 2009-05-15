Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.highlandsun.com ([70.87.222.79]:57189 "EHLO
	mail.highlandsun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbZEOTiR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 May 2009 15:38:17 -0400
Message-ID: <4A0DC4A9.8050505@highlandsun.com>
Date: Fri, 15 May 2009 12:38:17 -0700
From: Howard Chu <hyc@highlandsun.com>
MIME-Version: 1.0
To: Dave <kilroyd@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: orinoco_cs and WPA-EAP?
References: <4A065AFD.8000604@highlandsun.com> <4A0D3A83.4040809@highlandsun.com> <4A0DB0A5.9010301@gmail.com>
In-Reply-To: <4A0DB0A5.9010301@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave wrote:
> Howard Chu wrote:
>> Sigh, nothing's ever easy. After abandoning the CTX714 I mentioned in an
>> earlier email, I find that the Thinkpad T42 I got from eBay came with some
>> kind of Orinoco 802.11B mini-PCI card installed. Ubuntu Jaunty's 2.6.28 kernel
>> loads up the orinoco_cs driver for this card. It appears that this driver only
>> supports WPA-PSK, and I use WPA-EAP on my home wlan. Has anyone done any work
>> on supporting WPA-EAP for this card?
>
> Michael Stokes, who is primarily responsible for debugging my initial
> WPA efforts, reported getting WPA-EAP working with a Toshiba Wireless
> WLAN v01.01 shortly after we got WPA-PSK working. However I haven't had
>   independent confirmation of this.
>
> The driver has evolved since then, so it's possible that we've broken
> something.
>
> Note that the card only supports TKIP, so it won't work if the AP
> doesn't offer it. At that time there seemed to be an issue with
> wpa_supplicant attempting to use CCMP when offered by the AP, despite it
> also offering TKIP - the workaround being to explicitly specify TKIP in
> wpa_supplicant.conf.

Thanks, that may have been the issue I was facing at first. My AP was 
configured for CCMP. I've now set it to TKIP and seem to be getting further. 
But now when I start wpa_supplicant I see a stream of "Information frame lost" 
messages in dmesg that pretty much never end (interspersed once in a while 
with ratelimit messages). I wonder if this laptop's mini-PCI slot is hosed or 
something. Also, one of the 2 antenna cable's connector came off, and I've 
tried to crimp the cable back into the connector but it may not be making full 
contact. The joys of buying used hardware...

> Regards,
>
> Dave.
>
> PS. My contact with Michael has only been in private mail, so I've bcc'd
> him (rather than cc'ing in case he want to keep his email off public
> lists) in the hope that he can supply you with the necessary hints to
> get it working.
>


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
