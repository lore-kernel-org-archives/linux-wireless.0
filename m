Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:54991 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751943Ab1ARPC4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 10:02:56 -0500
Message-ID: <4D35AB9D.6040004@openwrt.org>
Date: Tue, 18 Jan 2011 16:02:53 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH v2] mac80211: drop non-auth 3-addr data frames when running
 as a 4-addr station
References: <1295362128-2294-1-git-send-email-nbd@openwrt.org> <1295362547.3563.22.camel@jlt3.sipsolutions.net>
In-Reply-To: <1295362547.3563.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-18 3:55 PM, Johannes Berg wrote:
> On Tue, 2011-01-18 at 15:48 +0100, Felix Fietkau wrote:
>> When running as a 4-addr station against an AP that has the 4-addr VLAN
>> interface and the main 3-addr AP interface bridged together, sometimes
>> frames originating from the station were looping back from the 3-addr AP
>> interface, causing the bridge code to emit warnings about receiving frames
>> with its own source address.
>> I'm not sure why this is happening yet, but I think it's a good idea to
>> drop all frames (except 802.1x/EAP frames) that do not match the configured
>> addressing mode, including 4-address frames sent to a 3-address station.
>> User test reports indicate that the problem goes away with this patch.
> 
> This looks better, thanks. But did they really test _this_ patch? :)
A few users tested this and told me that it didn't make things worse
compared to my first patch - which did fix some, but not all issues
related to this.

- Felix
