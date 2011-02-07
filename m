Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39349 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1BGFnQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 00:43:16 -0500
Received: by iyj8 with SMTP id 8so1782477iyj.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 21:43:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D4F0DFF.9010703@openwrt.org>
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org>
 <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org>
 <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
 <4D4F0D83.4040401@candelatech.com> <4D4F0DFF.9010703@openwrt.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 6 Feb 2011 21:42:55 -0800
Message-ID: <AANLkTin=zENpxMQYe65Vxs7oSVqe37Lt3mgiPp=L-jzA@mail.gmail.com>
Subject: Re: Scanning and channel types.
To: Felix Fietkau <nbd@openwrt.org>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right. I think there is a function something like "send_rate_low" that
sends the lowest entry in the mac80211 enabled rates table for control
and mgmt packets.  If the NIC is associated to an HT Only AP then that
lowest entry should be HT20 MCS 1, I'd think.

Also, does circumventing "set channel type" code work properly across
bands?  If you start on 5 GHz will it send 6 Mbps probes or 1 Mbps
probes?

Dan

On Sun, Feb 6, 2011 at 1:09 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-02-06 10:07 PM, Ben Greear wrote:
>> On 02/06/2011 12:23 PM, Daniel Halperin wrote:
>>> Could be rate selection.
>>>
>>> Ben, a sanity check:  is it possible for the device to be associated
>>> to an "HT-Only" AP and thus not be able to sent NO_HT packets?  Could
>>> that be why there might need to be a channel change sometimes?
>>
>> I don't know.  The code and comments in  ieee80211_set_channel_type
>> make me think that it's always possible to send NO_HT packets regardless
>> of hardware's channel type.
>>
>> One thing I haven't figured out yet:  What actually tells the
>> hardware to send NO_HT v/s HT20 v/s HT40, etc.  I have previously tested
>> HT20 STAs concurrent with HT40 stas, and both can send/receive at once
>> while the hardware stays in HT40 mode.
> mac80211 tx info sets the mode for the transmission (as part of the rate
> series). Drivers like ath9k translate that to descriptor fields.
> Rate control selects these things based on peer HT capabilities.
>
> - Felix
>
