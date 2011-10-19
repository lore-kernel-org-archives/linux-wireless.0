Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3504 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab1JSM6k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 08:58:40 -0400
Message-ID: <4E9EC96E.8020303@broadcom.com> (sfid-20111019_145903_113691_E6215085)
Date: Wed, 19 Oct 2011 14:58:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Eric Dumazet" <eric.dumazet@gmail.com>
cc: "Nico Schottelius" <nico-linux-20111017@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Subject: Re: BUG: All network processes hang (brcmsmac/wpa_supplicant)
References: <20111019123602.GA11883@schottelius.org>
 <1319028563.8416.1.camel@edumazet-laptop>
In-Reply-To: <1319028563.8416.1.camel@edumazet-laptop>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/19/2011 02:49 PM, Eric Dumazet wrote:
> Le mercredi 19 octobre 2011 à 14:36 +0200, Nico Schottelius a écrit :
>> Hello,
>>
>> I've
>>
>> Eric Dumazet [Tue, Oct 18, 2011 at 02:24:25PM +0200]:
>>> Must be a mutex_unlock(some_mltex) missing somewhere.
>>>
>>> Then later, a process holding RTNL is blocking on mutex_lock(some_mutex)
>>>
>>> Try a "CONFIG_LOCKDEP=y" enabled build
>>
>> Did so, attached is the dmesg output after 3x suspend.
>>
>> It also seems this bug gets more / only triggered when I loose the
>> connection to a wpa2-eap network that is defined like this:
>>
>> network={
>>    ssid="eth"
>>   id_str="eth-802.2x"
>>    key_mgmt=WPA-EAP
>>    proto=WPA2
>>    eap=TTLS
>>    pairwise=CCMP TKIP
>>    group=CCMP TKIP
>>    phase2="auth=MSCHAPV2"
>>    identity="MYNAME"
>>    password="forgottoremoveit"
>> }
>>
>> Hope the dmesg output helps and we can remove the problem soon
>> and making the mba finally almost completly usable :-)
>>
> 
> Sorry, no CONFIG_LOCKDEP in your config or dmesg. Maybe you sent a
> previous dmesg/config file ?
> 
> Note that you have "CONFIG_LOCKDEP_SUPPORT=y", not "CONFIG_LOCKDEP=y"
> 

Hi Eric,

Are there any configuration setting needed that CONFIG_LOCKDEP depends on?

Gr. AvS


