Received: from mail-qk1-f227.google.com (mail-qk1-f227.google.com [209.85.222.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2776E2367CF
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 14:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785249970; cv=none; b=b72JxncSg+WBh3594Q+O5RuPJUhAB/wMRBetiRUGBwL9PcJye8M+kLLASCt6Pa2HQtjf2jOx9TvAHWVevXUxjHkLMpElUlDhwNjG2rU6FHKm1btam3g0F0ScY8XePB3N7ibG/T4pp2+bVibMNDfZ9hZJGYO8cbduRJVQQkm8dZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785249970; c=relaxed/simple;
	bh=jMgvxiK9lmLnOAee+XZtVagqR2BdhpjxqxhBR68zT+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nWR6Ruze5o0tjedHFHMJwCXsqAqgxyX9ljbA1ozifpzjGnmoQfiIGsQx5cOrsGIVR/6ZzSLg/JuN9NspzQaWw3hthN2+5D7tVbDkahsZM4d+ioxVzpNU8NaTCjC347hQko5p6i3NDGead5Pn/kai4cy8Y1jigrJf5W3PDvYw/Us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KFVSNiPU; arc=none smtp.client-ip=209.85.222.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KFVSNiPU"
Received: by mail-qk1-f227.google.com with SMTP id af79cd13be357-92e5cb052edso287551285a.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785249968; x=1785854768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ar0WQnIHDpGHXJ9rIXyWU0tvEfBnqrXceAiqGiwHa6c=;
        b=SFHve70pG9qLjK/faxhft7kDOleWgLc1sPzxYT868v81yGEuKd767ux35/RFONpkYl
         ad1JTJD+rP5V6sG4F8FsKmx8mMHxFQYiKRq3MEcaxWIYmTMbFsVmKjvr5rypQ/HLm3jW
         cdLlrFYlMCLQQnSxwdjRhBzruffNEL5vVBJPrsH2cx279vixF2MdDjhfKCazjkK1BMmq
         KFw000J3N726HlYCNHeing5oIIPyJZTqIlFclM7U6v8dXoSDOjqUZeKztQQkdYp9OFEk
         YNKeKmNRuATcKR5JBMMJnqCIXfG85+q7jonZYolA4MgREemEgRmek1y3+7bxUvx8SiVs
         9dKQ==
X-Gm-Message-State: AOJu0YzUNVNonXv6fIgoWGbSEqpfjK2eDKj6JncPECkWtDAQOhNggV/4
	w/rnORv0DrgHzCd7IEFpAUUHMuB9j4KAX23goKIxh7soz5oSSufdu0RCLXbah0hcs+xbaZR1wY+
	miFSjf4axwIFn/CbaQpzV4HTuENhMp/GxvaqYRaql4i0FX1DIZf45/zg7E5taYKTutkitw4SUt6
	OkKbFZss5uDacCPediwPW8dILtGfrqCHbIvo3sZOj44D/yinfIdxKr/joUw6ULoL9hZiqsUhIcq
	w328CQQZJGm+9e0bGdn/omEWRAm
X-Gm-Gg: AR+sD13aCL/NM4AmpQPe+9+t6WTNptYGK402oeTxiWVpqhJMN1upPxMIte+yQvicV4o
	IYHz64zosQ1O9wXpnYZY+J+KsjznlQRQglcvIqTw47JlqHsZ0Z2yRUeb4ufnAUdgLV9/WraQjpQ
	RWiBvh2rzsPW5dJNIMB6SyiYBjzaBnqa5z2DG8yAu6zyHzyoY+aCtwckwX7uN0v2rj2tsEnOnBq
	3HPlmvz2FSDr6MWKjesRzl36WJpHyV2BHZ8RKa8bdvggOlUwmwaJzjZmuuZveRZmecwslMQ8KLE
	bFKLmJ3nTNmVse9PgFVDzpQWbPSKoC6nop61h8/mBsofThFo+ffqup1Too/9M4oPxd+OCvBQdWi
	9Wtjd9azn2SgKq2H07gx45yPIto7q6L/xvZEM2q6boIYgvkh+wEHNgZ8rqnTJPgauefZFxfhDHK
	x4VhmUadWLfFWbCTvm1v30WnvvtrYZnqjfEdX0b4M=
X-Received: by 2002:a05:620a:2789:b0:930:a3f9:93b0 with SMTP id af79cd13be357-93302afd4cfmr283019185a.86.1785249967968;
        Tue, 28 Jul 2026 07:46:07 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-9081dc45613sm50676d6.11.2026.07.28.07.46.07
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 07:46:07 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-92e9a2b95b5so715983985a.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 07:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785249967; x=1785854767; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ar0WQnIHDpGHXJ9rIXyWU0tvEfBnqrXceAiqGiwHa6c=;
        b=KFVSNiPU48Xo65seKzyVwoK315diDRDiEUS6G2lKWSQ75rV19RI2sgMLXm9rSAPQL9
         hKcRiqy0d/8xn/2XBXTO3yApsT/kzWtXVIXTkL+hWQKSLK3JUTJOgjGqaCyUAcbueGqn
         mpTMP1V7xq5KKlFDCoeSOacKfS5AM3ta5fDg8=
X-Received: by 2002:a05:620a:319a:b0:92e:dddc:6588 with SMTP id af79cd13be357-9330277eb01mr244915785a.42.1785249966666;
        Tue, 28 Jul 2026 07:46:06 -0700 (PDT)
X-Received: by 2002:a05:620a:319a:b0:92e:dddc:6588 with SMTP id af79cd13be357-9330277eb01mr244907885a.42.1785249965874;
        Tue, 28 Jul 2026 07:46:05 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-932de519154sm878659685a.5.2026.07.28.07.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 07:46:05 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH -next v2 05/12] wifi: brcmfmac: use pre-assigned cookie for remain_on_channel and mgmt_tx
Date: Tue, 28 Jul 2026 16:45:42 +0200
Message-ID: <20260728144549.2207061-6-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Stop generating cookies in brcmf_p2p_remain_on_channel() and
brcmf_cfg80211_mgmt_tx().

For remain_on_channel, remove the cookie increment from
brcmf_p2p_discover_listen() and store the pre-assigned cookie in
p2p->remain_on_channel_cookie. The expiry callback in
brcmf_p2p_notify_listen_complete() already reads from that field.

For mgmt_tx, remove the "*cookie = 0" assignments in
brcmf_cfg80211_mgmt_tx() and the cyw extension. The pre-assigned
cookie is then correctly passed to cfg80211_mgmt_tx_status() which
already uses *cookie.

Assisted-by: Claude:claude-sonnet-4-6
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 --
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 1 -
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c      | 6 ++----
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index 20f7fccd6121..7e0368f6860e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -5573,8 +5573,6 @@ brcmf_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	*cookie = 0;
-
 	mgmt = (const struct ieee80211_mgmt *)buf;
 
 	if (!ieee80211_is_mgmt(mgmt->frame_control)) {
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
index ce09d44fa73c..f0f3a45d7cde 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c
@@ -123,7 +123,6 @@ int brcmf_cyw_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 	if (!ieee80211_is_auth(mgmt->frame_control))
 		return brcmf_cfg80211_mgmt_tx(wiphy, wdev, params, cookie);
 
-	*cookie = 0;
 	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
 
 	reinit_completion(&vif->mgmt_tx);
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index c7d7b35ab125..3d7bf25f1985 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -979,10 +979,8 @@ brcmf_p2p_discover_listen(struct brcmf_p2p_info *p2p, u16 channel, u32 duration)
 	p2p->cfg->d11inf.encchspec(&ch);
 	err = brcmf_p2p_set_discover_state(vif->ifp, WL_P2P_DISC_ST_LISTEN,
 					   ch.chspec, (u16)duration);
-	if (!err) {
+	if (!err)
 		set_bit(BRCMF_P2P_STATUS_DISCOVER_LISTEN, &p2p->status);
-		p2p->remain_on_channel_cookie++;
-	}
 exit:
 	return err;
 }
@@ -1020,7 +1018,7 @@ int brcmf_p2p_remain_on_channel(struct wiphy *wiphy, struct wireless_dev *wdev,
 		goto exit;
 
 	memcpy(&p2p->remain_on_channel, channel, sizeof(*channel));
-	*cookie = p2p->remain_on_channel_cookie;
+	p2p->remain_on_channel_cookie = *cookie;
 	cfg80211_ready_on_channel(wdev, *cookie, channel, duration, GFP_KERNEL);
 
 exit:
-- 
2.54.0

