Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367872E736F
	for <linux-wireless@vger.kernel.org>; Sat,  5 Sep 2026 08:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788598740; cv=none; b=IQkCsDK2T3vZcLTFn/alYNNcujGU8OuiC8zUQo7OP3lhCSJPj5Ml4HiLVt/2fDyfkJ1kpxq5sRWSzNsT7PQt8LnyD3nP9lAbaMSXeiolNR4rNzj3UzsqUeb/85+3N8wuOAe9q1Ipdh6sCDK1kAjz+cyH1uc0/arS32Pw2J0XELs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788598740; c=relaxed/simple;
	bh=6zz9Ag85LOmpD6O7B3WH4S6lYKS21tOMt9b0pe3DHRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s4417Ndc/bhX1VuxvZ/w7p3uT751bf6kA6+ykGlSQIOzDHuvyLsJGB618x24/RTGLenpe14aIhepxKy/SpRJRWN90maJSMeNR76jPrY8iwXVtTdjBYOnzK8sjvhLnLWaQ7HyI81o6Fjq1SIZFBbQVrAm3sFVhk9dXQpfVXoO+DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ADidD9x2; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ADidD9x2"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4956869750eso14349095e9.2
        for <linux-wireless@vger.kernel.org>; Sat, 05 Sep 2026 01:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788598735; x=1789203535; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=GUrJMaiglIbT6L941pCJUScecxh9O9MwXfOfsOlfv0Y=;
        b=ADidD9x2/cstVJ/31ydDidK8pdHM7PBb8VDP1eB4gn1ZVwCulPaevTYBkIU9U5iJV6
         cuTDM3ht+gIq3PWdSxEa8/7XnALp38cwZntGSQCGjG3Bnf1tdmP0s0ArFHAJZzAUZazX
         KlvkLvCV5sxnQuro9vddeCuWDa/t+/rgtJS5fa5b0QgByIsWcT/bt++n9QNxxPEkfcTE
         lM9jQwEI6d3scr9FqYbdkogbccpgBqiP8Po+lQBUL38a1YAXd33iJI+iUsqnait71/bZ
         E48CT7UMOHEH4A/8cWskl/v9oXeVh8txjEUD6TOpwVQIVEPEgacba1NN/k02xy66QNNT
         Q6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788598735; x=1789203535;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GUrJMaiglIbT6L941pCJUScecxh9O9MwXfOfsOlfv0Y=;
        b=A29MeZlz8jU9P1AQT4DbkTfsCrA8u4Gen9/dH6yNgu6HO8Bjovdoyg5dTzUjy37a0u
         AU5aI10MXb8BsCQobCSVAJQuJY/VAjBAXu1PukXMKgBWeZDBpc3LpzYwZmCubVzcnw+l
         8HuqH2nqmryw18Efjfv7DrRDLhZ0k3tdYHZKbpzocGfsR1N4V6pcJfDyzzF00IorOX2+
         EKA/ASnK165rCm10VLyGeoAbgbnO/OBxWQ1xAHJyRxmZ4sNVfXGuCOLv19TgxDJVW0K9
         dExPIZUBV6sbKBndChQ+U1EYa2PcvfOPdB1qFat2op+mCTVAf0XhUoYIhqn4B/gU9u5Q
         IjEw==
X-Forwarded-Encrypted: i=1; AKwUvBxOWqe4oSAp/UE3kT5P1LI1T2wYE+gu3zkvsBEBE1dVIGlpN0vm1TunOZp6lgOXAosGm8AzJchaAyMIkxzfYA==@vger.kernel.org
X-Gm-Message-State: AFuF++m8vt9THqAe9tD8Ux/ecdfDSTt/JtdV9/+wQwJZEys12aGe/DsM
	EpYD8ggiQRbxs+Ez/Ag12E/VN661JErYn9TG9vVBXsjG+L28y0lQuqs=
X-Gm-Gg: AYBFou3WEqE6vJ8ZktSAqFWADOTOND2Dsc+IFjyrc/EWMJOXopByRBB655T6/2Vb+uF
	/LNah8+zV9Nfje3i1jsl0xMHeHmmR3fExpS3aALFkfMAiZkiNgk8Vm/y64hNYaFlTMd7NBW56g/
	sQbtNa7rUeOzoWHIBZAYSurry49gjTcv7jOEn6GmI8o0UFzJKr/fUG+aMmw+BuYkw915YjvAmwn
	6fvtLbxdUwA5QK6IfBtsQz2gV9JVG3BsTBM3Va0BSLd3Z/iG1jXJDfkwVc9ZH9JLc03/NZkG39n
	u6y7wFUIK1o/qBqpiITqdUIVXhHynwiPRGscUxtVXURUAoWicvLg09Tcp7eOWoSqIBObytMHYBl
	Ozzg7oGPCkt9v72AbCRnXvqQQOvjqS2mEn45h/en81jy1yFnxj84a3Cpzo+CtLcqfr0O7pcEj3n
	l4Eh3KmBC+36PR6sunw6KaVE1oL/w7i31YrLMWdug7qBkLir5j510A/6sPLK3LwHYOVVsSo9SqR
	m1OzWqCnvGUDF487XcLKsvhLRNQIdgWzTUMs9IwiaGXCYgiUJq64Vi/cjw0lUy4QlijakK3nTCu
	dZJ+
X-Received: by 2002:a05:600c:8b32:b0:49b:d03:8d3a with SMTP id 5b1f17b1804b1-49cf8244878mr121200985e9.11.1788598735193;
        Sat, 05 Sep 2026 01:58:55 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49ce5952560sm228306435e9.3.2026.09.05.01.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2026 01:58:54 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@kernel.org>,
	Oleksij Rempel <linux@rempel-privat.de>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] wifi: ath9k_htc: refuse a command that fills whole USB packets
Date: Sat,  5 Sep 2026 11:58:07 +0300
Message-ID: <20260905085807.384488-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905085807.384488-1-nerijus.bendziunas@gmail.com>
References: <20260905085807.384488-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The firmware ends a command on the interrupt OUT endpoint only when a
packet is shorter than 64 bytes (usb_reg_out_patch() in
open-ath9k-htc-firmware). The one such command this driver can
produce, 192 bytes, was never delivered: the device stopped answering
WMI and stayed dead through a warm reboot until power was removed.

Nothing in the driver checks for this. Check the length in
hif_usb_send_regout(), where the packet size is known, and refuse the
command with a warning. The command then fails the way any other WMI
command failure does: ath9k_wmi_cmd() frees the buffer and returns
the error.

Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
New in v3.

 drivers/net/wireless/ath/ath9k/hif_usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index d3491ff08e6e..49303c7e3fef 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -99,10 +99,17 @@ static void hif_usb_regout_cb(struct urb *urb)
 static int hif_usb_send_regout(struct hif_device_usb *hif_dev,
 			       struct sk_buff *skb)
 {
+	u16 maxpacket = usb_maxpacket(hif_dev->udev,
+				      usb_sndintpipe(hif_dev->udev,
+						     USB_REG_OUT_PIPE));
 	struct urb *urb;
 	struct cmd_buf *cmd;
 	int ret = 0;
 
+	if (WARN_ONCE(maxpacket && skb->len % maxpacket == 0,
+		      "%u-byte command fills whole USB packets\n", skb->len))
+		return -EINVAL;
+
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (urb == NULL)
 		return -ENOMEM;
-- 
2.55.0

