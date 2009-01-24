Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp4.int-evry.fr ([157.159.10.71]:51561 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbZAXIYf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 03:24:35 -0500
Message-ID: <497AD024.2050301@telecom-sudparis.eu> (sfid-20090124_092440_056900_E2AA0D93)
Date: Sat, 24 Jan 2009 09:24:04 +0100
From: Chanthearith HUON <chanthearith.huon@telecom-sudparis.eu>
MIME-Version: 1.0
To: Andrey Yurovsky <andrey@cozybit.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Hakima.Chaouchi@it-sudparis.eu
Subject: Re: SIOCSIFFLAGS: Name not unique on network
References: <49788E88.5000608@telecom-sudparis.eu>	 <1232749288.3977.14.camel@johannes.local> <45e8e6c40901231457x57625153wad49b4869a1627bd@mail.gmail.com>
In-Reply-To: <45e8e6c40901231457x57625153wad49b4869a1627bd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you very much, this problem also occured with supported cards.
I solved this problem with both broadcom and intel wireless cards.

I deactivated the physical interface first before using mesh interfaces 
and no more error message.
However, since you mentionned that non of Intel card support mesh, now I 
only use broadcom wireless cards for testing.

I followed the howto http://www.open80211s.org/trac/wiki/HOWTO
but things did not work as expected.

my broadcom wireless cards
"
card: Broadcom Corporation BCM4306
driver: b43legacy
"

Here are commands for all my pcs except mesh interface name and ip which 
are different thereby i replace them here by X.
"
Killall NetworkManager
iw dev wlan0 interface add meshX type mp mesh_id mymesh
ifconfig wlan0 down
iwconfig meshX mode Ad-hoc
ifconfig meshX up
iwconfig meshX channel 2.462G
ifconfig meshX inet 192.168.1.X netmask 255.255.255.0
"

However, with "iw dev meshX station dump" in all experiement machines, 
nothing displayed on the screen as a result. I waited and no route 
constructed between them. Thus, I can not ping any mesh neighbors.

I would like to know ur suggestion? what is missing or...?

Thank,
Thierry

Andrey Yurovsky wrote:
> On Fri, Jan 23, 2009 at 2:21 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>   
>> On Thu, 2009-01-22 at 16:19 +0100, Chanthearith HUON wrote:
>>
>>     
>>> This wireless card is not listed
>>> in http://linuxwireless.org/en/users/Devices
>>> <http://linuxwireless.org/en/users/Devices>
>>> but the driver is in the
>>> list http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211drivers
>>> <http://linuxwireless.org/en/developers/Documentation/mac80211#mac80211drivers>
>>>       
>> But it's listed here:
>> http://linuxwireless.org/en/users/Drivers
>>
>> -- as not supporting mesh.
>>
>>     
>>> The OS is ubuntu Intrepid Ibex 8.10 with kernel 2.6.27-9-generic
>>>
>>> After creating new interface for mesh "iw dev wlan0 interface add mesh
>>> type mp mesh_id 100". I turned the mesh interface up by "ifconfig mesh up".
>>> I got following error message
>>> " SIOCSIFFLAGS: Name not unique on network "
>>>       
>> That's strange, it should not have allowed you to add the interface in
>> the first place. But then, you're using an ancient kernel anyway...
>>
>> johannes
>>
>>     
>
> That's indeed strange: the iwl3945 (along with the other Intel cards)
> definitely doesn't support mesh but I was able to add an interface as
> well on my Ubuntu box (2.6.27-9).  I think the reason is that iwlwifi
> doesn't explicitly test for interfaces it actually supports:
>
> static int iwl3945_mac_add_interface(struct ieee80211_hw *hw,
>                                  struct ieee80211_if_init_conf *conf)
> {
>         struct iwl_priv *priv = hw->priv;
>         unsigned long flags;
>
>         IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);
>
>         if (priv->vif) {
>                 IWL_DEBUG_MAC80211("leave - vif != NULL\n");
>                 return -EOPNOTSUPP;
>         }
> <snip>
>   

