Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50690 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757857Ab2BIUQi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:16:38 -0500
Date: Thu, 9 Feb 2012 15:14:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net, arend@broadcom.com
Subject: Re: [PATCH] mac80211: do not call rate control .tx_status before
 .rate_init
Message-ID: <20120209201411.GB29948@tuxdriver.com> (sfid-20120209_211642_436101_11255664)
References: <1328725031-35464-1-git-send-email-nbd@openwrt.org>
 <20120208192536.GB2929@tuxdriver.com>
 <4F32CF18.4010300@openwrt.org>
 <20120208194453.GC2929@tuxdriver.com>
 <20120208180152.082cff4e@mj>
 <4F3318A7.5030809@openwrt.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <4F3318A7.5030809@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 09, 2012 at 01:51:51AM +0100, Felix Fietkau wrote:
> On 2012-02-09 12:01 AM, Pavel Roskin wrote:
> > On Wed, 8 Feb 2012 14:44:54 -0500
> > "John W. Linville" <linville@tuxdriver.com> wrote:
> > 
> >> On Wed, Feb 08, 2012 at 08:38:00PM +0100, Felix Fietkau wrote:
> >> > On 2012-02-08 8:25 PM, John W. Linville wrote:
> >> > > On Wed, Feb 08, 2012 at 07:17:11PM +0100, Felix Fietkau wrote:
> >> > >> Most rate control implementations assume .get_rate
> >> > >> and .tx_status are only called once the per-station data has
> >> > >> been fully initialized. minstrel_ht crashes if this assumption
> >> > >> is violated.
> >> > >> 
> >> > >> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> >> > >> Tested-by: Arend van Spriel <arend@broadcom.com>
> >> > >> ---
> >> > >>  net/mac80211/rate.h |    2 +-
> >> > >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >> > >> 
> >> > >> diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
> >> > >> index 5fc3135..fbb1efd 100644
> >> > >> --- a/net/mac80211/rate.h
> >> > >> +++ b/net/mac80211/rate.h
> >> > >> @@ -37,7 +37,7 @@ static inline void
> >> > >> rate_control_tx_status(struct ieee80211_local *local, struct
> >> > >> ieee80211_sta *ista = &sta->sta; void *priv_sta =
> >> > >> sta->rate_ctrl_priv; 
> >> > >> -	if (!ref)
> >> > >> +	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
> >> > >>  		return;
> >> > >>  
> >> > >>  	ref->ops->tx_status(ref->priv, sband, ista, priv_sta,
> >> > >> skb);
> >> > > 
> >> > > Any reason not to apply this for 3.3?  Or stable?
> >> > I think 3.3 doesn't have that sta flag, the issue was probably
> >> > introduced with the 3.4 changes.
> >> > I don't remember something like this appearing in earlier versions.
> >> 
> >> Cool, thanks.
> > 
> > I believe 3.3 is affected.  At least it looks like the Fedora bug 768639
> > (https://bugzilla.redhat.com/show_bug.cgi?id=768639) is caused by
> > calling .tx_status at a wrong time.  Fedora kernels use
> > compat-wireless-3.3.  I'm going to test the bleeding edge
> > compat-wireless with the patch by Felix to see if it fixes things.
> > 
> > The lack of the WLAN_STA_RATE_CONTROL flag doesn't mean that the old
> > behavior was correct.  The flag was introduced to correct that behavior.
> > 
> > The oldest report is dated 2011-12-17 and it's about Linux 3.2.0-rc5
> > with compat-wireless-2011-12-01.
> Only .get_rate and .tx_status are affected, wireless-testing commit
> e1936e9407138b483e6d1332dd944afec8131f30 adds one of the checks, and my
> commit adds the other. Maybe John could merge those two to 3.3.

At least one of them will cause some merge issues.  Can someone try
the attached patches to verify that they actually fix a real problem
in 3.3?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mac80211-call-rate-control-only-after-init.patch"

>From e11d0ade78b05641b969cb434680711ff04a159b Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Fri, 20 Jan 2012 13:55:23 +0100
Subject: [PATCH 1/2] mac80211: call rate control only after init

There are situations where we don't have the
necessary rate control information yet for
station entries, e.g. when associating. This
currently doesn't really happen due to the
dummy station handling; explicitly disabling
rate control when it's not initialised will
allow us to remove dummy stations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/debugfs_sta.c |    4 ++--
 net/mac80211/rate.c        |    2 +-
 net/mac80211/rate.h        |    1 +
 net/mac80211/sta_info.h    |    2 ++
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 2406b3e..d86217d 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -63,14 +63,14 @@ static ssize_t sta_flags_read(struct file *file, char __user *userbuf,
 	test_sta_flag(sta, WLAN_STA_##flg) ? #flg "\n" : ""
 
 	int res = scnprintf(buf, sizeof(buf),
-			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
+			    "%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s",
 			    TEST(AUTH), TEST(ASSOC), TEST(PS_STA),
 			    TEST(PS_DRIVER), TEST(AUTHORIZED),
 			    TEST(SHORT_PREAMBLE),
 			    TEST(WME), TEST(WDS), TEST(CLEAR_PS_FILT),
 			    TEST(MFP), TEST(BLOCK_BA), TEST(PSPOLL),
 			    TEST(UAPSD), TEST(SP), TEST(TDLS_PEER),
-			    TEST(TDLS_PEER_AUTH));
+			    TEST(TDLS_PEER_AUTH), TEST(RATE_CONTROL));
 #undef TEST
 	return simple_read_from_buffer(userbuf, count, ppos, buf, res);
 }
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 5a5a776..ad64f4d 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -336,7 +336,7 @@ void rate_control_get_rate(struct ieee80211_sub_if_data *sdata,
 	int i;
 	u32 mask;
 
-	if (sta) {
+	if (sta && test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
 		ista = &sta->sta;
 		priv_sta = sta->rate_ctrl_priv;
 	}
diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 168427b..2b83f32 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -62,6 +62,7 @@ static inline void rate_control_rate_init(struct sta_info *sta)
 	sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
 	ref->ops->rate_init(ref->priv, sband, ista, priv_sta);
+	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
 }
 
 static inline void rate_control_rate_update(struct ieee80211_local *local,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 6f77f12..bfed851 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -52,6 +52,7 @@
  * @WLAN_STA_SP: Station is in a service period, so don't try to
  *	reply to other uAPSD trigger frames or PS-Poll.
  * @WLAN_STA_4ADDR_EVENT: 4-addr event was already sent for this frame.
+ * @WLAN_STA_RATE_CONTROL: rate control was initialized for this station.
  */
 enum ieee80211_sta_info_flags {
 	WLAN_STA_AUTH,
@@ -71,6 +72,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
+	WLAN_STA_RATE_CONTROL,
 };
 
 enum ieee80211_sta_state {
-- 
1.7.4.4


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-mac80211-do-not-call-rate-control-.tx_status-before-.patch"

>From ecdf3e49fd8bcb6c09adf2558f6508f928e35af0 Mon Sep 17 00:00:00 2001
From: Felix Fietkau <nbd@openwrt.org>
Date: Wed, 8 Feb 2012 19:17:11 +0100
Subject: [PATCH 2/2] mac80211: do not call rate control .tx_status before
 .rate_init

Most rate control implementations assume .get_rate and .tx_status are only
called once the per-station data has been fully initialized.
minstrel_ht crashes if this assumption is violated.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Tested-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/rate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
index 2b83f32..80cfc00 100644
--- a/net/mac80211/rate.h
+++ b/net/mac80211/rate.h
@@ -41,7 +41,7 @@ static inline void rate_control_tx_status(struct ieee80211_local *local,
 	struct ieee80211_sta *ista = &sta->sta;
 	void *priv_sta = sta->rate_ctrl_priv;
 
-	if (!ref)
+	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
 		return;
 
 	ref->ops->tx_status(ref->priv, sband, ista, priv_sta, skb);
-- 
1.7.4.4


--XsQoSWH+UP9D9v3l--
