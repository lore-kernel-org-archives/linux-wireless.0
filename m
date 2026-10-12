Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862C48EC6A;
	Mon, 12 Oct 2026 13:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.205.221.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810007; cv=none; b=i49pnPRMYy+ih2NuDYp9IlufIQvdpbIrD7+D47CS2LPkCRhGePa3YQnAgDy/xw4iKHrJgvitZlRN8KU3FzeeJU0s78t1UfWwOH/p3Z6zxBi2VsoaIlzZbRb0P4YimQbxs0DM7wp8ULZtqAPOwzMedH3yjrZu1FrUjIvuUxap7kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810007; c=relaxed/simple;
	bh=bIiGhEg42cXEjfOIwoIajqWbNokAPbabOfNrcPH0mGY=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=EpGbyRLVwEUMoO3cwx3icW54pNdOYwpYsfRnRInPlIYqbCpXfIV504lFTEMgtHNfb1S6mjrvBCsZdY+3YFiM8e0luLKLJyIcuJh49aAs7mpgxoXu+iLIBXtXDLZy0YtP/1xtjgE4mX1f9sh+zjoeQtGQlCsi3InMn7Nl1mCAxYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Rbw+yMuB; arc=none smtp.client-ip=203.205.221.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Rbw+yMuB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1791809997; bh=bp30NSjuFsaCAe+qWs1g5X7hc0pMA8zxyXHMbxScZQg=;
	h=From:To:Cc:Subject:Date;
	b=Rbw+yMuBN9TyrWMcUc5QMTLzYZj45fxbOwJD8kTAQUiUdL/drPzRWAaY7N+DwWfK+
	 6So6p71dSobKo9V7aswucZcFMnLJHXz7oR6dTjPWiVRhSCgxHnJwPDWUKsthyjDQ+R
	 8JoUF+0wcd5R6+C3v64gcs/SQ/laSaU3tPkjA3Uc=
Received: from chichu-arch.ibis-mark.ts.net ([27.38.246.181])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id EF738AF6; Mon, 12 Oct 2026 20:59:55 +0800
X-QQ-mid: xmsmtpt1791809995t7pwrbc8m
Message-ID: <tencent_2B956CE56BB4DE6A4748896922E04666FD0A@qq.com>
X-QQ-XMAILINFO: MhK4DKsBP06iyHC12lnLqyp0SqpeOUDBzHlhC8iQW46z+eFUV9HOwMTYBV38vz
	 /4QS1Jvkpf1YfONuM41dK6qBmf8lxz9UytpTH58dOETwRh1OxFOaGTdaHGNrPFm/vRRB31dCF6OR
	 fCjve1f60ExNe5z4A9WWNsTTONldD8I0BaG8UHuqd+PmvUJW8BWmHbKF3cs7X1G2jovB4mFIxstQ
	 H2NFRS90WVqL7jyMOscEt4P1lUpYwu77yLuh3wONIKWJ1Gm/eEfgbiF7/8n2EPln2W3YBCFiO0B+
	 NFKrGuxDwEPTkBt9jrZkDKlVtH7h4avpBtzyCHvp2p1GJKPHO1YoiWDtaJ1lBitjuCHoGgtabqCv
	 ShVOy2j1j2lTyaeeef/hbzW1m1dFA8mpjO1fJKwXOj6HyDtZ6Hz0ceu15YQ3oTLUvmDlt6yQR59M
	 QqgmxllDIR+stDniC1g/xy5+d/FCOeE6xVyY9MM3Gv02JLuSK0uH/fVSNu9FISDMoiETlK91tkyh
	 AiL9C+iQEy622kUX4UhqGoo8+ju+/EeyChrlVirj0eRNEz1za+oHFT+Ivf8tzt2j03fncMM41xFa
	 E9MMY51W4htpBnmcexk7CmepYa4uzkAYRTf5fLOKS/+yVZAI+vUVk+eMly9L/uonv3Bg0yz6EfBd
	 L83YTeCZFt5S7I2Y58cyzYISO03MbX2sggTGP2jofjoVrXEleSkjlkSsS5T85a9n4aUleMeI7txC
	 mQTp2yqqLsijjgFoHjvRb2zHYAWrVKb5dfE4uo6alppOJ+c+0EGoHF/GVBhRDqsKfvIVP86JGTro
	 j84iEsVMUI+X1yptPZBbT2+dQHQ+NhUDgbU8YCXWuLYgfdet/eyz/CaIJxCNFSoS2CagpEhT5l0T
	 +PsH6uZLuki5IpQnfhzU3FatJPMEYKS9HxqMwADdjYw9v7jq/scTEFiC50i7Lv+EnborcdjHr1xI
	 xxNQUDQnYl1GhMIX7EcGOZxrTRf0HTtyy35upG/CwDIzfPLSnljLCCYLVyKEtmecpzZTrKDQeOWK
	 NoMuzUQuKjBSk1BTJdWSXwdAsHqlWkObW8WNnPWa9FtOOT3NpXf5pWTVdNfZT/d1cBE5S6e9Gs/Y
	 cEcGG9tUpkJ+pb3AC8nnzjiV9f5g==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: TangYi <1914018426@qq.com>
