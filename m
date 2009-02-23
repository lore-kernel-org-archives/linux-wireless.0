Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56760 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814AbZBWVPU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 16:15:20 -0500
Date: Mon, 23 Feb 2009 16:11:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Lars Ericsson <Lars_Ericsson@telia.com>
Cc: "'Johannes Berg'" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: SIOCGIWSCAN-race
Message-ID: <20090223211155.GA8814@tuxdriver.com> (sfid-20090223_221524_088890_C081F26F)
References: <B944EEED4BC94818AF57142C1687A0A0@gotws1589>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <B944EEED4BC94818AF57142C1687A0A0@gotws1589>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 21, 2009 at 08:33:06AM +0100, Lars Ericsson wrote:
> Hi Johannes,
> 
> I have discovered and patched a race in the scanning function since a couple
> of releases.
> To day I checked the current Linux git and the problem is still there.
> 
> The problem is the sequence of events when the scan result is reported back.
> The wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL); 
> is called before ieee80211_hw_config(local);
> 
> ieee80211_hw_config(local) will trig the wpa_supplicant to select an AP. 
> That may happen before the ieee80211_hw_config() is executed since the
> wpa_supplicant
> generated actions is executed by an other thread (wpa_supplicant).
> 
> The result is that:
> - wpa_supplicant setup for an association to an ap using correct channel.
> - ieee80211_hw_config() reset the channel to the value before the SCAN
> started.
> - the association request will be sent out using the wrong channel.
> 
> 
> Attached you will find the patch for 2.6.27. 
> It is not a perfect patch since the code is duplicated but it works :)

Looks like the patch would need to be reworked -- the code in 2.6.29
and later is different.  Also, any reason we can't just move the
wireless_send_event() down to done:?

Still, this doesn't feel quite right.  Shouldn't we be able to queue
the userland-driven channel change until after the scan completes?

John

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index f5c7c33..8c13a91 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -437,15 +437,6 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	local->last_scan_completed = jiffies;
 	memset(&wrqu, 0, sizeof(wrqu));
 
-	/*
-	 * local->scan_sdata could have been NULLed by the interface
-	 * down code in case we were scanning on an interface that is
-	 * being taken down.
-	 */
-	sdata = local->scan_sdata;
-	if (sdata)
-		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
-
 	if (local->hw_scanning) {
 		local->hw_scanning = false;
 		/*
@@ -486,6 +477,15 @@ void ieee80211_scan_completed(struct ieee80211_hw *hw)
 	rcu_read_unlock();
 
  done:
+	/*
+	 * local->scan_sdata could have been NULLed by the interface
+	 * down code in case we were scanning on an interface that is
+	 * being taken down.
+	 */
+	sdata = local->scan_sdata;
+	if (sdata)
+		wireless_send_event(sdata->dev, SIOCGIWSCAN, &wrqu, NULL);
+
 	ieee80211_mlme_notify_scan_completed(local);
 	ieee80211_mesh_notify_scan_completed(local);
 }

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
