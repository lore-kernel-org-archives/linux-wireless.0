Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419984EA39C
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 15:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788534082; cv=none; b=SdO1LZt9iAL5xnoQMEz5UvU1EedwBIbL1cAOR6IX7NDl3Md+j8hl0+k5MhFPuwBGVV1xe/1E4OElKwxkbXEuC0NqwVTwgEe1eDmkZw76glRKSW0CwL7AOZcL+VOtfFa5klJuEmZad55nkuxoyeeVx6uCLKdq6nNsxwv4h8VWnPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788534082; c=relaxed/simple;
	bh=hRrMGXrywIs1cT2r2C6JxHc4G76M3xYfqxq1+hXIir0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6NXFKCdoTWQYF4dtUPt7VLm8t2KBzQqwQxUtpnAqK9ij9xR5vzpLrkGkAuBem7Na9UZUJtCZVSiPkhyzFWsJyhIw2+cvSMlTugZ+l0RonBeUGEpTHhgYo/gsgB9d03VABIOOdhyMhkHOGUg/oKgpram8uESfDHSLOWm0XQcKRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=nuLHWqau; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="nuLHWqau"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=qsfaB7Bg/6kb78Sx499Kb47kVPxambREY9mPArfMpWI=;
	t=1788534080; x=1789743680; b=nuLHWqauRNbkg7x0oazrVIumYAj4hBpFJuNj9bstgSAoNLP
	2dzb13eQ6DYgh+mtu2/Y6hgxc1ACEdIOklXAab2yMEDQ8huF9xk/I7P/eJrw7vUEUjIqXVO0SVvp0
	qwFcBULjWzysVWoM/2Z6d9rQVl5fUc6Um9e6i8HTIKhZ/ndiBqRp0bbsm+i7dCT9Ol2tovUlUVlJ/
	/ErH7WNE+5V07oO/q+PnDfBjwRQ5/W4MU8M8txesN5/9FaXh9lyVlIoqOhqRIJnzdi/l06PlktraG
	Tq/sJlIcym3+mtKavAKJ2GKRdiiSPCc5vWJIYuRhrMfomVjeIMaOQQI+RT4wvTOQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2VPo-00000001SeL-1jZK;
	Fri, 04 Sep 2026 17:01:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com
Subject: [PATCH wireless 07/10] wifi: mac80211: add HE 6 GHz capability in the scan elems len
Date: Fri,  4 Sep 2026 16:58:06 +0200
Message-ID: <20260904170057.c08c4965ccd2.I5ccc4ffcbccce7e33f038bffa27bb5d215e982ee@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904150057.424369-12-johannes@sipsolutions.net>
References: <20260904150057.424369-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

The HE 6 GHz Band Capability element is in the probe request for
every band if 6 GHz is supported, so add the size to scan_ies_len.

Otherwise, building probe request elements can fail, triggering the
WARN_ON in __ieee80211_start_scan().

Assisted-by: LLM
Fixes: 2ad2274c58ee ("mac80211: Add HE 6GHz capabilities element to probe request")
Reported-by: syzbot+f961b9f94edbc266f1f8@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f961b9f94edbc266f1f8
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index a59837b9f480..6408e8464338 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1453,6 +1453,10 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 			sizeof(struct ieee80211_he_mcs_nss_supp) +
 			IEEE80211_HE_PPE_THRES_MAX_LEN;
 
+		if (local->hw.wiphy->bands[NL80211_BAND_6GHZ])
+			local->scan_ies_len +=
+				3 + sizeof(struct ieee80211_he_6ghz_capa);
+
 		if (supp_eht)
 			local->scan_ies_len +=
 				3 + sizeof(struct ieee80211_eht_cap_elem) +
-- 
2.55.0

