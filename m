Received: from mail-139-mta237.mxyeet.net (mail-139-mta237.mxyeet.net [23.172.139.237])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA623921F6
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 21:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.172.139.237
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791150693; cv=none; b=LhbEzdRE1bSCkkzqmYfGCHpPBxG4yZ+Xe1eGu2TWcbTDX7bYRtKc/0J1s8Djs8EaavlKTpkAg8qeIynWobThaL06gjtT5sDk6LqbpmnjXvk7uloqfzrgo6urPXkzWdw7py7G+1ECA5MFmG6fb/5NBAfbAzTXo0cAcvJljcGj5gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791150693; c=relaxed/simple;
	bh=4YlyFoVd99oxKR55yIsBbI8vnY/VmwSK2dh5SNpSSVE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X+SKT6+9bcFMVIEhofsaiJLN5QP05+8nLNPToPCM1+awnyyyd6VfX/vlI4Xi/Z8WqXBCmDuwZuaxa1ZaLIkKN7+oCC+R0pV04bFSYfYBfP0GqWrkSzOOQzz64fVa5Eyc1drj6zJn48guyhBIsdwOW9rY+LvLgUs3Gg4vAX3LrAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev; spf=pass smtp.mailfrom=endrik.dev; dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b=bQHp4LK2; arc=none smtp.client-ip=23.172.139.237
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=endrik.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b="bQHp4LK2"
Received: from lu-shared04.cpanelplatform.com [2602:faa9:3000::1006] (Authenticated sender: relay@mxyeet.net)
 by mail-139-mta237.mxyeet.net (MailFilter Outbound) with ESMTPSA id 1a108e1ccf900089d7.002
 for <linux-wireless@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Sun, 04 Oct 2026 21:46:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=endrik.dev;
	s=default; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vHFr8/CTwZAVFjirB4h0/WeMgo2o6MuAR0uEbIJCBZY=; b=bQHp4LK2fZxlDn8QqWbyUZu4EW
	QtJBRyx5F3cXUKAcQGCpOAhfP3Py4zQ4w5s6b4dpq4nzCkQ1RsKiCbdedDhKihqL8RRipQP4NZEPe
	CxZoMdrTmcm+GL0wpJ+NvW5AQPxL+Y7QECEVM//d6jrPNQ/t3sPdnWxqn3ASnLd0IhDxmGfvZ7b7D
	h6tcimhpi4n15fbmr3vyysP5i69NX7OjV2U3PcsP81cvhiiHIvVt0t1HolxkQuxapDG5IEtF/wVMl
	NFxI0G9ciJzDxZIbP183+46VO+VNxRQ0qKzfWoWzOEPAd7CIxrZBUT17bb/VUBMyOlFqojX2s7Pvd
	chcT0plA==;
Received: from [85.253.174.246] (port=35450 helo=noether.localdomain)
	by lu-shared04.cpanelplatform.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100.1)
	(envelope-from <git@endrik.dev>)
	id 1xDU2C-00000006hka-1q3y;
	Sun, 04 Oct 2026 23:46:16 +0200
From: Endrik Einberg <git@endrik.dev>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Endrik Einberg <git@endrik.dev>
Subject: [PATCH] wifi: iwlwifi: mld: include VI packets in low latency detection
Date: Mon,  5 Oct 2026 00:44:38 +0300
Message-ID: <20261004214438.128694-1-git@endrik.dev>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-From-Rewrite: unmodified, there is a forwarder that points to the actual sender.
X-AuthUser: endrik@endrik.dev
X-NCN-Id: qrBpiUCfTMOkjygEbw==

iwl_mld_is_vo_vi_pkt() checks whether the mapped access category
is less than IEEE80211_AC_VI.
Since mac80211 defines IEEE80211_AC_VO as 0 and IEEE80211_AC_VI as 1,
this only matches voice traffic and excludes video traffic.

Include IEEE80211_AC_VI as intended,
matching behaviour of iwlmvm's iwl_mvm_calc_tcm_stats().

Fixes: d1e879ec600f ("wifi: iwlwifi: add iwlmld sub-driver")
Signed-off-by: Endrik Einberg <git@endrik.dev>
---
 drivers/net/wireless/intel/iwlwifi/mld/low_latency.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
index a4ddc32e2860..36da639aee54 100644
--- a/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
+++ b/drivers/net/wireless/intel/iwlwifi/mld/low_latency.c
@@ -257,7 +257,7 @@ static bool iwl_mld_is_vo_vi_pkt(struct ieee80211_hdr *hdr)
 	if (tid >= IWL_MAX_TID_COUNT)
 		return false;
 
-	return tid_to_mac80211_ac[tid] < IEEE80211_AC_VI;
+	return tid_to_mac80211_ac[tid] <= IEEE80211_AC_VI;
 }
 
 void iwl_mld_low_latency_update_counters(struct iwl_mld *mld,
-- 
2.53.0

