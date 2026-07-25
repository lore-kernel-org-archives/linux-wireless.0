Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 850AF19D065
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 14:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784989238; cv=none; b=AogXpamgWNFmz9Q2WAqp+3nlRDhu5UWH62M3RSishlvs47/90MTKL0S2Y5CM8xygR7NsCykyjANtjCVqBVgYuAngXifs6o5xNeMHYlvscIWkKGG2CGU5qV3Nh5+ztwPI8GPfAPJP6V/a90plibgqNlGR2Tyk0q+PDC86yMFNkLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784989238; c=relaxed/simple;
	bh=vF/EZxMH4ith7H/T/Ifl0fk3k439bUBG4mpWJtmX8Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d15MQS0iFpQ1dI1b/6LtuenUQMzxy0UdM0nMUuHMM16ihmCtjo1reeUzPXiX7U7BxkYSRZ3TE6++ZRZcLx14nZekhUamLvFuRXVDiNWeTfhpnsExPRBGDkDMMoBvAOK9XMdPBOKUuJdioEYsMXPJSRCBaW73VAYFwQr5x+P5XDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LDpALPrX; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LDpALPrX"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso15124595ad.1
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 07:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784989237; x=1785594037; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dx1yo+iIXIjXTyWIGQd/i3LQYtj6TWfZYRYFmYaTjBE=;
        b=LDpALPrX/+/2FLs6yQXQaOAl/jb90TxGHal2w+r/RK24ezPy41cc9SruqNL97su69T
         Q/PijZTK+oF8OejxUI04ZncdZxvR6AB12PJYRWb4hsfDzCMTMkgWA7nFnU1/KOnjg6O1
         llC6NFvwaQ9gZ+L3e6STIuossfRn8CTxSYiNBUpj6uiG46MEgSDvUsHu37HJYBmiLEAn
         5MGdR6e70IEwpb32m+LqvNJ0OgzP5lUDrjtiRgBLmu17Nerhupy6NrOOuaEF+9lv+LO0
         31j4K6TmfAmDaPzZs15IU6H/jp1Zg9WocHdIgAmUc5B6JtxPqGHyxBBY0yZheVPqHCx1
         nmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784989237; x=1785594037;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dx1yo+iIXIjXTyWIGQd/i3LQYtj6TWfZYRYFmYaTjBE=;
        b=VAWNwL8OsH1OvLeaaYRP6L/Ok7aFijfEbZ9NTlqexVoSvLDMJqMZwvuH8omT5AZnM/
         gqFdRsle8FwEx/XIYKEPQZ58JEi7MKtvwGTEWelRyUKiWnTh7HEnkP9l5qkOMOO/32uV
         yIFPhxYMAafRQjLaWe3ipPGiwlKI91fqYvYCtbv7LZJBb+5FlQB/tgW75t2YOMK81+0n
         ou2X2rDcpyXUGncD25mFJUJIPDI5SJps87kFTKEb7jrYOITrhvRgiHXyXBnW7af1y/+g
         JOV3JwsQVPTQe8gC8KKuHy7NH513mwuMp9XwbjwhNk2GA6INos7zqdFu3Mt9obZGPY14
         9p/w==
X-Gm-Message-State: AOJu0Yxnllq0fGl6rpEfBqE0LIsUn8ynjI40HKMppxPHddMALd+x56pK
	mdCfCm1zwlY2AthF9RPUsazTim8gYUtUqKsSiiQbNNVqzom9PPUCLFrs
X-Gm-Gg: AR+sD128QEi7DN+TkmilW9T1fuh/7qK0E9ATadcd2WIFTc7SQzOAI6gSsr/xo9UZysg
	3b0NBD33xRM1uD+P8EpfrVhUg6iYWvp9EZ3a0joYEgS4+0k4HbFaXPGfVD1xKovN5qtUPR+wFrS
	j+l/N74dH4b1LvnInc2e0ztfg+++z675v/5mJj1Mbk42udgxy+C0xVoXrqmnpQxHVahGYBvD8zi
	0sOqDenF87FhiA/CxoiGhBdkXlUDPnPZN0kInMtQSfSbAzbhXn+13ptZFR3kjDIoz8VFh2pnmI5
	h9geeQaidqOAu1VslO8H6aLhIk3psdKGQzkaRT9UwcpsqckUdtDUfmM7yC0cFGdUGt+9IQ4dgPa
	OfGn8yn1uyYiUxOclo38j2NRy2LZcruIrSzvI2RGxkh617WLQyTGlkMZjPe5LwoHdvtKabVjh3s
	t4XUuEpoCxwUzfWGdVXDCCkmJsGqZnrkwh30puoop0NqfgKEepBr81c4Vz
X-Received: by 2002:a17:903:1a27:b0:2cf:8131:75f4 with SMTP id d9443c01a7336-2cfde7aa812mr22476235ad.11.1784989236717;
        Sat, 25 Jul 2026 07:20:36 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:383f:14e7:a09f:23fb:cb4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc549cacsm11412873eec.16.2026.07.25.07.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 07:20:35 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: cfg80211: validate IEs in cfg80211_wext_siwgenie()
Date: Sat, 25 Jul 2026 19:50:28 +0530
Message-ID: <20260725142028.32560-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KASAN allocation trace shows that a malformed IE buffer is
stored via SIOCSIWGENIE (cfg80211_wext_siwgenie()) without any
validation. The crash trace shows that a subsequent SIOCSIWESSID
triggers a connection attempt which calls cfg80211_sme_get_conn_ies()
to process the stored IE buffer, causing:

 - An out-of-bounds read in skip_ie() which reads ies[pos+1]
   (the length byte) past the end of the 1-byte buffer.

 - An integer underflow in the memcpy size argument when offs
   returned by ieee80211_ie_split() exceeds ies_len, causing
   unsigned subtraction to wrap to SIZE_MAX and triggering a
   fortify panic.

Fix this by validating the IE buffer in cfg80211_wext_siwgenie()
before storing it. First reject buffers smaller than 2 bytes since
a valid IE requires at least a type and length field. Then use
for_each_element() and for_each_element_completed() to verify all
elements are well-formed. Return -EINVAL if validation fails.

Reported-by: syzbot+cc867e537e4bd36f69bb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cc867e537e4bd36f69bb
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>

---
v2: Use for_each_element() and for_each_element_completed() instead
    of open-coded validation loop, as suggested by Johannes Berg.
    Also add explicit ie_len < 2 check to handle the case where
    for_each_element_completed() returns true for a 1-byte buffer.
---
 net/wireless/wext-sme.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 573b6b15a446..51fc2617a1c3 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -319,6 +319,18 @@ int cfg80211_wext_siwgenie(struct net_device *dev,
 		return 0;
 
 	if (ie_len) {
+		const struct element *elem;
+
+		 /* IE must have at least Type + Length bytes */
+		if (ie_len < 2)
+			return -EINVAL;
+		for_each_element(elem, extra, ie_len) {
+			/* nothing */
+		}
+
+		if (!for_each_element_completed(elem, extra, ie_len))
+			return -EINVAL;
+
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
 		if (!ie)
 			return -ENOMEM;
-- 
2.43.0

