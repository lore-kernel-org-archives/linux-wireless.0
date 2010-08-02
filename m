Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:38760 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651Ab0HBPmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 11:42:43 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy\, Wey-Yi" <wey-yi.w.guy@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi connection problems
References: <87tynqvtu6.fsf@sycorax.lbl.gov>
	<1279917523.10769.1.camel@wwguy-huron>
	<1280135867.3693.5.camel@jlt3.sipsolutions.net>
	<87mxtd5xlq.fsf@sycorax.lbl.gov>
	<1280212629.19098.0.camel@jlt3.sipsolutions.net>
	<87bp9l6f4k.fsf@sycorax.lbl.gov>
	<1280746705.3923.11.camel@jlt3.sipsolutions.net>
Date: Mon, 02 Aug 2010 08:42:37 -0700
In-Reply-To: <1280746705.3923.11.camel@jlt3.sipsolutions.net> (message from
	Johannes Berg on Mon, 02 Aug 2010 12:58:25 +0200)
Message-ID: <878w4pvx5e.fsf@sycorax.lbl.gov>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-=-=

Johannes Berg <johannes@sipsolutions.net> writes:

> However, if that doesn't help this seems like an ideal candidate for
> bisection, would you be willing to try that? I'd restrict to wireless
> code, i.e.
>
> git bisect start -- net/wireless net/mac80211 drivers/net/wireless/iwlwifi

so i think i finally managed to track this down. doing a git bisect i
get:

3474ad635db371b0d8d0ee40086f15d223d5b6a4 is the first bad commit
commit 3474ad635db371b0d8d0ee40086f15d223d5b6a4
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Apr 29 04:43:05 2010 -0700

    iwlwifi: apply filter flags directly

    Since iwl_configure_filter can now sleep since
    the mac80211 callback was changed, we can now
    apply filter flags changes directly.

    Also, while at it, make the code a bit more
    generic with a local macro. There's no need
    to check changed_flags since we apply all at
    the same time anyway.

    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

:040000 040000 40b7db1c9366981ce696f96a9e4a515bfafa6437 824fbd988db160dc0067bced1a8e907edc0fed97 M      drivers

then i did a git revert 3474ad635db371b0d8d0ee40086f15d223d5b6a4 there
was a conflict i had to edit by hand but the actual diff between 2.6.35
and the version that works is:


--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline; filename=iwlwifi.patch
Content-Description: bad commit

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 5bbc529..350a4a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1301,32 +1301,41 @@ void iwl_configure_filter(struct ieee80211_hw *hw,
 			  u64 multicast)
 {
 	struct iwl_priv *priv = hw->priv;
-	__le32 filter_or = 0, filter_nand = 0;
-
-#define CHK(test, flag)	do { \
-	if (*total_flags & (test))		\
-		filter_or |= (flag);		\
-	else					\
-		filter_nand |= (flag);		\
-	} while (0)
+	__le32 *filter_flags = &priv->staging_rxon.filter_flags;
 
 	IWL_DEBUG_MAC80211(priv, "Enter: changed: 0x%x, total: 0x%x\n",
 			changed_flags, *total_flags);
 
-	CHK(FIF_OTHER_BSS | FIF_PROMISC_IN_BSS, RXON_FILTER_PROMISC_MSK);
-	CHK(FIF_CONTROL, RXON_FILTER_CTL2HOST_MSK);
-	CHK(FIF_BCN_PRBRESP_PROMISC, RXON_FILTER_BCON_AWARE_MSK);
-
-#undef CHK
-
-	mutex_lock(&priv->mutex);
-
-	priv->staging_rxon.filter_flags &= ~filter_nand;
-	priv->staging_rxon.filter_flags |= filter_or;
-
-	iwlcore_commit_rxon(priv);
+	if (changed_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS)) {
+		if (*total_flags & (FIF_OTHER_BSS | FIF_PROMISC_IN_BSS))
+			*filter_flags |= RXON_FILTER_PROMISC_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_PROMISC_MSK;
+	}
+	if (changed_flags & FIF_ALLMULTI) {
+		if (*total_flags & FIF_ALLMULTI)
+			*filter_flags |= RXON_FILTER_ACCEPT_GRP_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_ACCEPT_GRP_MSK;
+	}
+	if (changed_flags & FIF_CONTROL) {
+		if (*total_flags & FIF_CONTROL)
+			*filter_flags |= RXON_FILTER_CTL2HOST_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_CTL2HOST_MSK;
+	}
+	if (changed_flags & FIF_BCN_PRBRESP_PROMISC) {
+		if (*total_flags & FIF_BCN_PRBRESP_PROMISC)
+			*filter_flags |= RXON_FILTER_BCON_AWARE_MSK;
+		else
+			*filter_flags &= ~RXON_FILTER_BCON_AWARE_MSK;
+	}
 
-	mutex_unlock(&priv->mutex);
+	/* We avoid iwl_commit_rxon here to commit the new filter flags
+	 * since mac80211 will call ieee80211_hw_config immediately.
+	 * (mc_list is not supported at this time). Otherwise, we need to
+	 * queue a background iwl_commit_rxon work.
+	 */
 
 	/*
 	 * Receiving all multicast frames is always enabled by the

--=-=-=


and now 2.6.35 with this commit reverted (the above patch applied)
connects to my access point. 

i am willing to test an official patch against 2.6.35 (i'm just about to
leave for work so it might not happen until later today though).

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |

--=-=-=--
