Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lmv.inov.pt ([146.193.64.2]:49540 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728Ab3GJRsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jul 2013 13:48:55 -0400
Message-ID: <51DD9E6C.5060008@inov.pt> (sfid-20130710_194857_960554_D4C34571)
Date: Wed, 10 Jul 2013 18:48:28 +0100
From: =?UTF-8?B?Sm9zw6kgTWlndWVsIEdvbsOnYWx2ZXM=?=
	<jose.goncalves@inov.pt>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org
Subject: Re: wl127x: Unable to associate with a WPA2-PSK AP
References: <51DB0ACC.7050800@inov.pt>   <CA+XVXfcakDiN1pPqGDQAN=VR8p_C1LUWGt_nX-rGXDLsBkk+Dw@mail.gmail.com>   <51DB4195.8090103@inov.pt>   <CA+XVXffKKVMeD5GXkzDsnvR7=Ocb8QP0Y7eeD-ZZTzsxJL7PqA@mail.gmail.com>   <1373360959.21065.183.camel@cumari.coelho.fi> <51DBD904.6020007@inov.pt>   <1373362817.21065.191.camel@cumari.coelho.fi> <51DBF389.5060209@inov.pt>   <CA+XVXfeB3jpXaaV4vgbHUVRdPeH9tPVRWvRhZsYHmg33HNzmmw@mail.gmail.com>   <51DC0E7C.9080306@inov.pt>   <CA+XVXfd8WouC7UWwD5z=OAMT2AUaU25d13thinjRDe-JpTQCEw@mail.gmail.com>   <51DCA3EF.8090900@inov.pt> <1373448177.8385.22.camel@cumari.coelho.fi>  <51DD54D4.6090502@inov.pt> <51DD8C20.7010900@inov.pt> <1373476663.8385.28.camel@cumari.coelho.fi>
In-Reply-To: <1373476663.8385.28.camel@cumari.coelho.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10-07-2013 18:17, Luciano Coelho wrote:
> On Wed, 2013-07-10 at 17:30 +0100, José Miguel Gonçalves wrote:
>> On 10-07-2013 13:34, José Miguel Gonçalves wrote:
>>> I will try a new AP to see how it behaves...
>>>
>> I've tested with my Android smartphone acting as an AP, without authentication,
>> and I'm also unable to associate!
>>
>> I get from iw the following error message:
>>
>> wlan0 (phy #0): failed to connect to b4:07:f9:49:cc:65, status: 1: Unspecified failure
>>
>> Complete log is here:
>>
>> http://pastebin.com/DzPmMw8i
>>
>> So, something is definitely wrong with my setup... but what?
>> Hope that log has some useful info for you...
> This definitely looks like RF problems.  Especially this:
>
> [  177.575000] wlan0: send auth to b4:07:f9:49:cc:65 (try 1/3)
> [  177.595000] wlan0: send auth to b4:07:f9:49:cc:65 (try 2/3)
> [  177.605000] wlcore: EVENT on mbox 1
> [  177.605000] wlcore: MBOX vector: 0x100000
> [  177.610000] wlcore: MAX_TX_FAILURE_EVENT_ID
> [  177.615000] wlan0: send auth to b4:07:f9:49:cc:65 (try 3/3)
> [  177.640000] wlan0: authentication with b4:07:f9:49:cc:65 timed out
>
> You are send auth requests out, but not getting anything back.
> Apparently you're not even getting ACKs (as pointed out by the
> MAX_TX_FAILURE_EVENT_ID).

Hum. I never considered RF problems because I'm testing this module with a 
Jorjin's development kit, so I was considering that Jorjin knows how to make PCBs 
for RF. Also seeing that when I remove the antenna the AP signal strength changes 
from -51 dBm to -73 dBm was a signal to me that the RF was OK.

>
> Do you have a sniffer? You could try to use your TP-Link dongle with
> wireshark to see if it works fine as a sniffer.

I have a text console only system. I could put tcpdump on my system, but I think I 
can not monitor wireless traffic with it, or can I?

José Gonçalves

