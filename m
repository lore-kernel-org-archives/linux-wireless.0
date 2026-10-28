Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.255.227.205
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207861;
	b=w63VGX9icmfUs28h6Luy7H0CU2sORT26JidlGtDirIkTbqgWlsaG2R8L17XxejL74dUk
	 MsebaCfQFn50iaYZhoRvPiyC+a/Br3Jo3aXlQNhbdajv6T66RQjhQmNmtZhjRhKgva9ny
	 es/K1ilsS4EDbw2fXKQIy3yXxFmLKd8TSp7FZTAT4SjudwS70jBb6K/gI8DmrSsZpsYPY
	 VWY8ehPtIWKck13v/y+wqelDEXkH5Jvu3gUlkNrpu1lVsgRKJTvqL8C4ZG7On1p1Bllbp
	 o3h1tNKHGtCaL2sVvSyKWWINBX+qQ1qV4yB6f4xRaQEFa3EdN3x4PaAoR+XHQnaz6FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207861;
	h=DMARC-Filter:Received:DKIM-Signature:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ThreatScanner-Verdict:X-IPAS-Result:IronPort-PHdr:
	 IronPort-Data:IronPort-HdrOrdr:X-Talos-CUID:X-Talos-MUID:
	 X-IronPort-Anti-Spam-Filtered:X-IronPort-AV:Received:Received:From:To:
	 Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=188avWSxAb/Hx5PZoFDLB2RVYdy4a0Xx1tILZ1E7tKI=;
	b=3LT1sRAHpwKk4zr0s8pXAIU2gf3t4+I5Obyx9iFOQ6cFLI7co96v523k83lkLC+xOHuK
	 9FbRbG4Ei0htaDfDNdswqVnklKGCl8qok3k46/Ypm6qaXSeVUEhgrKjcHpDhBm2pZkvzF
	 pmxG9BxG10Yfce8gSkRMtclPAQBcrjRIOL2OeeHTVfJL5LVVkxFqhH+8xTfUxIIvv9KdS
	 OXrHFjMBOMvu7PJcdDCk6ssaFel3xtVxuhCo1UMrmOKo1VLqiZVl6rkhVORuklP/Kw4iV
	 zhTvSA+gLuH6YQHtaI5HZk7etiurLhNZnH0WHRVvx5t8hI3hExxfYvMDVQMgd1smjaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=pobox.sk;
	spf=pass smtp.mailfrom=pobox.sk;
	dkim=pass header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=OZGcXBfA;
	arc=none smtp.remote-ip=46.255.227.205
