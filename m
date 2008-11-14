Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:36899 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbYKNC7F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 21:59:05 -0500
Subject: Re: Problem with Kernel Oops in ipw2200
From: Zhu Yi <yi.zhu@intel.com>
To: Frank Seidel <fseidel@suse.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
In-Reply-To: <491BF062.4050705@suse.de>
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>
	 <20081112213350.GJ2411@tuxdriver.com>  <491BF062.4050705@suse.de>
Content-Type: multipart/mixed; boundary="=-bvJG/cX7sD5LC9PzDh1Q"
Date: Fri, 14 Nov 2008 10:58:58 +0800
Message-Id: <1226631539.2604.411.camel@debian.sh.intel.com> (sfid-20081114_035911_293780_28C293D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bvJG/cX7sD5LC9PzDh1Q
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Thu, 2008-11-13 at 17:16 +0800, Frank Seidel wrote:
> The problem is that before this patch ipw2200 didn't have that problem
> and now with it is constantly on various machines is running in
> a kernel oops at ipw_tx_skb called by ipw_net_hard_start_xmit.
> So imho that patch introduced the bug somehow and even partly
> reverting it fixes the problem here on my testmachine.

May I have your oops log?

Please try if attached patch fix the problem.

Thanks,
-yi

--=-bvJG/cX7sD5LC9PzDh1Q
Content-Disposition: attachment; filename=ipw2200-send-noassoc.patch
Content-Type: text/x-patch; name=ipw2200-send-noassoc.patch; charset=GB2312
Content-Transfer-Encoding: 7bit

diff --git a/drivers/net/wireless/ipw2200.c b/drivers/net/wireless/ipw2200.c
index 65a733d..0a14dea 100644
--- a/drivers/net/wireless/ipw2200.c
+++ b/drivers/net/wireless/ipw2200.c
@@ -10197,6 +10197,11 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct ieee80211_txb *txb,
 	u16 remaining_bytes;
 	int fc;
 
+	if (!(priv->status & STATUS_ASSOCIATED)) {
+		IPW_DEBUG("Tx attempt while not associated.\n");
+		goto drop;
+	}
+
 	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 	switch (priv->ieee->iw_mode) {
 	case IW_MODE_ADHOC:

--=-bvJG/cX7sD5LC9PzDh1Q--

