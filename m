Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:11512 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803Ab0HZUrX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 16:47:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 26 Aug 2010 13:47:19 -0700
Date: Thu, 26 Aug 2010 13:47:22 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Amod Bodas <Amod.Bodas@Atheros.com>
CC: Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Helmut Schaa <Helmut.Schaa@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	ext Kalle Valo <kvalo@adurom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: issues with scanning in mac80211
Message-ID: <20100826204722.GA1745@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Massaging this message a bit and putting it on the public
mailing list.

On Thu, Aug 26, 2010 at 01:14:36PM -0700, Amod Bodas wrote:
> Thanks Jouni. Even my observations are same i.e I see 1 sec or
> so scan before returning to home channel. Given background scan
> issue looks to be mac80211 related.
>
> Who is lead scan module expert in the community?

Well Helmut worked on it:

Author: Helmut Schaa <Helmut.Schaa@gmx.de>
Date:   Wed Feb 24 14:19:21 2010 +0100

    mac80211: Improve software scan timing
    
    The current software scan implemenation in mac80211 returns to the operating
    channel after each scanned channel. However, in some situations (e.g. no
    traffic) it would be nicer to scan a few channels in a row to speed up
    the scan itself.
    
    Hence, after scanning a channel, check if we have queued up any tx frames and
    return to the operating channel in that case.
    
    Unfortunately we don't know if the AP has buffered any frames for us. Hence,
    scan only as many channels in a row as the pm_qos latency and the negotiated
    listen interval allows us to.
    
    Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

but AFAICT the issues documented below were likely not considered into the
architecture and its the first time I see them pointed out, unless I missed
something. The above commit log shows only the pm_qos latency was taken
into consideration, which I suppose can be modified for now as a hack
to deal with these issues.

Jouni's observations below.

> -----Original Message-----
> From: Jouni Malinen 
> Sent: Thursday, August 26, 2010 12:22 PM
> To: Amod Bodas
> Cc: Luis Rodriguez
> Subject: Re: issues with scanning in mac80211
> 
> I do not know what is in compat-wireless, but at least the current
> wireless-testing.git background scanning algorithm in mac80211 looks
> pretty horrible from the view point of receiving broadcast frames from
> the current AP. I'm actually getting much worse results..
> My tests show 1020 ms away from operating channel vs. Sam's 175 ms.
> 
> mac80211 does not seem to even try to receive PS buffered
> broadcast/multicast frames. It is only limiting the off-channel scan
> operation based on listen interval (which is 10 with ath9k) which allows
> it to miss ten beacon intervals in row from the current AP even if the
> DTIM period is one.. In addition, the time when it leaves the operating
> channel is not synchronized with the beacons at all. Both of these
> should really be fixed in mac80211 in a way that at least provides an
> optional configuration parameter to try to receive all broadcast frames.
> 
> As far as unicast issues are concerned, I'm not aware of issues in this
> area and would need to see a wireless capture log showing a case where
> mac80211 (or ath9k for that matter) does something wrong. The current
> code seems to return to the operating channel every beacon_int *
> listen_int and as such, is likely to allow the AP to keep unicast frames
> in PS buffer (assuming there is not much traffic going on; which should
> be the case at least during the initial EAP authentication).
