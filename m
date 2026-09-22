Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB967442B32
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072337; cv=none; b=Ua8eGAkowC8VxrdR+T7FUG+vzmu/GVnjlQn+eSryOf466eSXHvLpIq/fsqORQZ7ka53bPM8o9p5QER4gvlD/Q8aBOv5Oz1B4mTzPNzhc9LNOo5mG7ivtu/GJD4k1cvGqrpSR9yL+FxEYTUwXBLTMhEDAhSFuz0BegDewUPwmiCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072337; c=relaxed/simple;
	bh=4s+TY+DqQ+zy0XOMCcXHRdi+6XaH6k8faC5LDU+LdAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kL5bPxoyMBOhLBirsmWD0yhTL2NFtsnXttIj7FArA6Jk6h9HRPZGcCIGQfHqKjNid04CWhaSDjZNBpYROsirEaVv50xnp9Z7I3Ksi3sxnpPjdl7KRKuDJ7OawhclhASKyFem2C6fWTfpYTSk4jLNpdJdck2C47twNmOMdeWmdSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=K1I3fJc+; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="K1I3fJc+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wRTrmBM9AfC7NGkbD1vgtt3xHm7uqLRwHQ7WPx91Mow=; b=K1I3fJc+brxQUVT7zyMZ6UuMQF
	ycq5JhE7NPS9t/IhUFpgHuZrVNFiEqH+adgfYTY28ESBYMrE9/IHgRjxKhf9c4aEvrbzF5IZrshPS
	jEWCXAZh+gON8tjqya3BW1uWqEIT9GWLiPI411O8LJUhBkmtFMhP3vyab4MVhkIW+9SI=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xaM-0080aD-3D;
	Tue, 22 Sep 2026 12:18:51 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH 1/5] wifi: cfg80211: report an undecided SCS evaluation
Date: Tue, 22 Sep 2026 12:18:44 +0200
Message-ID: <92ad245dd3afa933ea2234c56228f5c63b52c5ee.1790072192.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
References: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A caller that evaluates a flow instead of a frame, such as a driver
that offloads flows to hardware, has no frame for a filter classifier
and may lack parameters that a classifier selects. A descriptor that
did not match for that reason could still match a frame of the flow,
so the caller must not derive a per flow rule from the verdict.

Add an undecided flag to the verdict. It is set when a descriptor that
did not match selects a parameter that the flow does not carry, and
matched on nothing else. The transmit path ignores it, since a frame
without the parameter cannot match.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h   |  4 ++-
 net/wireless/scs.c       | 28 +++++++++++-----
 net/wireless/tests/scs.c | 74 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 58b28c53a86b..2d670828d664 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4299,11 +4299,15 @@ struct cfg80211_mscs_desc {
  * struct cfg80211_scs_verdict - result of an SCS evaluation
  *
  * @match: an SCS descriptor matched the MSDU
+ * @undecided: a descriptor that did not match selects a parameter that the
+ *	MSDU lacks. A caller that evaluates a flow instead of a frame must
+ *	not derive a flow rule from this verdict.
  * @scsid: identifier of the matching descriptor
  * @up: user priority to assign
  */
 struct cfg80211_scs_verdict {
 	bool match;
+	bool undecided;
 	u8 scsid;
 	u8 up;
 };
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index 22c0b9d6930e..11094e77b440 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -760,14 +760,18 @@ static bool tclas_filter_offset(const struct cfg80211_flow_info *info,
 }
 
 static bool tclas_filter_match(const struct cfg80211_tclas *t,
-			       const struct cfg80211_flow_info *info)
+			       const struct cfg80211_flow_info *info,
+			       bool *undecided)
 {
 	const struct cfg80211_tclas_filter *f = &t->filter;
 	u8 buf[CFG80211_TCLAS_FILTER_LEN], *p;
 	unsigned int i, off;
 
-	if (!info->skb)
+	if (!info->skb) {
+		*undecided = true;
+
 		return false;
+	}
 
 	if (!tclas_filter_offset(info, f, &off))
 		return false;
@@ -784,16 +788,19 @@ static bool tclas_filter_match(const struct cfg80211_tclas *t,
 }
 
 static bool tclas_match(const struct cfg80211_tclas *t,
-			const struct cfg80211_flow_info *info)
+			const struct cfg80211_flow_info *info, bool *undecided)
 {
 	struct cfg80211_flow_key key;
 
 	if (t->type == CFG80211_TCLAS_FILTER)
-		return tclas_filter_match(t, info);
+		return tclas_filter_match(t, info, undecided);
 
 	if (!cfg80211_flow_key_build(info, t->fields, CFG80211_FLOW_AS_IS,
-				     &key))
+				     &key)) {
+		*undecided = true;
+
 		return false;
+	}
 
 	return !memcmp(&key, &t->key, sizeof(key));
 }
