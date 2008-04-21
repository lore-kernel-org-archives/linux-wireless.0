Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:33497 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbYDUPgr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 11:36:47 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Jny4T-0005nJ-JH
	for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 16:36:45 +0100
Message-ID: <480CB48C.2000503@fenrir.org.uk> (sfid-20080421_173744_802670_7DCB0FF0)
Date: Mon, 21 Apr 2008 16:36:44 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>	 (sfid-20080421_101455_395583_495A4EE6) <1208785818.26186.101.camel@johannes.berg>	 <480CA260.70506@fenrir.org.uk>	 (sfid-20080421_162006_486515_D95FEC5E) <1208788898.26186.105.camel@johannes.berg>	 <480CAC55.1000704@fenrir.org.uk> (sfid-20080421_170234_346603_44E35F3C) <1208790764.26186.115.camel@johannes.berg>
In-Reply-To: <1208790764.26186.115.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> [Can you please not drop CCs all the time? thanks]
> 
>> That makes it all very difficult, I think that an EU domain is OK 
>> provided that there is also a Spanish domain. Or maybe the EU domain 
>> should actually be named ETSI (which was my original preference, it was 
>> John Linville that said EU hence why I used it).
> 
> I think we had ETSI in some of the original proposals and I think that
> makes much more sense.
> 
>> I'll have to see if I can work out what the allowable domains are for 
>> the Ralink RT2500 drivers, under Windows for instance. I know that are 
>> are considerable number of choices, certainly more than US/EU/JP. That 
>> might provide a good clue.
> 
> I'm not sure we care that much, we have a huge list somewhere (look for
> softmac work in this area from Larry Finger)

Is it in the code?

> 
>> Does anyone know how the EEPROM contents are supposed to work for the 
>> Intel hardware? How they are queried and compared with kernel and 
>> userspace programs?
> 
> The EEPROM is queried once and that's all the channels you saw in your
> iw dev wlan0 info output, then userspace restricts it further. The
> hardware also assumes you never move out of the country you bought it
> in.

The 802.11d stuff is designed to allow an AP to tell you the reg domain 
you're in, but I don't know how many implement it. This is included in 
the rolled up 802.11-2007 document I think, although it's more difficult 
to find. Ah, right, it's there, section 7.2.3.1 details it.

If this is commonly broadcast in AP beacons then I assume we should be 
using it, but if the scan is restricted to the FCC allocation then APs 
not set to FCC channels will never be found. That suggests the default 
reg dom should actually cover all channels the hardware supports.

-- 

Brian
