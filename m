Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48568 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZCJJK0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 05:10:26 -0400
Date: Tue, 10 Mar 2009 11:10:20 +0200
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC] cfg80211: send regulatory beacon hint events to userspace
Message-ID: <20090310091020.GA2578@jm.kir.nu> (sfid-20090310_101028_214589_B37532F0)
References: <1236653332-3515-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1236653332-3515-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 09, 2009 at 10:48:52PM -0400, Luis R. Rodriguez wrote:

> There is something awefully wrong with this patch and after some
> good review I cannot determine what is wrong with it. The issue is
> I end up following bug complaint saying I'm sleeping while I'm atomic..
> but this is all from a workqueue so what gives?

You hold a spinlock while trying to alloc memory with GFP_KERNEL..

> [14462.644641]  [<ffffffff804a40c4>] __alloc_skb+0x44/0x140
> [14462.644652]  [<ffffffffa051a8b3>] nl80211_send_beacon_hint_event+0x33/0x370 [cfg80211]
> [14462.644660]  [<ffffffff8026960e>] ? put_lock_stats+0xe/0x30
> [14462.644671]  [<ffffffffa0511f19>] handle_reg_beacon+0xa9/0xc0 [cfg80211]
> [14462.644685]  [<ffffffffa0512500>] ? reg_todo+0x0/0x5c0 [cfg80211]
> [14462.644696]  [<ffffffff80541a1d>] ? _spin_lock_bh+0x6d/0x80

That would be spin_lock_bh() from reg_process_pending_beacon_hints(), I
would assume.. nl80211_send_beacon_hint_event() cannot use GFP_KERNEL on
such a call path.

-- 
Jouni Malinen                                            PGP id EFC895FA
