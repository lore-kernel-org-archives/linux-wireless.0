Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.120
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793709223;
	b=x+V9GHIkbE9FEmRqgwiig1b9K0nuCKrFrymXv4Z5r0cW0RV5CIDDRkj3MfmpHOfTL3ZD
	 nLWQtSotf+tpkohKYNawDtDTSrsJztdhhb1DOIzonEjvmu9Ix5R0Bs8Mre2MOIWq0Lhhp
	 MAMlRbhxqGzWrFwN0qf110xogsJCES+1JPUnCI7LVl855RegaO5fcoKL9ehXmH7vn4Byr
	 KfysqwFjjsDNB2lT6dKbIc0GZn5eVZYDOWovaO/yZsA5z5K+X8ucxTh6aZENHyzb14IvW
	 0Mx3qayp72xpSOjh2ZYDfc+GDRy6auoYPrDf/pAZYL4rKMeQ1DvIPhclobIqHWwbKVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793709223;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 Feedback-ID:X-Pm-Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=HUat9nsOmLCyAsqZk4Bi3Mhnvn0vqy2uZqBBdAs07do=;
	b=lAjgfwIbN8y6ZPEaxbc8BAsUFL9G4EK3zxOzG9hRSYo3MV5jcAJAjQHjnx/7A1c8UbNC
	 y2dtlGwJVuNbN2etDSvIxT4qGTtZX2iYiQpt4XCGSkHIQVchZpGyEyes8+CDnOz3Uhl7i
	 ZJzkN+oPhRLthQWpYJftnfTNW4/kSkkEcPY4LBzKyZ4rXNUcczYJ8BBEJw/C26PdCBeWH
	 0ejuF+QyhtFUjo868lGE+TpuvGnGISWLeWRI17Tgleb2VZYAJAL7rHUDYjmfvRWZhodEJ
	 UKv1P4gst7RmXHgbjhKcmEoP1KrCCKFA/+PDedFZkGTuNQwo2PDValQp2gn0q4xYTyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=proton.me;
	spf=pass smtp.mailfrom=proton.me;
	dkim=pass header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=d2Pdlbqf;
	arc=none smtp.remote-ip=79.135.106.120
Received: from mail-106120.protonmail.ch (mail-106120.protonmail.ch [79.135.106.120])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA351606D83B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 12:33:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EA351606D83B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=proton.me header.i=@proton.me header.a=rsa-sha256 header.s=protonmail2 header.b=d2Pdlbqf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail2; t=1793709219; x=1793968419;
	bh=HUat9nsOmLCyAsqZk4Bi3Mhnvn0vqy2uZqBBdAs07do=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=d2PdlbqfW+pSqZri23MJnTYsM+Pf0m8yVVNyaLn5SLB0C1p5/jka6+LP3nv484RkW
	 +WGp8evzLMV2N8+592thWrhtF4WcHcWXeXM+fpEBHE1jNmv7IDOPKhLmhi/+5eh6p1
	 5uRcF5cb2dOKH+uB1Hh8ErhSowQwTWKR4ewwhTNC4o8HDqHfG5V2OUa8AyI5IC28gs
	 zwiDYHRncApeUTbzzJksO/8b79SXx7xycjgA9dTabARMrrXf1c+oAwjtq/Hf3f8s0v
	 B9h6uy3SQvixGJu4rpD+Yp4vG5/FKn5K2pg+WbqOp/pYDidEyVvlm8XnDzRRgFL/Ji
	 VI8kqC7nMHEMg==
Date: Tue, 03 Nov 2026 12:33:34 +0000
To: Johannes Berg <johannes@sipsolutions.net>
From: Paolo Bertinetti <paolobertinetti200f4@proton.me>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+56f5119a6b206041a6b7@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: [PATCH wireless] wifi: cfg80211: check name length before rfkill copies it
Message-ID: <20261103123332.707584-1-paolobertinetti200f4@proton.me>
Feedback-ID: 117280896:user:proton
X-Pm-Message-ID: e589bd1a2c632ba1c3ccdf9684c7105d7ddb54d7
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

syzbot reports a WARN when mac80211_hwsim creates a radio with a
very long name:

  add_uevent_var: buffer size too small
  WARNING: lib/kobject_uevent.c:688 at add_uevent_var+0x2db/0x460
  Call Trace:
   rfkill_dev_uevent+0x2f/0x1f0
   rfkill_register+0x170/0x9b0
   wiphy_register+0x2a5f/0x3290
   ieee80211_register_hw+0x3d72/0x4b30
   mac80211_hwsim_new_radio+0x32f1/0x5990

Since commit b6c27cf5fe5d ("wifi: cfg80211: check wiphy name in
wiphy_register()"), the name is only checked there, but wiphy_new_nm()
already passes it to rfkill_alloc(), which copies it. A name longer
than NL80211_WIPHY_NAME_MAXLEN thus ends up in the rfkill uevent,
which is what the limit was added to prevent.

The length check depends only on the name and cannot race, so do it
in wiphy_new_nm() before rfkill_alloc().

Fixes: b6c27cf5fe5d ("wifi: cfg80211: check wiphy name in wiphy_register()"=
)
Reported-by: syzbot+56f5119a6b206041a6b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=3D56f5119a6b206041a6b7
Assisted-by: LLM
Signed-off-by: Paolo Bertinetti <paolobertinetti200f4@proton.me>
---

Notes:
    Tested in QEMU on v7.4-rc1: a 6000 byte hwsim name no longer WARNs
    and the rfkill gets the phy%d name of the wiphy. cfg80211/mac80211
    KUnit tests pass.
   =20
    Duplicate or phy<N> names still reach rfkill unchanged. That is
    cosmetic, and fixing it needs rfkill allocated later or renamed.
   =20
    Based on v7.4-rc1, wireless.git doesn't have b6c27cf5fe5d yet.

 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index f4153c249599..d2868e57a030 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -662,6 +662,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *o=
ps, int sizeof_priv,
=20
 =09/* remember the name, used/checked during registration */
 =09if (!requested_name || !requested_name[0] ||
+=09    strlen(requested_name) > NL80211_WIPHY_NAME_MAXLEN ||
 =09    dev_set_name(&rdev->wiphy.dev, "%s", requested_name)) {
 =09=09int rv;
=20

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
--=20
2.53.0


