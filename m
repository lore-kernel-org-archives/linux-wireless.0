Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38101 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1LPJxo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 04:53:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAGXE3d_=OA+EvX8Q=gELDHSESAQpgt_EavTWGTNLYMnjURLJWw@mail.gmail.com>
References: <CAGXE3d_ouo4KzQA0-ysLz_RwcqoTc5Sg4V6BZZJP0TJewzNOxw@mail.gmail.com>
	<CAA93jw4-OEbiSpQM+SJn7R0uAe0o-nw0kwgvjVkL4w4AeWQtjQ@mail.gmail.com>
	<CAGXE3d_=OA+EvX8Q=gELDHSESAQpgt_EavTWGTNLYMnjURLJWw@mail.gmail.com>
Date: Fri, 16 Dec 2011 10:53:43 +0100
Message-ID: <CAA93jw7pBA3fxJg6KpFAFXCJZ=A63LCbJTjv2UpDmQH9-fyPSQ@mail.gmail.com> (sfid-20111216_105349_968549_E4E4FE2A)
Subject: Re: skb->priority usage in wireless frame classification
From: Dave Taht <dave.taht@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 16, 2011 at 10:42 AM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> On Fri, Dec 16, 2011 at 10:35 AM, Dave Taht <dave.taht@gmail.com> wrote:
>> On Fri, Dec 16, 2011 at 9:45 AM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>>> [Adding netdev]
>>>
>>> Maybe someone from the netdev people can shed some light on this.
>>> We've got the following code in net/wireless/util.c for frame classification
>>> (cfg80211_classify8021d):
>>>
>>> /* skb->priority values from 256->263 are magic values to
>>> * directly indicate a specific 802.1d priority.  This is used
>>> * to allow 802.1d priority to be passed directly in from VLAN
>>> * tags, etc.
>>> */
>>> if (skb->priority >= 256 && skb->priority <= 263)
>>>                  return skb->priority - 256;
>>>
>>> I was just thinking about making use of this for some internal mac80211
>>> QoS handling. But is this code still valid? At least I haven't found anything
>>> in the 802.1q code :(
>>
>> I made use of the above 'feature' while prototyping some Diffserv work
>> with iptables. I have no idea if there are users of this obscure
>> overloading of priority in userspace....
>>
>> The vlan code at least used to do something like this:
>>
>> net/8021q/vlan.h: *     @vlan_qos: vlan priority: (skb->priority << 13) & 0xE000
>
> Yeah, I saw that too but +256 would be << 8 and not << 13.

Exactly. It's why I used the word 'overload'. Someone in the distant
past saw >> 8 was 'reserved', and figured >> 13 was a safe place to
stick some valuable bits...

or vice versa.

> Helmut



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net
