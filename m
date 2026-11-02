Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793649821;
	b=3ejvPO83pujH6lWXDKAvWAr3fUiDDq1H5BdFd3KjxCIXAbHWdLmZeKsmPfgaz5FP/KQK
	 PX9AVRVtmaJaghZxNRtoPyVIyAPETJbtpzXe45F2zz84NqtpoSgNQoWADIYXuOVQxj2Mt
	 mqDcgd0i83r4sXORBUgQ0GYmIr4OWiTd2vk0cEkFIAHtd4zhnfHVDKgFZyWOwlFjDdcX7
	 FpvyCeiIgXF55lSO/CTgq6cUttV7fvc//j9i8MXbj26ap8KijM0aFSVA1t3Ib0qSnnKZ4
	 Lvo2VPZH8xrpslfySZYk4LgcRQblILx20Ao264J/wtkoy6OIINrLj3nWlIF5LIk5N7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793649821;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=qDmRuiAok4BDh7Ywtb7KXFZfCX8FiUeWMjnaMHr+TlM=;
	b=neeos6N2w3BgW1t/Y5Bziu1qKPQGc6Ki8pLCf1MrzqYlke4UsATEu2ylSI9SHW6gX1MJ
	 JLvr7eqWOA44+e4S1xyq4xn5z7SBq2zl6VuDdNQT1bMK4FAl+z5SABXPddiCMKQrhk0Tp
	 5jaCnYxSHaB8HkUGKGxSpTQyQmTabMMeNgGn3ZI0kFWLLKxq0yaoRMG6iD44nZV5eTJY2
	 aveuU+rcsqTHxdSTXYQ+LrkeNzx/w1TGBdj7F9NbvxET9kKdXpz8O/pJKXYMo0BxE5jBD
	 daD5PSmCsvItlPL7IEgsR1rv1I85eXFKaVKcVSvT/SBDCowIHnrUvxVjHCAA1sGR3fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Iy4Fg+BY;
	arc=none smtp.remote-ip=209.85.221.46
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1077606A329
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 20:03:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1077606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Iy4Fg+BY
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48e0d1c095dso1776803f8f.1
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 12:03:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793649819; x=1794254619; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=qDmRuiAok4BDh7Ywtb7KXFZfCX8FiUeWMjnaMHr+TlM=;
        b=Iy4Fg+BYUaijtdcG+0RGKvA4N02PAmy7Ct3XpBbFGTBlXQfUSoHEgF/hWqWLyPugRf
         cq/HRlLOw2dihG0EeV9jWTSryDT8wCOQSyBpcpqLwqgP5p6rpWgOKVfZKUqW0gx68EZQ
         SVKAfCT+LIzEKT+GV0HPGIx7mtZn8LZhhlwEFs7U25esXNfzKvbfHZkSt9pOysY8Dagi
         mM+cvQJaJfoIzWjBcJZKCEZyC11dU2GgZD9tRG5hNX6mB3uNsKoT7ik4EHM2TbP2mOdM
         FboNv37N2PY5Nmwkq+4MKBZiScZ1Zd6/qZ81zvuTCohBgNXAdV3UR5rqkh0suXxBaJgt
         3mnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793649819; x=1794254619;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qDmRuiAok4BDh7Ywtb7KXFZfCX8FiUeWMjnaMHr+TlM=;
        b=vGD3Fpx1lOhdvKLRKLLoOqBYeut0Z0ZP/eVoQn0mCeAcHw7k0lX61DaAm7wf7lqmz5
         GZ77CFxzd9mOt7p8xezeMuUJUmm5CR+AHWzAJ6im5nHUwgGn+/sYp1eDI3qOd/qlW+e3
         bVsz/lY7QIFCtve81uQ0skDtCevoGkHVOAKi3OmZ4zsMNcpRP4CZhhM7IIwlT98vpB2e
         v4+hlO9rrHAVisoSaymi1uA34FPx2b+bOzT8mveRCCqtHA0dVyqh4SV9OHpr+HUVm+Lo
         xWUN0OzUAmjnpey8++IDbuLPrqT6sGFRCQ8fOc5RAywkRU/EqQkl+MP44Sf0PDUUee62
         5MfA==
X-Gm-Message-State: APuU4Z8IkBIXV109aN/1xHCoSHg/dGPD6aFBNTYUUJg6JIlb329A8exm
	B0+rV+ek8uUAyw0XeEd2fa2CrTvnQXbxMaAuOwb38Xv3lPHsE/DC6YLJ
