Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A564B2714
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789553210; cv=none; b=eDGQIU+5psFgRE/ZuNogm3Vv5AdSqxVH1xNVuQ2roEk4DE/h7KmUKgGViTwe6I6k1qlxtGKsrVPSZngZFVIdXYv2AGCmt+7hq/9iOIRARzN3O/wM3GyM9Ffzs3i+1LZFalGMViJ9lNE1qbJMxuYXRoA9ZVpVkiT65IEfokxCtGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789553210; c=relaxed/simple;
	bh=BDRJ/yY504HQs/ocE9iWVSZdeMyUDadLps/cnJbF/nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Kfu7T0E2Ow555F3avzBSmHDvHt0upUt9Cs1Z92extk9iHW4uUuG2pXkTaT2C2MxSdh1T3s/ar3I3EJcujhvWJGxkxBK6OzyZ7Us7k8kTzRj2Rl1tEuL6f4XUPF+a5Zt7+ueoScRyibqg0e3kCZKwOqVk5BdXdAhVkGnNJQJJ9XY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=SxfLK4Zp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="SxfLK4Zp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=XfuLS2/JIVfoW+3pDUthmCw+9c5cvHdC4QYSihEfx+E=; t=1789553189; x=1790762789; 
	b=SxfLK4ZpF8LR5PjCmArqQevNC/obE843PpwD980zz47wBY/Q6BcBIAj62H8PlfPMakxbUwWMLw1
	TWzfhZV1Vnp3pPksasA4GWaxuAgc1DHNlEG0Kbvelw8k/Jny5hHGzH/AiEVKKpH0DS9gg0B4VQntz
	JCe71Klh511p/9mwDFWTE3MWxSJyPYx2ywNqRv1F8t2/sNkHjNldLg15a4pjOl1xyu2OU1lBfz1uA
	LP3E5RCVhec07yblS8d7kFeb0Uu9poQ6VEsfOjZs7jXRToNhdGOJV/Md09R5ilAhNIu1BaDpbfOUU
	FzvCPj7SK1+dLanIxhjCiCGHVPTiYMIpPP9g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x6mX0-00000000beA-2ABR;
	Wed, 16 Sep 2026 12:06:22 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: nl80211: rename no-ACK bitmap to TID bitmap
Date: Wed, 16 Sep 2026 12:06:20 +0200
Message-ID: <20260916120620.823bfa05f5f5.Ibb334016129512921b0aa5236ee4c670d83d0f95@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Rename the NL80211_ATTR_NOACK_MAP attribute to be called
NL80211_ATTR_TID_BITMAP, allowing it to be reused in more
contexts. The interpretation stays for the only command
using it now (NL80211_CMD_SET_NOACK_MAP.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
I needed a TID bitmap attribute for SMD transition - I'll
post those patches later but this seemed reasonable as is.
---
 include/uapi/linux/nl80211.h | 11 ++++++-----
 net/wireless/nl80211.c       |  6 +++---
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 510102febc26..9a2ccb8d66b8 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -937,8 +937,8 @@
  *	OLBC handling in hostapd. Beacons are reported in %NL80211_CMD_FRAME
  *	messages. Note that per PHY only one application may register.
  *
- * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap for the individual TIDs whether
- *      No Acknowledgement Policy should be applied.
+ * @NL80211_CMD_SET_NOACK_MAP: sets a bitmap (%NL80211_ATTR_TID_BITMAP)
+ *	indicating for which TIDs No Acknowledgment Policy should be applied.
  *
  * @NL80211_CMD_CH_SWITCH_NOTIFY: An AP or GO may decide to switch channels
  *	independently of the userspace SME, send this event indicating
@@ -2288,8 +2288,8 @@ enum nl80211_commands {
  *    abides to when initiating radiation on DFS channels. A country maps
  *    to one DFS region.
  *
- * @NL80211_ATTR_NOACK_MAP: This u16 bitmap contains the No Ack Policy of
- *      up to 16 TIDs.
+ * @NL80211_ATTR_TID_BITMAP: A TID bitmap (u16) whose meaning depends
+ *	on the command.
  *
  * @NL80211_ATTR_INACTIVITY_TIMEOUT: timeout value in seconds, this can be
  *	used by the drivers which has MLME in firmware and does not have support
@@ -3434,7 +3434,7 @@ enum nl80211_attrs {
 	NL80211_ATTR_DISABLE_HT,
 	NL80211_ATTR_HT_CAPABILITY_MASK,
 
-	NL80211_ATTR_NOACK_MAP,
+	NL80211_ATTR_TID_BITMAP,
 
 	NL80211_ATTR_INACTIVITY_TIMEOUT,
 
@@ -3807,6 +3807,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_CSA_C_OFF_BEACON NL80211_ATTR_CNTDWN_OFFS_BEACON
 #define NL80211_ATTR_CSA_C_OFF_PRESP NL80211_ATTR_CNTDWN_OFFS_PRESP
 #define NL80211_ATTR_ASSOC_MLD_EXT_CAPA_OPS NL80211_ATTR_EXT_MLD_CAPA_AND_OPS
+#define NL80211_ATTR_NOACK_MAP NL80211_ATTR_TID_BITMAP
 
 /*
  * Allow user space programs to use #ifdef on new attributes by defining them
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e77a4c81d031..ab5a14f5fe28 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -877,7 +877,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_HT_CAPABILITY_MASK] = {
 		.len = NL80211_HT_CAPABILITY_LEN
 	},
-	[NL80211_ATTR_NOACK_MAP] = { .type = NLA_U16 },
+	[NL80211_ATTR_TID_BITMAP] = { .type = NLA_U16 },
 	[NL80211_ATTR_INACTIVITY_TIMEOUT] = { .type = NLA_U16 },
 	[NL80211_ATTR_BG_SCAN_PERIOD] = { .type = NLA_U16 },
 	[NL80211_ATTR_WDEV] = { .type = NLA_U64 },
@@ -5282,13 +5282,13 @@ static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
 	struct net_device *dev = info->user_ptr[1];
 	u16 noack_map;
 
-	if (!info->attrs[NL80211_ATTR_NOACK_MAP])
+	if (!info->attrs[NL80211_ATTR_TID_BITMAP])
 		return -EINVAL;
 
 	if (!rdev->ops->set_noack_map)
 		return -EOPNOTSUPP;
 
-	noack_map = nla_get_u16(info->attrs[NL80211_ATTR_NOACK_MAP]);
+	noack_map = nla_get_u16(info->attrs[NL80211_ATTR_TID_BITMAP]);
 
 	return rdev_set_noack_map(rdev, dev, noack_map);
 }
-- 
2.55.0

