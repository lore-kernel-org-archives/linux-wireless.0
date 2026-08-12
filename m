Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28832F76D;
	Wed, 12 Aug 2026 20:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786567014; cv=pass; b=b6jjXKXYAILBsybCumLl3geqRUKITqxB3cQHbk90l7z+1rwH0O0rtvrS1h3AGlQ8bXuPcK7/Oshsn3q0okVcVWsMEMFPAF4l3FrGDprMciojgZv4C3kJhFXrmFaz/6WH9Xq0h7yfS+cDwJSzwfhuU4nQaISMOSxeWFd134D0oNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786567014; c=relaxed/simple;
	bh=4+Tn1o97X0Kfrm/xf0FMqMRVydJV3VGgC3SRjzz1Dng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=I575m6L7MXnSajsr7W4fnk4TLNseEXnJuvlCCfLKzhUA5G751THVPYJxC53af3EfUg5rJFi5hYOOsCo/x3txxageqe2YACZlZCQi5aaTYNs7p1p0IS6r9Ivr37JhLXAav4mKPdG061VabaEPR6J7JtpKmpnhhVPeEPfOHFWq3ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=nfraprado@collabora.com header.b=g0sKewgk; arc=pass smtp.client-ip=136.143.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=nfraprado@collabora.com header.b="g0sKewgk"
ARC-Seal: i=1; a=rsa-sha256; t=1786567005; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=X075EU6MRpVRlzJ4uZbut7Lr58EEIs0Pj+gKdgaGqv2q+KpbFHPyTYvTq2p4WeEeePEFQRJ3jkStqiuYZPUtBdZZvJji6xPEA4DW6/XXRMdvvHjh1cPU41wk5vUBcthIxXr1nMmcf1YFonvU1+VH0eAZr7I3EmTOwbZVPfbqeMw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1786567005; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=Qw3KNkbsAFDFoFMqjDmjCmgfg9nfJafp8ZWY+tryqiA=; 
	b=lT0oU/3iE1tXzFtJ+opu/a5PMR7zYxhsUNB1up+DybvMiL86zvXNxrGc90FzhBp5wwz2GU1EWTexh8VbZkgwb8Rix1rQuPMpsvkrFImDAVVWITDkgXj1NR/RQ9SgOH2ogF/VedjFDF3qu+f8tOtkkUfyUvGKxCrS5kEywVRSGU8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=nfraprado@collabora.com;
	dmarc=pass header.from=<nfraprado@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786567005;
	s=zohomail; d=collabora.com; i=nfraprado@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Cc:Cc:Reply-To;
	bh=Qw3KNkbsAFDFoFMqjDmjCmgfg9nfJafp8ZWY+tryqiA=;
	b=g0sKewgkXvMcKdQJt0g0hqFfHLldKxAQWBRAQU3rB6pR2o/CRRMOe5ht9+yKdH4S
	0Yy2V5lkDXEBIpSU5KgvPp4M7GkyBSnd2p/mjGtVjZM6n5uIUzGgDsts0Yh3/9nHo28
	MQxELrFsCzYAdglGxnB1xc4iquuwHQ/ck9GI8d4U=
Received: by mx.zohomail.com with SMTPS id 1786567003147986.8537930537418;
	Wed, 12 Aug 2026 13:36:43 -0700 (PDT)
From: =?utf-8?q?N=C3=ADcolas_F=2E_R=2E_A=2E_Prado?= <nfraprado@collabora.com>
Date: Wed, 12 Aug 2026 16:36:28 -0400
Subject: [PATCH] wifi: rtw89: Don't return default channel from disabled
 bands
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260812-rtw89-2ghz-quirk-fix-v1-1-7fd2a46e7a02@collabora.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CQAyF4auQrm0y1EQGrkJcaClQSFA6oAbC3
 R1g+b3k/SsEMZUARbKCyUeDvoaI9JIAt4+hEdQqGsjRzfmU0Kavz5GadsFxVuux1h8y19eMMse
 5J4jXt0mcj2x5Px3mZyc87S3Ytj+kksJteAAAAA==
X-Change-ID: 20260812-rtw89-2ghz-quirk-fix-ccf37270c982
To: Ping-Ke Shih <pkshih@realtek.com>, David Lee <sc.lee@realtek.com>
Cc: kernel@collabora.com, linux-wireless@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 =?utf-8?q?N=C3=ADcolas_F=2E_R=2E_A=2E_Prado?= <nfraprado@collabora.com>
X-Mailer: b4 0.15.2
X-ZohoMailClient: External

