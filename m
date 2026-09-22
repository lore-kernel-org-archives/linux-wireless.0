Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C6553F6A1
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 12:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790081326; cv=none; b=ca4wrPbee8vAkjOA9qh7r7koIlCqatfu5XrKweBaHjid2i+w8lcaxq/CfzeFUjpKFH6vSY82AOLGpP7F8SnHcoG6uYH3l/8ScZkwrhys1hBz+chsioal+XaIKwzww8J7NKh4Rx3SK2nLM0ZX/SIMVGJX5BbHZ/uw5+6RBGZPgbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790081326; c=relaxed/simple;
	bh=QTxXMwsiRFFoVN51shJkah4jJ1R3Gec3u46VJqk3HAk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bXNPvupQSwk6OxxBbXWYiqSs1rtcx4Uh71WpJ9phTwuyfmDyZUYzxMt6Ku1+VQmJSZ3eTjlN+mQdupnKnWRSSSytOpOcx4gTSIQqtCdLnrd3OtfhQLDTiKrT3Q6zeJQ2sHVYSclzWCwlMl6+2RyHGaZMne/WB4P0vL79ABpES/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NjIlgrHy; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NjIlgrHy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=c7YI8x+6jK+ik3SRBaD9K4dxGQ8k9gfPgOhkeyux1Vg=; t=1790081325; x=1791290925; 
	b=NjIlgrHyBl9TlNbVVaIVDM0IxoC5eCCgtDHCdKTpvKJodhvEVHxPV2ZmkFMGewtWz47gw4uVS1Z
	O6iAiDMPFkUqB0Np8RN8ZhI0NM4e+oWHlVwLuNw6UnZQqf0mX7bsFcNn3Sarl+jPYtTUtMoo0alw9
	iLF+yKhctoVLuilyuSITjtOcNmPxRI3Cy8dR376gg9a9OTV5zduIJdfFWXLbDfGB4l68L+ud9kkSF
	fJUHE73czyOKNTfXIBBKzbDj+LzqGzzBzfb2VWS7ZmZm5B63bxSc9QViRi2pOzoM5N0no7G5oSnWT
	fiqK2LSV/ITdEYbtkzSPAnnrWvrbpX6h3ynQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x8zvM-00000006upq-2LHm;
	Tue, 22 Sep 2026 14:48:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+8bd4574e8c52c48c2595@syzkaller.appspotmail.com
Subject: [PATCH] wifi: mac80211: mesh: don't send peering close in listen
Date: Tue, 22 Sep 2026 14:48:37 +0200
Message-ID: <20260922144838.b1b35f44b069.I80ab9ad25eb48d291807ca968fcba6b64d8fb6ab@changeid>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

In listen state, nothing has been sent, so there's no
need to send a WLAN_SP_MESH_PEERING_CLOSE frame. Also,
in case the station just failed to insert, e.g. due
to a missing channel context, it might not be possible
to transmit the frame at all, leading to a warning.

Reported-by: syzbot+8bd4574e8c52c48c2595@syzkaller.appspotmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mesh_plink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 268857467f29..6ce3ae3fb39b 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -399,11 +399,13 @@ u64 mesh_plink_deactivate(struct sta_info *sta)
 {
 	struct ieee80211_sub_if_data *sdata = sta->sdata;
 	u64 changed;
+	bool send_close;
 
 	spin_lock_bh(&sta->mesh->plink_lock);
+	send_close = sta->mesh->plink_state != NL80211_PLINK_LISTEN;
 	changed = __mesh_plink_deactivate(sta);
 
-	if (!sdata->u.mesh.user_mpm) {
+	if (!sdata->u.mesh.user_mpm && send_close) {
 		sta->mesh->reason = WLAN_REASON_MESH_PEER_CANCELED;
 		mesh_plink_frame_tx(sdata, sta, WLAN_SP_MESH_PEERING_CLOSE,
 				    sta->sta.addr, sta->mesh->llid,
-- 
2.55.0

