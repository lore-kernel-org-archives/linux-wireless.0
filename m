Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793811872;
	b=yHf+i51mL2NzqugabawOMXPL5zVMw0jm2KLoDrMf+ycHsUViNLged+LGJKFoEMu/9Y2T
	 H1RwcEZZwrZRT9ChtsnAjuiBweZZPsgbbivMbd1aRE8SneJP99DoF6EQr5lcj/4jhHJ/9
	 8ZiuM8w2cXx2jV8gLafy5kUknMuh7tapDM3Q+MzX0N0McnXelzKVuFWphOS6gup/sWKaT
	 4HIoPZAm5fINW4eEq4H5FF6zpDDIB8xPCAIZ/nefAjITLbreHVf8ICiJFRM/zIzGO2lym
	 DoUbQ40GkHV+jtB8ayIrulcDwOq5jRy69g+qQ5nKl6YymwcZH1E2SPtYayWBBfnLG6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793811872;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=F8uAXRtGsSienYNkaab0cXktgUbGtmZejNsezC1QQio=;
	b=GOjxkV4lkSygXRST7FGzC/oK6jKj6iTHBKmPwtsJaZo5emrE/RHi7v8ywhJrH2ZOTO9t
	 k16bHY8TmiAa7+UakQTj1kiOzKtL8ZHHCWKGFor7qQixrYY6m03XopDJg///Ys1IG1Lly
	 QIhOKAzpbDc50ijH3dmQAkfP7RCvWbhZOm7nTXMyzZ4/bgZ9meJPCxYcXio/FhpMJJOZd
	 8Qsj8wJiK0/RpgOq4lOQTARsgalc+dFccC32Bdf0caGoe8IOz9nLkm+yvnPg30vWEdAVx
	 lsSWSJI4N1iZ3KQIILTYTs0ZJFY44htdbJkjw6iF4miFnyWzVacnp8hL1V7JSxOc2cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ot3IjQ+j;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98811606A331
	for <linux-wireless@vger.kernel.org>; Wed,  4 Nov 2026 17:04:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98811606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ot3IjQ+j
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso705501f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 04 Nov 2026 09:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793811870; x=1794416670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=F8uAXRtGsSienYNkaab0cXktgUbGtmZejNsezC1QQio=;
        b=ot3IjQ+jG2FOxRpDI5geJv/xMcVJs9tpGafAakIEQWj6jZgIhemPS9HE8xJn80Al1O
         MNm7EwScNB108UwfZ1uBUGyk0ZW76lxRHh9HNGYTlyRhqHF8Qn9TUByemFfIzm2mZhwD
         DjKhTmdZKsdpqpDdbCYCUfjnD9XhKVj6uD1Ccmt75PIHdi/GnaXzxBDoALNkuH859hcP
         l6XeymxFNsCxLHi8D/8TD4U5vf+AOj7fUkzG5t7N4FaXeciLHVuKMZtrJvl1iyqoo4hs
         CqS8Pljcq11wXHopu0VxKU4vMniQtUjbhBKWzfSFIi+Ng45gAdicbuw0muD/nkLqtf4R
         Nqwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793811870; x=1794416670;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F8uAXRtGsSienYNkaab0cXktgUbGtmZejNsezC1QQio=;
        b=TI6JAqBETSUsehCs+mI43hLgJuw6UariUAVHHHJ9u9XdQ9iQc85KF5DSZjYRlN/Y9H
         UK1OaA36dwCFNaUGN67TcQ6U2tlVurDdH9ksuo6vX8NcBGYFExDXuR7XXsw6LezDGQ9I
         BQFtXd322A9jAfoY6e1F3w6E63mU1TLfRXcBOGHZQhdSoUajGYuUimKt0PXGwCK0lVQR
         26hQrv4nljcM9jLwe6jmbrJaoQnfVTHCljkMzS7Agck+coiKJnxsPbhsRC5DBngRGGRS
         hY2ymrO1RI6wU9SK6vsAD3C71JzgprOa9Dv5bH6MlqNsoIwcQ3UnpXcQc+SgI1xZsxtW
         VNtA==
X-Gm-Message-State: APuU4Z+g+913zthXeDl4n+8mMFkfGXc1fwijuPubsrgShYPQHNNvIu+w
	29Je5ogywewjhHS+rDHErM+AqI8hU5HmwPGGeAu5ft6b/bSWXy/tZojV
X-Gm-Gg: AYBFou0ajqP0PvGJXB/0VbPiKzs/TomZFYh+cJNYGb9882ynQj9nh8bdYlP7hhPS1Qg
	q1xNnBjKZRBUBE2juzMEKWssthWwHMzChNy8o7ilVXaFjOB+JmmxJNeWVPm1wrvdLYsY6Rf3tH5
	okG4Of7nctJtWodQV7WlcRGcnYj47UhyetS+US8k2PFXtifgaB4oQ+NNY4IvyO0ow8ZLPALWyrh
	gU4zZKsKkZSgwG2aPmVSBwU9Mpc8D5ZwLM+9Cnhrjqv8LWtjoJKiSkgPF+HHaRvaEZ/DwSS0yv9
	HpxC2yffAbH2+p7f5WShzy5T3UeLMfKpaD9hzmnMDokdwlYKc/uX9DEjI9HU3Ej7WKKAE7J6cfP
	3KsOyFfYOIHyc6Y1jH0tnBXGBFlvGtFOJOlgcgSiIGKibtjXheIK0zZuE3Ve4Xy5h29trzjwUJT
	UbsAg6OIx2lT82EOkVzIyGyKiHiozyX7A98b2yJBA5gK7GSUSVVQ087phFptoc7FRblb+7pOJS5
	csta64D28ix29um/6H0catg9tNr0VRgpIJJT7VdKN9ysmwRefJ3U1mY19P0CBbK7hP+KDbqx4IO
	8iPPdtb9TfdDAf4J4MP2c2cI38J1jLBuKs2miebh9ezQLuSFL/PR7yeDDd7RQS9PO5moyF/sux+
	rOC1ClI142Ec=
