Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from erley.org ([97.107.129.9]:57221 "EHLO remote.erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbbAEX4l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2015 18:56:41 -0500
Message-ID: <54AB2307.7080409@erley.org> (sfid-20150106_005644_898285_5CCD7DEB)
Date: Mon, 05 Jan 2015 17:49:27 -0600
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Erich Titl <erich.titl@think.ch>,
	linux-wireless@vger.kernel.org
Subject: Re: b43 driver and WEP
References: <54AA5438.9070902@think.ch> <54AAFFB1.8030109@lwfinger.net>
In-Reply-To: <54AAFFB1.8030109@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/05/2015 03:18 PM, Larry Finger wrote:
> On 01/05/2015 03:07 AM, Erich Titl wrote:
>> Hello
>>
>> I am working on a WLAN client on an embedded system and I am facing a
>> problem using WEP. I am using the b43 driver with a BCM43222 mini-pci
>> card and kernel 3.10.55.
>>
>> The card works fine with WPA and without encryption. Using WEP results
>> in a weird situation where dhcp requests can be sent across the wireless
>> link, but a dhcp reply is never received.
>>
>> The only error I could come up with is
>>
>> AP# ip link set wlan0 up
>> AP# iw event -f &
>> AP# iw wlan0 connect scoobly keys 0:abcdefghijklm
<<Snip>>
>>
>> [  417.886167] b43 ssb0:0 wlan0: failed to set key 0

Does the key have to be hexadecimal for iw, and is yours?  A lot of WEP 
APs will generate a hex key from a passphrase, but (from what I 
remember), linux requires the actual hex key.  This is just from hazy 
memory as the last time I used WEP without a gui controller (or even 
with) was years ago.

