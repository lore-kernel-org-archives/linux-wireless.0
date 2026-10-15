Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900B23F8891
	for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792089650; cv=none; b=LiagiF4D6nz08UGYHKT2QqhW5rHz5L4GZ+lK0V6IdLLZha80BmUbpCD2yLZOatJxQUY/XLUux5XHod8+KpOF7t/djz2CpA4zCYB+Q64C/7zWFSPnCB5yCbqTZR3oVIh0ATVRlrd6Qn9l76TZ5mzbZilGmW4WG0pwA7iu81zBRhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792089650; c=relaxed/simple;
	bh=V5yzgDr21nxczhxKu9JiO+Rl3gBcr/Doa1CAdEco8JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tIe61zPY5TCFcDKSC/20X23GcjXSGntP8f41FvJkPjhLQBm1aw0k8ed6kF0M5ayZoNYmlqcjzAotBEnx+rjt/jv2vGj2nTJAtQqQmbK6TxT7+oxaIKViE7jejbLVMS6VJerCx9U8XeQJbpMz0bEU1hWfE4VhQHaFJH+6CcCP3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8/gAHWA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8/gAHWA"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a022fee0caso53114305e9.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2026 11:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792089647; x=1792694447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rGkil06XO3g5opDlFSJDhdb0jcGxqJIbAxYs8/6p9Sc=;
        b=H8/gAHWACQEjvRgEjxncrSbDKg4VlqGYblmErKuDKlNhvRo9hpgdWgTaiwVII8p1MJ
         eL3QeMoDhfx+9dWI+w+22RyBNyarsIYJ50VYJz/YST9jobv3phMU5xe5e5iPWYAUfRBi
         7Z/hqsvYzIqd/iNykCX+AGZA6m++f4tlN5oICtnTPb5Pb2xdQk/l5bzarKEIgAD2lyks
         dHPtVQXSBmTFKP4TeE9OpQuwrIsbP29QQ3AHNPXxPKGdiELL1fhV6oUZK24zUFTQr/4J
         STcsFZbJrP9N1J9YiKQI1Q5gDAmw8+g+hwpVIJJbHNU/cRQS9hjKhJCBakmFXFnGvaB9
         fJhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792089647; x=1792694447;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rGkil06XO3g5opDlFSJDhdb0jcGxqJIbAxYs8/6p9Sc=;
        b=fLnQ+unsli39w5AR4X5VsOYL6ZLV88pzDSQL+xHcCEwAa4xGT0yYlzOl/XKn8rFBfg
         oJmk8Xf1PRhxkdrMSNHDkIQxi+Abu6hnSYdS6poZ4pn0WM1YiVupDRm6UbWEqUQRs/K/
         ZWwrjc81hDKETRRQEK8YvPbpCx0WV3nTKCckgtF5hB0GhMy3rLuq0lJLU9ZYJ3Yklvzi
         nqbAZKqKtK7KYP4ZaIpGIReBCjtglLV1wk8R+FXI6RRC711VWdiu3h0i4i9O+YOzLHY/
         DUtHOe5Tfhmj7kYBZfIIwlAN11HAMmXhOaLfFkW7bwjer82rZP2efsglHdt6dvm8cQjg
         lRxQ==
X-Forwarded-Encrypted: i=1; AKwUvBxr58XEtwIkD2asDFDo0wlUlyqybx/PE9CO8YkDh9WoGb3PHZQyPxiwNO/Nrj7g3+2JYCMKTF7qESK+vu3kyg==@vger.kernel.org
X-Gm-Message-State: AFq9FYLo8/8yUYK6siMjRnpAhxApMA4AcHK+4Ay672FmS3Hs9Neci/J7
	C9y9Wu4O5tpceMPEDPsgyWFQkTEmecPtvXipjiOGYRbbzKJno80lwKvR
