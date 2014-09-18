Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.bemta7.messagelabs.com ([216.82.254.111]:49210 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbaIRIzH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2014 04:55:07 -0400
Message-ID: <541A9D6D.8050903@netcommwireless.com> (sfid-20140918_105513_649386_E4BD85E6)
Date: Thu, 18 Sep 2014 18:53:01 +1000
From: Sourav <sourav.chakraborty@netcommwireless.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Not reaching optimum speeds with IEEE 802.11n
References: <540FA8D9.2070803@netcommwireless.com> <54100F0E.8030204@broadcom.com> <CAGXE3d9FRLOPQ1pO6WFWy4FF67PGbo5ztfhLELydq3k410731w@mail.gmail.com> <54125652.7060205@netcommwireless.com> <CAGXE3d_QE0zCAgbLaa+93JNM-GhRMvHENqW1zXy_txeV1mKwSg@mail.gmail.com> <5412A831.3050804@netcommwireless.com>
In-Reply-To: <5412A831.3050804@netcommwireless.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,
Is there a parameter in hostapd.conf or elsewhere to enable/disable MPDU 
and MSDU aggregation? Please reply as this is very urgent.

Thanks in advance,
Sourav
On 12/09/14 18:00, Sourav wrote:
> On 12/09/14 17:46, Helmut Schaa wrote:
>> On Fri, Sep 12, 2014 at 4:11 AM, Sourav
>> <sourav.chakraborty@netcommwireless.com> wrote:
>>> On 11/09/14 00:14, Helmut Schaa wrote:
>>>> On Wed, Sep 10, 2014 at 10:42 AM, Arend van Spriel 
>>>> <arend@broadcom.com>
>>>> wrote:
>>>>> On 09/10/14 03:26, Sourav wrote:
>>>>>> We are using Ralink chip Rt3072L (using rt2800usb drivers 
>>>>>> rt2800usb.c),
>>>> The Ralink USB hardware is quite bad in reporting TX status and as
>>>> such minstrel_ht cannot do proper rate selection.
>>>> If you watch the rc stats at
>>>>
>>>> /sys/kernel/debug/ieee80211/phy0/netdev\:wlan0-0/stations/xx:xx:xx:xx:xx:xx/rc_stats 
>>>>
>>>> you might see a lot of rate selection "hopping".
>>>>
>>>> Regards.
>>>> Helmut
>>> please take a look at the attachments.... the first one shows the 
>>> rc_stats
>>> and iperf stats side by side on the router(iperf is running in 
>>> client mode
>>> in the router).....the second attachment is from a laptop which is 
>>> running
>>> iperf in server mode.
>>>
>>> I don't see a lot of rate "hopping" in the rc_stats file, (T,t and 
>>> P) rates
>>> are pretty much stable.... yet there is a big difference between 
>>> those rates
>>> and the throughput using iperf......
>> Indeed, rc_stats looks acceptable.
>>
>>> when you say "Ralink USB hardware is quite bad in reporting TX 
>>> status", do
>>> you mean that the HW reports less tx rate to minstrel_ht and so its 
>>> rate
>>> calculation is screwed up?
>> The HW sometimes does not report the status of transmitted frames 
>> correctly.
>> The TX status register is a FIFO of 16 (or similar) elements and if
>> the driver is
>> not reading it "fast enough" the FIFO will overflow :( at least that
>> was the point
>> when I was looking at the ralink hardware last time. Not sure if 
>> something
>> changed recently.
> How did you detect this? I can see no error messages in 
> syslog....hence I am thinking that the HW is processing packets 
> properly....though I may be wrong here.
>>> Can you please let me know the section of code inside 
>>> Rc_80211_minstrel_ht.c
>>> (or somewhere else) which deals with getting the tx rate from ralink 
>>> HW?
>> There is no special code in minstrel(_ht) in regard to rt2x00.
>>
>> Are you able able to get some statistics on the receiver side (your
>> windows machine)
>> regarding TX rates and AMPDU lengths?
> the 2nd attachment had logs from the windows machine.....it is also 
> showing similar rates as on the router
>> Helmut
>
>


-- 
Warm Regards,
Sourav


______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
