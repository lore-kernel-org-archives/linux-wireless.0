Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722EB3C5DD4
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 09:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788774838; cv=none; b=njSsKFokzGmGXYWnS+Hi3O6x/CIwpyZu8ymH6MMjLGv0IiM6ewrtNzUHlRvj7o7Ie60vZyaO7NZUo2Zk1EmdSJ24jK9gtWDBZrXLQfZvAqfdiAKQZwoeCaDuW83TOYx184uFfopIeAsXcgDmbWgjKdbWKKmMuTjS6+6Dw832cuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788774838; c=relaxed/simple;
	bh=3KBZPwEVmn7lOCShsk6B4qQEIG7pdHl5Dd4E72KTwb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmXljSta4l6Ky9In+SOpu45YHJF78mkiaHJvtT7GrbiAmO9sWykfHZNao7v4XLWdsg2Cnzya41Nlej+IWWxzjnkbGoYmi64mERcGZjDwdCNfTP2h0jEt7HcpCKJkOdVYFJMnu/OUg/YQJADcisvcDW8XCrzvjg3K/c+bHDzsYX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b4jQ4scO; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b4jQ4scO"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2d560775ca2so22642185ad.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Sep 2026 02:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788774837; x=1789379637; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=szavzFK0KF8Wr+Vhy6Y3uk6vMkGm7SAWG9oD4RgC4H8=;
        b=b4jQ4scOfMX1jM2MWw4vs+PaTaU4xowYpxrXcFpGFFTMwHw2Pns/VLBtg3loQYa1JY
         8g1j7NuBsgyjGAwowARP7nOqvXo5tpn+bRLXXTgQcKZX6WKexUNlSYSp6B5Ax71UC9iF
         FAsHLT44LiheWhTBNaEEI1a+/+XFM/U6TogT0fTZbLLxkVK5d62X5QbxqdOn5JytMFCr
         wkWn3LntuwJM6BhzazXDd1TVCM9FgHxBG1NRpz50dVvu2jxiy/yYSWBW1+JKuSIUTadB
         2HhGgfVKPAIn9JZeEmsi9BNXCjM9to65P5+Vi9Cql5qHuy3ZpjIylMSY/X8RF78wEWPZ
         NQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788774837; x=1789379637;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=szavzFK0KF8Wr+Vhy6Y3uk6vMkGm7SAWG9oD4RgC4H8=;
        b=EP9Ri2lMvBpdeicRwbNzFcMEsCtjo/BYM+RasIeSzQkFJ+iP7L1zCgEmlGeBu47CEj
         MZmNbjbqOsGjWxXB8ZuYCDYgt9+/oRaEUoXlhAT4uBu6RbEoc7O4iYNqrc89pEEwq+M5
         JftvLsvcNdM1G49OyQSsO74d9dxuqgpe4/TuLnElzSlDlgMriHhatc5OVQ3gd+9YaKag
         Cx1/DTRVENDOX9z7Cjuu9xzhhQxBNQBbsjc/++rEjLz3L+vAIH52PZyAO+pVa8FGXMvj
         zxHcIa0vnSehbHImY5wUAB1l5zRSCekkQw4p3S+DAA7P2jW0yxKOCbCZt/QywZ+Lo7uq
         23yA==
X-Gm-Message-State: AFuF++metvL4g84YMCSkHUzfMLQWa3GVoqLyCaR9jX73lCuCoIOIpLzz
	3fOhlM8YBKabRZB9vMPUpuKmAvIvefHvjKxnThlO2LKlllAs7A5sx8IG
X-Gm-Gg: AYBFou0guksCKgSdDGhGsvUVEJ0k6q1bAYt4xBbm6Au7Loe/B6RG1HLzIrSXtAqgIJW
	8lMXNIMROEqgkVjRKWb3fD0RvfKDQCxm1N37g8DbYMTafeliJIQpLhoCYvwK7KQyV+LT846wXPi
	fb2xi+mNERLeRaE/4iqRYAn1s3vYYPRXoM4JLr2kg0twZ0TLd+9ow4ibRX1TdpTGgFzn7jINZl8
	8U+qe1Pu1gCWZSjJwGakbBvLyge9MWg0R+sz4kE/FvM0yZvegIRtVIjVX/9A79zhvDXU8IKU+d7
	/dHDqhKmrNKU0jvN8REeYLoJ5h/ExAC6YZJauGvOWoMTst4Hs3Voiwf/0xSMpsX1KaQCOhLldZG
	vDnVwfjYR8A2b7DK9ZbZ8h9TJY/tgA/aPxzeEebojyYqNJdZzTBYh4PUp3t4ZwsepEfs1mBBmtH
	3Yj82j2rZ/RepCThDduACignO6Tq+r1aVnvSckdguDTWA3b6TcM70sI/V3+x7GTcpRjfirOn9bu
	ORoLVCy2v2FwQ==
X-Received: by 2002:a17:903:3247:b0:2d7:2edd:d140 with SMTP id d9443c01a7336-2db1232e1cemr317858645ad.3.1788774836680;
        Mon, 07 Sep 2026 02:53:56 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339b608409sm30377066eec.21.2026.09.07.02.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 02:53:56 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next v2 2/4] uapi: wireless: fix typos in comments
Date: Mon,  7 Sep 2026 15:23:46 +0530
Message-ID: <20260907095348.26094-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907095348.26094-1-hemanth.selam@gmail.com>
References: <20260907095348.26094-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix typos in comments, found with scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt. Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---

Notes:
    v2: designate the patch to wireless-next and use a subject prefix naming
    the component, as maintainer-netdev.rst asks; v1 went out with a bare
    [PATCH] and a "net:" prefix. Rebased onto wireless-next, diff unchanged.
    
    v1: https://lore.kernel.org/all/20260907061417.33729-1-hemanth.selam@gmail.com/

 include/uapi/linux/wireless.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/wireless.h b/include/uapi/linux/wireless.h
index 3c2ad5fae17f..28ae6bb0d5e3 100644
--- a/include/uapi/linux/wireless.h
+++ b/include/uapi/linux/wireless.h
@@ -301,7 +301,7 @@
 #define SIOCSIWPOWER	0x8B2C		/* set Power Management settings */
 #define SIOCGIWPOWER	0x8B2D		/* get Power Management settings */
 
-/* WPA : Generic IEEE 802.11 informatiom element (e.g., for WPA/RSN/WMM).
+/* WPA : Generic IEEE 802.11 information element (e.g., for WPA/RSN/WMM).
  * This ioctl uses struct iw_point and data buffer that includes IE id and len
  * fields. More than one IE may be included in the request. Setting the generic
  * IE to empty buffer (len=0) removes the generic IE from the driver. Drivers
@@ -681,7 +681,7 @@ struct iw_param {
   __s32		value;		/* The value of the parameter itself */
   __u8		fixed;		/* Hardware should not use auto select */
   __u8		disabled;	/* Disable the feature */
-  __u16		flags;		/* Various specifc flags (if any) */
+  __u16		flags;		/* Various specific flags (if any) */
 };
 
 /*
@@ -1083,7 +1083,7 @@ struct iw_event {
 	union iwreq_data	u;		/* IOCTL fixed payload */
 };
 
-/* Size of the Event prefix (including padding and alignement junk) */
+/* Size of the Event prefix (including padding and alignment junk) */
 #define IW_EV_LCP_LEN	(sizeof(struct iw_event) - sizeof(union iwreq_data))
 /* Size of the various events */
 #define IW_EV_CHAR_LEN	(IW_EV_LCP_LEN + IFNAMSIZ)
