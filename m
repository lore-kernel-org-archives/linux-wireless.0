Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8C030C637
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 00:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791939361; cv=none; b=KB0pGFiy4gtmsI8vQChreHSKgyEJvHfQQ69YpA9dCA//khBHP7Y1+HpLCJQlkWWN3I1rQzQRNrvf4t5jjVdbzWK5xbEVed1No7DwZRSAGuCGrRIBX1ePTmoD+hC7O3Ww6MSmwL6oIKu3Xyd3QP55HwevL9l3ntPkU5oZnrm64UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791939361; c=relaxed/simple;
	bh=0rogUu4QkF17ZLJAaaspEh/DNCFstmo4ri+cWV90+MM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gndxlOJEqRKbZecqv5LCAZ8fMxzOGeebRyxVnnvzy9LGnB3hmxJpl/YJf80M174twgaLogRHV5b9b5+WNpnBOMdB3GH5DWiiNu7wtgMiTugwgi2iAtvOBxWSy4qRO0EihCG1V16fB6cnG53p9j7Rar/DjFE4CvAl4Qa81r4/NzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yg986yzG; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yg986yzG"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1419d3416ceso695177c88.0
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 17:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791939359; x=1792544159; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=XxW2/JWpAEpLHapcMk1I83pgwiqBPA5dyGFRHFqowQk=;
        b=Yg986yzGDiDWhD8xTLi8ry/d9oYlDgWx6reUjjx7hpi5kIUhwAt9kafsYWjMGl36sJ
         PsYDLcW7aakggbhEyahvLLcjtgsvdfVm394EsUV2tFnmPyIG0ZB975aN+ucad1WhafhU
         Ydkt+vv6ifYRfcphUIzsyMuQbLEQKyL7TK75ISU/P4DKDPAsc2VSCJOgDwd4GmbFFt0i
         weuU8xg8lBpRTFXcAW1HHJ1N6EiXBQhkZSfF2fhoFJoZCjEkCXAPHqDsitChLV8s8/pL
         q7zX4Bq7ReRD3SleV/+xAE1GNZGEB9Vu8WW1dWZdauDpM+nQFznLAPj8Ka7t4cf3F99b
         MscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791939359; x=1792544159;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XxW2/JWpAEpLHapcMk1I83pgwiqBPA5dyGFRHFqowQk=;
        b=YmVxtmg+Ipacxd1qp2ifJQ4tO963MPO80PJB9ONpwnaTdmwTkvWmd9IhwTlHOCa9So
         MQXf4Bok3UD6OQThJbGylCewD6RTJeFuho8ZAGzVpCro3ZYd0lvYKNSMaI1NHh6DfK5r
         JWUz9rFAGo51Gjp/Xzsag2gLFlU3bmcACy2jRf4ZPmmITXfX1G2f0NCwfYQF94zJ0MhT
         G9PhL9w8r3ulYLNx37Psj13M+fgZ0Fz28FjQLzyiBtG72O1NFpgRQqGpDQ7suVyE3b2x
         F+cTt0Z3G1IkCYXWGl7h32PXqdRCk9Uoxxk7uo/rMYzzszsLJ+AD9XF15ES6kIxgYynr
         WJMA==
X-Gm-Message-State: AFq9FYLKxjmVSRDCuP/8tbNdxHsVEz8R79afOItjvNUS4eW4z4ox+Bmo
	h3sBa8rFgmKNlN5hIp28j/Ni7RnGAuY+rhNv3My5oq9qk9LmEFjUQ0yv
