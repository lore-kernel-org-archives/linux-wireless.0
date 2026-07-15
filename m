Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C5943F0BB
	for <linux-wireless@vger.kernel.org>; Wed, 15 Jul 2026 19:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784142346; cv=none; b=YMp4Yx4reoHSoS6kAjDheqITvRLxMKAIJV8erOvl8kIDW0rfVpij9nCZEYicDKgHRdff2viBBuiIibx84kyONF+S38JblMvUOtc+bGWIR3sis7bBvCGO1b/uMN31hGwwvBqU3y+jKQhQATm4D7bFTP7UUHBY591SKckJAU+1TkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784142346; c=relaxed/simple;
	bh=74cN3P1p+GOp8oSwfH/Fv/QyDI0BHBRhYapaBKJcLyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EvqpVwaoMczg8j9xYgy4nMHMOexC+Tk5Ue6b5ioGNU6rv5xZlKogOFOIOgz7dUBYY0SlvY3sp00YEjf2XXkvSl+JTbtooVFdRX0oeBB8AW8Pbxw05OT1YIO4/OyOs7XUKstf2umK8VVlITBQcFXdMCMkuMkuElEnrH9ugsikVlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Kt3IBydc; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Kt3IBydc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784142338; x=1815678338;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=74cN3P1p+GOp8oSwfH/Fv/QyDI0BHBRhYapaBKJcLyE=;
  b=Kt3IBydckX4KGrfrSGTE7uGkZFS8zAtK1f59eGsibWZdFi2VPooQqm++
   8kwDkTBWAD597yXwbmNrxuZyDoiHWRCeWiEq1pBD5u4BM24nJ7kkoJhJ8
   DLdMIyeJptBqK3iX4y//aDS3cQocFuXt+YcOypRtDq2R5yg/+6sI9Ls22
   JC11oQ80d8QQMGUg+PwqcvqPsC89+tHgkrEhMTr84lxN3cfCGcVo1QPpV
   HKdw8rTsMurivtv9q2/aM/fhW+OIeEImX6gjcRUGZMjfbm4DP9QBTPC18
   IAtwkDH+ALOdtR2yx8djWykn8QVQeMvBcpDLyUk80sAo8GcAHvg7ZpFmJ
   Q==;
X-CSE-ConnectionGUID: YvGQRaFnSaKA4W3q/19m5Q==
X-CSE-MsgGUID: nhs78QD4Tyqf60cEKO9uzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="87340741"
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="87340741"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:10 -0700
X-CSE-ConnectionGUID: XwMyfRQFSAmxeIlnVYcolw==
X-CSE-MsgGUID: ilkwMldOQSqLLQvcOvo9zA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,166,1779174000"; 
   d="scan'208";a="251852042"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 12:05:09 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>
Subject: [PATCH iwlwifi-next 12/15] wifi: iwlwifi: mei: skip data read if length is too short
Date: Wed, 15 Jul 2026 22:04:28 +0300
Message-Id: <20260715220243.f66b10736047.I4a1dde517c36561d41358dd82a5cec8b6c886c14@changeid>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
References: <20260715190431.327910-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Avraham Stern <avraham.stern@intel.com>

When calculating the SAP data length, the code subtracts
sizeof(*ethhdr) from len. If the SAP data header indicates a length
that is shorter than ethernet header length, this will result in an
unsigned underflow which will lead to a kernel panic when trying to
put the data into the SKB. Fix it by skipping a message if the
indicated length is too short.
In addition, if the message type is not SAP_MSG_DATA_PACKET or skb
allocation fails, the loop skips to the next message but without
reading the message payload. This may result in reading the payload
as the next message header, which will lead to errors in parsing the
next messages. Fix it by skipping the message payload as well.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mei/main.c | 20 +++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mei/main.c b/drivers/net/wireless/intel/iwlwifi/mei/main.c
index c01435859349..c462c3b22ec1 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/mei/main.c
@@ -1041,11 +1041,14 @@ static void iwl_mei_read_from_q(const u8 *q_head, u32 q_sz,
 	u32 rd = *_rd;
 
 	if (rd + len <= q_sz) {
-		memcpy(buf, q_head + rd, len);
+		if (buf)
+			memcpy(buf, q_head + rd, len);
 		rd += len;
 	} else {
-		memcpy(buf, q_head + rd, q_sz - rd);
-		memcpy(buf + q_sz - rd, q_head, len - (q_sz - rd));
+		if (buf) {
+			memcpy(buf, q_head + rd, q_sz - rd);
+			memcpy(buf + q_sz - rd, q_head, len - (q_sz - rd));
+		}
 		rd = len - (q_sz - rd);
 	}
 
@@ -1086,24 +1089,29 @@ static void iwl_mei_handle_sap_data(struct mei_cl_device *cldev,
 			break;
 		}
 
+		valid_rx_sz -= len;
+
 		if (len < sizeof(*ethhdr)) {
 			dev_err(&cldev->dev,
 				"Data len is smaller than an ethernet header? len = %d\n",
 				len);
+			iwl_mei_read_from_q(q_head, q_sz, &rd, wr, NULL, len);
+			continue;
 		}
 
-		valid_rx_sz -= len;
-
 		if (le16_to_cpu(hdr.type) != SAP_MSG_DATA_PACKET) {
 			dev_err(&cldev->dev, "Unsupported Rx data: type %d, len %d\n",
 				le16_to_cpu(hdr.type), len);
+			iwl_mei_read_from_q(q_head, q_sz, &rd, wr, NULL, len);
 			continue;
 		}
 
 		/* We need enough room for the WiFi header + SNAP + IV */
 		skb = netdev_alloc_skb(netdev, len + QOS_HDR_IV_SNAP_LEN);
-		if (!skb)
+		if (!skb) {
+			iwl_mei_read_from_q(q_head, q_sz, &rd, wr, NULL, len);
 			continue;
+		}
 
 		skb_reserve(skb, QOS_HDR_IV_SNAP_LEN);
 		ethhdr = skb_push(skb, sizeof(*ethhdr));
-- 
2.34.1

