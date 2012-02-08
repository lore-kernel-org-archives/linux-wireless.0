Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1335 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab2BHMd7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 07:33:59 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Felix Fietkau" <nbd@openwrt.org>
Subject: [PATCH] mac80211: minstrel_ht: fix NULL pointer dereference
 during auth/assoc
Date: Wed, 8 Feb 2012 13:33:41 +0100
Message-ID: <1328704421-31202-1-git-send-email-arend@broadcom.com> (sfid-20120208_133402_868106_DCB45AA2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes the following NULL pointer dereference:

> I rerun the test on a kernel with some more lock checking and got lucky.
>
> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512283] wlan0: authenticate
> with 98:fc:11:8e:94:57
> Feb  8 08:40:17 lb-bun-10 kernel: [  514.512515] wlan0: send auth to
> 98:fc:11:8e:94:57 (try 1/3)
> Feb  8 08:40:17 lb-bun-10 kernel: [  514.514184] BUG: unable to handle
> kernel NULL pointer dereference at 00000004
> Feb  8 08:40:17 lb-bun-10 kernel: [  514.514233] IP: [<f8648f08>]
> minstrel_tx_status+0x48/0xe0 [mac80211]

static inline int
rix_to_ndx(struct minstrel_sta_info *mi, int rix)
{
        int i = rix;
        for (i = rix; i >= 0; i--)
                if (mi->r[i].rix == rix)
  48:   3b 58 04                cmp    0x4(%eax),%ebx
  4b:   74 4b                   je     98 <minstrel_tx_status+0x98>
  4d:   83 c2 01                add    $0x1,%edx

It fails because of mi->r[i] being a NULL pointer. It is allocated in
minstel_alloc_sta, but minstrel_ht_alloc_sta does not call that function.

struct minstrel_ht_sta_priv holds a union with struct minstrel_ht_sta and
struct minstrel_sta_info. During authenticate the bool is_ht is false so
minstrel_ht_tx_status calls minstrel_tx_status, but minstrel_sta_info::r
is not set until rate_init which is after assoc.

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index ff5f7b8..cf3919f 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -813,6 +813,9 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	if (!msp->sample_table)
 		goto error1;
 
+        msp->legacy.r = msp->ratelist;
+        msp->legacy.sample_table = msp->sample_table;
+
 	return msp;
 
 error1:
-- 
1.7.5.4


