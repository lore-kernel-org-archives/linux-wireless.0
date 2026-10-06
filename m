Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785B43C9EF6
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 08:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791274597; cv=none; b=BeKh4IhxBdHwvs8pOIETSVMkqyMnpi1He94V07FQPpXVMhJi1/Gid8uaUTcG1ubY2IgTAFvvDIc+Y+YyodmrNaDX17adq9NpQzgrDmFtfm15kdXZhPdJJ0KMTV8VQks5vLnyDr8qVLC75GEQqJtOJTUvUhzeUCdEeeQG5ZE+UCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791274597; c=relaxed/simple;
	bh=KJBdGEpLDa0C4+0sFGwlBRRDrjOlZR3aoT9AePMS6TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O7Lv5h3uyvhcqwoPxi/+TB793N+VyATtNUhsymG+3Ny7LHAX183aCqm2ykLpwvmxAiXJDflWFMeNdJZeyosLCo/itL9CG6VuV4jdU76lwvzbxs0ocSvZxQv1XFf16/2U5PicPhtAzvTS4Yg41MI5XxproRhJfJH5hHNZ4s+PXCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JDcwHJqr; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JDcwHJqr"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-487049569b6so258292f8f.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 01:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791274595; x=1791879395; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KJBdGEpLDa0C4+0sFGwlBRRDrjOlZR3aoT9AePMS6TU=;
        b=JDcwHJqrMIq3l8aL4Y6ejT2tCRjQ7XLLjrPp6R0hPs3LpFeSmH7PimWrBX8HbDTvNf
         fzV6IG6xkhgR82LWIj+7ajuEubH1HhmroIcXrJRCq7kEn3zYCfUYKUpn0ob609Qvy6mL
         iV4evr1x3HQvwuP272U4PxX4tWy8fvjPcXVm1Nx4ewdktGsQn0cs7FP8yfyjcTrmT+3c
         vhG9r2br+Vq/WEaJnrAcy3EL5IMiVs4BaC33DbiRXi/eVK8WUPTHvOYI3AoTXTcosz0v
         S6xLQ5IVowuz036PWCU/276SnQHaCHGL+VKdowp3ihTrNXoiP/Ufc2R6ZhGzmS2ViDRW
         9thQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791274595; x=1791879395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KJBdGEpLDa0C4+0sFGwlBRRDrjOlZR3aoT9AePMS6TU=;
        b=cOgebpW/KLbn2F2CYsEsfz1kN7d2zM9QZBOaj14snjXQzXSRkfHNdOSsVvhVvRKN/q
         YVQC6LOL3ZwlRGCKFLsoZHmSfbHK+ZETD11L9tIVMwXifU5SXm0x5stMS+NayApyPX3p
         1m3dbO8lFBgg1ThrlUmlLsy0ievx4bpQrq2zzXKYafFDAEyM983AzEKdTqBTIuMgsWTe
         XL8N0U1lw4AboZZS/7rwhHhMlPJHBTRk5BIbV7/XHVocae0kENrcEj/IM8MAuPRjl1xF
         h1e9sAFnW1R/dAyYXxQD76JTUtyzwfIE1X1ty3vsrKQr2eDWBr0vPoR3QlQq1fVcbBg1
         1CKA==
X-Forwarded-Encrypted: i=1; AKwUvBxYzH1ye0Sps5UmvGUm5Tqr9dS6Z97jfA8IOgGVuJU6KXjBFS2n8+cJylRZN0iC2jypJrDv+Fce82TrUY2o2Q==@vger.kernel.org
X-Gm-Message-State: AFq9FYKgRXLCaykUGuAn2cyP6Z6/hJpoQ8AYOia2EA3G7k2s+ZHpjOTm
	qrljRH/M4fSdYskbnqGL9zsom6gWpAvyxVz90VPa5tOw+1Ml96d61zC0
X-Gm-Gg: AYBFou3oTB52Tnqs2b7rUimWo7w7d/RpTbKzh4jy7kWKjKslZl9UYSkEcIu2YGlCvG1
	GOFjz4hK8IwgMofFccgZ5IkvKYpXixTf8N6x0GspcR2abcXAtsoN9r6Fj47QHtHZfovE2wUTnmH
	gSPmal9k7gWCKFQShLrQA2jtFUAg6P3hc+dmBKgyXmdxFm5T5nClkPDC8YEoQ2JodF4VAZv67p4
	Y+w1BbuBAqTGNqJwd5BK5kOtyg+VUP7ugQx6mk0FW5aUxFlckWDM1+G3D3eAnI7TN/kQ710CGFx
	6bDb/LYiNL6e5KH2qh+zgmEPPFOZ0uou3CLHtaUnqfSN9cfr9/fLuoYPv+YNMdOw3Le75yyCrPm
	pdWNDiqTcSDvsXQvO1D1OrQqtO/bQuWzZnGnjYYK275073J6VYmssSPaTFD0CJB4egVm6N7caR0
	9MFl4p3CzIfWxgHzj1+BBOi5m84QQAXN7cJ1OKNnLfTzAcLZS88iM3pu4yc+VhmQ==
X-Received: by 2002:a05:6000:4b0e:b0:487:106f:ee31 with SMTP id ffacd0b85a97d-48c6d1b260bmr830584f8f.27.1791274594512;
        Tue, 06 Oct 2026 01:16:34 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c622ab7b5sm9481343f8f.37.2026.10.06.01.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 01:16:34 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v3 2/2] wifi: rtw88: support channel switch in AP mode
Date: Tue,  6 Oct 2026 10:16:32 +0200
Message-ID: <20261006081632.382185-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <3002971ac7824b0b9cafa852e0e81e8b@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-06 Ping-Ke Shih wrote:
> Can we stop the work properly before hardware restart?
> I just don't want many flags (conditions).

Yes. v4 cancels the countdown in rtw_fw_recovery_work(), under the
wiphy lock, before ieee80211_restart_hw(); the other stops are the AP
stop, the interface removal and the WoWLAN suspend. The work then
tests nothing but csa_active and the countdown itself; the running
flag check is gone. After the restart mac80211 reports the beacon
again and, if the switch is still announced, the countdown is armed
again from there.

Best regards,
Mehmet
