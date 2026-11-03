Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793742960;
	b=jHA8I9gF88KnzTg/y1yj9AhIpSY/OPGdUoDyEU3TwksSuIFFNJ/zHJgX+l39taE5qAu8
	 lVVMNxFmEGGk4v8XUmkJPrqgjVpx5Dw/Hiy8owcEsuUVqxUE6AaomDCXZkuqSNw0cVzQQ
	 N4eAqW2OvwU0SzUeK1FD4Kph572Yn589QuwcAofQY87Q33wCw3Kp3WvPbNw+zfLv9vL48
	 RyGfYbVWhuSlttnm4QBRJSidl/0vidFBisGE/rrIkCqTKux58y2imxOFzLVxoL4aVSvCY
	 WCo8TkbOEw8ljtUdxNMgLIXvJSY9jJBiDpoeEHthwX3UHxq009nXveVMWZkBAFBIPjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793742960;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=s3fU+uIBacPNU5dcYXXxOIdYe2LuItJu7S++G+cSYLw=;
	b=s/S/ZG1KYbrCxmUCJO0+DV+Csc0Xbiwds6Z0UoU66X42MtpwRuoCX3rChhpYe0Xi69kU
	 IRRCOe5c7Qo/Goq70s6C1W+dplOLw0WZE0DP64twynbyFsFmqs1MQa5sZfDl2xrJVqhvB
	 uplBDVcXzWuJrwbYxWZmfGBqRtxeHZhVUxMomk+2W+NpcIwe2sXOsbYtlhCSl8XnC+sD+
	 ZCgndvWjhuFMQ/f89Fc6Cpw1xwzUkRluOgIv1JwX3kEsIyA7IwlYlo9kGeQaN3kvsRwKD
	 lN/7i5QGi4UEiVsppaU6ucpQMvLZM2rvk/04BZsX5Gnv6Mo1N2+ri27LtzBlEGde+Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WsfbYW2Z;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004D2606A31B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 21:55:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 004D2606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=WsfbYW2Z
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cc4aa18f9afso39378a12.3
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 13:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793742959; x=1794347759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s3fU+uIBacPNU5dcYXXxOIdYe2LuItJu7S++G+cSYLw=;
        b=WsfbYW2ZnE3D8XrxZ2f5xlSnVCKbXaiCxJTYTHnq3f51CAcUf6YOaN+IvPYAbSvn2c
         L2djqS9YTEJByI/BIJRM1dvld7GHrEDPop8XK1JpkemEBdlNxKHTZMG+T6qdrfC0yDUK
         mFAx8sQ3tNPZQxtrAR9Z6YayVQWAGwyqXrDxnx11R4TBS1LDrdxTQqwxJuURltQPf1xY
         YGRk4Kpg40ZMLjJeJDY1fvO29slp+GVVSpm3mMWXqeVNrs+oTaIwZbx2BxX30gQFi9Co
         JqognmRJatCnyg26E8eajiq2d8xoHLoYN1X6vQZl1R41qwh/yS5HjsUY026ICCWICtH1
         DuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793742959; x=1794347759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s3fU+uIBacPNU5dcYXXxOIdYe2LuItJu7S++G+cSYLw=;
        b=PLIXwu6ncp95qz2gyIYKn3LoLXWdYMmCQH0vT6JYZtWsPt0agduFiCiSuk6qMjP8BA
         HFyjOLalU9feQpfMdD/hwQm7+OP8c8QXao/6EcJZRCkGoGXj8QR5pKCqcVxAFGzHVVi2
         z4voMtTTvb05W2oo0UWLzXqNWHslKAEgf75IRYpXfphurQhFftVMZv5DhPM31Z4xdMOx
         QarroCmyDmjFVuq4snOBtO5RA1DUahxy7aOhj5RCQLJT5k3RD76U+MVe8+08zt8quihF
         n700O++D7HblYnNWhhE3r0OEodtoCNJXgwDOSJ8qYsf3jNs/islInnM5h8zI5nFZDhKj
         /xjg==
X-Gm-Message-State: APuU4Z9MwTjY3WqKuPBABOfBqnvIkkpJqS1Fab7pe0vd4aYe5yL6wD73
	UsD62bIcJ+MHekOO7E2kpoLO+T9z0T/cads8zct/3GP4v6fw96+3qDJ9YXL3rA==
