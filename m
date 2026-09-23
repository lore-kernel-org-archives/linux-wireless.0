Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3DF57D233
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.122
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790196496; cv=none; b=aWBNfDWz+b85B8Az8yV4anr9XDEYd4oVkgMJke1GylY63BCUMk/MO+im5x9s2VC6cf6sfyeaynzS0o3coV/FyKZrdKsVvbCWp4Cetg4He3/icELFTfLun8Q0n1+61Evf8a84mnDvlp0rmJdnXEElDnLy2teG77ZaOng+qWCEu6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790196496; c=relaxed/simple;
	bh=/JJF6ssyxAQdmL0bSTx1Ono3iYU/qejhw/WQLlUJjoo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FuQdUy/kar9Ah+gtKDHzpYeoTCrxDngtqrOmvLuHhfsWD+DtsBSyDzIcz2/hal7OcVBeu25WexCchSpJ9i3CHLIRtF9wAUq1aXag4LtZJBq7Vtw+EpCLz5gRRf3zVLjloUgR59RP8go1RmDIsLLBoaT+AuIB8+V3KeCM3WGzEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b=cVHavJqo; arc=none smtp.client-ip=185.125.188.122
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=canonical.com header.i=@canonical.com header.b="cVHavJqo"
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 076A33F1ED
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 20:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1790196177;
	bh=1lsBUs9NSNq+2CCd0RHpAdGjAy6PPuORFqVcIIm1nuk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=cVHavJqoeUvPYyz/+c9am5+bg0tyvwbVPoCoS7SFk+Ez8eUquVjppMSrsnB+OAnJ9
	 rYQbXm6f3RBWjTVK7mac8bSTQDvswTrQywLVDDSSxmkaLolAImHHGrSdqjC3rHVncb
	 //xUxmWfifg5EET2IJ1WHpFnIgZYd3Ip6RoGKmfIsMsaDlr8/HkZcdUITiBZAA+h22
	 AqGw9KNRkZopJOoeCziWgLXxYmylXhAUb//lOfgM7v+dJ2prMqZK125TdfsnrcZwqI
	 5915RudZYhTEMbvY1xYzo6KQ/7hypJaFnYmMbbUrBoHQi744E2iEQhQfwJq93wIRW7
	 Qbp60nisj7Ub74zeMDJdPL2+LdIsGKMGb8tHxJyRi5+1iJ2WavZ9Azp2vbgVLWwSXK
	 WWEtEnNC7RV5d2zc1viYm0o1pF41Eps7C6S81ye6UgcLaghemDdblI/k5uM2qs0b1o
	 rfj/znp19C0mmI3PKSfRs6xz8XBO0tbJX3GdtXsyZHqXm38zofyLCa5Al6tFhIOntC
	 NF8t7WbTYYt9jQokQPMWjr+5pz4LJ96c7XHW7iXLl0mkVX8vYEK0AGUqW2D+ovNOsP
	 MCoZIjjx91aAVr5BWlcwQ5366nNegFKanSAGj+RRNAxECFlUlCDD/EeGETrtm2CuYj
	 q/6QyDsoBvE04JxO/yWu/v4U=
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-c29959eb71fso135326366b.1
        for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 13:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790196176; x=1790800976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1lsBUs9NSNq+2CCd0RHpAdGjAy6PPuORFqVcIIm1nuk=;
        b=mrTJrsjo71lGjl8rfUia0YGdudAcI/bRMzy2vqk8LAf19GY8BzpSBRh46GhfSEnbfm
         GoNfUOBO16Kks/jsFP0jZqmv4wu1AdUsa4rArfdvfK9ndMz1S+VnAE/Unde5rsPXa8j3
         S922FAA99dtbaxDtDykigqEZ0gtN+gwkDmO4EKI1yk+Dl473JtnJ5r/UfEfhNiporS5d
         FcmhMTYODGX/lJFdJnZI6GE7RQYZbWXLzQ87KxdusvZAG6AyJcV4CQ1HJYJNqCFtzkEr
         ASSBddzOCCONuQfBIF1HpgGwVZLb4crHBwlc+xGm+yOXsZxEn6ksOzMk4VFhs0mkTsok
         at0g==
