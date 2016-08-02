Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33398 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbcHBELW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 00:11:22 -0400
Subject: Re: [PATCH v3 3/3] mac80211: mesh: fixed HT ies in beacon template
To: Johannes Berg <johannes@sipsolutions.net>
References: <20160713200755.26839-1-yanivma@ti.com>
 <40a34537-486e-a466-5a7e-e253f19d81c3@gmail.com>
 <1470045822.3389.24.camel@sipsolutions.net>
 <75fef3ce-41a6-5845-e9be-d7ff052a07da@gmail.com>
Cc: Yaniv Machani <yanivma@ti.com>, linux-kernel@vger.kernel.org,
	Meirav Kama <meiravk@ti.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <1c2d3cfc-b7fd-c8fd-4f74-14dd3aa3076e@gmail.com> (sfid-20160802_061150_191787_D40E0B10)
Date: Tue, 2 Aug 2016 11:59:04 +0900
MIME-Version: 1.0
In-Reply-To: <75fef3ce-41a6-5845-e9be-d7ff052a07da@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 2016年08月01日 19:03, Johannes Berg wrote:
>>
>> But why is that behaviour *correct*? We still support 40 MHz bandwidth
>> things, we just don't use them if we disable HT40.

Or do you mean difference between "hardware capability" and "software 
capability" ?
Do you think IEEE80211_HT_CAP_SUP_WIDTH_20_40 bit should be 1 if the 
hardware capable of HT40 even though HT40 is disabled by 
wpa_supplicant/hostapd ?

I have tested with hostapd. I compared these 2 configfiles.

hostapd0.conf
	ht_capab=[HT40-]
hostapd1.conf
	#ht_capab=[HT40-]

The IEEE80211_HT_CAP_SUP_WIDTH_20_40 bit in beacon was below.

hostapd0.conf
	IEEE80211_HT_CAP_SUP_WIDTH_20_40 = 1
hostapd1.conf
	IEEE80211_HT_CAP_SUP_WIDTH_20_40 = 0

So I think the bit should be zero if disabled also for mesh peer.

Masashi Honma.
