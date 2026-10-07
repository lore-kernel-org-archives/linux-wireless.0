Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8089D3D813E
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 14:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791383351; cv=none; b=KXuUjxTrv798/FALFDnibrt9WgawT9FNc8wEc69Z+NOodZBWy8dPMV+wnbqeEuhdRx2PMpDibDUpUiN9XOLn8XlOdKOXXtHThxTd5S0pINWpNpGNRiWQd21ZVHEa0MuzVCMVVA+VPm1190gEZ9Ril4LJtpGIE7pF3SXoev1KUF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791383351; c=relaxed/simple;
	bh=iYXR+WO4Xo6Z9SQO8O8Zw30mGsfc7tNwv58vyWm79Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Vlfsn4zvsWFnpFmYiZ43FMFzP0SGEBx94auRxUDUtAmRkjOhkwguSe2xheECeItoFo7/uRIMDFPpF1u9QYLHyhnV3FTvkRN5W7zz3o1rJADvk4DM1y8RR3R0AtuUCfuVGLnHX/x/LKxsSriyFTL4w2cuG1fmwrc1qSjtvzGND4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WYU8NwUD; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WYU8NwUD"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso12886855e9.0
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 07:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791383340; x=1791988140; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AoGMhCcKaJd+VLZOOK8qVd8ldhqESPN1LjxvOJM3Kqc=;
        b=WYU8NwUDfITFt3xvwX1fl3yTEXwrFpZ4I9SiLR1HuGdGD2aBJq1mYDgBSeJsrTn05J
         sYP6HqkAxnPool025BSH+a/bivm11lXhyaS2sWQo0IOCz0eYX6eTxws64CYdCJeGk8sX
         5BVb+FTstCWTWtH6s2ZYtexdOxuL3ypgg4R2TfYGHluyi0J9DNaeVQl8yOKA3WCGJAw6
         qqXHzWtYXsa6g7Abr47iM6m5rjZ487jTWYtqCn/r3mkg4zP5gl0QR23NymuHX/FqWJ+b
         6IOefKH9NiQcLVVak49qGa2bl2MQWyxlu3uPpX8AJ85/rE0Gf6B9HhCvUhqwz0NI592l
         U09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791383340; x=1791988140;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AoGMhCcKaJd+VLZOOK8qVd8ldhqESPN1LjxvOJM3Kqc=;
        b=P4iStxQkt3WCnIJNd6jiifVCnOxX2ELMBNh8SQPBCT5i4o3XgnVnfb8aDjRTQgdHMN
         4L3WA0OSJdSx1mvQwQGNYYwlMGx+JAtn3JSDGCsIRjrjaAADt5/REYKu5FvOP6UI1tq5
         4PUWWgebCHrf0HOsUp56FKtkTsR4Y164Ame1v0jjjzx4/oAOaofeTT3en6LT6YWQEGXa
         q526EoIppvQ5UtP0X2c0qdK3ocOxjVJ7mJN4Ny35wJARTBMCp9WgCMp+o1+6kV84fC/s
         lthnzLKLJTK0UrQRc9+G/tnIiWpVv6lDd3xiwCH1faK3JbmHHjP0SCs+0LUWdAbEfTjz
         zmlQ==
X-Gm-Message-State: AFuF++nuxvkK443EMW2+ZejljHhu2oIkikl7xzITURh4mHqDNCQyOuvX
	P2lCiqMgU6DKk+aKJ6LJP5kEfF7kzzt6ryd1RXL4b5Kvr2BhvqwcJgY3
X-Gm-Gg: AYBFou3BIsuUIPJhPy0isyoHzPAVL6fRe7vA/7PYE8laiiz7lDxcOb5J4vTxZo8oc/F
	2T1WpAq0pEGSkUhcjrkw1oXaxkRHb24R+flJexDMcHkv0/s8M3X0ImwJ660fc9wNwMFpFD/55zn
	jNrqTyCdZR3MW9WTPHpvB2ESbAKhtCM89pzCRg8RWzFhtg0wRTmCXwp+LBIne8XGP+8YwiAxYlf
	HnHNQ9o9rHWE3EjfW0QM0Ke6QNm39OuXGvUAYNAZYeBvnUkE+1lo9NEZl4dNY62lEtAjE1wMwDn
	yeiWUg1NHocN/5uTDxiDM9qae7c79B6WAfyid7pFdQ8BCyDvDI8poeLKC6LcLwj1pYOXf7t+WHE
	5kC+7uLqH8BIWS5Afv4nD1qLB41rU3s4ehkLQIA4+hFJTevH9Ad2xNghDIPe1V93dKRlF7h+Hdx
	PsnGmUXT+dWuhAQCcQWlJp+Wp7OHryz9JpV9xCKtxPQRrKMt2cwc/neNwyCnW4brMBeQ7qqOjAM
	sGGnpPkc3W1mLs=
X-Received: by 2002:a05:600c:8707:b0:4a0:1b14:d009 with SMTP id 5b1f17b1804b1-4a1800cb098mr46620595e9.1.1791383340243;
        Wed, 07 Oct 2026 07:29:00 -0700 (PDT)
Received: from linux.tail9b532d.ts.net ([84.75.40.48])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d1272esm5654491f8f.27.2026.10.07.07.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 07:28:59 -0700 (PDT)
From: Eduard Zateev <hackerowskiy@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eduard Zateev <hackerowskiy@gmail.com>,
	syzbot+d0a52209bddfa0948065@syzkaller.appspotmail.com
Subject: [PATCH] wifi: cfg80211: validate WEXT station BSSID
Date: Wed,  7 Oct 2026 16:28:55 +0200
Message-ID: <20261007142855.1472524-1-hackerowskiy@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WEXT IBSS and managed mode store the BSSID in the same
wdev->wext.bssid buffer. cfg80211_ibss_wext_siwap() keeps a pointer to
that buffer in wext.ibss.bssid. After changing to station mode,
cfg80211_mgd_wext_siwap() accepts a multicast AP address and copies it
to the buffer. Switching back to IBSS then follows that pointer and
uses the multicast address as a fixed BSSID.

mac80211 can create a beacon with that address, but cfg80211_get_bss()
rejects it, causing WARN_ON(!bss) in cfg80211_ibss_joined() after the
join has been reported.

Reject invalid station BSSIDs before copying them. A mac80211_hwsim WEXT
ioctl test reproduces the reported BSSID and warning; the original
syzbot report has no reproducer.

Reported-by: syzbot+d0a52209bddfa0948065@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=d0a52209bddfa0948065
Signed-off-by: Eduard Zateev <hackerowskiy@gmail.com>
---
 net/wireless/wext-sme.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index b5914f3658db..3db73a0765c9 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -245,6 +245,9 @@ int cfg80211_mgd_wext_siwap(struct net_device *dev,
 	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
 		bssid = NULL;
 
+	if (bssid && !is_valid_ether_addr(bssid))
+		return -EINVAL;
+
 	if (wdev->conn) {
 		/* both automatic */
 		if (!bssid && !wdev->wext.connect.bssid)
-- 
2.55.0

