Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.98
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792516253;
	b=mQuixAYLkQjvYJ5zghbxnV0RUXJSy8rKZhW0UkWDMWbvkzZdm7vnhpiRLHXZCDxcsian
	 qne0YXUzxYmfMXKwZg3pjZG9kOgO3jnh6DKJ2qiiVSSAZJ000gRVher50DB3rsItf/1cv
	 6xM6faGJ/Z8dLVaGWyXhJ6+psYAkFgF381qhQWjwIW6KXzexyu3jd0kvkEXIyRpxosgOF
	 g79t+tVEBIbPSyblxH7CfYz7H5kLfIqgfJQZVTvSupZ+Fz38fLRjJaYCGZwtW1VLLAoYI
	 htyQYkMmvU5M+QWRvJaIJlsSPinNis6R+yfN5t2lJK0B7O8GXhdKeF9t8+YQGeWAH7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792516253;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:X-Relaying-Domain:
	 X-CFilter-Loop:Received:DKIM-Signature:X-Forwarded-Encrypted:
	 X-Received:X-Received:Received:From:To:CC:Date:Message-ID:In-Reply-To:
	 References:User-Agent:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:X-DetectorID-Processed;
	bh=VJqkIiPNVDYg99+7WtjqOTUKFy/SQG4E1Zt5xkilM1s=;
	b=VwZEFa/9nl0OIhvWds5NTOQrtxMc/yWKh2g3MpEoG6PqjYdwHyJd9j8TqqqAa7zlUh1U
	 aI/MVz7bssqe8rEHmldOEzxD/U/wjiUpoWp4LY9g3TgHnjW8BjQ3zOFc9AJ7dnv4XGa/D
	 SPy4PJLJAEaK6tn9l3X0EXhyiRMB2FRl+lgiZx+yRjODxwkOToeDfKGJE9WKyimn3cZha
	 wsg9cB3qLeEO3QdZIoujn3GMlJiv5bkcHWh1kO3X3V+AKVFn73mYyoKQYF9mwLevr1wjV
	 +bPgpWq9NfNY0kseDAZDegEOTu7E34A6O8V0obb4vvrhzmZsLtJgU7PCnSfeNKj8kRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=broadcom.com;
	spf=fail smtp.mailfrom=broadcom.com;
	dkim=pass header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FfFkyGYe;
	arc=none smtp.remote-ip=209.85.216.98
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DAC606A31D
	for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 17:10:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00DAC606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=FfFkyGYe
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3ac77270fbfso2063400a91.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 10:10:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792516252; x=1793121052;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VJqkIiPNVDYg99+7WtjqOTUKFy/SQG4E1Zt5xkilM1s=;
        b=d7y/XMNlGgJUb/zmJJ5cZjBtV23CMKkk4grKbfrkFL/NFTIbHAejVdvmDfcNemkZm+
         k334jqm+Xqkr/EIuKerkEzqgRkliWbaaFLdtA2kCFW6HB16GVI9fAOk831VeOJ38LYub
         nRnsKDFSFWahFXMn+2JCI6wdxOJ6TkCZqVlWPSFOmzZKOGxz8puQDWs+AQvpfjDjsTud
         JdpFjZQCpO8fPnwtPsYNxL9A9arEroq5leRw0gX4nLwDHTDDyvfKu40zoP7yoQNnK8uX
         QUhr80pML2UePC5ffN4I5LBGKiH/tArlt8/BzIHRWgrvTpXjN0BGqoBUYKKPnZVfX3b4
         +kPg==
X-Forwarded-Encrypted: i=1; AKwUvBzf6Yp+DhKq9bdL1ZOkSoTB0CblRZ1AVj0ryB9hGpChdE4HzBG/Yd12w59KKT1VD/kRSeRPslalTmhOQFPreg==@vger.kernel.org
X-Gm-Message-State: AFq9FYL+sTnYvm1KrAzl+x0zvw/D1H/PnL4XY2SyaCEyIC10K0bk4FwD
	wi2IRBx5RLdQZvTs3yluS2dlXGxG1z91vOd7r8VQmLKKKH7yIcX1JdTGA7axE5s4+YGVCc69HEK
	O3/XUd7d3s2J+9L3e5xeU2tmCRYIW1sMxgM5872Lj0XYOUiY5quaz84yeTdkULdJ40Y3fKakwf4
	E0N+e8S4d9M0N5VltdzYKCP7Lbz6RgNbLqBi9zZm0oXJPyO0B0zX9pk1bmQYzxjCal5f87MNeDJ
	AnNV9sCTEdYZxGTViFHkahKAw==
