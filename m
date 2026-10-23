Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.239.133.37
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792753153;
	b=ymy2FBYJf5iKdRpcXXEPzEckoMAOQNnsBMFEcktiaDzZblkf6Lmj3+MwCcqkNxASKjCn
	 XFlQgtNdv4CaBZ4jgS7kQLRzleg6zle7rk0kCxZcKXFl7p8rwW3nuSMV9AeraPM06pTjj
	 TH0C3kCOytV1FhpvlQQo7KvlT4lAg+c8imgkkybBQqn1JdTuOMFYLYENwWeTmfsXfaBi6
	 kCrF2tY3DZAuERwknBW0FVIqkI3zfZ0/qdLe9rYkQl4L3KpKW61OIc49r/uhZcImzzadw
	 DTELXLa1BH3o+kg4JJBzSih2OsBL4+IB+u1S8z7HVyDbFb/L9ij430m/jefKhSomtZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792753153;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Authenticated-Id;
	bh=LHfgAyi8VV4DRuObt8YjEp94oIzCplWcTYr3zZrfddI=;
	b=MfuyoVzEUSXS5XRAFrM0mKYxnAlqc/9gBujejj/Fm1IcY9C57Kge+XKwXrfXMag9fMGg
	 Iz+DDh9OkkbuXtvzqiq6YgNhvrLvz0Rk4lw1liMLWp6VObicLjij4pF5jRowhsHCjeHoi
	 pAPN7s8Kgh4cuzZNKH0q9A2qRRYUBP34+jq2rDEZj+YZd3IhYpqC7xuykgX7SlBIOgbJ+
	 rytZ+YKemEqRXxVVSch8xa459H4/B29jGs9h7PaHKJkpunfrILwReuVK5xtck4Z3OLMVA
	 KYO2Ix++HRZREoHLSjviRUIUl560Z9TButr/jegnU8+U6CG4lVyH7kcKROysmD31rqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kubik.pl;
	spf=pass smtp.mailfrom=kubik.pl;
	arc=none smtp.remote-ip=213.239.133.37
Received: from mail-e842.seohost-mail.eu (mail-e842.seohost-mail.eu [213.239.133.37])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E528E606A33D;
	Fri, 23 Oct 2026 10:59:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E528E606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kubik.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kubik.pl
Received: from static-46-238-236-132.awacom.net ([46.238.236.132] helo=localhost)
	by h84.seohost.pl with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <piotr@kubik.pl>)
	id 1xKCzH-00000007eiL-14iN;
	Fri, 23 Oct 2026 12:59:03 +0200
From: Piotr Kubik <piotr@kubik.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Piotr Kubik <piotr@kubik.pl>
Subject: [PATCH wireless v2 0/2] wifi: mac80211: fix link changes of 4-address MLD stations
Date: Fri, 23 Oct 2026 12:58:42 +0200
Message-ID: <20261023105844.1117460-1-piotr@kubik.pl>
X-Mailer: git-send-email 2.55.0
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
X-Authenticated-Id: piotr@kubik.pl

A 4-address (WDS) station of an AP MLD sits on an AP_VLAN interface.
Two faults appear when the links of such a station change, for
example when the station reassociates or removes a link with ML
reconfiguration:

- drv_change_sta_links() checks the AP_VLAN, which is never in the
  driver, so every link add fails with -EIO and a link removal stays
  in the driver.
- ieee80211_set_sta_4addr() adds the AP_VLAN links before it sets
  their addresses, so a link that the station gains later gets the
  zero address, and a second such link fails with -EALREADY. The
  station then stays on the AP interface.

Both come with 469d5d5a3b7a ("wifi: mac80211: synchronize valid links
for WDS AP_VLAN interfaces"). Tested with mt7996e on a 2-link AP MLD
(5 GHz + 6 GHz) and a 4-address non-AP MLD: after repeated
reassociation and after a link removal, the station stays on its
AP_VLAN with all of its links.

Changes in v2:
- 2/2: remove the vif variable of ieee80211_set_sta_4addr(), which
  the patch leaves unused (reported by the kernel test robot).
- Rebase on wireless/main.

v1: https://lore.kernel.org/r/20261020124446.188739-1-piotr@kubik.pl

Piotr Kubik (2):
  wifi: mac80211: change the links of an AP_VLAN station through its AP
  wifi: mac80211: set the link addresses of a 4-address AP_VLAN before
    its links

 net/mac80211/cfg.c        | 18 ++++++++++--------
 net/mac80211/driver-ops.c |  1 +
 2 files changed, 11 insertions(+), 8 deletions(-)


base-commit: 9d8ec0b5b5295bd23d979d1b2b905de25c36fff2
-- 
2.55.0

