Received: from mail-qv1-f97.google.com (mail-qv1-f97.google.com [209.85.219.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B260A416858
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785501342; cv=none; b=m6kWqBtWxXXQnsZQ6nzYBhzLR+zfkTOLTYRBgxXL3O8YJy4ZShEYr/9rJi7DGzp/qpYyrlJ4TmGP6OuaErx3pj2bq2nSbo3VASdxzucqXiXY4T0zRbBsqyuhrdiwOp1WaBZTC6rt94UbXt8bYenafzicTcKVkXk0CQ8wOMjkhRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785501342; c=relaxed/simple;
	bh=K/DdBaFpWrUAJmAtsopPn4EUPsSFubMdKIv6WaVvK2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o495ciKvuRAm5MN5WDY1lOTe7x0252Ee9BA1L0O9DF7NN85EEFC1UDALgP5V9T2FgmTDTD7tNS3I608OWf7UQfjyz64FCxl1UtFCrJLUrLvbT7oE6SYvF0h1jD5zLyYKJThVCR3v1exeW6ZbnnLWiG5hAdffRoR6fR7OiNjPMCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ND7TBGbZ; arc=none smtp.client-ip=209.85.219.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ND7TBGbZ"
Received: by mail-qv1-f97.google.com with SMTP id 6a1803df08f44-8efcef23d21so6139936d6.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785501340; x=1786106140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PTE1HjCQloV4v/Rut0+DoPlUP4dxL3XlmD11O1EpnDI=;
        b=MEkUIQhjFkXwxaxJTFiSY66wIQ2+cSRaXJrstSNxh4+RaoODGE6WxQ5jxOklTGBiY5
         M/aEuF+3uX4C28gALgvwaXV1FT66C7IvutBSee8xQT4Btm67E9q+ThPS/H0DOOxVli+b
         QEkOjQvyo1Yf1CewKbp9SigkZX2Pjz9QU726/vX+5D3jgj/gE8IxTOlQd0qkoXg6nDNe
         xxjAuHYJd3VxeiJ3zD3TF9L0G/AWVrIAypSEUxok8hDHQ7QULXvxNlTXFoAKQGFCTPii
         9VSzNshIOOwuvXQ4QEraI/NYASRxAfQ0luInsrbIzA39O/Fy8hvygpeN2/OaowbjT5eh
         yocQ==
X-Gm-Message-State: AOJu0YzguoMogcRuTBBd2eugNB2fVMgMzxbwdyd7uUvpfIZjBma6QLVt
	Ai4d5bWPqWppu8bVuGpozrv2ECgmXbSYlzRh9yWhnoSjoy5IVJlbqFlO6KaCk9XAeTFSyu2SDdZ
	XB2WwwS9GEiCCC78ztGThC/EXUaa3u/1X9BagZtvCBuYd8m1jyppcjBNclCkoQDxwBdQGjO3wta
	Q4c04IpbYpT5WEqo0SkotA7/96JdoMDs/enJNXqQqQ+OL1QGQ6zlllExGJgG0wkXjIB420ODhuK
	3thl4/T5Q6HCy9/W5Dk+dYA7Fvb
X-Gm-Gg: AR+sD10b8aM4aKJ/16ZfP2F9fGgQiKPiGkA+z8ldlwitWh+fpgPJlc2Uq+n7lDyTmJt
	HHwH+csAqAYA6ycE/zbmBSI5h752qazchhAv7kzqPkUAIviKMTsEEG2kra1J7TqHdunBtrlV6JB
	w5AHo3LGmj/MRN9E1YQiF22V0l2qaizEgqRZmJ4Ws1kgUA/KrhL3LlW8tX+eRyF9CkCdrBJuHBD
	4188zKWFwxI6R8KFhpJipelSGIAcJyjvjU1C0k7LkqWxDMEN4eXlFnpxCpoARvLB9R0UBpiKPs7
	fUfTrAWnLYAR8pj48UnW8fv5IXWNfZ6S3qZnlJwVUIBVY/dpRfc1kn4aXxp0TkiVEnTXpk1xa/A
	/bL8mp3k3pvfvQkFutx/FTzHyR8oWAPsgz+VdKxDbGIX2/aR/5zBz5WuW1TfJrcLnHpixLuBIKn
	60lbgVWcv893slscRP0wqFdV+6AxTzH8azGVJOtiU=
X-Received: by 2002:a05:6214:c8f:b0:8fb:81c5:7997 with SMTP id 6a1803df08f44-9084227aeddmr31562746d6.31.1785501340360;
        Fri, 31 Jul 2026 05:35:40 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-908435aa6b3sm817276d6.17.2026.07.31.05.35.40
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2026 05:35:40 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e475f83a2so1589889a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 05:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785501339; x=1786106139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PTE1HjCQloV4v/Rut0+DoPlUP4dxL3XlmD11O1EpnDI=;
        b=ND7TBGbZ57ydnqT2DI1rGdhpise55JCqjrJa+uGnZOvFybIPYNwvfoQ1+EID0JSzbf
         q637GuogTNJggCpFMQ0KUZGro3RgvdprRnsCfaQ9p64thK3TIM+rC7AhbNr17NdNTibz
         hTc1CSL7yhvr9bSN+/PWJo4fzx+gu89rzIhuI=
X-Received: by 2002:a17:90b:5844:b0:38e:2524:724f with SMTP id 98e67ed59e1d1-38fb1147403mr1759615a91.12.1785501339069;
        Fri, 31 Jul 2026 05:35:39 -0700 (PDT)
X-Received: by 2002:a17:90b:5844:b0:38e:2524:724f with SMTP id 98e67ed59e1d1-38fb1147403mr1759595a91.12.1785501338586;
        Fri, 31 Jul 2026 05:35:38 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm5187041eec.9.2026.07.31.05.35.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 05:35:38 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v3 10/13] wifi: rtl8723bs: use pre-assigned cookie for mgmt_tx
Date: Fri, 31 Jul 2026 14:35:06 +0200
Message-ID: <20260731123509.1975281-11-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
References: <20260731123509.1975281-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop using params->buf address as cookie value and simply pass the
pre-assigned cookie in frame tx status. This implementation seems
to fire-and-forget the transmitted frame as the cookie is not used
in any other way.

Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 6a97afd89dc7..0e6b40336123 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -2552,9 +2552,6 @@ static int cfg80211_rtw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	padapter = rtw_netdev_priv(ndev);
 
-	/* cookie generation */
-	*cookie = (unsigned long)buf;
-
 	/* indicate ack before issue frame to avoid racing with rsp frame */
 	rtw_cfg80211_mgmt_tx_status(padapter, *cookie, buf, len, ack, GFP_KERNEL);
 
-- 
2.54.0

