Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35852 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbbGFKqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2015 06:46:20 -0400
Received: by widjy10 with SMTP id jy10so157050107wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2015 03:46:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMArcTUvpBpTB=woMiY2mET+KOUKNLvY53Exb1F6vB+aztq6Lw@mail.gmail.com>
References: <CAFSTUk6UasnV4P3B1TR7kSx1ToQTC+PC2hU6PynDBWJ3ALJzyg@mail.gmail.com>
	<55965CF8.20208@thinktube.com>
	<CAMArcTUvpBpTB=woMiY2mET+KOUKNLvY53Exb1F6vB+aztq6Lw@mail.gmail.com>
Date: Mon, 6 Jul 2015 11:46:19 +0100
Message-ID: <CAFSTUk6u6rNF1njVBMFT4VAKPZ0Y6BvHB3mJEu7H7oM3tma5tQ@mail.gmail.com> (sfid-20150706_124624_900099_48496313)
Subject: Re: mesh support on rtl8192cu
From: Richard Palethorpe <richard@lm-technologies.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Bruno Randolf <br1@thinktube.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 4, 2015 at 3:15 AM, Taehee Yoo <ap420073@gmail.com> wrote:
> 2015-07-03 18:59 GMT+09:00 Bruno Randolf <br1@thinktube.com>:
>> On 07/03/2015 10:34 AM, Richard Palethorpe wrote:
>>> Hello Taehee,
>>>
>>> I have been experimenting with MESH mode on kernel 4.0.7. It is
>>> sending beacons out, but is unable to establish a connection.
>>>
>>> I have two rtl8192cu based dongles connected to identical VMs and am
>>> using the following commands to set up the mesh:
>>>
>>> iw dev wls160u2 set type mesh
>>> ip addr add 192.168.2.1/24 broadcast 192.168.2.255 dev wls160u2
>>> ip link set wls160u2 up
>>> iw dev wls160u2 mesh join lmmesh
>>>
>>> Running 'iw dev wls160u2 mpath dump' produces no results and there is
>>> nothing regarding mesh in dmesg. I can't find any other information on
>>> mesh with rtl8192cu other than the patch which you submitted.
>>>
>>> I am wondering if it does work, but there is a step I am missing or if
>>> something is wrong with the code?
>>
>> I don't know about this 'mesh' mode, but I have noted problems in ad-hoc
>> mode with this chipset and driver. The problem seems to be that ARP
>> replies are not sent on the air... Not sure what the reason is or if
>> it's possible to fix it in the driver, but my conclusion for now is that
>> this device is unusable for ad-hoc mode. Similar problems may exist for
>> mesh?
>>
>> bruno
>>
>
> I don't know about a mesh network.
> But, according to my ping test result, 'mpath dump' shows ping traffics.
>
> Did you generate any traffics?

Bruno, that surprises me somewhat because I have got IBSS mode to work
on kernel 4.0+. Are you using a slightly older kernel?

Taehee, I tried to ping with "ping -I wls160u2 192.168.2.1" which
didn't work. It is my understanding that "iw mpath dump" should show
other nodes in the network as soon as they have connected by doing "iw
dev <dev> mesh join <network>".

According to this page:
https://wireless.wiki.kernel.org/en/developers/documentation/mac80211/api,
there are a number of things that need to be done for mesh. I quote:

"
- react to the set_tim() callback or fetch each beacon from mac80211
For MESH mode, it must
- - allow beacons to be transmitted for NL80211_IFTYPE_MESH_POINT
interfaces. These can be AP or IBSS style beacons.
- - receive beacons and control frames for NL80211_IFTYPE_MESH_POINT interfaces
- - set the NL80211_IFTYPE_MESH_POINT bit in the
hw→wiphy→interface_modes mask to indicate that MP mode is supported.
...
"

The driver doesn't use the TIM callback, so it should "fetch each
beacon from mac80211". The driver does appear to send beacons, so that
part should be OK. I don't know if it receives beacons correctly in
mesh mode however.
