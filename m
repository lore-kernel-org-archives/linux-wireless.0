Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793405588;
	b=mhprPyelPru7JoXMypCmgLQGvDLT89vwI9QhmgVDy2gnWuUoKDwdj6HsKy62kVXnsvCC
	 YNg96gHgV2JDlk6FXfN7CpviEi6rQ2TB12NBV0RPqWzQVJ5J12Y9Qy01S2u12vkMICQQO
	 7Odn6BYp1vrGr20PACrdT2mz9zoigOcyC/OATTEBuAHYvPkFhdvJoouBSVP48fMTs55KA
	 sNlyhWJGjfMdco3gi/eLbkg7qH3HRwfMIIDNHwxSHMu22BZ7JKlhPYwp2o5+G5JqSyIT6
	 STHIgIKeKp76CM+brwYDPh3e5afzo+YLgJwEfJ3Kgx+tfHej10ozFM+Wr4Mf/ix/spA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793405588;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PcMrfu6GZltvu8/su8GUned+k9LOOivyrzQ2DWRx4jo=;
	b=0cE1tEuQhzFAm6gbhh5cUseo37viQ2ljusvPeSnWnGpld+Tr2+ph12lHaZQTGbeY+aeK
	 asZ1GO/swcgTRHLknDXr8afxe+hdsk19uuCru6e/NCA7R79Q0XKoYb3oiAicZI9Qeo180
	 Gkv/I0JUdztMzfTOFajTE9Aj9GDF0E3R14s+4ymFf1tz3sEajIy7A9ZzjMBxGMH/y38jH
	 xtH0rAW0cXuBRq6F7vslH1mkjIBA4Q++oJA1v9ErP9SUOsWnSSYxB3PzJnK+8GMQDvl6R
	 REdI6D+S1GQYYf0jEJGtCd9/XsUxZACDiHq5sjy3JEqp9an83lS6BdGjy4ZKRJJT3Yw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvzgCnXW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF04B606A324;
	Sat, 31 Oct 2026 00:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YvzgCnXW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793405587;
	b=1Tr9+iqmsubN0+5Ke7YARh4yL+F748YSS0LgfDySuT1QfWSgTgS2LTTdf5smJ/WyIQ1A
	 Zv8ZEDJX6AC/edjHBMM+Ql55v0EbnEaMacG3xttDBW7WNxi4N3VEozW5Sn7VBcfHf3yOz
	 W5n6/tamWmhvJvUJZgECdH7aFu4DNLCzvFtsQbImC64E7/S1W8fL/iWqYdEVGTaQ/pE2x
	 6aZsT0pTDdwBspkfqTLEw3rzd6zd4boB4RsKcgdFzMYx+fLeDf23Rx++7BWuVedfSPSgq
	 on14zE5wffSNygisC5JTcdd86KsfYeAcFGoimLBB1rTzb+rKjGlUcT5/2LkHa7RE0Hw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793405587;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=PcMrfu6GZltvu8/su8GUned+k9LOOivyrzQ2DWRx4jo=;
	b=U9VAKkWbujttfkVs3cMZrU74rPA/2DbBg316rA1PmcjCQsAGYOwtDD8EydnlqgGBYhmY
	 vXin2KDM2+dzvBvZ8HP/RK7+K/QvKO+s9e75d6Cyat+ILtVUzb6Z55onT7IQtY1saJQ2/
	 f4ZyDjG5Q7yR4ttReYo6zdlXdBD+DIhqIarwa9XIBnUbp2wicmnnnGXl+BnPbvoeupx+x
	 2LBLSSpGadXEU0KU9MiobkZtHeHsPfziNoohk8tgUtGdEVm0RM609XRvDDUOefDW2ggpj
	 urbq3SQsFvIig1EfUpgM7jfCTc4RRLGuU5KP9cqkVrwPP8icnbGdesko1YpB14kIFnw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BDF501F000C1;
	Sat, 31 Oct 2026 00:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793405587;
	bh=PcMrfu6GZltvu8/su8GUned+k9LOOivyrzQ2DWRx4jo=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=YvzgCnXWsMRUmzLTFfvg8kUgQxEidrGcTg1LsproM9HRYpJLgHgh07tECppoNaQfj
	 MiZquLKIC2BEni7KkJKegD84jEQ/wMppmCCstta/sQFMCBhc4VZY+WoWXuZYwRyUyF
	 PPoo8s14jJX52VDfREgOTSdnxJ3eHEjiz8Gwz3SzWFJGIz9rEj+aUvH7jGNCAPOE34
	 1RUJXJBNnp+GNISoxoUdrzzefWuk4QAjYgVcZLlPOmPXZPVKMvmh9n+Y4mGe6eeUPm
	 MM0WAjwegcA94JhzflQYB8ltHCQpyVNy9UExqSVGvUijCLeFH2um6wt9qJ1yl5Or7f
	 JjJPYIX5DfKCQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4DC1A442E0;
	Sat, 31 Oct 2026 00:13:06 +0000 (UTC)
