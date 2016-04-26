Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:55777 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbcDZIGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 04:06:39 -0400
From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, sd@queasysnail.net, johannes@sipsolutions.net,
	kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
	jack@suse.com, linux-kernel@vger.kernel.org, pshelar@nicira.com,
	dev@openvswitch.org, jhs@mojatatu.com, philipp.reisner@linbit.com,
	lars.ellenberg@linbit.com, drbd-dev@lists.linbit.com,
	Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 1/8] macsec: use nla_put_u64_64bit()
Date: Tue, 26 Apr 2016 10:06:11 +0200
Message-Id: <1461657978-13360-2-git-send-email-nicolas.dichtel@6wind.com> (sfid-20160426_101049_050751_7C9C72D7)
In-Reply-To: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1461657978-13360-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/macsec.c           | 121 ++++++++++++++++++++++++++++++-----------
 include/uapi/linux/if_link.h   |   1 +
 include/uapi/linux/if_macsec.h |   6 ++
 3 files changed, 95 insertions(+), 33 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 6caa72402de7..a172a1ffa151 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1405,9 +1405,10 @@ static sci_t nla_get_sci(const struct nlattr *nla)
 	return (__force sci_t)nla_get_u64(nla);
 }
 
-static int nla_put_sci(struct sk_buff *skb, int attrtype, sci_t value)
+static int nla_put_sci(struct sk_buff *skb, int attrtype, sci_t value,
+		       int padattr)
 {
-	return nla_put_u64(skb, attrtype, (__force u64)value);
+	return nla_put_u64_64bit(skb, attrtype, (__force u64)value, padattr);
 }
 
 static struct macsec_tx_sa *get_txsa_from_nl(struct net *net,
@@ -2131,16 +2132,36 @@ static int copy_rx_sc_stats(struct sk_buff *skb,
 		sum.InPktsUnusedSA    += tmp.InPktsUnusedSA;
 	}
 
-	if (nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_OCTETS_VALIDATED, sum.InOctetsValidated) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_OCTETS_DECRYPTED, sum.InOctetsDecrypted) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNCHECKED, sum.InPktsUnchecked) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_DELAYED, sum.InPktsDelayed) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_OK, sum.InPktsOK) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_INVALID, sum.InPktsInvalid) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_LATE, sum.InPktsLate) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_VALID, sum.InPktsNotValid) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_USING_SA, sum.InPktsNotUsingSA) ||
-	    nla_put_u64(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNUSED_SA, sum.InPktsUnusedSA))
+	if (nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_OCTETS_VALIDATED,
+			      sum.InOctetsValidated,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_OCTETS_DECRYPTED,
+			      sum.InOctetsDecrypted,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNCHECKED,
+			      sum.InPktsUnchecked,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_DELAYED,
+			      sum.InPktsDelayed,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_OK,
+			      sum.InPktsOK,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_INVALID,
+			      sum.InPktsInvalid,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_LATE,
+			      sum.InPktsLate,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_VALID,
+			      sum.InPktsNotValid,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_USING_SA,
+			      sum.InPktsNotUsingSA,
+			      MACSEC_RXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNUSED_SA,
+			      sum.InPktsUnusedSA,
+			      MACSEC_RXSC_STATS_ATTR_PAD))
 		return -EMSGSIZE;
 
 	return 0;
@@ -2169,10 +2190,18 @@ static int copy_tx_sc_stats(struct sk_buff *skb,
 		sum.OutOctetsEncrypted += tmp.OutOctetsEncrypted;
 	}
 
-	if (nla_put_u64(skb, MACSEC_TXSC_STATS_ATTR_OUT_PKTS_PROTECTED, sum.OutPktsProtected) ||
-	    nla_put_u64(skb, MACSEC_TXSC_STATS_ATTR_OUT_PKTS_ENCRYPTED, sum.OutPktsEncrypted) ||
-	    nla_put_u64(skb, MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_PROTECTED, sum.OutOctetsProtected) ||
-	    nla_put_u64(skb, MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_ENCRYPTED, sum.OutOctetsEncrypted))
+	if (nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_PKTS_PROTECTED,
+			      sum.OutPktsProtected,
+			      MACSEC_TXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_PKTS_ENCRYPTED,
+			      sum.OutPktsEncrypted,
+			      MACSEC_TXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_PROTECTED,
+			      sum.OutOctetsProtected,
+			      MACSEC_TXSC_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_ENCRYPTED,
+			      sum.OutOctetsEncrypted,
+			      MACSEC_TXSC_STATS_ATTR_PAD))
 		return -EMSGSIZE;
 
 	return 0;