rtw89_get_default_chandef() assumes the lowest frequency channel in the
2GHz band is available on all hardware, and always returns that as the
default channel. This is no longer the case after commit 355626a2c232
("wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band"), and the
current logic results in kernel WARNs and null pointer dereferences on
boards with that quirk set.

Update rtw89_get_default_chandef() to consider the available bands when
picking the default channel.

Fixes: 355626a2c232 ("wifi: rtw89: 8852cu: add quirk to disable 2.4 GHz band")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
---
 drivers/net/wireless/realtek/rtw89/chan.c |  2 +-
 drivers/net/wireless/realtek/rtw89/core.c | 21 ++++++++++++++++++---
 drivers/net/wireless/realtek/rtw89/core.h |  3 ++-
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/chan.c b/drivers/net/wireless/realtek/rtw89/chan.c
index 6f11335b4968..6512fc9eef29 100644
--- a/drivers/net/wireless/realtek/rtw89/chan.c
+++ b/drivers/net/wireless/realtek/rtw89/chan.c
@@ -297,7 +297,7 @@ static void rtw89_config_default_chandef(struct rtw89_dev *rtwdev)
 {
 	struct cfg80211_chan_def chandef = {0};
 
-	rtw89_get_default_chandef(&chandef);
+	rtw89_get_default_chandef(rtwdev, &chandef);
 	__rtw89_config_entity_chandef(rtwdev, RTW89_CHANCTX_0, &chandef);
 }
 
diff --git a/drivers/net/wireless/realtek/rtw89/core.c b/drivers/net/wireless/realtek/rtw89/core.c
index 397ebbfcac09..5ae9523667c6 100644
--- a/drivers/net/wireless/realtek/rtw89/core.c
+++ b/drivers/net/wireless/realtek/rtw89/core.c
@@ -393,10 +393,25 @@ static void rtw89_traffic_stats_accu(struct rtw89_dev *rtwdev,
 	}
 }
 
-void rtw89_get_default_chandef(struct cfg80211_chan_def *chandef)
+void rtw89_get_default_chandef(struct rtw89_dev *rtwdev,
+			       struct cfg80211_chan_def *chandef)
 {
-	cfg80211_chandef_create(chandef, &rtw89_channels_2ghz[0],
-				NL80211_CHAN_NO_HT);
+	u8 support_bands = rtwdev->chip->support_bands;
+	struct ieee80211_channel *default_channel;
+
+	if (support_bands & BIT(NL80211_BAND_2GHZ) &&
+	    !test_bit(RTW89_QUIRK_DISABLE_2GHZ, rtwdev->quirks)) {
+		default_channel = &rtw89_channels_2ghz[0];
+	} else if (support_bands & BIT(NL80211_BAND_5GHZ)) {
+		default_channel = &rtw89_channels_5ghz[0];
+	} else if (support_bands & BIT(NL80211_BAND_6GHZ)) {
+		default_channel = &rtw89_channels_6ghz[0];
+	} else {
+		rtw89_err(rtwdev, "Failed to get default channel, no band supported\n");
+		return;
+	}
+
+	cfg80211_chandef_create(chandef, default_channel, NL80211_CHAN_NO_HT);
 }
 
 void rtw89_get_channel_params(const struct cfg80211_chan_def *chandef,
diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 2b21d969ece7..2a101fa4bbca 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -9324,7 +9324,8 @@ void rtw89_chip_rfk_channel(struct rtw89_dev *rtwdev,
 			    struct rtw89_vif_link *rtwvif_link);
 const struct rtw89_6ghz_span *
 rtw89_get_6ghz_span(struct rtw89_dev *rtwdev, u32 center_freq);
-void rtw89_get_default_chandef(struct cfg80211_chan_def *chandef);
+void rtw89_get_default_chandef(struct rtw89_dev *rtwdev,
+			       struct cfg80211_chan_def *chandef);
 void rtw89_get_channel_params(const struct cfg80211_chan_def *chandef,
 			      struct rtw89_chan *chan);
 int rtw89_set_channel(struct rtw89_dev *rtwdev);

---
base-commit: ca800a9302764c445de0da0e84d2252400a770ee
change-id: 20260812-rtw89-2ghz-quirk-fix-ccf37270c982

Best regards,
--  
Nícolas F. R. A. Prado <nfraprado@collabora.com>

