Received: from mail-pf1-f225.google.com (mail-pf1-f225.google.com [209.85.210.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C734192EF
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 09:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791107152; cv=none; b=hWh+8oo5pOOp8NtOvzS5PPK8V0QlwEKattC/IHruNPGVBtDv2XBGaqMUhBkynsCcTNjMypGUk52FeXULIYD5Jn3zoSiSxc3MMUsbdV5C3Y85YPdtbXDGOdk1C3nSS8AJvQkFFwRitElYCRfGnSrSV85W5ozT9ee7YYMokUPacU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791107152; c=relaxed/simple;
	bh=420Bm5WTSD49smEVgl+DOIJhIdSyTQHkYriLCLQg948=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCA2EXvYb7dYZDYAwAta91InavlYFIeAbnEqPK0YqrOsj4mjYxHMTUbWkAaKBEpcKRxCVrfM4I5U5NN58U4GekEf4z7Y3pO6aTxCMV9sV6qbhgKTBwimc0bKnYKRwIMcKkjGxl/YartJx9OK9VADf1seicxiCePCRYwlTa3YPyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KucpNWNh; arc=none smtp.client-ip=209.85.210.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KucpNWNh"
Received: by mail-pf1-f225.google.com with SMTP id d2e1a72fcca58-887a58523e6so29499b3a.3
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791107146; x=1791711946;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=N4huEKa5MU1WXjI5tT87BDY0G4FHdScFokO8zXM7rU8=;
        b=k+vEyqsTcsQnFiOfCQuwUx7uIQHxGHT8/f+yqvvKFnH18DDnukZFVYwJzEBYpSmlnM
         WWmjY6zGPgERGRQX+qhBfnyNRGJO0G7Kcnzb5CFP1YObLzk+hZOe2znrC6ENP46q9IgU
         0qVfLl4c6rx1dFcygTKigs74kRrAhAW8BEOyg6TdFA7fTCyNWJi/JQti/xt6Sc8mIvgg
         3atwZ4hkB9QistvA/lE/eQ92390xbXQUHBcGA6eGV775NTCG3JCm0EHe1YKllLzj5Lpu
         PwApB/qI7hnefCazWwuqVsiSrxOtEBoHNDdRg6xJr30p1WBqXvK6a0kx0TV4i8g8qDZ8
         nU6w==
X-Forwarded-Encrypted: i=1; AKwUvByylmhtKwdoU5XRmTmQbPL/8BAA5f/GfFFx6r1rtuEtLzgrD0AsjoHezizIHYBGgCnMA6h19a3J7Sk+Jx4DcQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lEfHpVxWT+BGP7APY68gTacQ/9N/50BdhvQcnQCRRKrJ8u99mS
	0bVYi7v+OtSU2JwGiyzzECVHoM18zByomaq3qa6lTB6ACrFU9tDZXwfCaJaypzE+Rao7OGFFEvt
	I6VGVsX2g5ySRxFIc1mSU9C8ArbzOBuUVIhAV1UQLmZOp9Y9b9+nBWxbQAq1We+6A3RnsYEZiIL
	x18+xSr56yfsW+LGYDQLOaNesJjrO+0l1Yrismfp53PezlsQqcEEoLQPBDk6yHbGEVAyTXi2Vzs
	i8kD2eYYiESnwYgb7ZHEiuN+3g5
X-Gm-Gg: AYBFou2TwKqKgQeYA1k9ctB9OBnbOwaOyjnF8owMTeRJcWvl/F6nTyScZr9llGz5i3x
	vXVCvgNM0Jdvf85jpZ7ILlc7YTHu9I60MC3Afu4Xp4C1LuhyrRmoBTOc1oxxt9rr3x/bAnSZBDg
	65J/TNaBLHCC7ucDlGk390lMX9EVTLffur8Co+fupIr8kuSF+ce/+gO+zZYINnmQIrEksQZo0sC
	sUrJ21p1YMB3U7AHjdYZ5mi9vbXDeSQQ5tiWQ1FXfdmRHQfavT6wqP4pFLD2kmpsOTBL+wJ3Vf1
	q61ugliaFbNwwaaTNQ+J5PpcLSutELPnbcCGjxXu2vjRVnUs9SoZcWr2SBcOSdDfmc+G9mEjzfD
	XQYWCGOm4KNwRuIye6KzBNQzDtFhx7+v3B9MzS1/kYGLq0KH+Ok6BWAnLsvrVlKcijV2iTA1bU6
	CZwNMS3Mbk02310sKy7mzpElTtGAcaYz9L/nNEFlK31A==
X-Received: by 2002:a05:6a00:14c4:b0:881:158c:3b4e with SMTP id d2e1a72fcca58-88af59ca1dbmr6132202b3a.47.1791107146112;
        Sun, 04 Oct 2026 02:45:46 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-88b0bfc0a26sm1326145b3a.7.2026.10.04.02.45.44
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 02:45:46 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-33713e5e6daso927430eec.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791107143; x=1791711943; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=N4huEKa5MU1WXjI5tT87BDY0G4FHdScFokO8zXM7rU8=;
        b=KucpNWNhfyGJfw9nbz8hNkJopM5DG6IxVlyfrfSO2kx585nR6TATUjw5tT9TsgcGXS
         5LkQaAVQnWpWTbxk7Y7V7GJx/OUR97s8wOpvNrKfEsHmxIJHXHNnEhoKoC2mR3uwghwA
         NXqSxM9JWN5G+/a93GtZYRq5iDzfaxHOspPgI=
X-Forwarded-Encrypted: i=1; AKwUvBzgLZ3XekYV6t40eEye4ByQld6/s3mYyY5Pdcrfq5srM5ZuWiZjWP8Rvbmcxp8oz8sRgRdeQ/wtzClXGz04sg==@vger.kernel.org
X-Received: by 2002:a05:693c:4089:b0:351:d26:b74e with SMTP id 5a478bee46e88-3510d26ccdbmr7154442eec.1.1791107142852;
        Sun, 04 Oct 2026 02:45:42 -0700 (PDT)
X-Received: by 2002:a05:693c:4089:b0:351:d26:b74e with SMTP id 5a478bee46e88-3510d26ccdbmr7154413eec.1.1791107142210;
        Sun, 04 Oct 2026 02:45:42 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351272ceb02sm6392294eec.25.2026.10.04.02.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:45:41 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Girish Rudrappa <girishbukkasagara.rudrappa@infineon.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	Bogdan Nicolae <bogdan.nicolae@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH RESEND wireless-next v2] wifi: brcmfmac: Set extsae_pwe parameter to Infineon firmware in SAP mode
Date: Sun,  4 Oct 2026 02:45:37 -0700
Message-ID: <20261004094537.1324150-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260922062458.3550-1-girishbukkasagara.rudrappa@infineon.com>
References: <20260922062458.3550-1-girishbukkasagara.rudrappa@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 22 Sep 2026 06:24:58 +0000, Girish Rudrappa wrote:
> Parse and configure the extsae_pwe according to the information from the
> supported rate/extended support rate and RSNX IE
> 
> Parse the beacon IEs on start_ap() and set the extsae_pwe iovar.
> Set sae_pwe to 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> membership selector is present, 0 otherwise.
> 
> The changes are tested with FW Version 7.45.286
Just a nit about mentioning firmware versions. I doubt if it is very
useful. Anyway, here is my ...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Girish Rudrappa <girishbukkasagara.rudrappa@infineon.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 77 +++++++++++++++++++
>  .../broadcom/brcm80211/brcmfmac/cyw/core.c    |  6 ++
>  .../broadcom/brcm80211/brcmfmac/fwvid.h       | 11 +++
>  3 files changed, 94 insertions(+)