To: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
	johannes@sipsolutions.net,
	1914018426@qq.com
Subject: [PATCH] wifi: cfg80211: allow IR on a channel the wiphy already operates on
Date: Mon, 12 Oct 2026 20:59:55 +0800
X-OQ-MSGID: <20261012125955.1519379-1-1914018426@qq.com>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Self-managed LAR devices (e.g. iwlwifi) that have not yet learned a
regulatory domain flag their channels as NO-IR, typically without
setting IEEE80211_CHAN_IR_CONCURRENT, even while the device is
associated and communicating on that very channel. cfg80211's existing
IR relaxation cannot kick in for such channels:

  - cfg80211_ir_permissive_chan() gates on the driver opting in via
    REGULATORY_ENABLE_RELAX_NO_IR (iwlwifi does not), and its iftype
    whitelist covers P2P-GO/STATION/P2P-CLIENT but not AP;
  - even when it runs, it requires the channel to carry
    IEEE80211_CHAN_IR_CONCURRENT, which the LAR did not set.

Meanwhile starting an AP on the exact channel the wiphy is already
operating a station connection on adds nothing new from a regulatory
point of view: the device is already initiating radiation there.

Add a same-channel exemption ahead of the opt-in gate in
cfg80211_ir_permissive_chan(): if any wdev on this wiphy is currently
operating (station connected, or AP beaconing) on the requested
channel, allow IR for the new use regardless of interface type and
without requiring the driver opt-in. Also add NL80211_IFTYPE_AP to the
relaxation whitelist for the general IR_CONCURRENT case, since a plain
AP in the same spot is no more dangerous than a P2P GO, which is
already permitted.

This makes the common "share my Wi-Fi uplink over a hotspot on the
same card" scenario work on single-radio hardware that advertises
managed+AP concurrency in its interface combinations
(`#{ managed } <= 1, #{ AP, ... } <= 1, #channels <= 1`), including the
5 GHz bands that LAR-hobbled devices would otherwise refuse entirely.

Verified on iwlwifi (Meteor Lake PCH CNVi): with the patch, hostapd
brings up an AP on the station's channel (both 2.4 GHz and 5 GHz
UNII-3) while the station connection stays up; a client associates and
reaches the internet through the station uplink. Without the patch,
both wpa_supplicant's embedded channel check and the kernel's
SET_CHANNEL/start_ap path reject the channel with -EINVAL.

Signed-off-by: TangYi <1914018426@qq.com>
---
 net/wireless/chan.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletions(-)

--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -1701,6 +1701,30 @@
 
 	lockdep_assert_held(&rdev->wiphy.mtx);
 
+	/*
+	 * A channel the wiphy is already operating on (e.g. a station
+	 * connection) is already being radiated on by this device; starting
+	 * an AP on the very same channel adds nothing new from a regulatory
+	 * point of view. Allow it regardless of the driver's relax opt-in.
+	 */
+	list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
+		struct ieee80211_channel *other_chan = NULL;
+		unsigned int link_id;
+
+		for_each_valid_link(wdev, link_id) {
+			if (wdev->iftype == NL80211_IFTYPE_STATION &&
+			    wdev->links[link_id].client.current_bss)
+				other_chan = wdev->links[link_id].client.current_bss->pub.channel;
+			else if (wdev->iftype == NL80211_IFTYPE_AP &&
+				 wdev->links[link_id].ap.beacon_interval)
+				other_chan = wdev->links[link_id].ap.chandef.chan;
+
+			if (other_chan == chan)
+				return true;
+			other_chan = NULL;
+		}
+	}
+
 	if (!IS_ENABLED(CONFIG_CFG80211_REG_RELAX_NO_IR) ||
 	    !(wiphy->regulatory_flags & REGULATORY_ENABLE_RELAX_NO_IR))
 		return false;
@@ -1708,7 +1732,8 @@
 	/* only valid for GO and TDLS off-channel (station/p2p-CL) */
 	if (iftype != NL80211_IFTYPE_P2P_GO &&
 	    iftype != NL80211_IFTYPE_STATION &&
-	    iftype != NL80211_IFTYPE_P2P_CLIENT)
+	    iftype != NL80211_IFTYPE_P2P_CLIENT &&
+	    iftype != NL80211_IFTYPE_AP)
 		return false;
 
 	if (regulatory_indoor_allowed() &&