@@ -2205,14 +2234,30 @@ static int copy_secy_stats(struct sk_buff *skb,
 		sum.InPktsOverrun    += tmp.InPktsOverrun;
 	}
 
-	if (nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_OUT_PKTS_UNTAGGED, sum.OutPktsUntagged) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_UNTAGGED, sum.InPktsUntagged) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_OUT_PKTS_TOO_LONG, sum.OutPktsTooLong) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_TAG, sum.InPktsNoTag) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_BAD_TAG, sum.InPktsBadTag) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_UNKNOWN_SCI, sum.InPktsUnknownSCI) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_SCI, sum.InPktsNoSCI) ||
-	    nla_put_u64(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_OVERRUN, sum.InPktsOverrun))
+	if (nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_OUT_PKTS_UNTAGGED,
+			      sum.OutPktsUntagged,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_UNTAGGED,
+			      sum.InPktsUntagged,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_OUT_PKTS_TOO_LONG,
+			      sum.OutPktsTooLong,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_TAG,
+			      sum.InPktsNoTag,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_BAD_TAG,
+			      sum.InPktsBadTag,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_UNKNOWN_SCI,
+			      sum.InPktsUnknownSCI,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_SCI,
+			      sum.InPktsNoSCI,
+			      MACSEC_SECY_STATS_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_STATS_ATTR_IN_PKTS_OVERRUN,
+			      sum.InPktsOverrun,
+			      MACSEC_SECY_STATS_ATTR_PAD))
 		return -EMSGSIZE;
 
 	return 0;
@@ -2226,8 +2271,11 @@ static int nla_put_secy(struct macsec_secy *secy, struct sk_buff *skb)
 	if (!secy_nest)
 		return 1;
 
