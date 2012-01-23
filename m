Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57570 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122Ab2AWQg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 11:36:58 -0500
Received: by pbaa10 with SMTP id a10so1707683pba.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jan 2012 08:36:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F1D84CE.8020403@maya.org>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201200730.q0K7U0oj004966@mail.maya.org>
	<CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
	<4F1D84CE.8020403@maya.org>
Date: Mon, 23 Jan 2012 17:36:57 +0100
Message-ID: <CAGXE3d_UPmcjgss+xMPBtkM22kBwGD23y8Fzxkr+6286W+EwbQ@mail.gmail.com> (sfid-20120123_173702_480412_7EDC9710)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 5:03 PM, Andreas Hartmann
<andihartmann@freenet.de> wrote:
> Helmut Schaa schrieb:
>> On Fri, Jan 20, 2012 at 8:29 AM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
>>> All in one: Your workaround was a good idea, but unfortunately it
>>> doesn't "solve" / workaround the problem introduced with the patch
>>> "mac80211: retry sending failed BAR frames later instead of tearing
>>> down aggr" [1]. I don't know off any other solution at this time as to revert it.
>>
>> Ok, so we've got at least one hw issue here: rt2800 is not able to report
>> correct ACK state of BARs :(
>>
>> The interesting bit is that the legacy drivers tear the BA session down as
>> soon as the first AMPDU subframe failed. That's the same behavior as
>> mac80211 had before the mentioned patch.
>>
>> So, let's assume the generic way Felix implemented works for other devices
>> (like ath9k) we could go with a workaround inside rt2x00 to tear down
>> the BA session as soon as the first AMPDU frame failed.
>>
>> Mind to try that one (not even compile tested though :) ).
>
> hdr is missing. I tried to derive it like this:
>
> struct ieee80211_hdr *hdr=(void*)entry->skb->data;

Looks correct but you should put it right before the ieee80211_is_data_qos check
not at the start of the function ...

Also you might want to add " tx_info->control.sta != NULL" check in
the same if clause.

Helmut
