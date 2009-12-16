Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.187]:49816 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933758AbZLPP7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 10:59:47 -0500
Message-ID: <4B290462.7070401@gmail.com>
Date: Wed, 16 Dec 2009 17:01:38 +0100
From: Roel Kluin <roel.kluin@gmail.com>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: Samuel Ortiz <samuel.ortiz@intel.com>, Zhu Yi <yi.zhu@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iwmc3200wifi: Fix test of unsigned in iwm_ntf_stop_resume_tx()
References: <4B28DBB6.5030304@gmail.com> <1260975195.2965.3.camel@ct>
In-Reply-To: <1260975195.2965.3.camel@ct>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

`queue' was unsigned so the test did not work.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
Found using coccinelle: http://coccinelle.lip6.fr/

>> -			if (queue < 0)
>> +			if (queue == -EINVAL)
> 
> I think it's ugly.  iwm_tid_to_queue() should return int if it's allowed
> to return error codes.

Ok, how about:

 drivers/net/wireless/iwmc3200wifi/iwm.h    |    2 +-
 drivers/net/wireless/iwmc3200wifi/netdev.c |    2 +-
 drivers/net/wireless/iwmc3200wifi/rx.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 5a26bb0..79ffa3b 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -349,7 +349,7 @@ int iwm_up(struct iwm_priv *iwm);
 int iwm_down(struct iwm_priv *iwm);
 
 /* TX API */
-u16 iwm_tid_to_queue(u16 tid);
+int iwm_tid_to_queue(u16 tid);
 void iwm_tx_credit_inc(struct iwm_priv *iwm, int id, int total_freed_pages);
 void iwm_tx_worker(struct work_struct *work);
 int iwm_xmit_frame(struct sk_buff *skb, struct net_device *netdev);
diff --git a/drivers/net/wireless/iwmc3200wifi/netdev.c b/drivers/net/wireless/iwmc3200wifi/netdev.c
index e4f0f87..c4c0d23 100644
--- a/drivers/net/wireless/iwmc3200wifi/netdev.c
+++ b/drivers/net/wireless/iwmc3200wifi/netdev.c
@@ -76,7 +76,7 @@ static int iwm_stop(struct net_device *ndev)
  */
 static const u16 iwm_1d_to_queue[8] = { 1, 0, 0, 1, 2, 2, 3, 3 };
 
-u16 iwm_tid_to_queue(u16 tid)
+int iwm_tid_to_queue(u16 tid)
 {
 	if (tid > IWM_UMAC_TID_NR - 2)
 		return -EINVAL;
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index 1c57c1f..6d6ed74 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1126,7 +1126,7 @@ static int iwm_ntf_stop_resume_tx(struct iwm_priv *iwm, u8 *buf,
 
 		if (!stop) {
 			struct iwm_tx_queue *txq;
-			u16 queue = iwm_tid_to_queue(bit);
+			int queue = iwm_tid_to_queue(bit);
 
 			if (queue < 0)
 				continue;
