Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=iJ2GJgA6rJWxj21fbO4kF6SqGJUF8i3/Y4qShqpJj4juU411GBnr3eloWRLRVUtulr/O
	 p0Gad+6bz3a4HsVLZ45eAAS7F+lKy7YOce5mRUKHFqYd5J1WEOYEgA2J8Fd11Ud3X42rc
	 2Dvg3YTA9fIYDqve/1M/WLRD3MM7I5pwNXmp4wtOeK2MSVeNVUf51AOxUJ9wT9MEiZraH
	 3eGiCli7cNckarqLw1ilDzbPYdVp4YdKWd2YRN2YSKHWHN8ZOon9wSsPg6lWB8pux0Puu
	 ofRb9wajup/SVVfZsr5CkC+nwz9mkP1UnRZ+cc1GEImPnPGnx0h/SMV7qVhdwft4Chg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=8ybIOI0HGHgN/FqIEmpO/rfJJ3Y+x4zyF7zmLi9huo0=;
	b=CD1056h/35HemHQOiX4SJrJpCuuln+9AbJUY5lM6FKS1hBnYYkxVOB++gemFEasY9glk
	 MG7WUqU6TUw3BX3vuo668JwfvwoIFci5eBXZ8KnXVXVtC6dW1fnp8l2hT8gzxrjjIQW9l
	 SbAi1sRGudFbkidtR64uc2EcPw6pdRDNKSN+N9HZAH2WP2x1pQj7m2+9YVYTXq9tvmllv
	 oUgo1imIEjHLcgGvhkGwx6BhLbQY9azE/X1rVCMMXvhrGjkmR8FgfootOAoOEQmbFP4TN
	 622+2bWwUl6Fs4bVyFn9SstntYNJ38tOGjAwa2tyk88AeLrLBbpUlRquWPYCTY0Unog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=iwJwoPmj;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B0D606D81C
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55B0D606D81C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=iwJwoPmj
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8ybIOI0HGHgN/FqIEmpO/rfJJ3Y+x4zyF7zmLi9huo0=; b=iwJwoPmjwG9N3Q0cPTHc7GKqrL
	QR+qGBub7E0D0uh4aeMuNg+Ypzb0rf4dZlqtBZODv8LEhuT2lOJWg/aSU/PTt4VxqaQa01yJREMDl
	15v2rryuy5TqvxgpB8KteYtfIHfdoXOB/H0Oj2LUp/lN4OTCoU8y9O9xKA3QdM+HOIpY=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIm-00FDFp-21;
	Tue, 03 Nov 2026 17:24:00 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 09/18] wifi: cfg80211: split the DSCP mapping out of cfg80211_classify8021d()
Date: Tue,  3 Nov 2026 17:23:42 +0100
Message-ID: <f0c9e7a6ad7b2168ddce2fc0a5d5385ec22e2203.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A driver that passes the DSCP mapping to its firmware, or that
classifies an offloaded flow, has a DSCP but no frame to pass to
cfg80211_classify8021d(). Move the QoS map lookup and the RFC 8325
default mapping into cfg80211_dscp_to_up(), so that a caller can map a
DSCP without a frame.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h |  9 +++++++++
 net/wireless/util.c    | 25 ++++++++++++++++++-------
 2 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 35381c112af2..577c7100afe4 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -8161,6 +8161,15 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 				    struct cfg80211_qos_map *qos_map);
 
 /**
+ * cfg80211_dscp_to_up - map a DSCP to a user priority
+ * @dscp: the DSCP, 0 to 63
+ * @qos_map: Interworking QoS mapping or %NULL for the RFC 8325 default
+ * Return: The user priority.
+ */
+unsigned int cfg80211_dscp_to_up(unsigned int dscp,
+				 const struct cfg80211_qos_map *qos_map);
+
+/**
  * cfg80211_find_elem_match - match information element and byte array in data
  *
  * @eid: element ID
diff --git a/net/wireless/util.c b/net/wireless/util.c
index ad0e7b279111..49de2dd67b84 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1167,19 +1167,30 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 		return 0;
 	}
 
+	ret = cfg80211_dscp_to_up(dscp >> 2, qos_map);
+out:
+	return array_index_nospec(ret, IEEE80211_NUM_TIDS);
+}
+EXPORT_SYMBOL(cfg80211_classify8021d);
+
+unsigned int cfg80211_dscp_to_up(unsigned int dscp,
+				 const struct cfg80211_qos_map *qos_map)
+{
+	unsigned int ret;
+
 	if (qos_map) {
-		unsigned int i, tmp_dscp = dscp >> 2;
+		unsigned int i;
 
 		for (i = 0; i < qos_map->num_des; i++) {
-			if (tmp_dscp == qos_map->dscp_exception[i].dscp) {
+			if (dscp == qos_map->dscp_exception[i].dscp) {
 				ret = qos_map->dscp_exception[i].up;
 				goto out;
 			}
 		}
 
 		for (i = 0; i < 8; i++) {
-			if (tmp_dscp >= qos_map->up[i].low &&
-			    tmp_dscp <= qos_map->up[i].high) {
+			if (dscp >= qos_map->up[i].low &&
+			    dscp <= qos_map->up[i].high) {
 				ret = i;
 				goto out;
 			}
@@ -1190,7 +1201,7 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 	 * Most Significant Bits (MSBs) of the DSCP are used as the
 	 * corresponding L2 markings.
 	 */
-	ret = dscp >> 5;
+	ret = dscp >> 3;
 
 	/* Handle specific DSCP values for which the default mapping (as
 	 * described above) doesn't adhere to the intended usage of the DSCP
@@ -1203,7 +1214,7 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 	 * - Real-Time Interactive: CS4
 	 * - Signaling: CS5
 	 */
-	switch (dscp >> 2) {
+	switch (dscp) {
 	case 10:
 	case 12:
 	case 14:
@@ -1248,7 +1259,7 @@ unsigned int cfg80211_classify8021d(struct sk_buff *skb,
 out:
 	return array_index_nospec(ret, IEEE80211_NUM_TIDS);
 }
-EXPORT_SYMBOL(cfg80211_classify8021d);
+EXPORT_SYMBOL(cfg80211_dscp_to_up);
 
 const struct element *ieee80211_bss_get_elem(struct cfg80211_bss *bss, u8 id)
 {
-- 
git-series 0.9.1