-	if (nla_put_sci(skb, MACSEC_SECY_ATTR_SCI, secy->sci) ||
-	    nla_put_u64(skb, MACSEC_SECY_ATTR_CIPHER_SUITE, DEFAULT_CIPHER_ID) ||
+	if (nla_put_sci(skb, MACSEC_SECY_ATTR_SCI, secy->sci,
+			MACSEC_SECY_ATTR_PAD) ||
+	    nla_put_u64_64bit(skb, MACSEC_SECY_ATTR_CIPHER_SUITE,
+			      DEFAULT_CIPHER_ID,
+			      MACSEC_SECY_ATTR_PAD) ||
 	    nla_put_u8(skb, MACSEC_SECY_ATTR_ICV_LEN, secy->icv_len) ||
 	    nla_put_u8(skb, MACSEC_SECY_ATTR_OPER, secy->operational) ||
 	    nla_put_u8(skb, MACSEC_SECY_ATTR_PROTECT, secy->protect_frames) ||
@@ -2312,7 +2360,9 @@ static int dump_secy(struct macsec_secy *secy, struct net_device *dev,
 
 		if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
 		    nla_put_u32(skb, MACSEC_SA_ATTR_PN, tx_sa->next_pn) ||
-		    nla_put_u64(skb, MACSEC_SA_ATTR_KEYID, tx_sa->key.id) ||
+		    nla_put_u64_64bit(skb, MACSEC_SA_ATTR_KEYID,
+				      tx_sa->key.id,
+				      MACSEC_SA_ATTR_PAD) ||
 		    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, tx_sa->active)) {
 			nla_nest_cancel(skb, txsa_nest);
 			nla_nest_cancel(skb, txsa_list);
@@ -2353,7 +2403,8 @@ static int dump_secy(struct macsec_secy *secy, struct net_device *dev,
 		}
 
 		if (nla_put_u8(skb, MACSEC_RXSC_ATTR_ACTIVE, rx_sc->active) ||
-		    nla_put_sci(skb, MACSEC_RXSC_ATTR_SCI, rx_sc->sci)) {
+		    nla_put_sci(skb, MACSEC_RXSC_ATTR_SCI, rx_sc->sci,
+				MACSEC_RXSC_ATTR_PAD)) {
 			nla_nest_cancel(skb, rxsc_nest);
 			nla_nest_cancel(skb, rxsc_list);
 			goto nla_put_failure;
@@ -2413,7 +2464,9 @@ static int dump_secy(struct macsec_secy *secy, struct net_device *dev,
 
 			if (nla_put_u8(skb, MACSEC_SA_ATTR_AN, i) ||
 			    nla_put_u32(skb, MACSEC_SA_ATTR_PN, rx_sa->next_pn) ||
-			    nla_put_u64(skb, MACSEC_SA_ATTR_KEYID, rx_sa->key.id) ||
+			    nla_put_u64_64bit(skb, MACSEC_SA_ATTR_KEYID,
+					      rx_sa->key.id,
+					      MACSEC_SA_ATTR_PAD) ||
 			    nla_put_u8(skb, MACSEC_SA_ATTR_ACTIVE, rx_sa->active)) {
 				nla_nest_cancel(skb, rxsa_nest);
 				nla_nest_cancel(skb, rxsc_nest);
@@ -3145,9 +3198,9 @@ static struct net *macsec_get_link_net(const struct net_device *dev)
 static size_t macsec_get_size(const struct net_device *dev)
 {
 	return 0 +
-		nla_total_size(8) + /* SCI */
+		nla_total_size_64bit(8) + /* SCI */
 		nla_total_size(1) + /* ICV_LEN */
-		nla_total_size(8) + /* CIPHER_SUITE */
+		nla_total_size_64bit(8) + /* CIPHER_SUITE */
 		nla_total_size(4) + /* WINDOW */
 		nla_total_size(1) + /* ENCODING_SA */
 		nla_total_size(1) + /* ENCRYPT */
@@ -3166,9 +3219,11 @@ static int macsec_fill_info(struct sk_buff *skb,
 	struct macsec_secy *secy = &macsec_priv(dev)->secy;
 	struct macsec_tx_sc *tx_sc = &secy->tx_sc;
 
-	if (nla_put_sci(skb, IFLA_MACSEC_SCI, secy->sci) ||
+	if (nla_put_sci(skb, IFLA_MACSEC_SCI, secy->sci,
+			IFLA_MACSEC_PAD) ||
 	    nla_put_u8(skb, IFLA_MACSEC_ICV_LEN, secy->icv_len) ||
-	    nla_put_u64(skb, IFLA_MACSEC_CIPHER_SUITE, DEFAULT_CIPHER_ID) ||
+	    nla_put_u64_64bit(skb, IFLA_MACSEC_CIPHER_SUITE,
+			      DEFAULT_CIPHER_ID, IFLA_MACSEC_PAD) ||
 	    nla_put_u8(skb, IFLA_MACSEC_ENCODING_SA, tx_sc->encoding_sa) ||
 	    nla_put_u8(skb, IFLA_MACSEC_ENCRYPT, tx_sc->encrypt) ||
 	    nla_put_u8(skb, IFLA_MACSEC_PROTECT, secy->protect_frames) ||
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 9300c08346c8..d82de331bb6b 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -434,6 +434,7 @@ enum {
 	IFLA_MACSEC_SCB,
 	IFLA_MACSEC_REPLAY_PROTECT,
 	IFLA_MACSEC_VALIDATION,
+	IFLA_MACSEC_PAD,
 	__IFLA_MACSEC_MAX,
 };
 
diff --git a/include/uapi/linux/if_macsec.h b/include/uapi/linux/if_macsec.h
index 26b0d1e3e3e7..4c623d617b84 100644
--- a/include/uapi/linux/if_macsec.h
+++ b/include/uapi/linux/if_macsec.h
@@ -55,6 +55,7 @@ enum macsec_secy_attrs {
 	MACSEC_SECY_ATTR_INC_SCI,
 	MACSEC_SECY_ATTR_ES,
 	MACSEC_SECY_ATTR_SCB,
+	MACSEC_SECY_ATTR_PAD,
 	__MACSEC_SECY_ATTR_END,
 	NUM_MACSEC_SECY_ATTR = __MACSEC_SECY_ATTR_END,
 	MACSEC_SECY_ATTR_MAX = __MACSEC_SECY_ATTR_END - 1,
@@ -66,6 +67,7 @@ enum macsec_rxsc_attrs {
 	MACSEC_RXSC_ATTR_ACTIVE,  /* config/dump, u8 0..1 */
 	MACSEC_RXSC_ATTR_SA_LIST, /* dump, nested */
 	MACSEC_RXSC_ATTR_STATS,   /* dump, nested, macsec_rxsc_stats_attr */
+	MACSEC_RXSC_ATTR_PAD,
 	__MACSEC_RXSC_ATTR_END,
 	NUM_MACSEC_RXSC_ATTR = __MACSEC_RXSC_ATTR_END,
 	MACSEC_RXSC_ATTR_MAX = __MACSEC_RXSC_ATTR_END - 1,
@@ -79,6 +81,7 @@ enum macsec_sa_attrs {
 	MACSEC_SA_ATTR_KEY,    /* config, data */
 	MACSEC_SA_ATTR_KEYID,  /* config/dump, u64 */
 	MACSEC_SA_ATTR_STATS,  /* dump, nested, macsec_sa_stats_attr */
+	MACSEC_SA_ATTR_PAD,
 	__MACSEC_SA_ATTR_END,
 	NUM_MACSEC_SA_ATTR = __MACSEC_SA_ATTR_END,
 	MACSEC_SA_ATTR_MAX = __MACSEC_SA_ATTR_END - 1,
@@ -110,6 +113,7 @@ enum macsec_rxsc_stats_attr {
 	MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_VALID,
 	MACSEC_RXSC_STATS_ATTR_IN_PKTS_NOT_USING_SA,
 	MACSEC_RXSC_STATS_ATTR_IN_PKTS_UNUSED_SA,
+	MACSEC_RXSC_STATS_ATTR_PAD,
 	__MACSEC_RXSC_STATS_ATTR_END,
 	NUM_MACSEC_RXSC_STATS_ATTR = __MACSEC_RXSC_STATS_ATTR_END,
 	MACSEC_RXSC_STATS_ATTR_MAX = __MACSEC_RXSC_STATS_ATTR_END - 1,
@@ -137,6 +141,7 @@ enum macsec_txsc_stats_attr {
 	MACSEC_TXSC_STATS_ATTR_OUT_PKTS_ENCRYPTED,
 	MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_PROTECTED,
 	MACSEC_TXSC_STATS_ATTR_OUT_OCTETS_ENCRYPTED,
+	MACSEC_TXSC_STATS_ATTR_PAD,
 	__MACSEC_TXSC_STATS_ATTR_END,
 	NUM_MACSEC_TXSC_STATS_ATTR = __MACSEC_TXSC_STATS_ATTR_END,
 	MACSEC_TXSC_STATS_ATTR_MAX = __MACSEC_TXSC_STATS_ATTR_END - 1,
@@ -153,6 +158,7 @@ enum macsec_secy_stats_attr {
 	MACSEC_SECY_STATS_ATTR_IN_PKTS_UNKNOWN_SCI,
 	MACSEC_SECY_STATS_ATTR_IN_PKTS_NO_SCI,
 	MACSEC_SECY_STATS_ATTR_IN_PKTS_OVERRUN,
+	MACSEC_SECY_STATS_ATTR_PAD,
 	__MACSEC_SECY_STATS_ATTR_END,
 	NUM_MACSEC_SECY_STATS_ATTR = __MACSEC_SECY_STATS_ATTR_END,
 	MACSEC_SECY_STATS_ATTR_MAX = __MACSEC_SECY_STATS_ATTR_END - 1,
-- 
2.8.1

