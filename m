Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:46056 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbYKXLJI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 06:09:08 -0500
Received: by ey-out-2122.google.com with SMTP id 6so785661eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 03:09:06 -0800 (PST)
Message-ID: <eb3ff54b0811240309u31944469xa444ee25f8ac8496@mail.gmail.com> (sfid-20081124_120914_364623_F391CDEA)
Date: Mon, 24 Nov 2008 13:09:06 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] zd1211rw: enable an AP that can't support fully PS clients (wireless-testing).
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org, j@w1.fi,
	"Daniel Drake" <dsd@gentoo.org>
In-Reply-To: <1227522918.3599.63.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0811232344t665fe6abp9ca2be85cfcbd855@mail.gmail.com>
	 <1227522918.3599.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
If you are talking about whether the zd1211 driver can buffer
mcast/bcast frames in software, it seems to me that the answer is
negative, since there is no call for ieee80211_get_buffered_bc() in
the zd1211rw driver code and also there is no handling of
IEEE80211_TX_CTL_SEND_AFTER_DTIM or
IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING in the zd1211rw driver code.
This what made me add the NL80211_ATTR_WIPHY_AP_PS_CHALLENGED
attribute and prepare this patch.


Regards,
Rami Rosen



On Mon, Nov 24, 2008 at 12:35 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-11-24 at 09:44 +0200, Rami Rosen wrote:
>> This patch enables master mode support in zd1211rw driver and enables
>> it to support the PS challenged mode when used in master mode.
>>
>> It adds this functionality in the zd1211rw driver by adding support to
>> master mode (NL80211_IFTYPE_AP) in zd_op_add_interface() and in
>> zd_mac_alloc_hw() methods
>> of drivers/net/wireless/zd_mac.c.
>>
>> In addition, the new boolean member of wiphy struct, ap_ps_challenged,
>> is initialized to true in zd_mac_alloc_hw().
>
> This is all fine, but I'm starting to wonder why we're doing this at
> all. Have we actually determined that zd1211 cannot buffer mcast/bcast
> frames at all? Might it be worth asking around in Zydas/Atheros?
>
> johannes
>