X-Gm-Gg: AYBFou38Kp3ln4IQrH2bbrfGpuPuBlbb/qnoQWCozaxEvL1qn8VC0nefYuOjcRjYJ1f
	2XhFm1iP051tJQTPYdt7h7NnQT4H6WQZY3+UdEQtL4+k7AKDfnNjxwhtEsRp7IKswxDy0mIz26h
	4CKi8jzH22VcBOLPcNESswFNshuDu7leqv49Rj1csYrojqn+yV8ghVa0lCDE2QaTs3C0TVDl4mE
	8k+oKXf38q9oog3ME25qYcTrIptZOZ7Aaba9/qUPwcomxQ99tUk0GWfVYyjKJsbnOlOorJCJ+Vf
	XcVQ3BvKDbRrHIcaSVlZ8789eW2FzrIqF1xQVNQmuuIQV8wD/0lpKmZarI8zAgifmywOoCgyIn7
	MbRKXiUEEkvzdHAKki7+cGGhOuvjoU/MRzG91cg7uvqtHnj+73CHqcE+C5pu5q+ll4Se0T33APY
	ypRqXgD4VRYhzJ1BOgJkO/HM3q92De0Xr6XNREX8je2eZo+amhqAso2kXGzLHBYkM1b2QRlCfZf
	709eMTIMeHdowdOH6IwZHJVBGGkjagb3+knlBkmRAc=
X-Received: by 2002:a05:7022:1608:b0:150:1cea:31a8 with SMTP id a92af1059eb24-16a60bf2778mr16551597c88.19.1791939359163;
        Tue, 13 Oct 2026 17:55:59 -0700 (PDT)
Received: from homik.fullerton.edu ([137.151.175.208])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a4429603sm39561692c88.17.2026.10.13.17.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 17:55:58 -0700 (PDT)
From: Mariia Nikitash <nikitash.mariiaw@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	morbo@google.com,
	kees@kernel.org,
	justinstitt@google.com,
	codemender-patching+linux@google.com,
	Mariia Nikitash <nikitash.mariiaw@gmail.com>
Subject: [PATCH] wifi: brcmfmac: Replace strlcat() with snprintf() in brcmf_fw_alloc_request()
Date: Tue, 13 Oct 2026 17:55:52 -0700
Message-ID: <20261014005553.71803-1-nikitash.mariiaw@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Bill Wendling <morbo@google.com>

brcmf_fw_alloc_request() constructs firmware file paths by chaining
strscpy() and multiple strlcat() calls for the module parameter path,
separator, base name, and extension.

In preparation for removing the deprecated strlcat() API[1], format the
complete firmware path in a single snprintf() call.

Link: https://github.com/KSPP/linux/issues/370 [1]
Cc: codemender-patching+linux@google.com
Assisted-by: LLM
Signed-off-by: Bill Wendling <morbo@google.com>
Signed-off-by: Mariia Nikitash <nikitash.mariiaw@gmail.com>
---

This patch was originally part of Bill Wendling's strlcat() removal
series [2], and I am shepherding it individually to the subsystem
maintainers.

No code changes from the original posting [3].

[2] https://lore.kernel.org/all/20260915081910.4142719-1-morbo@google.com/
[3] https://lore.kernel.org/all/20260915081910.4142719-12-morbo@google.com/

 .../broadcom/brcm80211/brcmfmac/firmware.c    | 21 +++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 22ff326f1924..2f74a952599e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -845,22 +845,17 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 	fwreq->n_items = n_fwnames;
 
 	for (j = 0; j < n_fwnames; j++) {
-		fwreq->items[j].path = fwnames[j].path;
-		fwnames[j].path[0] = '\0';
 		/* check if firmware path is provided by module parameter */
 		if (brcmf_mp_global.firmware_path[0] != '\0') {
-			strscpy(fwnames[j].path, mp_path,
-				BRCMF_FW_NAME_LEN);
-
-			if (end != '/') {
-				strlcat(fwnames[j].path, "/",
-					BRCMF_FW_NAME_LEN);
-			}
+			snprintf(fwnames[j].path, BRCMF_FW_NAME_LEN, "%s%s%s%s",
+				 mp_path, (end == '/') ? "" : "/",
+				 mapping_table[i].fw_base,
+				 fwnames[j].extension);
+		} else {
+			snprintf(fwnames[j].path, BRCMF_FW_NAME_LEN, "%s%s",
+				 mapping_table[i].fw_base,
+				 fwnames[j].extension);
 		}
-		strlcat(fwnames[j].path, mapping_table[i].fw_base,
-			BRCMF_FW_NAME_LEN);
-		strlcat(fwnames[j].path, fwnames[j].extension,
-			BRCMF_FW_NAME_LEN);
 		fwreq->items[j].path = fwnames[j].path;
 	}
 
-- 
2.43.0

