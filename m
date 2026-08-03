Received: from mail-pl1-f227.google.com (mail-pl1-f227.google.com [209.85.214.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D043446C3
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 09:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785749725; cv=none; b=MhKHA/gulmau671RPzL7kyH0nqsXHsSIfrPUQuRPgrD7K3/XZpmr+A1rvn5tCmRxZP4lwxcVgFWfZ9azHCapprFgulS1PonBiGfiD9K+5XzWtlKD1HXzOmYQtSRueoiWhXYNWIuI4SyMPcXi+qHCd1R4mfP4zB067qe/KFlxKPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785749725; c=relaxed/simple;
	bh=DoBL7Qly3tk+RGTMaFUJMUuVsP34uQLJMhuVsoEjrbo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KtiCV3e7pJF5qaqvQ/nArRtVJwvi4SKeAjU96CSNlAWBBS4zZKqc7Cq6XlGQxW2p2wngCa5B/uu2/HgA/Qe8Te6Jcbb17wgU1M2ZbVd9k6Bxm4F1a+5/eL74oLMnMqipBq2UKL9ELEgoiJlYDYV1CHEISAmMyFaYhHwtthA9KuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=XZJoJzZw; arc=none smtp.client-ip=209.85.214.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XZJoJzZw"
Received: by mail-pl1-f227.google.com with SMTP id d9443c01a7336-2ceaf8a1265so36398525ad.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 02:35:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785749717; x=1786354517;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=EE8QIzp2YaXHpPmzLAzL2tRMNu4U4ZZi0jVVWshr8xY=;
        b=EnO1bwLR+GmAGxGVu0Z1oajjBxAoppvweGNifErvsexRfvvWCOQbZ/63kxQiacFbj0
         UNMnh23YNgfme2c4VRjfz+aQQSiv2VfvDRatPtElLktAxrIPSsJLoXvcTauJqEcbkf0t
         bTuXtY79X6ZkEaMDois48GgNgwyCTswKNod0T/iKsIUgsVlEDNQwzPwE3D72SE4gKIH5
         dYJ8RBC48xgtm6db8VKsoc/bn51bSkyGvR3L9cIwe3GkOc/0iYog5MoOncgbKctOUmFw
         w1ug1QXgxMfmxLhCWqbSv9/woGe0mRwlYbNsIUqK9dqwXjHd7Vm0G6npcYjQA+wcKKfd
         yXtQ==
X-Gm-Message-State: AOJu0YyKefxiEXgezhx6dYyuk00dB7dQGQDgjbuiR6B2RB40OE2iAcKD
	S1d/2oKA2oOAnsAjykdul4CE2bvHGOT+hezaG693SfIm+UGCR9DNvedXP2iI7UbvuCEacPoVGTn
	/A/4BChOaG7OeEm2HTMKqbuFR80YVpikfy69zcGvaAz/bOVbOKlIuELDM62Yqvqg/DGjZH+JgtY
	jfA8Ml0gCsbLq9A7ueti7cvWvLer/zkyLYTgDoLfL7NrxnwHl1x1JTBGGkeYxBMlyBFx7y+Gbgw
	63pU8Kcv3bPAWKXzEy862p5WX7/
X-Gm-Gg: AR+sD136ztq0Da2JE8jhE1POo9S9MbYl0GvC2UKBDOuMm2hTh8mCSbvlRDRP5v34XT7
	jBTZhR2Hl/CX9qGloy0CbncHnJkZHIK3J1yJv4khKiD1aHYjuQDopSc7JOt5xANdynAuNKBgOCW
	LkgXVvXNGag3uqTCo2TPyS521WPUVewIB8GOpu1gnl6e6sB9JxC8Nqz+ZTLpbe9uyZ+Xz+vh6Ji
	VgWEjXX4IEG0YhDTDIYyWjj2aAedzi7NlpIPao00deQWoDeIUEPRCxb80sqDYCT6AnbQBRdKAoR
	8gS0VxHdj/eC7QaxUbhD2PyF08Ds73JyxGOjj/yvhC1MOgHDQfGSVqMwbjIdbs3m3Q2VuwV1DJk
	QsKLEAm8wIDIY86DbAYNLAdJ6hjsgvIp7/iBulGv1DpvfmsH5KgbaetuqcP1JG/nfu5g7B2UNLV
	J00OkLYuN6fWjeLJiivWJaV+XYFORYbjwO+VbWMuE=
X-Received: by 2002:a17:903:2f50:b0:2cf:ba10:6d6 with SMTP id d9443c01a7336-2d0521cd87amr95216195ad.4.1785749717357;
        Mon, 03 Aug 2026 02:35:17 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-22.dlp.protect.broadcom.com. [144.49.247.22])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2d04b0fbe5esm9709645ad.30.2026.08.03.02.35.16
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Aug 2026 02:35:17 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb5ea36f969so3409590a12.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Aug 2026 02:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785749715; x=1786354515; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EE8QIzp2YaXHpPmzLAzL2tRMNu4U4ZZi0jVVWshr8xY=;
        b=XZJoJzZwSnkZiPW/IVnAl9+6UzPkZNcvJYSs2w1Gz07rssVZT9S1yXwKBHeqTSDs3k
         el8/QNkpKXKyojmFyYSUsN++RWXNgFcw8n9Lv+GFIfnlpc3BH4AIq6sp0+lL7st5NlCl
         pn1oxfk2InhrcOXJdBDITTGF0R+o7kvhsmVdA=
X-Received: by 2002:a05:6a21:3390:b0:3c4:3ada:384d with SMTP id adf61e73a8af0-3c92a57baf2mr8170846637.30.1785749715388;
        Mon, 03 Aug 2026 02:35:15 -0700 (PDT)
X-Received: by 2002:a05:6a21:3390:b0:3c4:3ada:384d with SMTP id adf61e73a8af0-3c92a57baf2mr8170813637.30.1785749714734;
        Mon, 03 Aug 2026 02:35:14 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13fab2530c0sm29343644c88.8.2026.08.03.02.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 02:35:14 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	stable@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH wireless-next] wifi: brcmfmac: Fix memory leak in brcmf_sdio_read_control()
Date: Mon,  3 Aug 2026 11:35:06 +0200
Message-ID: <20260803093506.1647790-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

The memory allocated for buf is not freed in some of the error paths in
brcmf_sdio_read_control(). Fix that by adding vfree() calls.

Cc: stable@vger.kernel.org
Fixes: dd43a01c5cdb ("brcmfmac: use dynamically allocated control frame buffer")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
[arend: rework as suggested by Johannes]
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 9f7ed1d293a0..381801af3ac9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1827,17 +1827,18 @@ brcmf_sdio_read_control(struct brcmf_sdio *bus, u8 *hdr, uint len, uint doff)
 	if (bus->rxctl) {
 		brcmf_err("last control frame is being processed.\n");
 		spin_unlock_bh(&bus->rxctl_lock);
-		vfree(buf);
 		goto done;
 	}
 	bus->rxctl = buf + doff;
 	bus->rxctl_orig = buf;
 	bus->rxlen = len - doff;
 	spin_unlock_bh(&bus->rxctl_lock);
+	buf = NULL;
 
 done:
 	/* Awake any waiters */
 	brcmf_sdio_dcmd_resp_wake(bus);
+	vfree(buf);
 }
 
 /* Pad read to blocksize for efficiency */

base-commit: 4a0bd262df757b25fc4e2a53c947317c119ced4e
-- 
2.54.0

