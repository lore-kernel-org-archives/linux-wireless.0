Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:34385 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144Ab0JRBwY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Oct 2010 21:52:24 -0400
Message-ID: <4CBBA850.1070503@openwrt.org>
Date: Mon, 18 Oct 2010 03:52:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH 4/6] ath9k: optimize/fix ANI RSSI processing
References: <1287165813-94331-1-git-send-email-nbd@openwrt.org> <1287165813-94331-3-git-send-email-nbd@openwrt.org> <1287165813-94331-4-git-send-email-nbd@openwrt.org> <201010181024.55475.br1@einfach.org>
In-Reply-To: <201010181024.55475.br1@einfach.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-18 3:24 AM, Bruno Randolf wrote:
> On Sat October 16 2010 03:03:31 Felix Fietkau wrote:
>> ANI needs the RSSI average only in station mode, and only for tracking
>> the signal strength of beacons of the AP that it is connected to.
>> Adjust the code to track on the beacon RSSI, and store the average of that
>> in the ath_wiphy struct.
>> With these changes, we can get rid of this extra station lookup in the
>> rx path, which saves precious CPU cycles.
> 
> wouldn't it make sense to have per-station RSSI in IBSS mode?
ath9k ANI can't deal with per-STA RSSI, and it's not something that the
driver should normally keep track of, as it's easier to do that in mac80211.

- Felix
