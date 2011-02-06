Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:56297 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1BFVJa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 16:09:30 -0500
Message-ID: <4D4F0DFF.9010703@openwrt.org>
Date: Sun, 06 Feb 2011 22:09:19 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Daniel Halperin <dhalperi@cs.washington.edu>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org> <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org> <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com> <4D4F0D83.4040401@candelatech.com>
In-Reply-To: <4D4F0D83.4040401@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-06 10:07 PM, Ben Greear wrote:
> On 02/06/2011 12:23 PM, Daniel Halperin wrote:
>> Could be rate selection.
>>
>> Ben, a sanity check:  is it possible for the device to be associated
>> to an "HT-Only" AP and thus not be able to sent NO_HT packets?  Could
>> that be why there might need to be a channel change sometimes?
> 
> I don't know.  The code and comments in  ieee80211_set_channel_type
> make me think that it's always possible to send NO_HT packets regardless
> of hardware's channel type.
> 
> One thing I haven't figured out yet:  What actually tells the
> hardware to send NO_HT v/s HT20 v/s HT40, etc.  I have previously tested
> HT20 STAs concurrent with HT40 stas, and both can send/receive at once
> while the hardware stays in HT40 mode.
mac80211 tx info sets the mode for the transmission (as part of the rate
series). Drivers like ath9k translate that to descriptor fields.
Rate control selects these things based on peer HT capabilities.

- Felix
