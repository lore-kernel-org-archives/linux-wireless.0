Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:33469 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbZDPT5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 15:57:23 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: p54 problem with PS
Date: Thu, 16 Apr 2009 21:57:20 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1239823495.20927.1.camel@johannes.local>
In-Reply-To: <1239823495.20927.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_g245Jhvo3guhOHx"
Message-Id: <200904162157.20576.chunkeey@web.de> (sfid-20090416_215728_250340_85B23E92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_g245Jhvo3guhOHx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 15 April 2009 21:24:55 Johannes Berg wrote:
> Right after associating, the AP sends us the EAPOL frame. We miss that
> frame, due to a race condition (we add the STA info for the AP a little
> too late and drop the frame because we don't know who it is from).
> 
> The AP of course retries the frame, a little later, but p54 misses the
> TIM bit -- see the ps.pkt file.
> 
> We should probably make that race window smaller somehow (stop the
> tasklet that is processing RX while processing assoc frames maybe?) but
> this is clearly foremost a p54 problem.

Well, I guess I figured out what's wrong: the hw spec.
So this patch might work on PCI & USB, but could break SPI devices.

Johannes, can you please test the attached patch?

BTW: there might be two problems:
1. if the timeout is too low the device might be fast enough to go into ps:
  -  either before sending a probe request
   (firmware reports tx_status TX_PSM, so the frame wasn't sent at all)
  - or the AP got the request and responded... 
    But the frame was lost, because probe responds are not buffered...

2. there was something wrong in ieee80211_rx_mgmt_beacon
    Sometimes the TIM was parsed, but thanks to
    local->hw.conf.dynamic_ps_timeout == 0
    mac80211 didn't issue a wakeup => so no data => disconnect

    But this bug maybe comes from the old RFCs from yesterday,
    as I didn't tried the final version yet...

Oh and one question:
Some time ago, I found some useful function that converted beacon_int TUs <-> msec,
do we still have them somewhere around and I'm just (temp) blind ?

Regards,
	Chr

--Boundary-00=_g245Jhvo3guhOHx
Content-Type: text/x-patch;
  charset="iso-8859-15";
  name="p54ps-test.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="p54ps-test.diff"

diff --git a/drivers/net/wireless/p54/p54.h b/drivers/net/wireless/p54/p54.h
index d6354fa..482071b 100644
--- a/drivers/net/wireless/p54/p54.h
+++ b/drivers/net/wireless/p54/p54.h
@@ -181,6 +181,7 @@ struct p54_common {
 	u32 tsf_low32, tsf_high32;
 	u32 basic_rate_mask;
 	u16 aid;
+	unsigned long beacon_timeout_guard;
 	struct sk_buff *cached_beacon;
 
 	/* cryptographic engine information */
diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index ad2503a..0bd5e73 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -1058,7 +1058,8 @@ static void p54_rx_trap(struct ieee80211_hw *dev, struct sk_buff *skb)
 			wiphy_name(dev->wiphy), freq);
 		break;
 	case P54_TRAP_NO_BEACON:
-		if (priv->vif)
+		if (time_after(priv->beacon_timeout_guard, jiffies) &&
+		    priv->vif)
 			ieee80211_beacon_loss(priv->vif);
 		break;
 	case P54_TRAP_SCAN:
@@ -1941,10 +1942,12 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 	u16 mode;
 	int i;
 
-	if (dev->conf.flags & IEEE80211_CONF_PS)
+	if (dev->conf.flags & IEEE80211_CONF_PS) {
 		mode = P54_PSM | P54_PSM_BEACON_TIMEOUT | P54_PSM_DTIM |
 		       P54_PSM_CHECKSUM | P54_PSM_MCBC;
-	else
+		priv->beacon_timeout_guard = jiffies + msecs_to_jiffies(
+						priv->hw->conf.beacon_int);
+	} else
 		mode = P54_PSM_CAM;
 
 	skb = p54_alloc_skb(dev, P54_HDR_FLAG_CONTROL_OPSET, sizeof(*psm),
@@ -1963,8 +1966,8 @@ static int p54_set_ps(struct ieee80211_hw *dev)
 
 	psm->beacon_rssi_skip_max = 200;
 	psm->rssi_delta_threshold = 0;
-	psm->nr = 10;
-	psm->exclude[0] = 0;
+	psm->nr = 1;
+	psm->exclude[0] = WLAN_EID_TIM;
 
 	priv->tx(dev, skb);
 

--Boundary-00=_g245Jhvo3guhOHx--