X-Gm-Gg: AYBFou1GOQv4PpnRh3U0ZKkM09ye9DkGfpHVpQvJ/726n02XDQ5oXk0K+cKzfqMJYSk
	QxTPoo49ByaFQ0RAtNgwuoX4WnTpFQhD5NPCPfsplg1fS04KB5bEJLQqH7spjUjLOedy7qvrDOg
	88d5Tussa4Afcg/6tOrLvKbLEB8Ce7DRF86KzxLwRSz5krZjC84iIQe6ItbQv3bf9CikdCACSAY
	8AgH7tWlkd8+MkZ56w+XeOL/p/qCQqFEFuFhn+i9M0R+PnPMEIScHKuNINL+bafzjA5qQyBk/4t
	rhGBn8bSUKn5SaO72rp7zICE24CqbWkBXgpdeKoDz0CtN0XRSyGL2oTDnPW3JFrHgASXsqfSYe7
	COl16iBP0CsZu9BgKflHE2M+8q20NhYBBXTShoic1JFP0dCBr7fMlsQ9nOHEpj0qJ6BAE4hIy8+
	sNiIl4FBWNKYxeV7t5XMd55fXBnYqvhSfOyQ0gXS1vNNgJywhusEg5iZWnMUU92u4Jz42GMEEDC
	+byJJ3rTHr2+380G/i03BxcPNT0vyk5By3U6SZR3N5H6asvarVhQ1ftPBp8EK9KFmTOppq21spg
	wW0eoOqiRj3ldktCm9vt3qmkM5H2CSMnz02CyTJdRDwDraDbNtC0D29ONHz2+MX7TndO0eVQ/M1
	NSnKBPq4rPdUkwHjzNSGR1nlX887cMIofxomyPxYg2sDSU0lXtbkhgXD1Cdqavxa8O48doSqRv0
	zl/ANfuH04c3vgqdAtjWDarTc=
X-Received: by 2002:a17:90b:4f88:b0:3ac:b185:fa16 with SMTP id 98e67ed59e1d1-3ae898185bamr11970368a91.43.1793742959303;
        Tue, 03 Nov 2026 13:55:59 -0800 (PST)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b0944ea360sm830523a91.14.2026.11.03.13.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:55:58 -0800 (PST)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH rtw-next v2] wifi: rtw89: acpi: check for _DSM function support before evaluating it
Date: Tue,  3 Nov 2026 13:55:57 -0800
Message-ID: <20261103215557.183459-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
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

When the WiFi device has no ACPI companion, or the firmware does not
implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() calls
acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:

  ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 rev:0 func:10 (0x1001)
  ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7 rev:0 func:6 (0x1001)

Here the handle is NULL, and acpi_evaluate_object() returns
AE_BAD_PARAMETER. All callers already treat failure as "no policy
provided by the platform", so this is only noise.

Bail out early when there is no ACPI handle, as acpi_check_dsm() would
otherwise hit the same warning while querying function 0. Then use
acpi_check_dsm() so that functions the firmware does not advertise fail
quietly at debug level, as rtw89_acpi_evaluate_method() already does.

Seen on an RTL8852BE in a desktop PCIe slot.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 v2: check handle separately. Remove Fixes.
 drivers/net/wireless/realtek/rtw89/acpi.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/acpi.c b/drivers/net/wireless/realtek/rtw89/acpi.c
index ebb6cf555747..3396d42594b3 100644
--- a/drivers/net/wireless/realtek/rtw89/acpi.c
+++ b/drivers/net/wireless/realtek/rtw89/acpi.c
@@ -372,11 +372,22 @@ int rtw89_acpi_evaluate_dsm(struct rtw89_dev *rtwdev,
 			    enum rtw89_acpi_dsm_func func,
 			    struct rtw89_acpi_dsm_result *res)
 {
+	acpi_handle handle = ACPI_HANDLE(rtwdev->dev);
 	union acpi_object *obj;
 	int ret;
 
-	obj = acpi_evaluate_dsm(ACPI_HANDLE(rtwdev->dev), &rtw89_guid,
-				0, func, NULL);
+	if (!handle) {
+		rtw89_debug(rtwdev, RTW89_DBG_ACPI, "acpi dsm no handle\n");
+		return -ENODEV;
+	}
+
+	if (!acpi_check_dsm(handle, &rtw89_guid, 0, BIT(func))) {
+		rtw89_debug(rtwdev, RTW89_DBG_ACPI,
+			    "acpi dsm func %d not supported\n", func);
+		return -ENOENT;
+	}
+
+	obj = acpi_evaluate_dsm(handle, &rtw89_guid, 0, func, NULL);
 	if (!obj) {
 		rtw89_debug(rtwdev, RTW89_DBG_ACPI,
 			    "acpi dsm fail to evaluate func: %d\n", func);
-- 
2.56.0

