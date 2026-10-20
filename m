Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.239.133.36
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792500304;
	b=KWw93v2pVL0kZjkqhOzk09mNOBoAzjM2vtHwBSlyTHaz/Aqm5cJUxVFw/92ib2c6dgOT
	 Gl56hDrtrqqIDWZMDeHx+AC+IHyV5JWbsXkIWiHXznU0aOe0D9tOzUiVWI7WZZXA0PRQU
	 eQwaLBg2VZWLzhkyi4w6Kv5BjvM3EY2bKKgcdhWueCYqbHBFjpxpgm9Nv9Ge+Lch3A96X
	 Zdqm9n/dz73q9G7bqOUnGaX/GJ+HzAAa5pbByC6i73Lj+hljXeWU5y2GnVrzWZRV+nPTj
	 3deg0TcHzJfN2L1wd72zdKDZMr6n/ntA6gmyrFiXFPQVtb+rCIE6+xLnWCVsXcktf1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792500304;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding:X-Authenticated-Id;
	bh=6md1Q1LR1EgAMQx/ZI+PnzYCAXPTV/UMjaNqfQ/l0BQ=;
	b=GnuKlUj1b0wOYW2XZ1RtsAJfEHbJSTJtCpvzzd+jTUR2YKLvIo4hlqhm3zkkYE+a8jNB
	 YKF+KOlmG/s4kSCGHU50gM58z7unWzNsfXrck5KMYhSPQNT4Xnz2igWJ7Dou4TbNocwlX
	 RU+LRg2qC3IU+ds3BVXX/OKqiDJ8XQxmXaw/9qlwmFs85m6ErMjvQi4nZrIE9cQ2IEodc
	 aGd9w3YRvLTrRphbcRkPla1u03fWANLewwjk7Tt6rQ64YyOW6WpzfTH+/y7qofBptab3b
	 xv0VONo3S5D5j4Fggp+EJvSQq0x02u4WDKO7ibAini/Gp6CvgkNU7DWF1vt9xqJrziA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=kubik.pl;
	spf=pass smtp.mailfrom=kubik.pl;
	arc=none smtp.remote-ip=213.239.133.36
Received: from mail-e681.seohost-mail.eu (mail-e681.seohost-mail.eu [213.239.133.36])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A537606A322;
	Tue, 20 Oct 2026 12:45:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A537606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=kubik.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kubik.pl
Received: from static-46-238-236-132.awacom.net ([46.238.236.132] helo=localhost)
	by h84.seohost.pl with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <piotr@kubik.pl>)
	id 1xJ9D3-00000004fYS-1i83;
	Tue, 20 Oct 2026 14:44:53 +0200
From: Piotr Kubik <piotr@kubik.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tamizh Chelvam Raja <tamizh.raja@oss.qualcomm.com>,
	Muna Sinada <muna.sinada@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Piotr Kubik <piotr@kubik.pl>
Subject: [PATCH wireless 0/2] wifi: mac80211: fix link changes of 4-address MLD stations
Date: Tue, 20 Oct 2026 14:44:44 +0200
Message-ID: <20261020124446.188739-1-piotr@kubik.pl>
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

Piotr Kubik (2):
  wifi: mac80211: change the links of an AP_VLAN station through its AP
  wifi: mac80211: set the link addresses of a 4-address AP_VLAN before its links

  net/mac80211/cfg.c        |   17 ++++++++++-------
  net/mac80211/driver-ops.c |    1 +
  2 files changed, 11 insertions(+), 7 deletions(-)
