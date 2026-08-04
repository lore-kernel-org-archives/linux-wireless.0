Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846B420E334
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 04:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785819217; cv=none; b=oKlj8m/yrE0DasPLmYiHf/RABxJLpY+J466yDkLOqysRpG8PoH+yHDXIwS5gtxv7skdE+e/E3hBA9MEMAJxeU2TlEZI1z35E99BB7hAnmQJFoIu0WgVT8hUbz5meVaMqzx36s7JysK2Mnyio8LXxTv66VMMyEvdoATJPP6WM5lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785819217; c=relaxed/simple;
	bh=nNrXpTS5p3MeaHobweXT5nADo9ur62gwlp1t4Onq0Jc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=X7IkZhZfWxc0zIcuJgRBrPMPO+ERTbAqFENOGZ3OjyvTOKbDgmI56OaqUcHuxwKqPIGKF+q/v/NDEjgDQHREdRA6UVotu0NWLMi9fhz8kDkoXVXfplAL8CJnR0PxcIUZfbh2mnqaIABHpjiBGISV8HZiUUZGqRXC3cGrSbgjMPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/u4ikFp; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/u4ikFp"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-43ccd57a931so982082fac.0
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 21:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785819215; x=1786424015; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ePP/FGrYS9KwAO8eWsNAP5nnVVIQOzeomHwBJLzdcl0=;
        b=N/u4ikFpw9hMmYa/VlrF2Wb4szgW8bEccUZ7e9U9yejQtrkkNaGC8VtrNzqtCruZuc
         QyFP0rU5Wjc8RdGKHxzQzjkloKYZMQ92VVy/Kg5ZjAiQmN2zuWZcCcbKTMLS3D9DcKcW
         rFc4Y7w6BY1H5yUKKP2a3Gj27hagFZ4iiVlIqlFFt9Xj9bJ6cbAA6ZfpkSbuJ5h1coe1
         +sQPYyvGXHuWj58SUlALAxs6GrBZTqZbPQItOLzS4CDHY3306Yv8sQftVrt82MfWJkrT
         XLExprCO2t6QjmYudnrFrlNykN9I8lXrUjseGRaPBGg5vFEq25YZTqMyVQapc5fL76Wm
         FHGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785819215; x=1786424015;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ePP/FGrYS9KwAO8eWsNAP5nnVVIQOzeomHwBJLzdcl0=;
        b=XmrM5k2M7fEcnOj3C+VlxWvRnISk7iWwZeiheK7x5RRgIu3CZqUC4dmFRXOhQNseWl
         h5r6k2W8cDvn5OY/E1IjrJD4Tnx0GZff4/7Uqae9/X/y75s74mQnSEQmYmWnCfrgp4tY
         fdVsNbpbYPVwAi1H23NIdTFFvQhbXrrz6mNAhJmUx5wAya4Iqewf1+WEtBEkKFTbwWMl
         EVjqXqXFJx2ds03XtyB+rwD+yF8e41wiuMiTJyqB6Lc3jNImyazOQT+GQEuKN9OWQU9k
         KZ34xEmu+81/s5UyL2u/sxgaCNtRWov7DZfbsJD+nQn+15uiahVXEHCsP6zm5h2d6YWU
         vLWQ==
X-Gm-Message-State: AOJu0Yx9KwTmjzlWWKO2ZT/MHhuITSEZcwqNIqUByHL8c65CaKGEjkOq
	GJ83qVIqPImKu1mWl6BHFIVfOu9VzxIOLNBwCSEhd1jxFn9GN3TLCRJq
X-Gm-Gg: AR+sD12VU3aC7/3u7Ip3INL+1DaDl43b7kmjcZ9Mmfdexk+acTZqwaha2DGlqKlhoU7
	DYU/ycNOgEmitpRs99xtII3pfCbF/KEvgmxCauDyxLQgHX5Y0Bj1oN2kTBXnpVngFlPqXopGC3h
	8o41HxIvPpgrxTuJd27qK9/m6lhAyTkzb2qG0Fv2oi3FZAp0aVT3JA+Oc09uPGZ6vT2qILxbTAO
	lVxRyNdlYpIye+k85BOdLcf1+l6cjQ6DUFd8RKtl0hkps2hOM+OsQL1Hr01YpHn2DPR+xzsqt/p
	C/RdBJB5GY/ih/YmIUC54UnmyJtGCi/JEdXv+fvYFloas2iG5wQNwwq/SJ9IfNoYxEmC6CGH+yv
	3LqlWvTt12DSbbfkdHf4YyEJ3OpX9ManbOlkTt/2zCktZdLaTxN5wgL2bVFgIvkG424H8k5EoPo
	uacAu0xvXwfND7Zj9BAtng7cEwrT1ezgTMnL0B1J2GSrRw3Fms9jdY4dOXKFnRBw4gAQub3uFdn
	VYPuNmOtIeudljUWDioPS4mMzRd47cFwDAd0mHgfYnA5QiYKu50h/bhLtiqrPg=
X-Received: by 2002:a05:6830:6a93:b0:7e9:e16c:d3d1 with SMTP id 46e09a7af769-7f196ef5898mr12750388a34.2.1785819215381;
        Mon, 03 Aug 2026 21:53:35 -0700 (PDT)
Received: from antares ([149.88.25.215])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f18ed3e926sm9058333a34.1.2026.08.03.21.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 21:53:34 -0700 (PDT)
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3] wifi: brcmfmac: cyw: pass PMKID to firmware if present
Date: Mon,  3 Aug 2026 23:47:08 -0500
Message-ID: <20260804044708.402133-1-bogdan.nicolae@gmail.com>
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
Cc: stable@vger.kernel.org
Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
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
+			memcpy(auth_status.pmkid, params->pmkid, WLAN_PMKID_LEN);
	auth_status.flags = cpu_to_le16(BRCMF_EXTAUTH_SUCCESS);
    } else {
	bphy_err(drvr, "External authentication failed: status=%d\n",
--
2.55.0
