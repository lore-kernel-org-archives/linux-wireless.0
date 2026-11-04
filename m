Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=79.135.106.25
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793801081;
	b=H5J0V4NFFPeqygPDyB2yZqUzzA5mIW7Fu9wm2ePgD7WrARwa6k3Ka5h7QVaU7s0VDi9Q
	 5Ew4npWlWsKtbKJ8Gocer/DSL1lphmx+dd5jL5Gc8SC/QaG/j907jVQdNHUKyLqFD+Wh0
	 qFxa3jXLb8drCJjj0TQRuIjofJO8qdIIE6vMhCfbuwUktJn6UA3KEfYm/Ke8Idc+MaWh1
	 9o/0C6WiLr0TL1P3EDNPDNjAUAgnDEqmixtQEeGfA9A1uydqBNYxZHbC3981nQPdu2jeO
	 jKbBNxzxz6u/z/LAn2xhOie7NTTxJhJ56/Two/4K0ReJFjtbe+bOiWL8a115JVyNPsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793801081;
	h=DMARC-Filter:DKIM-Signature:Date:To:From:Cc:Subject:Message-ID:
	 In-Reply-To:References:Feedback-ID:X-Pm-Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=Q+j0w6ajOyPB3jD/rih0h/NMdkOlRGOguGnwdiyJXsw=;
	b=zOlxtGjBuKjmnzwpkKtgEI2CE9eCxUGzByN9nFIzBdQGgQBfcrJBQxAUD8vuKxIs1W5Q
	 pqg54F7rHDgvcUVtX3N2eItLPZTeCYfzsULgPmNS8EPCB68WsDngarR5OhR85Qg7TndYV
	 lQdY3EYcGYRObYyt+dyv8mL8cDDgmim8srpgy3SU9jU3fj9wHOjtdHxP8dqwe0gpg4lwp
	 gCitjoaOtRpgABbGqmL5afb+LUcGgtP7zyKhC4/FH9pokcYStyFq1xkQzvFmOYhz7DzkB
	 Q44zvNNOfcIgyy+JsnehBqfpMTzX1nwaEnabbXt0JhvH0hV43tzuj5OjGKtFDga5c/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=innora.ai;
	spf=pass smtp.mailfrom=innora.ai;
	arc=none smtp.remote-ip=79.135.106.25
Received: from mail-10625.protonmail.ch (mail-10625.protonmail.ch [79.135.106.25])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2D606D80C
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 14:04:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C1F2D606D80C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=innora.ai
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=innora.ai
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=innora.ai;
	s=protonmail3; t=1793801073; x=1794060273;
	bh=Q+j0w6ajOyPB3jD/rih0h/NMdkOlRGOguGnwdiyJXsw=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=lpViz+t9kVbQWUd5rZldLkKtBKd1ACpQazUWDmKWA3Hueteye7bIvZZfMVDyVSscy
	 tW79nEn1lzxTkYtyUGTzNw08dDS37qtMRyMJQJAVJESMzPYaeZv+5V73FDOlh1wOEd
	 fJwk6WxjefHXbgTJ3mEwX2Mf7m3TP7ao6FM9WZZgOGIKek5FZv/PuMKtjYVkooY+Po
	 KVd2KdQOZS3l3jc2aeUTcNaZoOlF16HJwqIH2QJnRXMO1OQivBkjJlcJYWPXkjGUk6
	 DT0KMgpczJNklTY539bRQKsQsmBeL7PkjKAvIF4gabQRfOdJBSdJvMKFyUo9w4rrYH
	 ZZHaBr3cuKaFg==
Date: Wed, 04 Nov 2026 14:04:29 +0000
To: gregkh@linuxfoundation.org
From: Feng Ning <feng@innora.ai>
Cc: linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org, luka.gejak@linux.dev, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Feng Ning <feng@innora.ai>
Subject: [RFC PATCH v7] staging: rtl8723bs: fix heap buffer overflow in cfg80211_rtw_add_key()
Message-ID: <20261104220347.ccc09fa4-1-feng@innora.ai>
In-Reply-To: <2026050458-numbness-haven-1ae4@gregkh>
References: <20260413113224.5201-1-feng@innora.ai> <2026042626-tabloid-suitor-33c5@gregkh> <20260427111738.33069-1-feng@innora.ai> <2026050417-monkhood-backless-4c3e@gregkh> <20260504154823.52057-1-feng@innora.ai> <2026050458-numbness-haven-1ae4@gregkh>
Feedback-ID: 140578448:user:proton
X-Pm-Message-ID: b23681433844d943cff66205ae382c2b33bbff42
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

The cfg80211 framework allows userspace to specify a key sequence
counter (NL80211_KEY_SEQ) of up to 16 bytes via NL80211_CMD_NEW_KEY
netlink messages, but ieee_param.crypt.seq is a fixed 8-byte buffer.
When cfg80211_rtw_add_key() copies the sequence counter via memcpy()
without checking seq_len, a heap buffer overflow of up to 8 bytes
occurs, overwriting bytes following seq within the same ieee_param
structure (key_len and the trailing key[] flexible array).

Reject sequence counters longer than the destination buffer with
-EINVAL instead of copying them, as discussed during review of v6.

This is sent as an RFC because it still lacks a Tested-by from real
hardware.  A userspace trigger program for the overflow (libnl-based,
NL80211_CMD_NEW_KEY with a 16-byte NL80211_ATTR_KEY_SEQ) follows in
a reply to this thread; anyone with an rtl8723bs device who can run
it against this patch would help unblock the fix.

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Cc: stable@vger.kernel.org
Signed-off-by: Feng Ning <feng@innora.ai>
---
Changes v6 -> v7:
  - Replace silent min_t() truncation with an explicit -EINVAL when
    seq_len exceeds sizeof(param->u.crypt.seq), per review feedback
    (Greg KH, Sashiko automated review)
  - Use the existing addkey_end cleanup path so param is freed on
    the new error return
  - Sent as RFC: code is complete but awaits a Tested-by from real
    rtl8723bs hardware

Changes v5 -> v6:
  - Restore the changelog that was lost in v5 (per Greg KH feedback)
  - Add Cc: stable@vger.kernel.org (user-reachable heap overflow)
  - No code changes from v5

 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/st=
aging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 7cb0c6f22..000000000 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -896,8 +896,10 @@ static int cfg80211_rtw_add_key(struct wiphy *wiphy, s=
truct net_device *ndev,

 =09param->u.crypt.idx =3D key_index;

-=09if (params->seq_len && params->seq)
-=09=09memcpy(param->u.crypt.seq, (u8 *)params->seq, params->seq_len);
+=09if (params->seq_len > sizeof(param->u.crypt.seq)) {
+=09=09ret =3D -EINVAL;
+=09=09goto addkey_end;
+=09}
+
+=09if (params->seq_len && params->seq)
+=09=09memcpy(param->u.crypt.seq, (u8 *)params->seq, params->seq_len);

 =09if (params->key_len && params->key) {
 =09=09param->u.crypt.key_len =3D params->key_len;
--
2.43.0

