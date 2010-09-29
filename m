Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48561 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab0I2Pay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:30:54 -0400
Message-ID: <4CA35BAB.8090701@candelatech.com>
Date: Wed, 29 Sep 2010 08:30:51 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211:  Allow scanning single channel if other
 VIF is associated.
References: <1285708650-21858-1-git-send-email-greearb@candelatech.com> <1285743733.3756.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1285743733.3756.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/29/2010 12:02 AM, Johannes Berg wrote:
> On Tue, 2010-09-28 at 14:17 -0700, greearb@candelatech.com wrote:

>> +	NL80211_ATTR_SCAN_ONE_IF_ASSOC,
>> +
>
> Still NACK, I don't see the need for new API for this odd case.
>
> Please don't resubmit similar patches to this, I don't want to nack them
> all the time.

Ok.

Does this portion seem useful as a stand-alone patch?  It does not
depend on the other scan-one logic.

diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index ae344d1..1bfc1e0 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -910,12 +910,17 @@ static void ieee80211_work_work(struct work_struct *work)
  			 *	 happen to be on the same channel as
  			 *	 the requested channel
  			 */
-			ieee80211_offchannel_stop_beaconing(local);
-			ieee80211_offchannel_stop_station(local);
-
-			local->tmp_channel = wk->chan;
-			local->tmp_channel_type = wk->chan_type;
-			ieee80211_hw_config(local, 0);
+			if (!(wk->chan == local->scan_channel ||
+			      (wk->chan == local->oper_channel &&
+			       !local->scan_channel))) {
+				/* Only change channels if we need to */
+				ieee80211_offchannel_stop_beaconing(local);
+				ieee80211_offchannel_stop_station(local);
+
+				local->tmp_channel = wk->chan;
+				local->tmp_channel_type = wk->chan_type;
+				ieee80211_hw_config(local, 0);
+			}
  			started = true;
  			wk->timeout = jiffies;
  		}

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
