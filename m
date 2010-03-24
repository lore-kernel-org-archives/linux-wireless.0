Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:56007 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752873Ab0CXTJr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Mar 2010 15:09:47 -0400
Message-ID: <4BAA6379.2000203@gmail.com>
Date: Wed, 24 Mar 2010 20:09:45 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>, Dawid <quadri@tlen.pl>
CC: 567212@bugs.debian.org, linux-wireless@vger.kernel.org
Subject: Re: Bug#567212: rt73usb with 2.6.32-trunk kernel
References: <4B60D3DD.60802@tlen.pl> <1264721331.373.555.camel@localhost>	 <4B62D7C9.9050904@tlen.pl> <1267375207.2282.23.camel@localhost>
In-Reply-To: <1267375207.2282.23.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/28/10 17:40, Ben Hutchings wrote:
> Dawid wrote:
>> I use Edimax EW-7318USg  usb wifi adapter with rt73 chipset  - i use 
>> default rt73usb driver that is built in kernel and standard firmware 
>> from non-free repository package: firmware-ralink (0.22)  - on new 
>> 2.6.32 trunk kernel, connection is very unstable - i can connect to my 
>> access point but i get disconnected periodicly in about 6 to 10 seconds 
>> and get connected again afer about 4 seconds. This process repeats 
>> itself continously. I use WPAPSK autentication TKIP encryption in 
>> managed mode - with wpa_supplicant - encryption works but i guess 
>> becouse of such frequent disconnetions dhclient can't get IP and i can't 
>> connect to internet.
>>
>> On previous 2.6.30 kernel and same configuration, everything works fine 
>> and connection is stable.
>>
>> scanning with iwlist works on both kernels but on 2.6.32-trunk takes 2 
>> times longer.
> 
> Dawid wrote:
>> I attached kern.log to this e-mail.  Last logs in this file were made on 
>> 2.6.32-trunk kernel to make wlan0 entries from this kernel, clearly seen 
>> at the end of the file.
>>
>>
>>>
>>> Were you using the rt73usb driver (from Debian kernel packages) or the
>>> rt73 driver (from rt73-source or from Ralink)?
>>>
>>>   
>> I'm using standard rt73usb driver from Debian kernel packages on both 
>> kernels 2.6.30 and 2.6.32 - and as i wrote before, described problem 
>> exist only in 2.6.32 . Now i'm forced to use 2.6.30 becouse on this 
>> kernel internet connection is possible.
> 
> I'm forwarding this to the linux-wireless list in the hope that someone
> there will be able to investigate this.
> 

We recently discovered that rt73usb may be affected with powersaving issues.

Is it possible to check the stability of the connection with powersaving
disabled?
Just execute a iwconfig wlan0 power off before associating.

---
Gertjan.
