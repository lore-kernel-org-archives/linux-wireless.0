Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8667539CD1B
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416264; cv=none; b=Sh+9rcDMD0IGSPMfrzu6mMxmnS9/q7HVzBRcP/com6bUd29zUB2/8+uBpV8Q9WWOKhbbIAUAofkS3c0yWItp0ZYr78YQDJu/QgKmAlricnm7VKKUoGyzzrRNTDn7bIO0o/Z6R/uGnpn1dWSomE0EeQWWkV1+T/RLhJRTtWY4NEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416264; c=relaxed/simple;
	bh=oDNnoTLAG3z5e8XehABOObZ1Jm57MalG4FqBQTsd5I4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBRVliE8NGIyyj4v2NpB/mEqYDusg7uelOKHHxeWKPrRXKdVu9b7EDZUrFSHCDdyR5OudOeFfCbfXZyUmtPrCWuP0IIy9nWSQlJMXLRyOhDgTp9JGvXAbyWWfNBEejNn2Lw+XJCHyEUq5I6Q8gRcn2PkSxJyYgjYDxntvw0ZVT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hv2B7kf4; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hv2B7kf4"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-80587a80992so1688297a34.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416262; x=1790021062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ptl2eI5BrtYzmF7s/oP2Y6D2qarZoa2Eb/4pwhgjoQc=;
        b=nW7fy0haX0g3vypASf2XNadulsPg4I10WXAMYp+e4dYH4WA9mc/ZcvuypMwR+9xrYt
         my1gv+NVYl/OVcKCH/rwBRK62oiFoQp0eMSZvqt5ky5+000uixTqLzVVwNBazdjdHFk6
         QD4oAYp6hGxVjT+Dzf1zc5XLwMUI1WkoyY3zKijwBFGZOubAtkA4YdoF8GkojRP7DNlf
         PI51XZ4uUgcU3Os0fqqAeR+zxWO536BqCfucnfZ9cfazHdfmmNdJpNo4ZW8uD0J2GSbJ
         THfp6YZlIahAq1cvTudsdpRzm52cXO2RtPbYrdZrUHUrHpY82ExDM6+f0AVCArJ0Zl8i
         Baxg==
X-Gm-Message-State: AFuF++lnOayWjqGr55g5pAS983DYKGSjLf2JaiedbMvDOUEPF2SDZElg
	CBRZREB2bY71Oc3h0CKcoWiU7dI8LfYgWc2x6UcMvuuYWvDLuigWYD1EywZ0NmNYcz8HLVh2rkA
	dz6ZK8rLy/S40VaSlVkVR2cOCyHcd8jeEZwZMHZaXIFPpfNeAl4uEXFGHMuB7k5WNcUjpWDJKWf
	l2SveX6bSTxrcOP9TJLN4SLcGzo6T0hoUksJznECdFJ1Fz8l0GG2z5E5bL0qq4QYtCtSEvmkI4B
	LnlBhb40ydcNqQayMYOKFV0Ktia
X-Gm-Gg: AYBFou39RBymFnH7SGOZs3DEXMNDpQhoeQdOvfSnoJrC5vdiTugAEC3LWD0eo+BovQV
	oIKWt19zKNyyYdMacIYaPc9saV6No1pyIrMq9wLhs1OkIxadmmuN8RtMH1NOPSiMT7XYAln5aOl
	RxBR8uDEXmfDvE3XnkfCuF7JFZdbKXE/i6eWFdZWuL9EI4Hc/+oBUBuyz/qzAS8eKbwSMRWgYD8
	LRF/TF5cQRnwIBARiJ/8ggEUXa+nmI2r6EETgGsbMovHUV4Qhr9yZMNE1dauFrIZT44JFn3XrYD
	0WRCRsbbYbIeGfCm//fhCyW69P+V4j1rIIvGkissvBTc3trtUKfcXiT/Ky27/Z3Eby46sy2PSQv
	F7KihJhGEt5VUxByPafxWvc/GyfdYF1FPPd2LezGmO4tTztic1LP/Vi20tyJZeI8BPkh78GRTnR
	YgngXUtMezirEf9GC5t7QDug/8UsaNPQVeAh0Mhts=
X-Received: by 2002:a05:6830:700f:b0:805:bf8b:9523 with SMTP id 46e09a7af769-8089798f8d0mr2594388a34.10.1789416262474;
        Mon, 14 Sep 2026 13:04:22 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-29.dlp.protect.broadcom.com. [144.49.247.29])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-803f56cc0c4sm6417170a34.4.2026.09.14.13.04.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:22 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90cddf4f59eso75995956d6.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416261; x=1790021061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ptl2eI5BrtYzmF7s/oP2Y6D2qarZoa2Eb/4pwhgjoQc=;
        b=hv2B7kf4vm/q/KsVBLWH8Xo85yRZAB2wpRvkqbPY/YGpbamwsvQc1rGL75a7BB8Avv
         BQN15POTwlgh+wBMX2WXQ1Tw0CrX6BWKuu2zq22b/cmEz0nPFYIO/kOPAb11E/doLRsr
         +6qvppUJa+X52nEP6nibupHkXJntVD63fwl8E=
X-Received: by 2002:a05:6214:5f0a:b0:8fd:d5a7:f970 with SMTP id 6a1803df08f44-9122e4ff410mr64196976d6.11.1789416261391;
        Mon, 14 Sep 2026 13:04:21 -0700 (PDT)
X-Received: by 2002:a05:6214:5f0a:b0:8fd:d5a7:f970 with SMTP id 6a1803df08f44-9122e4ff410mr64195776d6.11.1789416260709;
        Mon, 14 Sep 2026 13:04:20 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm103068516d6.22.2026.09.14.13.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:20 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	Darren Li <hsin-hung.li@cypress.com>,
	Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>,
	Chi-hsien Lin <chi-hsien.lin@cypress.com>,
	Carella Chen <carella.chen@infineon.com>,
	Shelley Yang <shelley.yang@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v6 3/5] wifi: brcmfmac: add PMK programming for firmware roaming offload
Date: Mon, 14 Sep 2026 22:04:13 +0200
Message-ID: <20260914200417.1744264-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911065656.1269623-4-Jason.Huang2@infineon.com>
References: <20260911065656.1269623-4-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 11 Sep 2026 14:56:54 +0800, Jason Huang wrote:
> From: Darren Li <hsin-hung.li@cypress.com>
> 
> FT and OKC roaming offload need PMK material in firmware even when

[...]

> For FT-PSK with firmware supplicant support, keep the profile in the
> PSK firmware-supplicant state.
> 
> Assisted-by: GitHub-Copilot-CLI:gpt-5.5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Darren Li <hsin-hung.li@cypress.com>
> Signed-off-by: Chung-Hsien Hsu <Chung-Hsien.Hsu@infineon.com>
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> Co-developed-by: Carella Chen <carella.chen@infineon.com>
> Signed-off-by: Carella Chen <carella.chen@infineon.com>
> Co-developed-by: Shelley Yang <shelley.yang@infineon.com>
> Signed-off-by: Shelley Yang <shelley.yang@infineon.com>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++--------
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h |  5 ++++-
>  2 files changed, 52 insertions(+), 9 deletions(-)
