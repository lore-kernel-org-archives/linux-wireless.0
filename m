Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F0D4DAFAB
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 21:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025503; cv=none; b=cuOHsXHlpVQL/MoPMzJRrJT2YCFUA9mPa3dr6g6Iwf9jwPkuZpsdyCLADkkzErqH5N0KeXhL775QRFp61nCPkMWYTGZmh0t+5hWPaTue/EFeGkeg6o4IXA/TlNBeinf/odQQwfEBtAX4UjQZKI7k5h5WpSu6WXcea/UNGErW62E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025503; c=relaxed/simple;
	bh=72VPKGFgUFUjrL2n1VYKmbyNf3I0BnnQw/kQ9VbMmhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpcHDjGxnVx2JRVCfzctjo99MBvniuQ2roDiJAoIK7ylJWkZnbRYffeUR7bJpD98yCUi+6gaAHwOzo986qYeXafVFvzg8Hr/7G8efKVCGZZpd3/aQmaHvc7X3xzcPcQu6hSQYtH+gXR6iofODTRNPH81kb6B1WiLkUw3EIksq/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com; spf=pass smtp.mailfrom=brivo.com; dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b=b7AceCuw; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b="b7AceCuw"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-530301ff353so45383221cf.2
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 14:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brivo.com; s=google; t=1790025501; x=1790630301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3XC9Sb/ipf1691XqMArNePnNNYX36EhvRdBJwfuO0HU=;
        b=b7AceCuwA7VVTS0jeFvUnrNbSLYisFbfbvuSUGbWdTb/7wGuUTLQLRykIQpWy6g1Dr
         M+3vUS0gANDzKphd8nH5TjFtPfNOtjd38/1RncKgIk7UQ/ihmBbvvRor4PU8kpz2KLmk
         2afskiBzuf6DpudC6ESqHhX4UJbCspAIcRtK3x9biSpViNo0ivIsH7awcEsYhV63ydrE
         je50DMo4WD/tSxZKRhqVwLY3qZ5/GBkByeuU7BnfoeI46MGjfkzwazRIRCmD8lR4lHDP
         hTPSH67FQ+l7HOtMyu4LL7dO6ZIUudL70vDJGgTow4cLNazSC9XhvQIqpNpe9FKbzHfl
         kQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790025501; x=1790630301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3XC9Sb/ipf1691XqMArNePnNNYX36EhvRdBJwfuO0HU=;
        b=BqdpMz3WeVCB63NV1rvNLkqPkUWmrb/pHhVP4zYJvC8ZQoAWMksLiqApovEJLw6rPl
         SVBBfKwCb7RIqLwhZqHTWf0m98Ru59qlX1HycWMITx+5rKvr6Nl3nAE8rLDJsjm54XSg
         jYtHtQ6q3u8Zpf3ANFccCpBuG2B4skzL26lzi8q6cHTpNUH2tUUyxzZaa8eMkowg6Ypy
         ODPwU3fZ9aknMxLwgofzLgNeTtozQ6vV/dkxqNWkjwkEq5B/BMWNc3TWq6IwJHfMYJug
         MePSLxstbuzM5VvFWy6cUaEkZyQREYrKNX0tN+4/BjEHyG+EX5fPLIo8QIJCCPzfdzCj
         bS8Q==
X-Forwarded-Encrypted: i=1; AKwUvBy2EpapZa0d5gB8pbembO2ff8xmp4eEGf4OlD1S5yA1jPfNgfFdLBSwcpthiPflGeE2pHk8JPJM+/uMWJ9y3g==@vger.kernel.org
X-Gm-Message-State: AFuF++n+43Ij+77IpqgHOxYfdioksM0siyC5rA+mARjFo9ItOixko2Ih
	JCI1Cig4IomUMnvj9saivEk3XlyFkIeVna2REmOmPdFUoG5mDKmcu2TrRaKDvMiHW0tYo9GN9fg
	fvZUgQnTRN+mKYodlY/vujXe3d4VNUUYqIAAr+IzmJ2uVQd2WM7QcOVpDqbQ9cQ==
