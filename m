Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:43268 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab1BFVHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 16:07:24 -0500
Message-ID: <4D4F0D83.4040401@candelatech.com>
Date: Sun, 06 Feb 2011 13:07:15 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Daniel Halperin <dhalperi@cs.washington.edu>
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning and channel types.
References: <4D4EF004.3040109@candelatech.com> <4D4EF99D.5020601@openwrt.org> <4D4EFC76.6090000@candelatech.com> <4D4EFD87.4010005@openwrt.org> <4D4EFF68.9060101@candelatech.com> <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
In-Reply-To: <AANLkTin6ia8mYsS4LOFTyZoD-dKUgUBGo6uMFt=FjTcY@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2011 12:23 PM, Daniel Halperin wrote:
> Could be rate selection.
>
> Ben, a sanity check:  is it possible for the device to be associated
> to an "HT-Only" AP and thus not be able to sent NO_HT packets?  Could
> that be why there might need to be a channel change sometimes?

I don't know.  The code and comments in  ieee80211_set_channel_type
make me think that it's always possible to send NO_HT packets regardless
of hardware's channel type.

One thing I haven't figured out yet:  What actually tells the
hardware to send NO_HT v/s HT20 v/s HT40, etc.  I have previously tested
HT20 STAs concurrent with HT40 stas, and both can send/receive at once
while the hardware stays in HT40 mode.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
