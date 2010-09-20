Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:42498 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755221Ab0ITO3Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 10:29:25 -0400
Message-ID: <4C976FBD.8010007@openwrt.org>
Date: Mon, 20 Sep 2010 16:29:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 2/5] ath9k: fix an aggregation start related race condition
References: <1284983140-30099-1-git-send-email-nbd@openwrt.org> <1284983140-30099-2-git-send-email-nbd@openwrt.org> <AANLkTinRQsy3JZ5yr_9xjPhFA3Mez5ewV1V+R1dN3yen@mail.gmail.com>
In-Reply-To: <AANLkTinRQsy3JZ5yr_9xjPhFA3Mez5ewV1V+R1dN3yen@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-09-20 4:19 PM, Luis R. Rodriguez wrote:
> On Mon, Sep 20, 2010 at 4:45 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>> A new aggregation session start can be issued by mac80211, even when the
>> cleanup of the previous session has not completed yet. Since the data structure
>> for the session is not recreated, this could corrupt the block ack window
>> and lock up the aggregation session. Fix this by delaying the new session
>> until the old one has been cleaned up.
>>
>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>> Cc: stable@kernel.org
> 
> Any reason to not fix this in mac80211 instead?
mac80211 is already doing the right thing here. The cleanup is ath9k
specific.

- Felix