X-Received: by 2002:adf:e19c:0:b0:490:ae2:b841 with SMTP id ffacd0b85a97d-4900ae2b9a7mr4474785f8f.30.1793811869589;
        Wed, 04 Nov 2026 09:04:29 -0800 (PST)
Received: from User-PC.localdomain (185-80-76-65.ptr185.nosmadeira.net. [185.80.76.65])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fecac17c1sm4747263f8f.10.2026.11.04.09.04.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 09:04:28 -0800 (PST)
From: Jeff Campbell <inca.jeff.campbell@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next] wifi: brcmfmac: enable 2.4 GHz VHT on BCM4366 before AP bring-up
Date: Wed,  4 Nov 2026 17:04:26 +0000
Message-ID: <20261104170426.4129715-1-inca.jeff.campbell@gmail.com>
X-Mailer: git-send-email 2.47.3
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

On BCM4366 firmware 10.28.2 (r769115) the 2.4 GHz radio defaults to
vht_features 6: proprietary rates and 1024-QAM on, 2.4 GHz VHT off.
brcmfmac never sets this iovar. As an AP the d11 PSM watchdog then fires
repeatedly once a client passes traffic, the client disassociates and
never completes DHCP.  This renders the radio unusable as an AP.

On an ASUS RT-AC86U (BCM43666 2.4 GHz radio), with every other bring-up
setting held fixed, values 0 and 6 fail and values 1 and 7 are stable,
so bit 0 alone decides it. The ASUS firmware for this router sets 7.

Set bit 0, keeping the other bits, on the primary 2.4 GHz BSS of the
4366 family while the radio is still down. 5 GHz is left alone: it
keeps 6 and is stable.  This stabilizes 2.4GHz AP and clients now
associate, DHCP and pass traffic at normal levels.

Signed-off-by: Jeff Campbell <inca.jeff.campbell@gmail.com>
---
Tested on an ASUS RT-AC86U, firmware 10.28.2 (r769115), AP mode, 2.4 GHz
channel 1 at 20 MHz, one client. The router runs OpenWrt on 6.12, so this
is wireless-next brcmfmac at 991a73f49 built as a module with a small
local shim for the older cfg80211 API (not part of this patch), not a
wireless-next kernel. The two builds differ only by this patch:

  with patch:    vht_features 7, three speed test runs on one association,
                 no watchdog, DHCP completes, 560/155917 tx failed
  without patch: vht_features 6, 16 PSM watchdogs in the first 102 s after
                 boot, client retries DHCP and gives up

5 GHz stays at 6 in both builds. One speed test run there was clean, with
no tx failures and no watchdog.

The chip check covers the 4366
family, but only the 43666 2.4 GHz radio on this board has been tested.

 .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 46714d871..e971057fb 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5253,6 +5253,36 @@ brcmf_parse_configure_security(struct brcmf_if *ifp,
 	return err;
 }
 
+#define BRCMF_VHT_FEATURES_2G_ENAB	BIT(0)
+
+static void brcmf_cfg80211_4366_2g_vht(struct brcmf_if *ifp,
+				       const struct cfg80211_chan_def *chandef)
+{
+	u32 chip = ifp->drvr->bus_if->chip;
+	u32 val, want;
+	s32 err;
+
+	if (chandef->chan->band != NL80211_BAND_2GHZ)
+		return;
+	if (chip != BRCM_CC_4366_CHIP_ID && chip != BRCM_CC_43664_CHIP_ID &&
+	    chip != BRCM_CC_43666_CHIP_ID)
+		return;
+	err = brcmf_fil_iovar_int_get(ifp, "vht_features", &val);
+	if (err < 0) {
+		brcmf_dbg(INFO, "vht_features get failed (%d)\n", err);
+		return;
+	}
+	if (val & BRCMF_VHT_FEATURES_2G_ENAB)
+		return;
+	want = val | BRCMF_VHT_FEATURES_2G_ENAB;
+	err = brcmf_fil_iovar_int_set(ifp, "vht_features", want);
+	if (err < 0)
+		bphy_err(ifp->drvr, "vht_features 2.4 GHz enable failed (%d)\n",
+			 err);
+	else
+		brcmf_dbg(INFO, "vht_features 0x%x -> 0x%x\n", val, want);
+}
+
 static s32
 brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 			struct cfg80211_ap_settings *settings)
@@ -5397,6 +5427,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 				goto exit;
 			}
 		}
+		if (!mbss)
+			brcmf_cfg80211_4366_2g_vht(ifp, &settings->chandef);
 		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_UP, 1);
 		if (err < 0) {
 			bphy_err(drvr, "BRCMF_C_UP error (%d)\n", err);

base-commit: 991a73f4909f1348ffb4b38765cdb522a775e4c2
-- 
2.47.3

