Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47597 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab3I3Jna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:43:30 -0400
Message-ID: <524947C0.7060607@openwrt.org> (sfid-20130930_114333_939968_1C375613)
Date: Mon, 30 Sep 2013 11:43:28 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.12] mac80211: fix a tx power handling regression
References: <1380458883-19862-1-git-send-email-nbd@openwrt.org> <1380532158.14467.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1380532158.14467.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-09-30 11:09 AM, Johannes Berg wrote:
> On Sun, 2013-09-29 at 14:48 +0200, Felix Fietkau wrote:
>> commit 1ea6f9c0d48b11b6ec3ec4b5579ec74fc3951cf8
>> "mac80211: handle TX power per virtual interface"
>> 
>> This commit added support for tracking tx power configuration for
>> multiple interfaces, however instead of using the maximum value of all
>> virtual interfaces, it uses the minimum.
> 
> I'm not sure it should be using the maximum? What if the AP required
> lowering TX power by way of TPC for example?
Shouldn't that only affect the virtual interface that is connected to
that AP?
If there's a regulatory requirement to use lower tx power, it should be
tracked as a limit somewhere else instead of implicitly being handled
via vif tx power configuration.

- Felix

