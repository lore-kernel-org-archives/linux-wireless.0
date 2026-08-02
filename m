Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 604793815E2
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 08:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785658365; cv=none; b=QItF+xgTT6jhc9JGTPxBwRPKgXU7YyHNMbQOpSflgPC/pi0uLRltBQiX9fn8t/eUBydSa6ZvufWNgcKdaAqYUwm2xVri0idCF/hzBYr0Zefp28b3K0VI1ok3ommTNkJODn/rjLotYu8n0mgQm0Cch1+61F7up2fcfQ2NJi8zVHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785658365; c=relaxed/simple;
	bh=oonhCjUiNHQbXz2Jic4jiCUmV23VmwsAVITbWK/0fRA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uos9hGy1Rk9+JGHnmhLntFs90908SHmsIrxVzURw7+SE0bL3JNEtpompwcHlLeawwdOcjSw6kKFBAoM0bxjITLcJzrN8wLJUXKvPURU84cwVYIPWSQpfPpYjIGEs05K0rXNXciTnrGBvxmhHgJ9AsO8aV4grLoDOty23zHRLDv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYk11OM2; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYk11OM2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1785658362; x=1817194362;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oonhCjUiNHQbXz2Jic4jiCUmV23VmwsAVITbWK/0fRA=;
  b=nYk11OM2ZU/69ADdu8XadDWDx8uRhxThAQIDYNfbbX5UV9RgmkBdCd2n
   nZ6EiASZWwHabQIYrr8cXiIEWOO4/0E2FUCOhqyqjeUkNYWaumuWUSwtC
   fM5q+bZO83dAiY5LLFN467KCj4MyFMyq8yup/y5wt3Ds1dahmSlciyZZN
   LCKX0adNSBAPR3bWWDLE73PYZdgwePucuU74wJt0nm4a/N17BuvC7zbPS
   nMaZK+U/GersxaGO6QSzvVwFFUxoo6t0aSaNbfL6zaJUYQDnph8fRl+yN
   wMYj71jR4HwUp9QfsgOP5JsEskQIDRR21R4b7ckzyyEBr6yTUoKHqiDnI
   Q==;
X-CSE-ConnectionGUID: j/Vrn0W7SF+POyQ1VZwnUA==
X-CSE-MsgGUID: 0OOeaoUvRL2/OcGRJ9z4vg==
X-IronPort-AV: E=McAfee;i="6800,10657,11862"; a="96815241"
X-IronPort-AV: E=Sophos;i="6.25,200,1779174000"; 
   d="scan'208";a="96815241"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 01:12:41 -0700
X-CSE-ConnectionGUID: 8aq/kgCsSkCqwrEsvIIQWA==
X-CSE-MsgGUID: LWgVu8nuSDC8LstTZ/UBZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,200,1779174000"; 
   d="scan'208";a="284327323"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2026 01:12:40 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH wireless] wifi: mac80211: disconnect on CSA to channel 0
Date: Sun,  2 Aug 2026 11:12:17 +0300
Message-Id: <20260802111213.3bc833515e40.I255c37c31ca8b0b34e351cf254e16b6071dd8fb3@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The refactor for the CSA parsing erroneously equates channel
zero and no information present, leading it to ignore a CSA
on an AP that advertises a switch to that (invalid) channel.
This leads to not disconnecting, which we should. For Intel
devices, this can lead to a firmware crash.

Fix this by using an int type for the channel number as well
as the opclass, and using a (negative) value that cannot be
encoded in the element to indicate it's not present.

Fixes: 21c3f8f95554 ("wifi: mac80211: refactor STA CSA parsing flows")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/spectmgmt.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index ec622750e1c9..880f4625775d 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -227,7 +227,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 {
 	enum nl80211_band new_band = current_band;
 	int new_freq;
-	u8 new_chan_no = 0, new_op_class = 0;
+	int new_chan_no = -1, new_op_class = -1;
 	struct ieee80211_channel *new_chan;
 	struct cfg80211_chan_def new_chandef = {};
 	const struct ieee80211_sec_chan_offs_ie *sec_chan_offs;
@@ -256,7 +256,7 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		new_op_class = ext_chansw_elem->new_operating_class;
 
 		if (!ieee80211_operating_class_to_band(new_op_class, &new_band)) {
-			new_op_class = 0;
+			new_op_class = -1;
 			if (!unprot_action)
 				sdata_info(sdata,
 					   "cannot understand ECSA IE operating class, %d, ignoring\n",
@@ -268,14 +268,14 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		}
 	}
 
-	if (!new_op_class && elems->ch_switch_ie) {
+	if (new_op_class < 0 && elems->ch_switch_ie) {
 		new_chan_no = elems->ch_switch_ie->new_ch_num;
 		csa_ie->count = elems->ch_switch_ie->count;
 		csa_ie->mode = elems->ch_switch_ie->mode;
 	}
 
 	/* nothing here we understand */
-	if (!new_chan_no)
+	if (new_chan_no < 0)
 		return 1;
 
 	/* Mesh Channel Switch Parameters Element */
@@ -349,7 +349,8 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 				get_unaligned_le16(bwi->info.optional);
 	} else if (!wide_bw_chansw_ie || !wbcs_elem_to_chandef(wide_bw_chansw_ie,
 							       &new_chandef)) {
-		if (!ieee80211_operating_class_to_chandef(new_op_class, new_chan,
+		if (new_op_class < 0 ||
+		    !ieee80211_operating_class_to_chandef(new_op_class, new_chan,
 							  &new_chandef))
 			new_chandef = csa_ie->chanreq.oper;
 	}
-- 
2.34.1

