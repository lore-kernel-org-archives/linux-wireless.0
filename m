Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab1GRPBh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 11:01:37 -0400
Message-ID: <4E244AC6.2030306@redhat.com> (sfid-20110718_170143_706274_62B0A3EF)
Date: Mon, 18 Jul 2011 17:01:26 +0200
From: Stefan Assmann <sassmann@redhat.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: ali@internetdog.org, wireless <linux-wireless@vger.kernel.org>
Subject: Re: r8712u issue
References: <4E2051F3.20103@redhat.com> <4E205984.5040803@lwfinger.net> <4E23E56C.9000202@redhat.com> <20110718082709.GA8390@internetdog.org> <4E23F2E0.3050200@redhat.com> <4E2448D2.50502@lwfinger.net>
In-Reply-To: <4E2448D2.50502@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18.07.2011 16:53, Larry Finger wrote:
> On 07/18/2011 03:46 AM, Stefan Assmann wrote:
>> On 18.07.2011 10:27, Ali Bahar wrote:
>>> Stefan,
>>>
>>> I'd like to reproduce this problem. So I'd appreciate some specifics,
>>> as asked below.
>>>
>>>
>>> On Mon, Jul 18, 2011 at 09:49:00AM +0200, Stefan Assmann wrote:
>>>> On 15.07.2011 17:15, Larry Finger wrote:
>>>>> On 07/15/2011 09:42 AM, Stefan Assmann wrote:
>>>
>>>>>> driver. The problem I'm currently facing is that the driver does not
>>>>>> recognize any network disconnects. So whenever the network goes down the
>>>>>> driver will still report it's connected and thus doesn't reconnect when
>>>>>> the network is up again.
>>>
>>>
>>>> The system is a headless debian squeeze with a self build vanilla 2.6.39
>>>> kernel. The network is handled by debian scripts I just added the following
>>>> to /etc/network/interfaces:
>>>> auto wlan0
>>>> iface wlan0 inet dhcp
>>>> wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
>>>>
>>>> No NM involved.
>>>
>>> So wpa_supplicant is controlling (and presumably monitoring) the
>>> connection.
>>> How are you seeing that (to quote the above) "the network goes down"
>>> and that the driver reports that "it's connected"?
>>> (Typically, I use only ifconfig and iwconfig, but those don't monitor
>>> the connection.)
>>
>> OK, so I first recognized the problem when I rebooted my AP and the host
>> in question didn't get back online. Checking the host itself it seemed
>> that the network is doing fine, ifconfig showed the interface has an IP
>> but I couldn't ping any hosts. After an ifdown ; ifup cycle everything
>> was back to normal.
>> I pulled the power from the AP, waited a few minutes and checked back.
>> The ifconfig output still showed that the device had its IP.
>>
>>>>> When this situation occurs, what is output to the dmesg log?
>>>>
>>>> Sorry, I don't have the output at hand but IIRC basically nothing special
>>>> occurred in dmesg. The interface even keeps it's IP although the wireless
>>>> was long gone.
>>>
>>> So ifconfig shows the IP#. I'm assuming that it no longer shows a
>>> state of "UP".
>>
>> I would assume so, but I'll have to reproduce to make sure.
>>
>>> This'd seem an inane question, but I must ask: What exactly do you
>>> mean by the wireless being "gone"? Which GUI/utility/effect do you
>>> see? Is it a powered-down AP, roaming, iwconfig's output, or what?
>>
>> I pulled the power from the AP. :)
>>
>>>> Ccing Ali Bahar to this reply, since he has seen something similar.
>>>
>>> To clarify: I just meant that I've seen quite a number of similar
>>> inconsistencies in my testing as well as in my analysis of the code.
>>> So, when I read your post, it came as no surprise to me. These'll get
>>> fixed ... uh, let's hope soon! ;-)
>>
>> I see. :)
> 
> Please post your wpa_supplicant.conf. In particular, what is the value for 
> scan_ssid?

ctrl_interface=/var/run/wpa_supplicant
eapol_version=1
ap_scan=2

network={
        ssid="<ssid>"
        id_str="<ssid>"
        priority=5
        proto=RSN
        key_mgmt=WPA-PSK
        psk=<psk>
}

Should I try again with scan_ssid=1 ? From reading the man page this
makes a difference if the ssid is hidden, which is not the case.

  Stefan
