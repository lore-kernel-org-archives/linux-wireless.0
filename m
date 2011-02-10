Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36102.mail.mud.yahoo.com ([66.163.179.216]:27605 "HELO
	web36102.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750738Ab1BJG7T convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 01:59:19 -0500
Message-ID: <930089.13638.qm@web36102.mail.mud.yahoo.com>
Date: Wed, 9 Feb 2011 22:59:17 -0800 (PST)
From: Noel Milton Vega <nmvega@computingarchitects.com>
Reply-To: Noel Milton Vega <nmvega@ComputingArchitects.Com>
Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
To: =?utf-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless@vger.kernel.org,
	Noel Milton Vega <nmvega@ComputingArchitects.Com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Resent because the last messages was rejected due to having HTML formatting.

Hello Ozan:

You know that's actually a great point. You just reminded me of something!
I have noticed that, while the laptop Bluetooth indicator light does toggle
On-and-Off each time I press Fn-12; the WiFi laptop indicator light does *not*.
It has never turned on (*ever*), no matter how many times I press Fn-11
(the key combination to toggle WiFi On-and-Off). I just assumed it was
the driver issue I was having (and it may still be).

Here are your rfkill outputs...

root# rfkill list goes:

root@p170hm# rfkill list  (Run when Bluetooth light was on -- RX/TX enabled; 
WiFi light is off.)

   0: hci0: Bluetooth    <--- Note: Don't let this 2nd bluetooth interface 
beguile you.
       Soft blocked: no              This is a tiny bluetooth dongle I 
temporarily attached to
      Hard blocked: no              a USB port because this same N-6320 card 
also provides the laptop's
                                    bluetooth capability. But being connected to 
a USB port, Fn-12 will
                                    not affect it showing up in the output of 
rfkill (see later below  -
                                    it will remain in the output).
   1: hci1: Bluetooth    
      Soft blocked: no              
      Hard blocked: no              

root@p170hm# rfkill list  (Run when Bluetooth light was off -- RX/TX disabled; 
WiFi light is off)
   0: hci0: Bluetooth
   Soft blocked: no
   Hard blocked: no

In either case, I see no reference to a WiFi device.

Hope that helps some more.

Regards & Thanks,
Noel





>
>From: Noel Milton Vega <nmvega@computingarchitects.com>
>To: Ozan Çağlayan <ozan@pardus.org.tr>
>Cc: Julian Calaby <julian.calaby@gmail.com>; linux-wireless@vger.kernel.org; 
>Noel Milton Vega <nmvega@ComputingArchitects.Com>
>Sent: Thu, February 10, 2011 1:55:49 AM
>Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation 
>Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
>
>
>Hello Ozan:
>
>You know that's actually a great point. You just reminded me of something!
>I have noticed that, while the laptop Bluetooth indicator light does toggle
>On-and-Off each time I press Fn-12; the WiFi laptop indicator light does *not*.
>It has never turned on (*ever*), no matter how many times I press Fn-11
>(the key combination to toggle WiFi On-and-Off). I just assumed it was
>the driver issue I was having (and it may still be).
>
>Here are your rfkill outputs...
>
>root# rfkill list goes:
>
>root@p170hm# rfkill list  (Run when Bluetooth light was on -- RX/TX enabled; 
>WiFi light is off.)
>
>   0: hci0: Bluetooth    <--- Note: Don't let this 2nd bluetooth interface 
>beguile you.
>       Soft blocked: no              This is a tiny bluetooth dongle I 
>temporarily attached to
>      Hard blocked: no              a USB port because this same N-6320 card 
>also provides the laptop's
>                                    bluetooth capability. But being connected to 
>
>a USB port, Fn-12 will
>                                    not affect it showing up in the output of 
>rfkill (see later below  -
>                                    it will remain in the output).
>   1: hci1: Bluetooth    
>      Soft blocked: no              
>      Hard blocked: no              
>
>root@p170hm# rfkill list  (Run when Bluetooth light was off -- RX/TX disabled; 
>WiFi light is off)
>   0: hci0: Bluetooth
>   Soft blocked: no
>   Hard blocked: no
>
>
>In either case, I see no reference to a WiFi device.
>
>Hope that helps some more.
>
>Regards & Thanks,
>Noel
>
>
>
>
>-----  Original Message ----
>> From: Ozan Çağlayan <ozan@pardus.org.tr>
>> To: Noel Milton Vega <nmvega@computingarchitects.com>
>> Cc: Julian Calaby <julian.calaby@gmail.com>; linux-wireless@vger.kernel.org
>> Sent: Thu, February 10, 2011 1:21:38 AM
>> Subject: Re: Need Linux driver (preferably 64 bit) for "Intel Corporation 
>>Centrino Advanced-N 6230 (rev 34)" WiFI & Bluetooth card ...
>> 
>> Perşembe 10 Şubat 2011 günü (saat 07:25:12) Noel Milton Vega şunları  
>yazmıştı:
>> > Hi Julian,
>> > 
>> > Thank you for the extended reply.  It's appreciated. Your output wish is
>> > my command. Here they are (and  then some):
>> 
>> Can you run
>> 
>> rfkill list
>> 
>> and send the output?  Are there any WLAN toggles on your laptop (a hard switch 
>
>>or Fn + Fx  combination)?
>> If yes try playing with them.
>> 
>> ---
>> Ozan  Çağlayan
>> TUBITAK/UEKAE - Pardus Linux
>> http://www.pardus.org.tr/eng
>> 
