Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3624 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXHFRhG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 13:37:06 -0400
Date: Mon, 6 Aug 2007 13:05:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Wu <flamingice@sourmilk.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	jbenc@suse.cz, Michael Buesch <mb@bu3sch.de>,
	Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: mac80211 IPv6 problems
Message-ID: <20070806170500.GE6442@tuxdriver.com>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <1186094778.6701.6.camel@shinybook.infradead.org> <20070803005517.GA4261@tuxdriver.com> <200708030102.17358.flamingice@sourmilk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200708030102.17358.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 03, 2007 at 01:02:12AM -0700, Michael Wu wrote:

> This doesn't seem quite right. I think ieee80211_rx_h_data is a safer place 
> for this check (inside the IEEE80211_FCTL_FROMDS case), and allows various 
> statistics to be updated. ieee80211_rx_h_sta_process is another function that 
> might work though that would probably involve more code to add all the right 
> checks.

The patch below seems to work for me w/ an otherwise stock F-7 kernel
w/ iwl3945.  Thoughts?

From: John W. Linville <linville@tuxdriver.com>

[PATCH] mac80211: filter locally-originated multicast frames

In STA mode, the AP will echo our traffic.  This includes multicast
traffice.

Receiving these frames confuses some protocols and applications,
notably IPv6 Duplicate Address Detection.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

 net/mac80211/ieee80211.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index a42e70e..0097b0a 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -3030,9 +3030,10 @@ ieee80211_rx_h_data(struct ieee80211_txrx_data *rx)
 		memcpy(dst, hdr->addr1, ETH_ALEN);
 		memcpy(src, hdr->addr3, ETH_ALEN);
 
-		if (sdata->type != IEEE80211_IF_TYPE_STA) {
+		if (sdata->type != IEEE80211_IF_TYPE_STA ||
+		    (is_multicast_ether_addr(dst) &&
+		     !compare_ether_addr(src, dev->dev_addr)))
 			return TXRX_DROP;
-		}
 		break;
 	case 0:
 		/* DA SA BSSID */


-- 
John W. Linville
linville@tuxdriver.com
