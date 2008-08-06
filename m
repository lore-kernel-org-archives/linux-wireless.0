Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.183]:47455 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbYHFSdZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 14:33:25 -0400
Received: by ik-out-1112.google.com with SMTP id c28so53042ika.5
        for <linux-wireless@vger.kernel.org>; Wed, 06 Aug 2008 11:33:23 -0700 (PDT)
Message-ID: <4899EE69.6050205@gmail.com> (sfid-20080806_203336_939033_DAF5B5AC)
Date: Wed, 06 Aug 2008 19:33:13 +0100
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Dan Williams <dcbw@redhat.com>, Dave <kilroyd@googlemail.com>,
	linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 00/19] orinoco: WPA for Agere based cards
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217822232.10989.13.camel@dv>  <48978C25.601@gmail.com>	 <1217892514.17793.39.camel@localhost.localdomain> <1217983050.19480.41.camel@dv>
In-Reply-To: <1217983050.19480.41.camel@dv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Mon, 2008-08-04 at 19:28 -0400, Dan Williams wrote:
>>> I'm not familiar with the difference between WPA/WPA2. Is that expected to work?
>>
>> But you might be able to get away with WPA2/RSN + TKIP if the AP allows
>> this configuration.  In that configuration, the only difference between
>> WPA and WPA2/RSN would be the information element IDs, really.  But if
>> the firmware itself doesn't say it supports WPA on whatever website it
>> came from, then likely the card won't do WPA2/RSN either.
 
The firmware supports WPA, but makes no mention of WPA2.

> I tried association to hostapd with madwifi, and the only working
> configuration is WPA1 only with TKIP.  Even enabling WPA1 and WPA2 and
> TKIP makes the connection fail.  Forcing WPA1 and TKIP in
> wpa_supplicant.conf doesn't help.
> 
> I looked at the patches.  They have references to TKIP, but not to CCMP.
> Yet it would be nice if we could support WPA1+WPA2, as we cannot require
> that access points stop supporting WPA2, which is the 802.11i standard.
> It's possible that we have an issue outside the driver.

I don't believe the firmware supports CCMP. It has support for CCX/CKIP (Cisco specific TKIP-alike), but I'm guess we don't care about that.

I suggest that we leave figuring out how to associate with a WPA2+TKIP AP to another day.
 
>>>> [185219.617236] eth1: Ext scan results too large (272 bytes).
>> Truncating
>>>> results to 270 bytes.

> I tried increasing the "data" size from 200 to 300 in hermes.h, and the
> message went away.  I was able to associate to D-Link DIR-615 when it
> was set to WPA1.
> 
> I think it should be safe to increase the side of "data" and remove the
> unused "flags" filed at the end.  Let's make "data" 256 bytes to make it a nice
> round number.

Thanks for checking that. I'll set data to 316 bytes. This makes the agere_ext_scan_info 384 (256+128) bytes. That copes with the worst case you saw, and gives a nice alignment to the array of scan structures (total size now a round 24k).

> I'm sorry, I'm going to be offline soon, and I really cannot do any more
> tests.

Thank you for the feedback and testing, not to mention past maintainership of the driver.


Regards,

Dave.