Received: from gmmr-4.centrum.cz (gmmr-4.centrum.cz [46.255.227.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD652606A31C;
	Wed, 28 Oct 2026 17:17:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CD652606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pobox.sk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.sk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=pobox.sk header.i=@pobox.sk header.a=rsa-sha256 header.s=mail header.b=OZGcXBfA
Received: from gmmr-4.centrum.cz (localhost [127.0.0.1])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id 35A162BA6F;
	Wed, 28 Oct 2026 18:17:33 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.sk; s=mail;
	t=1793207853; bh=188avWSxAb/Hx5PZoFDLB2RVYdy4a0Xx1tILZ1E7tKI=;
	h=From:To:Cc:Subject:Date:From;
	b=OZGcXBfAgBmySTxTU+OgLowYc1UV3g2WnnZuKrdbnuyBEzQV2eV3NC3JkYyF4b3ig
	 p0BbcpQoxUyw9aak8bPn1Xy07xFwOSvT7e/8JDHd9QNaYcJbbKuEFo4DFgwCwCL8Ae
	 /dyoKpi+IUPqVBW4DEZeH1lKV2fBOHQEM3EGOQlE=
Received: from antispam66.centrum.cz (antispam66.cent [10.30.208.66])
	by gmmr-4.centrum.cz (Postfix) with ESMTP id 32E8D202A867;
	Wed, 28 Oct 2026 18:17:33 +0100 (CET)
X-CSE-ConnectionGUID: ntmBdc6SR16CPXGqhyIKJQ==
X-CSE-MsgGUID: mWkI/89ETv2xJ4m0JILrrg==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2FGAAC4LeJq/0vj/y5aHQEBAQEJARIBBQUBSYE0BwELA?=
 =?us-ascii?q?YNLgWyEWJF0nh+Bfg8BAQEBAQEBAQEJRA0EAQEDBDcBD4FEgnOOHyc1CA4BA?=
 =?us-ascii?q?gQDAgMBAQEBAQEBAQEBAQsBAQYBAQEBAQEGBgECgR2GCUYNjBoBgSSBJgEBA?=
 =?us-ascii?q?QEBAQEBAQEBAR0CDYEnBAsBRigNAiYCXhODAgGCOQE6FLYxfzMaAmXcfxaBN?=
 =?us-ascii?q?IFuBhWBCi4BiF4BhQN2hwhEgRWDaYQahASCagSDLpZESIECHANZLAFVEw0KC?=
 =?us-ascii?q?wcFgWgDNRIqFW4yHYEjPhcvWBsGBYEdgR6BGYEHXYErKWABISdhgXYCglGCA?=
 =?us-ascii?q?AIBSUEOB0VTCSVDEkckIggSCQETGi4LgRo1PAkmQRUMZAsaBWIIAg0MdjkQM?=
 =?us-ascii?q?SAmMgQDCRgNSBEsNxUZBD0BbgeRTIMNAYEOHBAiLQEHGiAHRlxAkmCTfZ9aB?=
 =?us-ascii?q?4QhhHOHL5U6GjOBSpY0A5JumQiMEIF6llCEaYFqA4IRTYNbEkAZjj0WiHPJK?=
 =?us-ascii?q?HoBATsHAgcPApFzNIFMAQE?=
IronPort-PHdr: A9a23:8fyZshL3UBzg7dFgBtmcuBNgWUAX0o4c3iYr45Yqw4hDbr6kt8y7e
 hCEu7M11hSQA92KurptsKn/jePJYSQ4+5GPsXQPItRndiQuroE7uTJlK+O+TXPBEfjxciYhF
 95DXlI2t1uyMExSBdqsLwaK+i764jEdAAjwOhRoLerpBIHSk9631+ev8JHPfglEnjWwbL1zI
 RmssQndqMYajZZjJ6otzhbEpmZDdvhLy29vOV+ckBHw69uq8pV+6SpQofUh98BBUaX+Yas1S
 KFTASolPW4o+sDlrAHPQwSX6HQTS2kbjBVGDRXd4B71Qpn+vC36tvFg2CaBJs35Uao0WTW54
 Kh1ThLjlToKOCQ48GHTjcxwkb5brRe8rBFx34LYfIeYP+dlc6jDYd0VW3ZOXsdJVyxAHIy8a
 ZcPD/EcNupctoXxukcCoQe7CQSqGejhyCJHhmXu0KM6zeosDxzI0gIjEdwJv3vbsNr7ObwOU
 e221qTE0S/OY+9U1Dr79YPGcgohofaJXb9ob8TRzkwvGBnejl6Nt4LlODWV1uQXvGiG9OpvS
 /ivgHMgpgFtuDSv2sAsio/Jho0P11DE7jt2wJwuKN2gT050etmkEZRKuyGBNIt7W8UvSHxnt
 ygm0LMJo4K7fDQUx5Q9wR7Sc/+KfpSI7B7+WuicLyp1iXJ4dL+imxq+7FWtxvD/W8So0ltHo
 S5InsTQu34N1xHe5ceKR/lj80qh1juC1Q7e5+5CLEspm6TbLJshzaQxlpoVqUnDHTH5mF/wj
 KCIckUo4O+o6/7oYrjgu5SSNJd0hxnxP6kvgMCzH+Q1PwgUU2SF5+ix1qfv8E/5TblSk/E7k
 arUvIrHKckapKO1GRJZ34gh5hqlEjur0NAVkH8aJ1xfYh2HlZLmO1TWLfD9CvewnkqjnS9wx
 /DDIr3hGpLNLmXfkLv5fbZy9UpcyA0rwNBQ4pJYE6oBIPfvWk/pqdDUEgU1PBCqzObhFNV9z
 J4eWWeVDqCFMaLeqV6I5uQxLOmQfIIYtzfwJ+I76/PujXI1g0ERcber0JcNan21HuxqI0CDb
 nrthtcBH30Kvg07TOHylF2OSyJTZ3G0X6I8/D47FZmmApnZRo22mLyB2zy0HppZZ2xcEVCME
 m/kd5+YVPcUdCKSPshhnyQCVbe6VoAszheuuxTnxLZ9KOrb4CgYuoz72Nhv++LTjQ0y9SBzD
 8mFz2GBVX10nmQORz82xq9/vFd9xUmZ0aVjm/xYEsdc5/RGUwsgLp7czPR2C8ruVQLZYteJV
 FGmT826ATE2TdI+3cQDY1p6G9WhkB/PxTelA7wNm7yRGJM06r7c32T2J8tlz3bG1a8hj0QpQ
 8dWNm2pmLR/9w7NCI7NiEiZiamqeroG3CLX92eM03COvEdGXw50S6nFWmofZkTOodTj+kzCV
 6OuCaggMgZZzc6CK61KasDmjFlfSvbjOc7ebHy1m2iuHhaI3aiBbJTle2oDxiXREksEnB4J/
 XaAKwc+Aj2to2XEDDxhDV7vZVjj/vFkqHynVk800x2Kb0p52re14hIamP+cS/IW3r8coCkvp
 Dt7Ekih0d/KDdSMvxdufKBGbtMn/FhKzXrXuRVlMJKvfOhegQsidAd692NFBxRzA4NM1OqBf
 GklwQxpJKTQhE9GdD6wwZfzN/vbKT+h0gqobvvq3VTXy56q/aEP4ekjpk+r6B3vCk0k83x6y
 NRP+2Ob7JLaShERB8GiGn0r/gR38umJKhI24JnZgDg1afHcjw==
IronPort-Data: A9a23:/o3o3aiqmzogJ/Iqm26wDbGZX161fREKZh0ujC45NGQN5FlHY01je
 htvWWCHO/eLM2f3eYpyOozlo04A6pbQyNMxGws9qHxnH3tjpJueD7x1DKtR0wB+jCHnZBg6h
 ynLQoCYdKjYdleF+FH1dOSn9SAivU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRWmthg
 vus5ZeAULOZ82QsaDxNs/jT8E8HUMna4Vv0gHRvOJing3eBzxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6YGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7ncfpFVp2ZP2kdNM1CHG0GwkmVUFPFSSuzXKX6aR/xGWeG5fgLmkH4Ojb8uT0984uaVyi+
 8D0JxgLchWpi+no+4jiFMJUtus6LNjKH6Em7yQIITHxVZ7KQLjMRuDR4MNAhW92jc1IAezDY
 owSe1KDbjycPVsVZwpRUshh2rj17pX8W2QwRFa9uewr5G7TxRFq3aLFKN3ffczMXsY9ckOw/
 z+WojWpXk5GXDCZ4T+68VPr1r7ioT2hSKBOEeWa19pwmlLGkwT/DzVTDzNXu8KRjESyc9RVJ
 woS8y8jxYAuslCsSNn0Qga1ulacuRQbS5xLEIUS9AaOx4LI5AWUQGQHJhZFado7pIo1SCYs2
 1uhgdzkH3psvaeTRHbb8a2bxRu2OC4IPSodZDUJSQYe+PH9r4wpyBHCVNBuFOiylNKdJN3r6
 2zU6nJj2vNJ15FNiPjTEU37vg9Ab6PhFmYdjjg7lEr8hu+lTOZJv7CV1GU=
IronPort-HdrOrdr: A9a23:fkrBOKFdRXvO04jOpLqE+ceALOsnbusQ8zAXPo5KJSC9Ffbo8v
 xG/c5rtyMc5wx+ZJhNo7q90cq7MBDhHPxOgLX5VI3KNGLbUQCTQ72Kg7GO/9SZIU3DytI=
X-Talos-CUID: 9a23:4rWZlWxxupMxZjqfHo5zBgUSBsUPfnaD902JfWSAOUlwSKy0an2prfY=
X-Talos-MUID: 9a23:P540/AoMBgAi0JIevYIezzRdN+Yvs/WDNF5XgbdavpGmFAhqITjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.27,183,1787004000"; 
   d="scan'208";a="158598474"
Received: from unknown (HELO gm-smtp10.centrum.cz) ([46.255.227.75])
  by antispam66.centrum.cz with ESMTP; 28 Oct 2026 18:17:32 +0100
Received: from blackbox.p10 (188-167-137-159.dynamic.chello.sk [188.167.137.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by gm-smtp10.centrum.cz (Postfix) with ESMTPSA id 7795A1011FBFB;
	Wed, 28 Oct 2026 18:17:32 +0100 (CET)
From: Tomas Tonhauser <t.tonhauser@pobox.sk>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	Felix Fietkau <nbd@nbd.name>,
	linux-kernel@vger.kernel.org,
	Tomas Tonhauser <t.tonhauser@pobox.sk>
Subject: [PATCH v2 0/2] wifi: ath9k: fix loss of non-aggregate frames
Date: Wed, 28 Oct 2026 18:16:50 +0100
Message-ID: <20261028171652.1125692-1-t.tonhauser@pobox.sk>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Non-aggregate frames (stations without an A-MPDU session, e.g.
non-WMM ESP8266 clients) are lost on ath9k in two ways:

 1. The hardware filters them (ATH9K_TXERR_FILT) while the station
    is awake, and mac80211 retries a filtered frame only once.
    Patch 1 sets CLRDMASK on every non-aggregate frame.

 2. Frames that exhaust the hardware retry chain are dropped, as
    there is no software retry for non-aggregate frames. Patch 2
    re-queues failed and filtered frames on tid->retry_q, as the
    aggregate path does.

Toke, I know you were not keen on clearing the filter
unconditionally, so I first tested your suggestion (patch 2) alone.
On a weak link it did much worse than patch 1 alone, and the two
together did best. If you would prefer patch 1 limited, e.g. to
stations that are not sleeping, I can rework it.

Setup: TP-Link EAP225 v3 (QCA9563, 2.4 GHz), OpenWrt 25.12.5,
backports 6.18.26. ESP8266 clients running Tasmota, non-WMM, legacy
rates, modem sleep on (PS_STA toggling constantly).

Weak client (-75 dBm), ping -s 1000 -i 0.05, 500 pings per run:

                     loss         TXERR Filtered   avg RTT
  patch 2 only       52-80%       +544 per run     0.6-1.4 s
  patch 1 only       0-1 pings    0                13 ms

Same client, patches 1+2 plus a test-only module parameter to switch
the software retry at runtime, 12 alternating runs in 11 minutes:

                     lost         tx failed
  retry off (1)      127/3000     130
  retry on (1+2)     1/3000       1

At 1 ping/s, 3 x 25 pings each: 5/75 lost with retry off, 0/75 on.

Other tests with patches 1+2:
 - 500 pings to each of five ESP8266 clients: 0 lost
 - client restarts during ping floods, OTA updates: no issues
 - WMM/HT clients (ESP32, IP camera, tablet): no change
 - 67 h soak: no warnings or resets, MemAvailable flat, ath9k
   queues drain to 0, 3 TXERR Filtered in total

Felix, on the open question from the RFC: on the weak link, filtered
frames appeared together with XRETRY failures, but on the original
good-signal setup they appeared without any. Do you know what sets
the destination mask for an awake station?

Changes since RFC:
 - Patch 1: code unchanged, commit message updated
 - Patch 2: new, alternative 2 from the RFC (Toke)

RFC: https://lore.kernel.org/linux-wireless/20261003192957.761090-1-t.tonhauser@pobox.sk/

The driver analysis and write-up were done with help from an LLM.
Tests and measurements were done by me.

Tomas Tonhauser (2):
  wifi: ath9k: clear destination mask for non-aggregate frames
  wifi: ath9k: retry failed non-aggregate frames in software

 drivers/net/wireless/ath/ath9k/xmit.c | 58 +++++++++++++++++++++++++--
 1 file changed, 54 insertions(+), 4 deletions(-)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.34.1

