Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793623738;
	b=CrLJuCA3ZNNASnYYyiyvYTFqEC6F/dyGzj1HOppBOL8/6FzZ+rBEK/kYopLAUyGI4ZAv
	 DiK9gIAaEBINsdBVaCtekAFeEHjamPSJaSwbVRV4ku5oIWhRmcm6Pv/ZYDj9sqieySHrF
	 03VDwZ2sOoJ+zzLzcrVl+p8Gn/dR2Pp8NehjBeoVWh7G9IEguQAuWx0VPOiV3w0kfmnWX
	 dbqrQncw5GB/bXnJ3yhLQOXUqnAKn0kswVCR3JDnuLwohpdNTbOr0UdfJe1YKiLWOjCOG
	 v543fzKofJJYQd6R1yulkt+hqYvrcM+gEvK69qOS4Pt2ZfoOrXCfhk4/w2LlN8dp2GQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793623738;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LBUpvPTvdv023x+oUMAsOEs1YSnQG/Nq32m4ILsCaxY=;
	b=xjGDo5EnivPWW8xAykd3OsN/F1ednS4LLABLbTHpEcUwzV+RdN2em5qIVBmWLiJk7bRW
	 YYY3n9X5U5hopj4wzOqK1dVldgLlk7v/VcddisbQ2CQlGV98q0+fzS3OHdWa3VruA5ld7
	 gFUIPq6ki75Ffk1VeNxDSfyH4yCdgMrwx5GJXxPWFbZkF8qSEbBeUx3JzPiqsBF4SZYuH
	 T6+dvfdGl12rLn7xSlCtoYbNVO7RmNy394JNhsr8GYQKxgY+m9d57/h0XjAGXSLPpuSTc
	 cXZs/TR8ddnHAPhwInEvkwBMz4rvhL2mVsYeYPneCkBHquCPgPUpgsteY74PxSkHB6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ke2atzBw;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79338606A336
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 12:48:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 79338606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ke2atzBw
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48df8fe8513so2541906f8f.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 04:48:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793623736; x=1794228536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=LBUpvPTvdv023x+oUMAsOEs1YSnQG/Nq32m4ILsCaxY=;
        b=Ke2atzBwtGQTnT57Tx2mPEWaeX8gEHW3h25HJnSDhnbLHW2m05y+FKCFoWfwxnoT2G
         sTZFqqPfiFcjnR6pwxhGNFIm5aVRFr182X3ov4hXK/95kOY5rq/pNn48urdF8EPuBKPQ
         tlPOsOSCRQgHZWELiQ1+KbO15L2S4WOURPjGXMyAAZBsP9+RKxsku+WMf/imwY6ZMWfs
         1TaYTpS42JztRVqjldgz4hD4JVzrFtbEM6yYDTxo301DyKqSju8u/ZUgWeAaAykL8sOj
         LzxMNwlVVk8SP+DbdeAlLgQon3MQGFEm0AimsBcfpU92kmHxY9USIISHnVG7VlDJHRvx
         Lq0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793623736; x=1794228536;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LBUpvPTvdv023x+oUMAsOEs1YSnQG/Nq32m4ILsCaxY=;
        b=y+CYQPspnZktW0M1c2YqsQ1FFEGiMvLxi1hDIRjjjjzSxX/MvqBNvurOQhJlOwXc3d
         fFtDUaXmAJmA5jT9Gn4xHEbLnU/0dvutm5BsLMl69X7RSgBz643lBJaxZ5Psmj79c4S0
         EAAF2hdYZYOhLJNbI8H6vuvAwY611H+t9GJEb2LeJxW0T2p9DlPYv5mbX7/xaUB3jJJ6
         jhbwxHaI+HLtGfbnRkjFGFB7UBWlf6Zrv4c3zAqHH4tPNG4Z9GhmlDYogS9N85pS/9eZ
         l6zyO6yEwrFBjweehEtK1msuCDiRR7f9zHCTUFnFl6Zukf2UES7P1Qjo+9bFzBtnkcIb
         g1xA==
