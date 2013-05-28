Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34192 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933730Ab3E1MRK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 08:17:10 -0400
Message-ID: <51A4A044.3030109@openwrt.org> (sfid-20130528_141713_546998_784F2233)
Date: Tue, 28 May 2013 14:17:08 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 1/3] cfg80211: support an active monitor interface
 flag
References: <1369738914-34367-1-git-send-email-nbd@openwrt.org> <1369741810.8548.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1369741810.8548.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-28 1:50 PM, Johannes Berg wrote:
> On Tue, 2013-05-28 at 13:01 +0200, Felix Fietkau wrote:
>> An active monitor interface is one that is used for communication (via
>> injection). It is expected to ACK incoming unicast packets. This is
>> useful for running various 802.11 testing utilities that associate to an
>> AP via injection and manage the state in user space.
> 
> Applied 1 and 2.
> 
> Allowing MAC address duplication seems a bit strange, but I guess it
> simplifies things for users?
It is allowed only for non-active monitor interfaces, which previously
did not use ieee80211_verify_mac and ignores the configured MAC address
anyway.

- Felix