X-Gm-Gg: AYBFou30axa8REAHXl2V/oxVKfLm8cXoyo/IUGiMB7xStlm556PkSXXBZ0tLBQ3ADqJ
	y2slGc8rZ3VBTXnN/CV597riBGHSdJPDms0eUeB56KWmMhcSiud6VM20cZSfIXAGX5/qvo37RDH
	dVr0VZhGmRMGGJffc1W+x0kebLpGcim6vkhpvk7vaJzfTKAQ2vHRAAUT1fDgo7vOlSERHaukVdL
	/YwZXtS+M3GW9vQEOOEeb0V7L0G/ORfiJTiv9i1nTri7dbXAt8F6opkm1O1WNAIa1GaP+4JeyCa
	xxwDRGaYsG+OoKAgje8VI1wHpX/Z1Kurezft/fzDsiyVsdTI2hd2d1XteeXLQLwF8qp4ecYYwsO
	T4rli6is5ypVioWmgNcz1drZPMqpmzPPpUvQTiV7hgtcxWoJc7deW/YM3w7pnkvvQn6mzboZ9nv
	cojWgIyQz49CqqZUoP90ZRQZERkZ4HD3LzqZwZuHbPPg7hx/hc4l6l+qSi8um7qaj9lDWgsn7J+
	6pB
X-Received: by 2002:a05:600c:4689:b0:4a0:1cfd:321 with SMTP id 5b1f17b1804b1-4a18e4a9b31mr429219275e9.12.1792089646475;
        Thu, 15 Oct 2026 11:40:46 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd67a080sm88337045e9.3.2026.10.15.11.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 11:40:45 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Sasha Levin <sashal@kernel.org>,
	linux-wireless@vger.kernel.org,
	stable@vger.kernel.org,
	regressions@lists.linux.dev,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH v2] wifi: ath9k: reject short WMI command responses
Date: Thu, 15 Oct 2026 20:40:44 +0200
Message-ID: <20261015184044.1321868-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260814075837.20005-1-pengpeng@iscas.ac.cn>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

this change breaks ath9k_htc with the AR9271 firmware from linux-firmware
(ath9k_htc/htc_9271-1.4.0.fw, "FW Version: 1.4"). The firmware answers
most commands with an empty payload, while the driver passes a response
buffer for every command: cmd_rsp in WMI_CMD()/WMI_CMD_BUF(), the 4-byte
value of WMI_REG_WRITE_CMDID, the 4- or 12-byte buffer of
WMI_REG_RMW_CMDID. With the new check all of these calls return
-EMSGSIZE, and bringing the interface up fails (hostapd: "Could not set
interface wlan0 flags (UP): Message too long").

Seen on a Colibri VF50 (Vybrid, armv7) with an AR9271 USB adapter on
6.12.113, which carries this commit as 03ef61d05aa2. A log line in
ath9k_wmi_rsp_callback() for every rejected response shows, during boot
and interface up:

  WMI_ATH_INIT_CMDID          0 bytes, 1 expected
  WMI_START_RECV_CMDID        0 bytes, 1 expected
  WMI_FLUSH_RECV_CMDID        0 bytes, 1 expected
  WMI_SET_MODE_CMDID          0 bytes, 1 expected
  WMI_REG_WRITE_CMDID         0 bytes, 4 expected
  WMI_TARGET_IC_UPDATE_CMDID  0 bytes, 1 expected
  WMI_REG_RMW_CMDID           0 bytes, 12 or 4 expected

With the commit reverted on the same kernel, logging instead of rejecting,
the same commands keep answering with 0 bytes, and so do
WMI_DISABLE_INTR_CMDID, WMI_ENABLE_INTR_CMDID, WMI_DRAIN_TXQ_ALL_CMDID,
WMI_STOP_RECV_CMDID, WMI_NODE_CREATE/REMOVE_CMDID and
WMI_VAP_CREATE/REMOVE_CMDID. WMI_REG_READ_CMDID is the only command in
the log that returns data.

So an empty reply is how this firmware answers a command without a
result, and rejecting it takes the device down. I have not tried other
firmware versions. I can test a fix on this hardware.

#regzbot introduced: 93ce8ea70451

Thanks,
Mehmet
