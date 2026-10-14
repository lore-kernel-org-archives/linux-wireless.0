Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208562FBE
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 06:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791959078; cv=none; b=tfKFjbqG6eC/YTxahSoI3Uy9KTPEKs60l8WS6f0JRmfGzWUxOOFiOhbzlAOy7BBKwZPYh87Ob6XVTCxjYydzSkbTW/fFbAjF3Q3aPNcpHqscSUfw7BQGm2cr4IqPftQsUhzklYeYhv9CQZNYb8JhJrE5cHWUqcdQKqplHfNCE6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791959078; c=relaxed/simple;
	bh=q0tVtjvX4IUhnu67bLdDxXUn1D7ch3ZBlRiaMjbf6yE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bc75eduMOsjz/imtzKqZ74/JBML65AI+/AVDWk233riybmvi2OM9+G75Z7htSl3/HPAUmFbefHeVfLDER5qPXdPLBH6OWUmw254ku+NVU6QWuAmKIE0R4CDriuRJQWH3OkT3GpNlkaiq3LPYkU9KDENJo+i7r5JzALgv2/frab0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=o9PX21oG; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o9PX21oG"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-7c33cc572e6so2678896137.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 23:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791959076; x=1792563876; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hujZ8aK+D0/YFkJGReZSv0OUEVZmD0gAt0WZ1nnaWCg=;
        b=o9PX21oGDRR5DMo+4iuhunjpRDZdj2Pb0CQMUplRTpnY8Iu2N2BBweZFb1ouzfB23m
         o40oZ5WLO2/KF+ttxkjQF2c+HL9vZ0E4TyfjcZQwnaLDVo1a7HHzpNrUZSJoiIMStie0
         Cfg06Lr70wUqOIwpX3qijY7tTB2GEdAuG6b8KVfYEAVVOpahpKXPZpYfa7FM31apXReE
         gq3yfw8DX065zjFfWDnxInrmxsFqeU3LyQCY1HM7BWI1Lvw2B8ccYKpVGG5sp35YP7aR
         N4Ey/WedCiSJeXR/zD5XSfYDg34IuwGv9eCpCvL52ziNt7LKtYDFQgq9syCGgKc/7gHH
         fCNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791959076; x=1792563876;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hujZ8aK+D0/YFkJGReZSv0OUEVZmD0gAt0WZ1nnaWCg=;
        b=NY/P2pG89QviGynXXuG0dAS7JDxnIopQkJCxUM6SkDktEKfOOYfGV5/uv24ZPGG3Xa
         SdeeXGlWENUtXhHJnqpjYgPEAfEdZUM1qVtF9jHvRCXexqmcuTjHY1qv9Dl2GETziqA9
         RX1u0AjQZpvsXqJ24IYVmglFoE7N5vyRbGTMaEFvJOyGo5CvO9TlMxOfCV+p7H4oGlJb
         vTIO4BjSAyJ3yjHMNrgWdYqZo+U+/54280ByE3icd0hskBJ821WggTcgAAOaw1ffIVVi
         CYY9beyTRjhOfM7TJhGuQ4a1CfOdGr0h4FW4vuwmm9+nbe4w11s99qK1hSIHzqRSAFcr
         yO8w==
X-Gm-Message-State: AFq9FYLUJU/iZmertBZCvqKYMLW13UBOXU/Eg5RJ1x0vRPXDdacNbkBJ
	jJITSilMjQwp1FRsr61W36+3pj6QA3hLiR1pIhix/0cPIZbePLaJFRFNYOVJLnn/
X-Gm-Gg: AYBFou1hf/H5HTCCXYEhwLB8f6/9aXz9mz8odvDDVLtRTZqLwvFSCO0MiVEgn0zfn9e
	biHt2ze8JL8zcZai0tCUN79vNo8gbhWWSGtUgH6Y18svJnef/7o8aS7RIj6MAuQJErYWlvMIfw7
	/cyUzTW8JL1QCbl4kfH7JAlCIxx31Jhj7EsTvRM5YDmuMymbQU7rZAPY/RwXpWd5XRvQq3COgvD
	rMKnDMDBkyaKomIiKFWE/zAUIB6hHzGXHzohyS7Hr5h1ZweV40ucq+0yCH0iY2THN4ZzN2ryqg+
	mJL+V1h02QcuPRDKvMLYTL+oxzBny8jTBPAFC24HgeYOl3z4nsO2boBjm5HYAHYAC+Hcu8T85kp
	ZEPDH+3tH8WAzUSgfLtFgzs4KEhgmvrs5bAnQoV5wz8w5Y349P6IJYNgJVnnZJ/yp8Zzd7s+wbT
	+iOu5FA1ZhS29G1MtF4XAHqXTqLlfo4CsgTgDn6tglni97oGwTCwdGUqmf/Tw0A4H9TuIUlPR/c
	J6sRjDyFi1Cv2hz0Df3ZmibU7+QI2rMJ2F8CeMYcYf6
X-Received: by 2002:a05:6102:2920:b0:7bb:64cc:1362 with SMTP id ada2fe7eead31-7cb429d7c22mr3298848137.6.1791959075829;
        Tue, 13 Oct 2026 23:24:35 -0700 (PDT)
Received: from DESKTOP-1E7V4GR.lan ([190.177.140.173])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb39d6396asm10208986137.1.2026.10.13.23.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 23:24:34 -0700 (PDT)
From: Cristian Papa <pcristian292@gmail.com>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless@vger.kernel.org
Subject: mt76: test report for three pending power-save fixes (MT7603E/MT7662E)
Date: Wed, 14 Oct 2026 03:22:43 -0300
Message-ID: <20261014062426.9282-1-pcristian292@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Felix,

I backported these commits from your pending branch, unchanged, onto
mt76 be5ce7910521 (backports 7.2, Linux 6.18.44) for a TP-Link Archer
XR500v (MT7603E 2.4 GHz + MT7662E 5 GHz):

  56b110804361 wifi: mt76: mt76x02: serialise wcid drop mask updates
  05fc7fb18f09 wifi: mt76: mt76x02: clear the wcid drop mask for all powersave responses
  2b7be52496ac wifi: mt76: honour the more-data flag when releasing buffered frames

With a phone associated to the MT7662E AP, three screen-off/wake cycles
(60 s each, browsing after each wake) worked without reconnecting, and
there were no resets or kernel warnings. The same three cycles on the
MT7603E AP, with a 1 Hz ping from the AP to the phone running throughout
(about 8 minutes), gave 474/474 replies, no reassociation, no resets and
no kernel warnings.

This is only a functional smoke test: I did not capture PS-Poll/U-APSD
or check MoreData/EOSP over the air, and the image carries other local
changes, so it does not isolate each commit.

Is anything holding these back from master, or is there a specific test
that would help?

Thanks,
Cristian
