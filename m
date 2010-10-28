Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:41972 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757152Ab0J1TGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 15:06:14 -0400
Message-ID: <4CC9C9A4.2020802@web.de>
Date: Thu, 28 Oct 2010 21:06:12 +0200
From: Lee <lee-in-berlin@web.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [regression]AP with hostapd 0.7.3 can't receive packets beyond
 authentication (2.6.36, rt73usb)
References: <4CC0D0F6.4080507@web.de> <201010260740.47692.helmut.schaa@googlemail.com> <4CC93148.7090308@web.de> <201010281023.26957.helmut.schaa@googlemail.com>
In-Reply-To: <201010281023.26957.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28/10/10 10:23, Helmut Schaa wrote:
> Am Donnerstag 28 Oktober 2010 schrieb Lee:
>> On 26/10/10 07:40, Helmut Schaa wrote:
>>> # tcpdump -i mon0 "ether src XX:XX:XX:XX:XX:XX"
>>>
>>> Do you see any frames from your specific client?
>>
>> Yes. I can see this:
>> # tcpdump -i mon0 "ether host 00:1F:3B:79:41:6F"
> [...]
>> 10:10:03.013402 5.5 Mb/s 2462 MHz 11b -76dB signal antenna 1 [bit 14] Data IV: 14 Pad 20 KeyID 0
>>
>> However, on wlan0 I don't see anything beyond the EAPOL packets.
>> Temporarily turning off WPA encryption let me successfully connect to my AP.
> 
> Aha, could you please try if loading rt73usb with nohwcrypt=1 helps?
> 
> Helmut

(argh, brown paper bag)

I went through the compiled kernels again, and I've screwed up at the last 
commit while bisecting (Sorry, Helmut!). The first bad kernel is a commit 
later:

# bad: [f1aa4c541e98afa8b770a75ccaa8504d0bff44a7] rt2x00: Write the BSSID to register when interface is added

On the good side, I tested 2.6.36 with nohwcrypt=1, and it works. Yay!