X-Forwarded-Encrypted: i=1; AKwUvBywuWoAPH5iLLNuRhPfCdEpRgW9xohtJNapxNpCsvfOU+yltCi1PKErpMVJ3GASJ6sPACLPt8trSCdlJ5cFiQ==@vger.kernel.org
X-Gm-Message-State: APuU4Z9Vno0G+glFAvSinl+PnEL/uI8DMNhfKCMieCcmWRPbjldF0jzV
	OW1XRGAO7JxBj0QQ3n0ogVZm3aUVYmEq4abYXn0r2IyTMa/dBl2R8GY=
X-Gm-Gg: AYBFou3qWYo74nzaZijzBOPULq1V15aKc7v/5ZS6+mUFaLqYK9M7NhwNoK04YCCQPFN
	jw0kXWsXTTJZB3BStFGOak6Uav+TAT0iGM5+157q5Zt0A0ux7obYiVJyyVBHiGzRkM6Xd1QkqaR
	5zU+xeRH+L6gokN/5YEdmmkLY+YX411kgM757iPTMtbgif5k7fE97qZiWve9jUuQUjwoG9rSPZR
	4tpcRHomW1aBSx9+PNaVtP57J7APOaHcPL0WtG6Rd2G4Q0op3KjjSzDGkpxrihLja0i6mAFMQj3
	6AyivxGwI9/+yiqkaxSpRYgCyScoz9Lw4MjuSN1Ip5bQenZU+LWN0VxrLdRK/r7NEBMxnGpugHU
	OYrizNwTOd2aG5Q+NeQcnc72AgF1LLzDQRgouDkSB6j2sHTj3Kn7JhYmZKlbI0OoiGzFXpz1JoD
	uumF5D2u4pa4YeBB4XI3TtlbcFGYQ9Mh5PC7mA7/GsyLOPHyxSwHJyoFZ4PbGWTtoxR/XayZe5t
	hTO1pW8MxssRVo17OqgBVerXnfRo7yBCmvj9D5/YULKKMKS8Sq9Ga7N/e2uuC5JHObh3XZojQ==
X-Received: by 2002:a05:6000:2488:b0:48d:f996:1814 with SMTP id ffacd0b85a97d-48e6e5366b6mr21410001f8f.57.1793623736403;
        Mon, 02 Nov 2026 04:48:56 -0800 (PST)
Received: from debian.. ([2001:41d0:303:db6b::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b723bfsm18719736f8f.15.2026.11.02.04.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:48:55 -0800 (PST)
From: Tristan Madani <tristmd@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tristan Madani <tristan@talencesecurity.com>
Subject: [PATCH wireless 0/3] wifi: nxpwifi: validate firmware response sizes
Date: Mon,  2 Nov 2026 12:48:51 +0000
Message-ID: <20261102124854.325979-1-tristmd@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tristan Madani <tristan@talencesecurity.com>

nxpwifi inherits several patterns from mwifiex where firmware-provided
lengths and counts are used to bound loops and copies without
validation against the actual response buffer size.  A malformed
firmware response can cause reads past the buffer.

This series adds bounds checks to three such paths:

  1/3 - HE capability TLV length in 11ax config response
  2/3 - ext_scan buf_size against event buffer length
  3/3 - command response size against response skb length

All three were introduced with the driver in 73b01e57ed3e ("wifi: nxp:
add nxpwifi driver for IW61x").

Tristan Madani (3):
  wifi: nxpwifi: validate HE capability TLV length in firmware response
  wifi: nxpwifi: validate ext_scan buf_size against event buffer length
  wifi: nxpwifi: validate command response size against buffer length

 drivers/net/wireless/nxp/nxpwifi/11ax.c   |  3 +++
 drivers/net/wireless/nxp/nxpwifi/scan.c   |  9 +++++++++
 drivers/net/wireless/nxp/nxpwifi/cmdevt.c | 14 ++++++++++++++
 3 files changed, 26 insertions(+)

-- 
2.47.3