X-Gm-Message-State: AFuF++kQwLnOYK8Nj1yarcu29CVx2jUrNTbR1sSBVywj+7VLydeY1kOw
	bA9cxY2UWC1jY9OJmdmdQ4rc6halqB94cR5QkDP6gMhmEaHLaPM2YFhnNorbLcqGK8eyOT1wOok
	ymlG/H5HK35r1Nyicnsuo+1UnbVkOQ42dYhlmJIEshYwT43+fNMhW6csbF0ulkI7gpo9qGdenHW
	z5zbO6vSrh
X-Gm-Gg: AYBFou2myaAaxuKHLb3hp5mZN99uy3Lj6D5rVn4+gR0mSpi5QSsFLSDvSULkOd/og78
	DrpyzZb311rCQAn5StaF/D+5bmegW4qibsM5dBfOaGnJ3Fa55m6xUlSlXeXy4K6JChyI+2UKOUy
	ZnBIoOYjJes6NrTbpwLf10rMUpxvtwzu1vpnpxOEfCcJWmyWM/bqbRY6sbSQ8UkDv1imhnNEarB
	IDAxpHE22mdoA2IHsFb6zRMdhoG7ZvyfE80tf8e2NkHtqkqBNISQktZvLkE+yqTDOe9xW5MtM++
	T1KUcTXSnTQR4zeGkLCz1HH+kt1YSc26XbkHC8u3z/fyXB7tqnrnGJ0vtmqGzp41MThLHLkKhFq
	ssWmaytm38JF5eqH7V89cMOr0NrNeDc7Oc9pzkPp82cWySrq2sieUpbgKT0OEyJpUE8TF3ttiLl
	YDk0nWjUU=
X-Received: by 2002:a17:907:968c:b0:c29:4b08:79d with SMTP id a640c23a62f3a-c2ac237a45bmr26771666b.26.1790196176617;
        Wed, 23 Sep 2026 13:42:56 -0700 (PDT)
X-Received: by 2002:a17:907:968c:b0:c29:4b08:79d with SMTP id a640c23a62f3a-c2ac237a45bmr26770966b.26.1790196176365;
        Wed, 23 Sep 2026 13:42:56 -0700 (PDT)
Received: from deep-thought.gnur.de (ip-095-089-205-015.vkd78.pools.vodafone-ip.de. [95.89.205.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2aae6a4a00sm185431466b.46.2026.09.23.13.42.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 13:42:55 -0700 (PDT)
From: Benjamin Drung <benjamin.drung@canonical.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Matthias Brugger <mbrugger@suse.com>,
	Benjamin Drung <benjamin.drung@canonical.com>
Subject: [PATCH 0/2] brcmfmac: firmware: Add missing clm_blob firmware files
Date: Wed, 23 Sep 2026 22:37:37 +0200
Message-ID: <20260923203739.2560527-1-benjamin.drung@canonical.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

I noticed that these firmware files were missing inside the initrd when
including the brcmfmac kernel module:

```
/usr/lib/firmware/brcm/brcmfmac43436-sdio.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43430-sdio.raspberrypi,3-model-b.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43430b0-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43436-sdio.raspberrypi,model-zero-2-w.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-a-plus.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,3-model-b-plus.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-compute-module.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,4-model-b.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-compute-module.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,5-model-b.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43455-sdio.raspberrypi,500.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,4-compute-module.clm_blob.zst
/usr/lib/firmware/brcm/brcmfmac43456-sdio.raspberrypi,400.clm_blob.zst
```

These changes should be backported to the stable kernel releases as
well.

Benjamin Drung (2):
  wifi: brcmfmac: Add per-board clm_blob firmware binaries
  wifi: brcmfmac: Add clm_blob firmware for brcmfmac43456-sdio

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.53.0

