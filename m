Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88184D6C23
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 17:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789580090; cv=none; b=J6r9omlpZ2FxP4blDQ/4tv2xULBRfEIyJa25KZ8T0k9ht599YXw/euj5luW/mhcmtMc+JEyz62vrDNbXuHS/CTJqepTmebiDEx1tD/wp6eLVkAj5uR4Bfy+0xLNSC/1rhDJdgPEctUNLt20g02swfGi7AjSt7oRtqNYCV2KSDqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789580090; c=relaxed/simple;
	bh=pbWiPxiQInKuj5bTFtORq9m72QKi4BBFkW3huAQwTGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GRNjbwiITuZFZ8LuECH8zfIU+ruVIZD4v4xbwpT4abFIaRfCwBQE1Jz9u7vtYjujjjYajD2gYPwugz1fv+cMGimYxgyC/gtjEmOSezEFQzXEqbCv8kMoaaHBx39SK4HAJNV293t3x0sSts5uBBfEQASSRWwANNj4fHh/K3+e9mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+jigOvX; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+jigOvX"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e6598dd44so6935885e9.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 10:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789580077; x=1790184877; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=TP9Q4QkeKPg/kRB9zan/QUnpnRo0dK+31LaOT3R+N7Y=;
        b=X+jigOvXb844rOIp9scXQCgpo2sYfoGdYGKyoBITcAaSxkqNBmIhgbKckmNFeldTRf
         uH8IvjsqxgxJ4kHelFL9HDOqZT7xFGpLlEFLnJodlCTd6Yy33Wa5OD+DqyV59VxD+FzA
         0HtyRpkNHrQdvKE4y17u7K9iMIH6ChwWpYaYkPG0wiiHQCHiMiFyBO86RdoxDWNFoM2L
         MIPLH3JeJrFqU9fR6pVBUbbluYHIPq2rMBzveycCCxjryRQHUyf9e+G1ZLuYilzceDF2
         WwAwVfDDFlfeC0s2su0eehePEi/XzLYhZwpM1u1iG3n8UBzD5Nv4n/beVTwtGM/vByj3
         osnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789580077; x=1790184877;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TP9Q4QkeKPg/kRB9zan/QUnpnRo0dK+31LaOT3R+N7Y=;
        b=Q+SAJf9D4E6+cZkurgm4oRtAAvYeF+9fi26O4k0il3eZqa0AU8ydjMGhS4+7YjG31T
         d+cymluBiSfyqTdNzx7hyr0NBi1XRkcYVrkYtVFztSq2UwkbbKOiT0/UCPE30xERwLeU
         3kaHms26h+zaaGNF72iIn5AHPsMR08D3WUfjClk7E6mcwOjEFPMRI9/ssEVZ4EOQFHAP
         BMPCwxGkrVHGCgNr9wgFeBiPYJMPn/fLdayV1gI+Vkeszm3/DzvvvB/Ia0/z5xRpsUhb
         SmT26dCq8vpOAnSqQnu46mUlLIgmBIsCsN0bRJguuhOHQZK/aZVAtfZ3zgPEG8oEHPjJ
         1MDg==
X-Gm-Message-State: AFuF++lRYNHWlf59LonndjqbMbjYdlNpe2HXTMc4cGgRg1p25Mx+HMnE
	/W6OdiVg100xAnNJZTUg9/fDX0rvnltIM/KlagLFQghBbo2MenyAUW8=
X-Gm-Gg: AYBFou3BM7GY6AWExCsUSuELSqSM0vXzKPlNkgiI+P7S7Gl8a6WizwWGGuxLSDizWfJ
	FZEv01SP6ljV5ElFivIHEUwFp6mE75kjuWhNkYvXfKE6YP8Z0iejhudMDa9zGYMAfyY4HEALMoP
	n9ZIPDA9XbB2zmpsY7sXuHrQ75qrTaDTZcDllci0ZLqnGccr8+4rBN493ATAdbS/RxZcV3zZfQY
	egUni/Lv/5wt/dqLbmm2OCe0Eo4p4MN0QPCNIg1BGxs6eHBNTKMVj7D4IqsFhc9Qc9oXiJAxhNi
	srGhiB4jKqPz8fRP49FkKYUhVA2yuZEQFRTlgXBRKIGC8pIjUZbr65jmm/spn2MJhvicqEL53/h
	+k99BcAVIHYSReJ/YdCmBrpIA1nQez0xMY49Y5nddBArR6b7uqEGumg3qTrRB9IlrqJaVDAF1iv
	JFs6XhkwjSveIx8o7gwk5JsoH/AcqzRO/jFlfqb4E3xM/m0JsA3Yx1rsfBTUYCuVZmZqInIyzuZ
	Xa/eDsW/Hxgoz6M8gxdjRSIKvIZ2TFOzp2jPdZs4Fi29g+rGmxrszVVGCjL9f79MI5G2dqSB4/B
	Xc2rRR7zQWOBvhA=
X-Received: by 2002:a05:600c:3e0a:b0:49d:39:90ba with SMTP id 5b1f17b1804b1-49eac46392fmr43178425e9.3.1789580077291;
        Wed, 16 Sep 2026 10:34:37 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:f23c:f0c3:c09d:d6d6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4870bf27ce2sm8987544f8f.20.2026.09.16.10.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 10:34:36 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"John W . Linville" <linville@tuxdriver.com>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	stable@vger.kernel.org
Subject: [PATCH ath-next v4 3/8] wifi: ath9k_htc: refuse a command that fills whole USB packets
Date: Wed, 16 Sep 2026 20:34:24 +0300
Message-ID: <20260916173429.403889-4-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
References: <20260916173429.403889-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The firmware ends a command on the interrupt OUT endpoint only on a
short packet, so a command whose length is a multiple of the packet
size is never delivered and the device stops answering WMI. The
previous patch removes the one such command; nothing prevents the next.

Refuse such a command in hif_usb_send_regout(), where the packet size
is known, with a warning.

Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index d3491ff08e6e..4b57cc2f3d6c 100644
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
+		return -EMSGSIZE;
+
 	urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (urb == NULL)
 		return -ENOMEM;
-- 
2.55.0

