Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0603935C692
	for <linux-wireless@vger.kernel.org>; Sat, 29 Aug 2026 05:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982265; cv=none; b=Wfx9OaGH4f4BY2Eq8oGxJGAPaMvTzn3PTTb2DDh5A8M2uqSRCbVZjiZa4Z4eVo3g/uHdMFH1HtPALuahv1INnQaRJEQeFLzlkMrARrn9xJZfBrVZ4wb3+BbmRnWx7e7531L/FD1/dw6OAdHo6D9Xzfcy8SCRgLV51U8Vqdfz+jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982265; c=relaxed/simple;
	bh=dxgTuRXIg9MafPzhR81UeFG4+538SkbvTi0siu7dZuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=okkkJUnu23B9XighAqJZaTBWArcOK0Ewa4+inju/WyVQrpQ4O4ozeSTDW9znrfjmHI4g0EbnAz5oil0+vLZ7oiTu0qSIZDUe0tjBGmC6xgsaIpZ+ZX5BNT6s/ByyoCW+DIq0SR/BCXqh2AH6NKTAGIcTG/HyqxDeyJiTtsF+ATU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=funJHjIM; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="funJHjIM"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5b00d083818so2650954e87.1
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 22:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787982260; x=1788587060; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UMmi9ENN2WjM1s9qjAy3S5/7V0uR4HETS3+LJLK/gWM=;
        b=funJHjIMlCps+wbJhrWDxzMm+mfvGAMqqON5iPV/kwemYytQ1L02+yFh5IvrKahdBX
         QKw6w+7dB7WXPqiHA+9nQUXv6ar0IfJZrMbBobyCquYIohZWv9x/fbcngh7jqp3UmuXi
         n0YrYH1SLCSzf0vQMPX7za+XyCocjeJ+wrIgtZiyzOiSCKYe+8vCtY+JHbaTVcB6bRud
         eK1kXSZ33xVeMQrlIqGWrwVl7g2MfixFc/3E9vikvdJJnyT80RrM9gI4r3cOYdJxOdET
         kkEMEmJmfphFlJOS6BRo4gNmP5PPyI1lODqf2dHQOOPxg1LvRo8hcrdsluM6KSOPmf0R
         99vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787982260; x=1788587060;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UMmi9ENN2WjM1s9qjAy3S5/7V0uR4HETS3+LJLK/gWM=;
        b=QS3118RcOEFQaIq4G13pd0Hp/arE6crfA5dtOr61gxva7ZNLnOv5wJQ/YlW8rmCNBk
         0xtvGEIomohK7jSBcYqZdu1cSuve8o+9+R45Fz+Ji96eeDhSzycHpD1soZf5OlQStHU0
         5/Q/oCM6PiYtHOS28XKqlhzMKZanqwvTLj0dA/mr2mre0W3cV/fO84uIlMDtJK4gLGBK
         r//JvG4kkg9qWLBqgnmjM3LT+Xuict7kjmd+dGRD8mya6G3D1Rm084f6UttuQaNDVw78
         QyublJ/4TaC6FvpCepWaFNOJsPb3xCIkWC9d1v0goP0Afex3809jKERvEaep5m44I9yY
         aamw==
X-Forwarded-Encrypted: i=1; AKwUvBy2atbIsmYu4eL3QiCRZTWARCo9clH6dDY4EOMDnCPXXE+wGZ2WM59/TWHIQYUO/8gvlteWLkIi4G84zB8mmg==@vger.kernel.org
X-Gm-Message-State: AFuF++no/JgUagdn5+QZZRvbkmMdPVnFJBAbAMnZo+OqivkDWhKw+WbM
	LPx4eGD9ymdn8dAX4QbHJQkm3K5sAS9EvUc4DBvxlN3tGKl+ysTXQ5zDsY6x
