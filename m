Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33E822579E
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 03:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786073143; cv=none; b=JUfV7dPQ+UHEMgm4OZ9+lANq8if7d0kplotfidBH9KG+fP49zt8dBuQ5/yXw/SP218tFgMn/04Qjqdrh5xsc8iHV/t6AhMIuv2lfkzeq6k6B0SSNircsWbjm5M9dgQcbfaD9u8gNgPZFD4xR94SesNflMPSdtjk0vW13h2N/48E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786073143; c=relaxed/simple;
	bh=5DWHTyV/pH+3MdDwtmbB7rkHS/t6yPLT6Xj+jVdd9cU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=haUWfvi8ZmSFBxqF1cw0KILjz7pyBwwfoXkxqotdzapl7wIUJqbyg6YY64D9hoszTQhKQmJcTlBsNvYjRsGq9pRMG92hYMeImI5F3XX6U/j7B43W7Nl0qoZiWj0tQeUTeoCUSNDJ+oVTQ7lrsiYttHpwHszeTRX4/8PrwbGUeOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XmlVLwZn; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmlVLwZn"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7ec6815f0f8so436487a34.3
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2026 20:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786073140; x=1786677940; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=1+6XE7Yc3wed4LEk38MwpLFA21L8FO91QUtlY5oe2OY=;
        b=XmlVLwZnH3GVLX7Qa71gCGaXQGrasc2svQM5rm07SFiO7TmbuoaA+FSl992Lx8DYuE
         DQdY6JGm66x0MkxNJ7iJoJyM+njYCuGaEYcXuzejPhh+nhXwWb+oX+pQ1IuEN+gzua61
         EATV4NHjC4tSc4kr1YPveYGRO1xus6kfWKbeZYkIV9s2CvSa08zP8XuI1Au557P7okS6
         4w+88GRSLztxXrQYupvLu2YabXUgVW70OZyl22bcsTGc1mtBVhiBFKlAwZ4L7/H2wHw9
         XVBoBCgx1kKrWdn/5IdusxCSFFy1Jj1qYJPFuA/FhVhfpxp4aW/keQDoew8u24mXEF9A
         tZ0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786073140; x=1786677940;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1+6XE7Yc3wed4LEk38MwpLFA21L8FO91QUtlY5oe2OY=;
        b=N0pPqVn9O5mUbBttQLhHllz4OM+a1E5KiP8kwSlbcFCkJGiBYZfREq4cJBwupSs8Eg
         esn9EAHEm7R3bZnzzadAxYjMkxJcit8oCBiS1ckRsY1iFHrilRYw6gkq/8REmMKym+3l
         5ggLtij9sznb43l/zRpn8SSC2aUvAkpdAYe+X2pWBLkho7hkn+gGu3Q9DS2rLlHpE3dL
         enRzsnW6dG13lD1hik3Q8zt7syZQwKKtT+QhbOMSXypDQFXB11I6FiAHCbvgNlOOVIOm
         nGBdAqtMYxnu9OtPt9rbkP3S8QZKu+YtILe8g0GWjK5sdDomjrzAJCDJxJACCpGP2KS6
         i5KA==
X-Gm-Message-State: AOJu0YxzXl/g+ijZ9uZcWcV+PgpJ8KRYdvhnAz9po0LXM7GONrxpqrFn
	Z2xfpGzuA/Ee5t3hD52x4rdnKmHr4kKfmWeSa0bmCaocZscRKdt+y3OzM62YPFIz
X-Gm-Gg: AR+sD11f/3yY1HKVUBxhGsTaQOyx+b2ioNn+uWbUzB0uMJre7mRfglrbU2PYateFU6C
	fRa2uU2trFpPJtDbsMdKvXGlbxcR/HVwUnbDCLmIxwQB8zRCtSAjezwfTnMULuo80nsg3QK0oeT
	7NQVmAIVU8KbvuxSU0sfOJvbQ3eLqQqR7PoSmPL6b0fccc5qy+36Iu57BWM63uArTL29Wif985P
	98IOpWHPR+F2F4nuWjJGyqw6haLu/Gs1pEmZRX0xNQouVmsvrbYOXU6JFqIFE6lOIBuW56jE2zI
	brw7lvt+0r/beWHi66CB8AJBi51He0VArcNc2JxA/MpDwfGIiNigABxiYDHR6HTUbUpH59FgY0k
	zPwUOvCSkID9RQrM+U8SI6wBpqg8jpqFH4/VZHEedlnaqNWuXqyH7UP1HEWhMSzNvkYGdUqpbS/
	vKOhGXvpaygpb+j7NEaGsFBd/Yr2XKLBgXadeBq000/uGvFBOtmxkVqguYGXrTC+0ZxPaCs8OvY
	e5Zbs7ZQWZusNAjbQFIG1rF2cbk05Rq04drcAu+koZcv7EQytWgCuIQTiKEZLwkt9f5mwnmFw==
X-Received: by 2002:a05:6830:8d1:b0:7dc:d6b1:48b7 with SMTP id 46e09a7af769-7f1e5c6e96amr7295657a34.1.1786073139763;
        Thu, 06 Aug 2026 20:25:39 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f35b563b04sm405786a34.6.2026.08.06.20.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 20:25:39 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v5] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Thu,  6 Aug 2026 22:22:09 -0500
Message-ID: <20260807032209.447044-1-bogdan.nicolae@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Zero out auth_status on initialization. Otherwise, garbage will
leak from the stack to the firmware (when ssid is less than 32 bytes
and/or when params->pmkid is set). Then, pass the params->pmkid to the
firmware (without it, the firmware caches a garbage PMKID on successful
authentication and denies a subsequent association request that includes
the PMKID).

Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE authentication in station mode")
Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
v5: Fixed line length > 80 chars
v4: Fixed indentation
v3: Added Fixes, Cc: stable, and Acked-by tags
v2: Split into a separate patch

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index 873754be5..2c59b5e57 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -200,7 +200,7 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 {
 	struct brcmf_if *ifp;
 	struct brcmf_pub *drvr;
-	struct brcmf_auth_req_status_le auth_status;
+	struct brcmf_auth_req_status_le auth_status = {};
 	int ret = 0;
 
 	brcmf_dbg(TRACE, "Enter\n");
@@ -208,6 +208,8 @@ brcmf_cyw_external_auth(struct wiphy *wiphy, struct net_device *dev,
 	ifp = netdev_priv(dev);
 	drvr = ifp->drvr;
 	if (params->status == WLAN_STATUS_SUCCESS) {
+		if (params->pmkid)
+			memcpy(auth_status.pmkid, params->pmkid,
+			       WLAN_PMKID_LEN);
 		auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
 	} else {
 		bphy_err(drvr, "External authentication failed: status=%d\n",
--
2.55.0
