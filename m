Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2EGL3L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 07:29:11 -0400
Message-ID: <1336390146.4325.14.camel@jlt3.sipsolutions.net> (sfid-20120507_132915_361224_F040378B)
Subject: Re: WARNING: at net/mac80211/iface.c:162
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Date: Mon, 07 May 2012 13:29:06 +0200
In-Reply-To: <4FA77FE7.5030303@broadcom.com>
References: <4FA709B3.4030404@lwfinger.net>
	 ( sfid-20120507_013135_141792_546F01AB) <1336372450.4325.0.camel@jlt3.sipsolutions.net>
	 <4FA77FE7.5030303@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-07 at 09:55 +0200, Arend van Spriel wrote:
> On 05/07/2012 08:34 AM, Johannes Berg wrote:
> > On Sun, 2012-05-06 at 18:30 -0500, Larry Finger wrote:
> >> Hi,
> >>
> >> I am getting the following warning from the latest wireless-testing system:
> >>
> >>   ------------[ cut here ]------------
> >>   WARNING: at net/mac80211/iface.c:162 ieee80211_check_queues+0x119/0x130 
> >> [mac80211]()
> > 
> > 
> >>       if (WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
> >>
> >> The warning is triggered for i, n_queues, and sdata->vif.hw_queue[i] all equal to 1.
> > 
> > Is this a driver with just a single queue by any chance? I never tested
> > that and probably forgot to set those up correctly.
> > 
> 
> The bug report Larry mentions is with iwlwifi driver:
> 
> pci, iwlwifi, NETWORK, Centrino Wireless-N 130 BGN

No, the bug report says rtl8187, the user said this happened when
plugging in the USB device.

I think this will fix it:

--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -206,8 +206,10 @@ static void ieee80211_set_default_queues(struct ieee80211_sub_if_data *sdata)
 	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
 		if (local->hw.flags & IEEE80211_HW_QUEUE_CONTROL)
 			sdata->vif.hw_queue[i] = IEEE80211_INVAL_HW_QUEUE;
-		else
+		else if (local->hw.queues >= IEEE80211_NUM_ACS)
 			sdata->vif.hw_queue[i] = i;
+		else
+			sdata->vif.hw_queue[i] = 0;
 	}
 	sdata->vif.cab_queue = IEEE80211_INVAL_HW_QUEUE;
 }


johannes