X-Gm-Gg: AYBFou2cOSg1l9JDPHhivgjaSwvWKOef/63tWAuxUe4r2+yGTSxbYgyB55orN3ioV5p
	ETbkZluqpyGskd1LIJSw5uFmoStmXSU5quaISVaWpV4iSBgyOwExfHT0Ns1HKEONbf8GtdBgL4X
	KlygZ2krv34F7ld/pY6Y5YZWlOlmhuDdKTgd0F1fR0AfUeTCNKX8mEAKsp4kMycKLmsVzayfIRi
	VSHLeaHVXM3WIXTc6CYqqiY2l00yy7reWX4JZdq6t9/T6QCuQw2pzWak2aEGZhs695vH7azq1FQ
	xhVu1U0IrbWs00MdXHFbG1Yy8rUSLLfuonMTnjbymLfsAMphG3N7JSncKWPXAM2Mnz3BZOkVzuB
	s8LOcW6eRZBiACFQrpv1qNij36gc5KPIDuAmV7dj8pR1uQ0x4cdfTYx5ACHRGTxesikSMFIygQk
	x75/Xe1HxpfrSZt08NMAEX8DUgQ+eu1NHw2iM/WIozHvE3i7kWLLLOezTQo9FmH4o=
X-Received: by 2002:a05:622a:449:b0:530:b2e4:d598 with SMTP id d75a77b69052e-532dd5508e3mr6762731cf.51.1790025500842;
        Mon, 21 Sep 2026 14:18:20 -0700 (PDT)
Received: from strozzi ([66.193.28.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532df63ab0dsm267121cf.26.2026.09.21.14.18.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:18:20 -0700 (PDT)
From: Sean Anderson <sanderson@brivo.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	brcm80211@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	Sean Anderson <sanderson@brivo.com>,
	Fan Wu <fanwu01@zju.edu.cn>
Subject: [PATCH 1/4] wifi: brcmfmac: Fix canceling uninitialized datawork
Date: Mon, 21 Sep 2026 17:18:11 -0400
Message-ID: <20260921211817.2432341-2-sanderson@brivo.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921211817.2432341-1-sanderson@brivo.com>
References: <20260921211817.2432341-1-sanderson@brivo.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

datawork is currently initialized in brcmf_attach, but bus_if->drvr is
created before this in brcmf_alloc. Both of these functions are called
on firmware load, which may race with device removal. If this happens,
cancel_work_sync may be called on an uninitialized datawork. Fix this by
always initializing datawork before we set bus_if->drvr, as this matches
the condition in brcmf_bus_cancel_reset_work.

Fixes: 43b25879f004c ("wifi: brcmfmac: drain bus_reset work on device removal")
Signed-off-by: Sean Anderson <sanderson@brivo.com>
---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index dad6f4563d146..a3163120154dd 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -1298,8 +1298,6 @@ static int brcmf_bus_started(struct brcmf_pub *drvr, struct cfg80211_ops *ops)
 #endif
 #endif /* CONFIG_INET */
 
-	INIT_WORK(&drvr->bus_reset, brcmf_core_bus_reset);
-
 	/* populate debugfs */
 	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
 	debugfs_create_file("reset", 0600, brcmf_debugfs_get_devdir(drvr), drvr,
@@ -1349,6 +1347,7 @@ int brcmf_alloc(struct device *dev, struct brcmf_mp_device *settings)
 	drvr = wiphy_priv(wiphy);
 	drvr->wiphy = wiphy;
 	drvr->ops = ops;
+	INIT_WORK(&drvr->bus_reset, brcmf_core_bus_reset);
 	drvr->bus_if = dev_get_drvdata(dev);
 	drvr->bus_if->drvr = drvr;
 	drvr->settings = settings;
-- 
2.53.0

