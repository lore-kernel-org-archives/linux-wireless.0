Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:56861 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750865Ab1EOUvH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 16:51:07 -0400
From: Clemens Noss <cnoss@gmx.de>
To: linux-wireless@vger.kernel.org, gregkh@suse.de
Cc: arend@broadcom.com, rvossen@broadcom.com, henryp@broadcom.com,
	brudley@broadcom.com, devel@linuxdriverproject.org
Subject: [PATCH] staging: brcm80211: use correct pointer types in bcm_pktq_flush
Date: Sun, 15 May 2011 22:50:46 +0200
Message-Id: <1305492646-20122-1-git-send-email-cnoss@gmx.de> (sfid-20110515_225117_574001_36CEA7EA)
In-Reply-To: <4DD02F72.3070905@broadcom.com>
References: <4DD02F72.3070905@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

to clarify the intention:

On Sun, May 15, 2011 at 09:54:26PM +0200, Arend van Spriel wrote:
> On 05/15/2011 08:10 PM, Hauke Mehrtens wrote:
[...]
>> Why don't you use the correct pointer type here instead of casting then
>> around and the parameter names are meaningless too.
>>
>> static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, struct
>> cb_del_ampdu_pars *ampdu_pars)
[...]
> Actually this is a generic callback mechanism in which an additional
> parameter can be passed, which can be of *any* type hence a void pointer
> seems justified here and a meaningless name is used. I do agree that the
> txi parameter will always be a struct sk_buff and should be indicated as
> such.

Reported-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Clemens Noss <cnoss@gmx.de>
---
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c |    3 +--
 drivers/staging/brcm80211/include/bcmutils.h   |    2 +-
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 0d93bd6..b1bc1a6 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -1225,9 +1225,8 @@ void wlc_ampdu_shm_upd(struct ampdu_info *ampdu)
 /*
  * callback function that helps flushing ampdu packets from a priority queue
  */
-static bool cb_del_ampdu_pkt(void *p, void *arg_a)
+static bool cb_del_ampdu_pkt(struct sk_buff *mpdu, void *arg_a)
 {
-	struct sk_buff *mpdu = (struct sk_buff *)p;
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(mpdu);
 	struct cb_del_ampdu_pars *ampdu_pars =
 				 (struct cb_del_ampdu_pars *)arg_a;
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 1d57934..4dc190b 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -74,7 +74,7 @@
 #define PKTQ_PREC_ITER(pq, prec)        for (prec = (pq)->num_prec - 1; prec >= 0; prec--)
 
 /* fn(pkt, arg).  return true if pkt belongs to if */
-	typedef bool(*ifpkt_cb_t) (void *, void *);
+typedef bool(*ifpkt_cb_t) (struct sk_buff *, void *);
 
 /* operations on a specific precedence in packet queue */
 
-- 
1.7.4.5

