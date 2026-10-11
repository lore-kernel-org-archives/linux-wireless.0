Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C923031B80E;
	Sun, 11 Oct 2026 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791755946; cv=none; b=WlL3nSKIJh/k4EKgHuM7r6pRdf95H8i+5wJZCkuN//ixHf8FPh85msIvcUqNex2JNn6ASG0DtOoOurmM0+xGzsQfoqEd9Y3PXpZiekmWa8W7ZTwlNWteV7m16UkA0g3D8GOiTmnDo+zbHiNyMgVIPZNClokhVg8JlIGJH60uZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791755946; c=relaxed/simple;
	bh=d+NTUVyVDetiwnvYSuPSA1B5KAFM0r7HORvNQ4h26Es=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=OQ7JMpk3hJitFuYnnALCx7yeYehaBpECk3aOkOgKytO8YC2QdNcnWL2Bg02kT/1ajmXMFYGKs9FiLsRNpMkHjvghfbD18kp6ouHtUKkjqCWvRChIT7NR15eHQmywiCS++/1wsDvM3vekeBfDxxJL3277oFfRC/Gx9m+aDXOg9KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCr3zy9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCr3zy9U"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EB5F4C2BCF5;
	Sun, 11 Oct 2026 21:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791755946;
	bh=d+NTUVyVDetiwnvYSuPSA1B5KAFM0r7HORvNQ4h26Es=;
	h=From:Date:Subject:To:Cc:Reply-To:From;
	b=RCr3zy9UBcCldAX9BW1nz+Kkrlfsn67VZEoWoJnva6ObMlB3PwK/3Dcn4aqXWfYLx
	 6J/5gAaqeVHWBl5/p8SOenBkMD/d8TYfL1v/mlB5d5uqWgXfADpj+b3V2sAqhcfBLS
	 8AlmSZypoXpNXSiqeFIci+Goi1WXYTeN/TYUJYEAgM4GdaGjp9uy91DSsRDOUwcK32
	 8kUqtt4lAHKtptzI1IFTqW9qe2edZPsWEEj3TrbqDPufkwCuxwE47hYANkumLyxHoD
	 lByH0yJq/CIsaQkwtG3T1ss9dtsOujv7rQA0AGecpCs1tnMBpKToOwBARXob6i1+Io
	 J6x+EIVt3Q4JA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80FDCA9ECF;
	Sun, 11 Oct 2026 21:59:05 +0000 (UTC)
From: Fabricio Akio via B4 Relay <devnull+fabricioakio.gmail.com@kernel.org>
Date: Sun, 11 Oct 2026 18:59:05 -0300
Subject: [PATCH] wifi: ath10k: don't reset TxBF on disassociation
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261011-ath10k-disassoc-txbf-v1-1-51e09115042e@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrB3IhJpAr1JcJHHUsaAlE4sg3
 r1pu3yL/09QzsIK9+aEzG9R2dYKahtIc1gnRhmqwRrryBBhKDOZJw6iQXVLWI44InfRe9u55G4
 eavrKPMrx2z76v3WPC6fyfcF1fQDsHsQgeAAAAA==
X-Change-ID: 20261011-ath10k-disassoc-txbf-e5b77256c647
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Fabricio Akio <fabricioakio@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791755944; l=2607;
 i=fabricioakio@gmail.com; s=20260928; h=from:subject:message-id;
 bh=yedrsdruZNEyyDyVSIF/isrw8Zan8nErgmxmiHmgDL8=;
 b=cew1YosN8FjDoaHqvWa0ZdfMoW2v03LTeceP8lH9yuKAlwlUfTzNqfbbnqqyUzaR4TwKbmhvF
 lfVTE8q2MeUDZRdW5MYxkJijLBIoCrrPwMrydWzTsth7IZQrewfUbLR
X-Developer-Key: i=fabricioakio@gmail.com; a=ed25519;
 pk=TlMUT8bPI/ZQzp2q24BIQTb2qSx/jdUTBlGEXIRCm54=
X-Endpoint-Received: by B4 Relay for fabricioakio@gmail.com/20260928 with
 auth_id=1076
X-Original-From: Fabricio Akio <fabricioakio@gmail.com>
Reply-To: fabricioakio@gmail.com

From: Fabricio Akio <fabricioakio@gmail.com>

WCN3990 firmware WLAN.HL.1.0.1.c2-00498 crashes whenever the vdev's
TxBF parameter is set while the vdev has no peer for its AP, whatever
the value. ath10k_bss_disassoc() sets it to 0 once the AP's peer is
gone. The firmware therefore crashes on every disconnect, including
the one cfg80211 makes before a suspend without WoWLAN, and whenever
mac80211 replays the state of an interface that is not associated, as
on resume from such a suspend and after a firmware restart. Each
restart replays it again, so the firmware never comes back:

  qcom-q6v5-mss 4080000.remoteproc: fatal error received:
    err_qdi.c:459:EX:wlan_process:1:WLAN RT:107b:PC=b00c8334

The reset is not needed: ath10k_bss_assoc() sets TxBF again from the
next AP's capabilities before bringing the vdev up. Drop it.

Fixes: 139e170da98a ("ath10k: add TxBF support")
Signed-off-by: Fabricio Akio <fabricioakio@gmail.com>
---
Tested on a Motorola Moto X4 (SDM630, WCN3990): without this patch a
disconnect, s2idle without an association and a forced modem restart
crashed the firmware every time; with it, none of those did, nor
s2idle while associated.

QCA6174 and QCA9377 also send this command and are untested here.
Qualcomm's qcacld-3.0, ath11k and ath12k do not send TxBF on
disassociation. A WCN3990-only hw_params flag was considered, but
association rewrites the parameter on every chip, so the patch drops
the reset for all of them.
---
 drivers/net/wireless/ath/ath10k/mac.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 8e604697d6c2..30355c598f97 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3190,7 +3190,6 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 {
 	struct ath10k *ar = hw->priv;
 	struct ath10k_vif *arvif = (void *)vif->drv_priv;
-	struct ieee80211_sta_vht_cap vht_cap = {};
 	int ret;
 
 	lockdep_assert_held(&ar->conf_mutex);
@@ -3204,14 +3203,6 @@ static void ath10k_bss_disassoc(struct ieee80211_hw *hw,
 			    arvif->vdev_id, ret);
 
 	arvif->def_wep_key_idx = -1;
-
-	ret = ath10k_mac_vif_recalc_txbf(ar, vif, vht_cap);
-	if (ret) {
-		ath10k_warn(ar, "failed to recalc txbf for vdev %i: %d\n",
-			    arvif->vdev_id, ret);
-		return;
-	}
-
 	arvif->is_up = false;
 
 	ath10k_mac_txpower_recalc(ar);

---
base-commit: becb95e45ef0dda9ffb35156d909d3da7a2789c3
change-id: 20261011-ath10k-disassoc-txbf-e5b77256c647

Best regards,
--  
Fabricio Akio <fabricioakio@gmail.com>


