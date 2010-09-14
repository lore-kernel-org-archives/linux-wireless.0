Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:37943 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0INRvg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Sep 2010 13:51:36 -0400
Message-ID: <4C8FB621.1060608@openwrt.org>
Date: Tue, 14 Sep 2010 19:51:29 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, lrodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k: fix BSSID mask calculation
References: <1284482240-57922-1-git-send-email-nbd@openwrt.org> <4C8FB1DA.5090209@candelatech.com>
In-Reply-To: <4C8FB1DA.5090209@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-14 7:33 PM, Ben Greear wrote:
> On 09/14/2010 09:37 AM, Felix Fietkau wrote:
>> At the time the .add_interface driver op is called, the interface has not
>> been marked as running yet, so ieee80211_iterate_active_interfaces will
>> not pass it to the iterator function.
>> Because of this, the calculated BSSID mask is wrong, which breaks multi-BSS
>> operation.
>>
>> Additionally, the current way of comparing all addresses against each other
>> is pointless, as the hardware only uses the hardware MAC address and the BSSID
>> mask for matching the destination address, so all the address array
>> reallocation is completely unnecessary.
>>
>> This patch simplifies the logic by setting the initial mask bytes to 0xff
>> and removing all bits in the iterator call that don't match the hardware MAC
>> address. It also calls the iterator for the vif that was passed to
>> add_interface()
> 
> You probably need to fix the mask-setting logic in
> ath_opmode_init as well?
What do you mean?

- Felix
