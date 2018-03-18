Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25155 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752359AbeCRCcW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Mar 2018 22:32:22 -0400
Date: Sun, 18 Mar 2018 10:31:45 +0800
From: kbuild test robot <lkp@intel.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: kbuild-all@01.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC PATCH] brcmfmac: brcmf_cfg80211_ops can be static
Message-ID: <20180318023145.GA29191@intel11> (sfid-20180318_033241_617318_40BD2ABB)
References: <1521195085-439-5-git-send-email-arend.vanspriel@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1521195085-439-5-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fixes: 6a5eed240a1c ("brcmfmac: allocate struct brcmf_pub instance using wiphy_new()")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index a47fe23..4133d66 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5141,7 +5141,7 @@ static int brcmf_cfg80211_del_pmk(struct wiphy *wiphy, struct net_device *dev,
 	return brcmf_set_pmk(ifp, NULL, 0);
 }
 
-struct cfg80211_ops brcmf_cfg80211_ops = {
+static struct cfg80211_ops brcmf_cfg80211_ops = {
 	.add_virtual_intf = brcmf_cfg80211_add_iface,
 	.del_virtual_intf = brcmf_cfg80211_del_iface,
 	.change_virtual_intf = brcmf_cfg80211_change_iface,