X-Gm-Gg: AYBFou3YvA/JR6T1RIHVNet2Cmn9fjN+4e7EIW/qC68+7nJXzsNhtVs1XlJDKUCc0cz
	kVsadfvwAai2jYT2OMdHvGiKSdYWOBU8MTISIyFqtdZ524pco2EXtumrmIXcNIvOIZIEfKBeVXR
	3cBL6lgrMxGKomYJ47vVrvG9p6UIcs8mUEdQozdOfRr0mF1Tnq5DgqnNv4WhOOgITrVEUVZAXKh
	pL6jejbzMrXkmlDSPjvKfPjuo0a+9RzHksscfyOuRrjG5Ygo1o8ioeJY/b7TMHBnEuC6F9qsv3P
	zfh7UYBxumFbtcWVRh1JTh1r9Fh/6Kn49R8+YVwstTbs+dJrwdqhLmVtAWQjS0RlxYxA3oGkuN4
	WNaAObEljRwI0PJ6rv9j3OuDwSteOiORzUdExWI5g4o737Gj2qSPTeCpCBTFYBli+BuzAe325dG
	pyC30+y1tQ3cymPmhUpMD4LUMhvSHpn1++jijnLF0gqA==
X-Received: by 2002:a17:90b:5784:b0:3ad:818f:3da2 with SMTP id 98e67ed59e1d1-3ad818f400cmr191227a91.63.1792516252161;
        Tue, 20 Oct 2026 10:10:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ad8235e7c5sm95203a91.6.2026.10.20.10.10.51
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Oct 2026 10:10:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-917a7c17166so74474926d6.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2026 10:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1792516251; x=1793121051; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VJqkIiPNVDYg99+7WtjqOTUKFy/SQG4E1Zt5xkilM1s=;
        b=FfFkyGYeNh8NDOWMMRF9OUdYUtWCgjUEcWhgzyFl245kBo+btyXy5DuI8hZEb/Aj4k
         STM9cYu0+QfGMKNdIZBWKgsDFCNdIk20k95rLQbCGr0Kha9xyNPmzsyq+SlnEIWnQEqS
         A2Yt6pn6Sor+SHAlhSW7sYixaTWsBB3p3M4E8=
X-Forwarded-Encrypted: i=1; AKwUvBxD5WpChPtB5rx3orSDyk0wXAxet47lL7fcQXoIQiJ4fQacttyP8u+QV7u5gSS/9tr5zSkPu1/AF9pb26d4Pw==@vger.kernel.org
X-Received: by 2002:a05:6214:250d:b0:914:51b1:6161 with SMTP id 6a1803df08f44-91bdf0df624mr198193716d6.30.1792516250828;
        Tue, 20 Oct 2026 10:10:50 -0700 (PDT)
X-Received: by 2002:a05:6214:250d:b0:914:51b1:6161 with SMTP id 6a1803df08f44-91bdf0df624mr198193046d6.30.1792516250202;
        Tue, 20 Oct 2026 10:10:50 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c10c48c49sm2815656d6.41.2026.10.20.10.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 10:10:49 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Perlow <jperlow@gmail.com>, <aditya.garg@linux.dev>, <baolu.lu@linux.intel.com>, <dwmw2@infradead.org>
CC: <iommu@lists.linux.dev>, <bhelgaas@google.com>, <linux-pci@vger.kernel.org>, <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <regressions@lists.linux.dev>, <regressions@leemhuis.info>
Date: Tue, 20 Oct 2026 19:10:46 +0200
Message-ID: <1a15a4b49f0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <D0E6473C-3234-4367-83E7-B85C022B0F1A@gmail.com>
References: <D0E6473C-3234-4367-83E7-B85C022B0F1A@gmail.com>
User-Agent: AquaMail/2.7.0 (build: 200700061)
Subject: Re: [REGRESSION] intel-iommu/brcmfmac DMAR fault on Broadcom PCIe wifi, v7.3-rc7 -> v7.3 final -- candidate mechanism and proposed fix path
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 20 oktober 2026 18:02:30 schreef Jason Perlow <jperlow@gmail.com>:

> NOTE: an earlier report on this bug from us bounced off one of these lists 
> due to HTML/multipart formatting from the mail client used -- apologies, 
> switching clients. This mail includes the full original report plus a 
> follow-up, merged into one self-contained report since the original never 
> reached anyone.
>
> === ORIGINAL REPORT ===
>
> Hardware: Intel CoffeeLake-H platforms, various. The affected device is a 
> Broadcom BCM4364 802.11ac PCIe wifi adapter (14e4:4464) at 0000:05:00.0 on 
> an Apple MacBookPro16,1 (T2 Mac). Aditya, including you directly since this 
> is T2 hardware; copying iommu/pci/wireless because the fault signature and 
> the fact that it reproduces on only one of five tested machines (at the 
> time of the original report -- see follow-up below, that has since changed) 
> looked like it needed eyes on the core IOMMU/PCI path, not the driver.

[...]

> THE ONE ANOMALY WE CAN'T YET EXPLAIN
>
> Despite the last two items above being unchanged, the actual generated 
> .config has CONFIG_INTEL_IOMMU_DEFAULT_ON unset after make olddefconfig 
> against the rc7 source tree, but =y after the same process against the 
> final source tree, even though our template explicitly answers "# 
> CONFIG_INTEL_IOMMU_DEFAULT_ON is not set" in both cases. Our working theory 
> is that some other symbol started selecting/implying INTEL_IOMMU_DEFAULT_ON 
> between rc7 and final -- which would override an explicitly-seeded "not 
> set" answer during olddefconfig resolution -- but we have not identified 
> which one yet.

Simply run make menuconfig and it should be able to tell you how it is 
selected.

Regards,
Arend>