@@ -811,13 +818,14 @@ static u16 tclas_param_count(const struct cfg80211_tclas *t)
 }
 
 static bool scs_desc_match(const struct cfg80211_scs_desc *desc,
-			   const struct cfg80211_flow_info *info)
+			   const struct cfg80211_flow_info *info,
+			   bool *undecided)
 {
 	unsigned int i;
 	bool any = false;
 
 	for (i = 0; i < desc->n_tclas; i++) {
-		if (tclas_match(&desc->tclas[i], info)) {
+		if (tclas_match(&desc->tclas[i], info, undecided)) {
 			any = true;
 			continue;
 		}
@@ -870,10 +878,14 @@ void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
 	memset(verdict, 0, sizeof(*verdict));
 
 	for (i = 0; i < n_desc; i++) {
+		bool undecided = false;
 		u16 count;
 
-		if (!scs_desc_match(desc[i], info))
+		if (!scs_desc_match(desc[i], info, &undecided)) {
+			/* A missing parameter only matters without a match */
+			verdict->undecided |= undecided;
 			continue;
+		}
 
 		count = scs_desc_param_count(desc[i]);
 		if (count <= best)
diff --git a/net/wireless/tests/scs.c b/net/wireless/tests/scs.c
index d3636bd45964..19e05974c7ee 100644
--- a/net/wireless/tests/scs.c
+++ b/net/wireless/tests/scs.c
@@ -175,6 +175,7 @@ static void scs_granularity(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, verdict.match);
 	KUNIT_EXPECT_EQ(test, verdict.scsid, 1);
 	KUNIT_EXPECT_EQ(test, verdict.up, 3);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
 }
 
 /* A key learned from an uplink frame must describe the downlink direction */
@@ -322,6 +323,70 @@ static void tclas_refused(struct kunit *test)
 						  &fields));
 }
 
+/* A descriptor that matched leaves nothing undecided */
+static void scs_undecided(struct kunit *test)
+{
+	static const u8 addr_or_port[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,		/* source address */
+		4,
+		192, 168, 1, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x08,		/* source port */
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0x13, 0x88, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS_PROCESSING, 1, 1,
+	};
+	static const u8 port_only[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x08,
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0x13, 0x88, 0, 0,
+		0, 0, 0,
+	};
+	struct cfg80211_scs_verdict verdict;
+	struct cfg80211_flow_info info;
+	struct cfg80211_scs_desc *list[1];
+
+	list[0] = test_scs_desc(test, 1, 4, addr_or_port, sizeof(addr_or_port));
+	KUNIT_ASSERT_EQ(test, list[0]->n_tclas, 2);
+	KUNIT_ASSERT_EQ(test, list[0]->tclas_processing, 1);
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* A later fragment has no ports, but the address element matches */
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_fragment),
+					      &info));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* With nothing else to match on, the same fragment is undecided */
+	list[0] = test_scs_desc(test, 2, 4, port_only, sizeof(port_only));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
+}
+
 /* The presence bitmap decides where every optional field starts */
 static void qos_characteristics(struct kunit *test)
 {
@@ -466,11 +531,20 @@ static void scs_filter(struct kunit *test)
 	list[0] = test_scs_desc(test, 2, 5, wrong_sport, sizeof(wrong_sport));
 	cfg80211_scs_evaluate(list, 1, &info, &verdict);
 	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* Without a frame, a filter classifier cannot decide the flow */
+	list[0] = test_scs_desc(test, 3, 5, udp_sport, sizeof(udp_sport));
+	info.skb = NULL;
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
 }
 
 static struct kunit_case scs_cases[] = {
 	KUNIT_CASE(flow_parse_fragment),
 	KUNIT_CASE(scs_granularity),
+	KUNIT_CASE(scs_undecided),
 	KUNIT_CASE(scs_filter),
 	KUNIT_CASE(flow_key_mirror),
 	KUNIT_CASE(flow_key_mirror_eth),
-- 
git-series 0.9.1
