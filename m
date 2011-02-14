Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48051 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1BNV6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 16:58:08 -0500
Received: by bwz15 with SMTP id 15so5956280bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 13:58:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1297685871.3785.39.camel@jlt3.sipsolutions.net>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
	<1297619803-2832-5-git-send-email-njs@pobox.com>
	<1297685871.3785.39.camel@jlt3.sipsolutions.net>
Date: Mon, 14 Feb 2011 13:58:05 -0800
Message-ID: <AANLkTinuvxEuuz3-xWkhQ1fA8s7QumJHJQKpd1C48CV1@mail.gmail.com>
Subject: Re: [PATCH 4/5] iwlwifi: auto-tune tx queue size to minimize latency
From: Nathaniel Smith <njs@pobox.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wey-yi.w.guy@intel.com, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 14, 2011 at 4:17 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2011-02-13 at 09:56 -0800, Nathaniel J. Smith wrote:
>> This patch estimates how long it takes the hardware to transmit one
>> packet (by comparing each packet's queue residency time to the number
>> of packets it had to wait behind), and then further smooths these
>> estimates with an EWMA. Then, it uses the estimated packet
>> transmission time to choose the maximum queue size that will still
>> produce reasonably bounded queue residency times, given current
>> conditions.
>
> This sounds nice -- but couldn't it just as well be implemented in
> mac80211, at least for most devices (that have accurate TX status
> reporting)?

I don't know. I take it you're imagining a scheme where mac80211 keeps
a hash table or similar of all packets that have been queued to the
device, and does its own tx rate estimation and calls start/stop_queue
as needed? If that works, then it would be lovely. (Heck, it should
probably go in the generic net layer eventually; ethernet cards have
the same problem.) But there are enough complications around
multiqueue devices, packet aggregation strategies, interrupt
mitigation, etc., that I don't think I sit down and write this fully
general solution myself, at least not without a lot more experience
with the needs of different devices. So this patch is intended as a
start.

On Mon, Feb 14, 2011 at 7:46 AM, wwguy <wey-yi.w.guy@intel.com> wrote:
> Hi Nathaniel,
[...]
> should the high_mark get reset when interface up or queue reset.

Hi Wey,

I thought about that, but I can't see what difference it would make.
If we have no information about connection quality, then any high_mark
is as good as any other (and if anything, the previous connection's
quality is probably as good an estimate as we have, since people often
reconnect to the same network repeatedly after suspend, etc.). And in
any case, once connected, we should adapt quite quickly (esp. when
using the uplink heavily, which is the only time when the queue size
has an effect), so our starting value should hardly matter. But I have
no objection to resetting it if that seems cleaner somehow.

-- Nathaniel