From: Jason Lee via B4 Relay <devnull+jay.ruby.im@kernel.org>
Date: Fri, 30 Oct 2026 20:13:01 -0400
Subject: [PATCH] wifi: ath11k: Warn when loading regdb fails
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261030-ath11k-regdb-warn-v1-1-17738169bcc5@ruby.im>
X-B4-Tracking: v=1; b=H4sIAIwy5WoC/yXMTQqEMAxA4atI1hNoHEbUq8gsqo0ahSqpPwPi3
 afq8lu8d0BgFQ5QJgcobxJk8hH0SqDpre8YxUVDatKMzNugXXqiEZU7V+Nu1aP5FK5oyVGeE8R
 uVm7ldz+r7+Ow1gM3yzWC8/wDKqzbJ3UAAAA=
X-Change-ID: 20261030-ath11k-regdb-warn-059d9f1d1881
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org, ath11k@lists.infradead.org, 
 linux-kernel@vger.kernel.org, Jason Lee <jay@ruby.im>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793405586; l=1920;
 i=jay@ruby.im; s=20261030; h=from:subject:message-id;
 bh=JfWZf+GvrJDa+0KJN3EFYz0wha5Nl7sP4WnES3xHdHM=;
 b=Y0+BzrE+FuAYMu7499B6t/YD5DPOiDS+dkw7KR70KC0Ww1aeLrvB3cBd/GJVmdK0b4WTuW42q
 rMdPqzZmLN8D2uwmKbCgu04Jn9XERqikmJaiyuRhpeNnvKshE/EW+sQ
X-Developer-Key: i=jay@ruby.im; a=ed25519;
 pk=nwVVsNgYUApfCPxmvZyTv0afv7bOSDky/hRrOjJKzys=
X-Endpoint-Received: by B4 Relay for jay@ruby.im/20261030 with auth_id=1367
X-Original-From: Jason Lee <jay@ruby.im>
Reply-To: jay@ruby.im
Content-Transfer-Encoding: 7bit

From: Jason Lee <jay@ruby.im>

ath11k_qmi_event_load_bdf() loads the regulatory database before the
board data file on hardware that supports it, but ignores the return
value of ath11k_qmi_load_bdf_qmi(ab, true). When the regdb is present
and cannot be loaded, the driver carries on silently and nothing in the
log says why the external regdb.bin is not being used.

regdb.bin is optional, so a missing file (-ENOENT) stays quiet, as it
is today (ath11k_core_fetch_regdb() already reports it at debug level).
Any other error is now reported with a warning. Loading still continues
either way, so behaviour does not change.

Compile tested only.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216664
Signed-off-by: Jason Lee <jay@ruby.im>
---
Compile tested only (x86_64 defconfig + ATH11K/ATH11K_PCI=m, W=1, no new
warnings); I don't have ath11k hardware to test on.

An AI assistant helped find this bug report and draft the change.
---
 drivers/net/wireless/ath/ath11k/qmi.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 7dc07339b9..e8096aca96 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2976,8 +2976,12 @@ static int ath11k_qmi_event_load_bdf(struct ath11k_qmi *qmi)
 		return ret;
 	}
 
-	if (ab->hw_params.supports_regdb)
-		ath11k_qmi_load_bdf_qmi(ab, true);
+	if (ab->hw_params.supports_regdb) {
+		/* regdb is optional, so a missing file is not an error */
+		ret = ath11k_qmi_load_bdf_qmi(ab, true);
+		if (ret < 0 && ret != -ENOENT)
+			ath11k_warn(ab, "failed to load regdb file: %d\n", ret);
+	}
 
 	ret = ath11k_qmi_load_bdf_qmi(ab, false);
 	if (ret < 0) {

---
base-commit: a9547379cb381e2a036e3261a6becc17973ac470
change-id: 20261030-ath11k-regdb-warn-059d9f1d1881

Best regards,
--  
Jason Lee <jay@ruby.im>


