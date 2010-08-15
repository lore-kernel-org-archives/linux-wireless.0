Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42772 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0HOURX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Aug 2010 16:17:23 -0400
Received: by pvg2 with SMTP id 2so1622819pvg.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 Aug 2010 13:17:23 -0700 (PDT)
Message-ID: <4C684B41.7060709@lwfinger.net>
Date: Sun, 15 Aug 2010 15:17:05 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: dimitri.gorokhovik@free.fr
CC: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>,
	linville@tuxdriver.com, stefano brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH]: b43: is there such a thing as radio 0x2062 rev 2?
References: <1123777895.142301281900112563.JavaMail.root@zimbra3-e1.priv.proxad.net>
In-Reply-To: <1123777895.142301281900112563.JavaMail.root@zimbra3-e1.priv.proxad.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/15/2010 02:21 PM, dimitri.gorokhovik@free.fr wrote:
> 
> ----- "Gábor Stefanik" <netrolller.3d@gmail.com> a écrit :
> 
>> Does the card actually work if you make b43 believe that it has a
>> BCM2063 radio?
> The interface stays on (the WiFi LED lit), and I can scan and see 
> the networks (Quality info seems OK as well with 2.6.35). However, 
> I am still unable to connect to either an open or a protected 
> network:
> 
> Aug 15 19:04:11 dimitri kernel: wlan0: authenticate with 00:17:33:1e:13:70 (try 1)
> Aug 15 19:04:11 dimitri kernel: wlan0: authenticated
> Aug 15 19:04:11 dimitri kernel: wlan0: associate with 00:17:33:1e:13:70 (try 1)
> Aug 15 19:04:11 dimitri kernel: wlan0: RX AssocResp from 00:17:33:1e:13:70 (capab=0x411 status=0 aid=2)
> Aug 15 19:04:11 dimitri kernel: wlan0: associated
> Aug 15 19:04:16 dimitri kernel: No probe response from AP 00:17:33:1e:13:70 after 500ms, disconnecting.
> 
>> BTW, all BCM2062 radios seen so far are rev.2, and none have shown
>> this error. Maybe your card actually has a BCM2063 radio, but for
>> some reason b43 detects it as a BCM2062?
> Sure, this is of course possible (I don't really believe my patch 
> fixes the problem). The MAC address of the WiFi card is 
> 00:22:68:ba:e2:ef (maybe somebody knows know the manufacturing 
> series).
> 
> For the record, I was able, only once, to run the unmodified driver
> (2.6.32 x86+_64 debian kernel), but was never able to get it ever 
> again after that. That time, the HDMI res negotiated on both my 
> screens (though a dock) was rather unusual (something like 
> 11xx X 9xx) so I think my problem might be some sort of CEM 
> problem.  
> 
>>
>> Also, does the Broadcom hybrid driver handle your card?
> Last time I tried (more than a year ago), from memory, I believe,
> I was able to scan, but I had the problems with Network Manager
> support and didn't go for manual config.

>From a quick look at the latest Broadcom driver that we have for RE, for PHY rev
<= 2, there are times when a 2063 radio is treated as a 2062, but there are
others where it is a 2063.

When I get time, I'll try to sort it out and update the specs. In the meantime,
NACK on the patch. It is certainly incomplete, and does not appear to help.

Larry