X-Gm-Gg: AYBFou1E7RsPnSaRY6iO88qxuiA9ZDe4EpXYblPjA023WPGP2EpB0Sbg7uHEhzeaHo7
	ZjfQ+hHkxq1y46Ic6iBjFUEo6ORC7zXKnRI3iXfbqFt4/DkRFZ0ygU7CyZsOH6MbDnLPk5YQixP
	55bOcAmw9PSIt0RHWZUnR85cL3JRZ8j4fP+QsIhwKJzIMAmvNRQG/d64MiQrV31ZHUD1uP4e51F
	dDH10aj+Q6zORiSehx4SabcnfF7ToH1uoHiCJsj5GDHsDXgZHLAO+cSo4/RTAf7p25LQ16fnePw
	Pv5AuYy/VFEh+l3QVpJzv1mcOeTB6aeQG085ue1QHydA0SS1lOQ8B7Qxk8u0tEol9ydBn5Yrpg4
	0yVQih4DhvesGRbv6Iu6QaUWKZl3/A0OemTBZ0/acwGrq2aycIAe99LtZB7pCs1ebGH/wefIMT4
	dgCxOKVSgMfhcLhs8trn1q4Nwp3iaqcy9F2AzNADYd/POr1NnGLUHwLn+EbnK5hqIE91chr2C1p
	RYWr9S8kN0vM4LtL/nVYi6G0IyqSjbbQPyQWcZHwX1Y13kTntVwQotrBp63MKIGHOXRUNuPuu21
	8+mNdl/VQyP+vW0=
X-Received: by 2002:a05:6512:33d5:b0:5ae:b5d7:7844 with SMTP id 2adb3069b0e04-5b5edba6aa3mr1113551e87.5.1787982259829;
        Fri, 28 Aug 2026 22:44:19 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b5e89c5b86sm803040e87.12.2026.08.28.22.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 22:44:18 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] wifi: ath9k: batch the read-modify-writes of a channel change
Date: Sat, 29 Aug 2026 08:44:00 +0300
Message-ID: <20260829054401.1198574-4-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829054401.1198574-1-nerijus.bendziunas@gmail.com>
References: <20260829054401.1198574-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

ar5008_hw_set_delta_slope() and ath9k_hw_start_nfcal() both issue a run
of read-modify-writes with nothing between them that reads a register
back. Both run on every channel change, and on the USB devices each
REG_RMW is its own WMI command.

Wrap the two runs in the RMW buffer so the transport sends each as a
single command. PCI does not install the buffer callbacks, so
ENABLE_REG_RMW_BUFFER() and REG_RMW_BUFFER_FLUSH() are empty there and
the writes are issued exactly as before.

Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/ar5008_phy.c | 2 ++
 drivers/net/wireless/ath/ath9k/calib.c      | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar5008_phy.c b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
index 7a45f5f62826..af05dcf95a61 100644
--- a/drivers/net/wireless/ath/ath9k/ar5008_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar5008_phy.c
@@ -868,6 +868,7 @@ static void ar5008_hw_set_delta_slope(struct ath_hw *ah,
 	ath9k_hw_get_delta_slope_vals(ah, coef_scaled, &ds_coef_man,
 				      &ds_coef_exp);
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
 		      AR_PHY_TIMING3_DSC_MAN, ds_coef_man);
 	REG_RMW_FIELD(ah, AR_PHY_TIMING3,
@@ -882,6 +883,7 @@ static void ar5008_hw_set_delta_slope(struct ath_hw *ah,
 		      AR_PHY_HALFGI_DSC_MAN, ds_coef_man);
 	REG_RMW_FIELD(ah, AR_PHY_HALFGI,
 		      AR_PHY_HALFGI_DSC_EXP, ds_coef_exp);
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 static bool ar5008_hw_rfbus_req(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index b4ab85bd7895..73c63ab32d53 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -224,6 +224,7 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 	if (ah->caldata)
 		set_bit(NFCAL_PENDING, &ah->caldata->cal_flags);
 
+	ENABLE_REG_RMW_BUFFER(ah);
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL(ah),
 		    AR_PHY_AGC_CONTROL_ENABLE_NF);
 
@@ -235,6 +236,7 @@ void ath9k_hw_start_nfcal(struct ath_hw *ah, bool update)
 		    AR_PHY_AGC_CONTROL_NO_UPDATE_NF);
 
 	REG_SET_BIT(ah, AR_PHY_AGC_CONTROL(ah), AR_PHY_AGC_CONTROL_NF);
+	REG_RMW_BUFFER_FLUSH(ah);
 }
 
 int ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
-- 
2.55.0

