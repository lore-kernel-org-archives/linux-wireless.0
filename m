Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49355 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1EaUWv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 16:22:51 -0400
Message-ID: <4DE54E16.7000709@openwrt.org> (sfid-20110531_222254_607187_875FC504)
Date: Tue, 31 May 2011 22:22:46 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/3] mac80211: create a STA entry for a WDS interface
 after receiving a beacon
References: <1306869394-83047-1-git-send-email-nbd@openwrt.org>	 <1306869394-83047-2-git-send-email-nbd@openwrt.org>	 <1306870354.29989.1.camel@jlt3.sipsolutions.net>	 <4DE543E2.9070600@openwrt.org> <1306872395.29989.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1306872395.29989.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-05-31 10:06 PM, Johannes Berg wrote:
> On Tue, 2011-05-31 at 21:39 +0200, Felix Fietkau wrote:
>>  On 2011-05-31 9:32 PM, Johannes Berg wrote:
>>  >  On Tue, 2011-05-31 at 21:16 +0200, Felix Fietkau wrote:
>>  >>   When a STA entry is created too early, a lot of essential information
>>  >>   required for rate control is missing.
>>  >
>>  >  I don't understand how you can rely on beacons for WDS.
>>  You usually set up WDS links between APs on the same channel, each
>>  running both a normal AP vif and a WDS vif. The remote AP's beacons are
>>  then used to detect the capabilities of the peer.
>
> I don't think we can rely on "usually" unless we also enforce that
> somehow. Otherwise this link will basically be dead. There's nothing
> that requires you to add WDS to an AP interface only after all.
I don't think using WDS without APs makes any sense. Since WDS alone 
does not use beacons or probe requests, there's nothing else that would 
ensure that rate information, HT capabilities, etc. get exchanged.

- Felix
