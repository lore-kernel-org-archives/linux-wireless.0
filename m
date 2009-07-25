Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:46910 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbZGYEXs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 00:23:48 -0400
Subject: Re: BUG in latest wireless-testing pull - 2.6.31-rc4
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A6A7D95.1080103@lwfinger.net>
References: <4A6A7D95.1080103@lwfinger.net>
Content-Type: text/plain
Date: Sat, 25 Jul 2009 00:21:55 -0400
Message-Id: <1248495715.2391.7.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-07-24 at 22:35 -0500, Larry Finger wrote:
> I pulled from the wireless-testing (git describe yields
> v2.6.31-rc4-29133-g1addf37) and get the following BUG:
> 
> BUG: unable to handle kernel NULL pointer dereference at 000000000000000c
> IP: [<ffffffffa0267fc1>] ieee80211_scan_work+0x18a/0x426 [mac80211]

I got it too :-(

> chan = local->scan_req->channels[local->scan_channel_idx];
> 
> in ieee80211_scan_state_set_channel().

The same thing here.

The oops happens when local->scan_channel_idx reaches 14, which is
local->scan_req->n_channels.

I tried this patch:

--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -588,6 +588,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
 	skip = 0;
+
+	if (local->scan_channel_idx >= local->scan_req->n_channels)
+		return;
+
 	chan = local->scan_req->channels[local->scan_channel_idx];
 
 	if (chan->flags & IEEE80211_CHAN_DISABLED ||


It prevents the oops, but now udev hangs on startup.   Perhaps
ieee80211_scan_state_set_channel() shouldn't set local->scan_channel_idx
to an invalid value in the first place.  Or maybe if it happens,
something else should be done to stop the scan.

-- 
Regards,
Pavel Roskin