X-Gm-Gg: AYBFou2RdrlOEZ5Qyu1N8iZIYXsNtwEbb/VLdPy4+63jThQ5MUE0IjR4LHV3tfU03H1
	7EekY2omaB89guekL/UzVbwxPjZzu6hR6GwT1x3fehDlBkX2bDBFrfUvAde35z+VJXyQI6WtDDW
	LzNlS+eBCGRGKrnaIvLFxy665h+pjbGlrp3QynmmfwyPuo0ReEbMjymNL3zJre+yTzUm2pzcoY0
	rIdReXR5bgxYEfG8LKH06Bkr6UomeUXu07jhdPTWV02nfCX5e66h4gYvt0DSkt0XRKQMyELgLBk
	yUBQOUrrEmXSnf/eETH25N1OjtOQ/P97SlVk8msASWUXzz+T6U0wELiiu6kV6+o8JAsT2zjYEVC
	v0Xwh4IhhsR4U+wITaGh54DLNYnZXQOiKvv32GNkBTyDquGfVwWkq7mIeRX/gAsJC0EA3u3H8g3
	pkgEwft0b3g48CefAgDC5V+TjXQQei+lCX43LhrFePSHuoPiRzwx0fELsJW8FaGm/SKXSvf70nT
	/z/K3033TIuNej0vUscnP+KSPDQjtFw6L7UzueOs1GisJmE3x/pxTLuXjDqeHrT0KC1iRtMoBve
	bze5Zf4MTdfEazQKK7QTLn/NeddUai/6U96FJuZYP0DoubKHAaSCXQXnLaBqBaYUKo9fYPkWvSf
	rUYPt+2OyD/tnJGr1oWf1MkvQHDYFfd2PK3XP00rJXgS5OoF0QjKAhXK0vLMKCmCveuMmnMVmH2
	57/cffrgpo6ZY=
X-Received: by 2002:a05:6000:46c5:b0:48d:fd4d:7fbe with SMTP id ffacd0b85a97d-48e6e2bdf92mr17382937f8f.2.1793649819000;
        Mon, 02 Nov 2026 12:03:39 -0800 (PST)
Received: from ADM-D9YH122JTV.home.lan (158-199.dsl.iskon.hr. [89.164.158.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b9b54dsm21191574f8f.47.2026.11.02.12.03.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Nov 2026 12:03:37 -0800 (PST)
From: Goran Sustek <gsustek@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Nazar Mokrynskyi <nazar@mokrynskyi.com>
Subject: [PATCH ath-next v2 0/2] wifi: ath12k: accept what newer QCN9274 firmware requests at boot
Date: Mon,  2 Nov 2026 21:02:33 +0100
Message-ID: <20261102200235.48973-1-gsustek@gmail.com>
X-Mailer: git-send-email 2.56.0
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

With QCN9274 firmware WLAN.WBE.1.6-01243 (the newest in
ath12k-firmware) the driver logs three warnings at every boot:

  ath12k_wifi7_pci 0000:06:00.0: memory type 10 not supported
  ath12k_wifi7_pci 0000:06:00.0: Invalid module id 2
  ath12k_wifi7_pci 0000:06:00.0: failed to parse tlv -22

The firmware requests the AFC memory region (QMI memory type 10) and
advertises direct buffer rings for modules 2 (CV upload) and 3 (Wi-Fi
radar), all defined in Qualcomm's interface headers but not known to
the driver.

Patch 1 answers the AFC region request with size 0, so that the
firmware sees no AFC region instead of one at bus address 0. Patch 2
makes the DMA ring capability parser skip unknown module IDs instead
of aborting the event, and stores the accepted entries contiguously.

Tested on two QCN9274 hw2.0 PCI boards (AP MLD on 5 + 6 GHz, and on
5 + 2.4 GHz) with the series on top of v7.3.1: all three warnings are
gone, the firmware reaches firmware ready, all links come up and serve
clients, and there is no firmware crash, call trace or IOMMU fault.

Changes in v2:
- Patch 1: do not allocate the AFC region, because ath12k does not
  support AFC. Answer the request with size 0 instead, and log at
  debug level. New subject. (Rameshkumar Sundaram)
- Dropped v1 patch 3 ("name direct buffer ring modules 2 and 3").
  ath12k has no user for these rings, and patch 2 alone removes the
  warnings (tested on both boards). The firmware uses such a ring only
  after the host configures it, so a host that does not implement the
  feature loses nothing by skipping the entry.
- Patch 2: commit message reworded and code comment corrected; credit
  Nazar's earlier version and Jeff's suggestion from its review.
- Rebased on ath-next a3ddbb457687.

v1: https://lore.kernel.org/r/20261030220824.915760-1-gsustek@gmail.com

Goran Sustek (2):
  wifi: ath12k: report no AFC memory region to firmware
  wifi: ath12k: skip unknown direct buffer ring module IDs

 drivers/net/wireless/ath/ath12k/qmi.c | 12 ++++++++
 drivers/net/wireless/ath/ath12k/qmi.h |  1 +
 drivers/net/wireless/ath/ath12k/wmi.c | 43 +++++++++++++++++----------
 3 files changed, 41 insertions(+), 15 deletions(-)


base-commit: a3ddbb45768717b5c9f923489387cf55c838d1ad
-- 
2.56.0

