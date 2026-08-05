Received: from mail-pl1-f226.google.com (mail-pl1-f226.google.com [209.85.214.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA16723EAB3
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 05:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785908818; cv=none; b=uJnngAbBC4DBEg1HmFa3J8FUBjftQfxQeixlCBjQWMX1cUQfLo3xrT18b+8KifzIitu9tXErZvmmvdhH1w+ko+LHyaZLZnufwhm9MZEqap4qWttvgWiMscZ10UZx19G+ZNXl2TtLbE+r4sSz3bK8gHzNj2VbJ6uisLvBFB9/Cuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785908818; c=relaxed/simple;
	bh=3R24kW9XBknBCDrCJn5tZVJzgixI5XEO2i1Ce+QevZ0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=QY4N71zRX7ejh6Rs0Q7mYWH9qllV4puKtsyhyH9xZcGmVepqcubYRYF9mCTEN/5f0lIiKOeOVqGoyx5lhW1FjjVRCPBtuS3txNIbUyyN/lp/L01in8aKhnN1WDgmRUGGWwM+da+PkjumBvD4RCpxv6o+ekhNt0aQHuBoZjqH7FI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=SQXMLK5j; arc=none smtp.client-ip=209.85.214.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="SQXMLK5j"
Received: by mail-pl1-f226.google.com with SMTP id d9443c01a7336-2cc7e86e7aeso6522445ad.2
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 22:46:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785908816; x=1786513616;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5BpLCfKAaXqi0duuQcGbfyu/XNCL8TH6OsPjIxhG+2w=;
        b=qwWnlqFEkxRJUipsQjQvN7pWUhT0+RQgLwREiJl4JCRuc627kZF58CtYpxTAeDVeHk
         r/ZfyKQ8M0FPLtL3AG7e7/vcrxPRd6hu3+1N2ge0mVUlY6gJjfNQ7lkfO84xOdlrgsZd
         GUmd4V2ZziTlmBAjt4S16abhvFeFwv6u8WxS5Ib97UyfDAzfooi5RT1EZ1rDk/HggjoD
         C1oJePiggO+tYj2sc5D2ZUIMwCPuvPRx0J1GXJol4p/9Zs+zBx2vd1iI37urlaj/eaQM
         SjyjnO5pgdLRezKEwNH4Iv8BuevxFjy+MHt9bhJgU5igYX0sJfcw0Y8WAL9pu11j+MLw
         859Q==
X-Forwarded-Encrypted: i=1; AHgh+RrTnEtLXGnlmSAY08IQWg/0dUnCu04pUY0GqlYtn1SWzTLVWdjeFM+XisKkArEQ46u4diWt5yfJyNveR1Sw/g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwIqwtsV+y3njTVee8uvEMMIZ/SSqpAk8rE7Tgtwj/6T5eG4Z0Y
	PkkEsoNDp636KbhZLWgwfPZiLt/v/3JHBce1Itd3Yp0revuy4ti8DeeSs6Yy6vtbxpSUKlXIPK+
	Nw/7VshHlDU7drJ9EntF56eULKkgQqhMLoJKnkLJK5YW819GHkn7QMj2lZ/VaHEV1XShymD/dM7
	Ca8V2yCkZDUhe3J+DQ5JkDsdKSgRiGZH9T3gk9MLJ15beosVExTdTTFfdb5183zymleQ80S9yFQ
	kRMjnhn7XK0SwIZOvLb9bjKEJWD
X-Gm-Gg: AR+sD10JwToc7yuJI+eDiKGz43aq7aAmIybXZMHsbuNvhshL8kEsRjls9wxgHJGCLNG
	SV0gU/dNSG71AVjcVpUvDPLBCyU4xqXxOIX7MTHH+T3ywrhwlDMH3qPhshTXDgAzrsm3u4+Ms94
	15sZtpyXkeubM63td1olNKSk2RIInlN4HH25YZEkdBZEMJFTDCLhoHQyAn3ukD7vXXVtveJWp8O
	sBaDsmJa05BQplm1LjL/hbWTWJPqMH1T4KLkSHW/vKGLrNO9UFy/HR3fN0eLkxbpMggXe2MAfTC
	mFnMm7u2bLJ4fVnHBJQE01aGZK6L9V+NvnmTvLReRXo4pTiCj/UPjzdCJppApayt2TylgY2dJz0
	zKuEl7aR4FpKmavXQHJEkPdt9/dHBJ1db8TKlYsBQF+2s2rxWr1JcLf0n7rwEZO+ULZoY1rB6V5
	16tdMfx15/NXgBmPBPnU++id3eMVYhVr+CSsBGsZQ=
X-Received: by 2002:a17:90b:1d52:b0:38f:23d6:b4ad with SMTP id 98e67ed59e1d1-3903c5433damr4559448a91.8.1785908815853;
        Tue, 04 Aug 2026 22:46:55 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39039289855sm508740a91.5.2026.08.04.22.46.55
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Aug 2026 22:46:55 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so780664a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 22:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785908814; x=1786513614; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5BpLCfKAaXqi0duuQcGbfyu/XNCL8TH6OsPjIxhG+2w=;
        b=SQXMLK5j5xhVzY8pRsA0Zf54CbRZz85GiS5q1dWy7oQcwRkPktylxAJ43mhmuNXla8
         I/T7jPMfW4UyLIRAERb5CHOVw14AMG9XWDquCbmRpSqKaGu4UFSmjafRZNwavRvUeTYO
         24vhxehFpo1cAXzMUvnHEGZ0lRJvAAEvLt6H8=
X-Forwarded-Encrypted: i=1; AHgh+Rp/kCqscqmEooh0pbmbyEMSVWl3x5HvdSV7GdX3p82wnJmryENFUPyEiJIMvUZ0qo5rmuad62SagpKs/SJJrA==@vger.kernel.org
X-Received: by 2002:a17:90b:3c0b:b0:382:1a6f:ba3b with SMTP id 98e67ed59e1d1-3903c543fcbmr4155790a91.5.1785908814123;
        Tue, 04 Aug 2026 22:46:54 -0700 (PDT)
X-Received: by 2002:a17:90b:3c0b:b0:382:1a6f:ba3b with SMTP id 98e67ed59e1d1-3903c543fcbmr4155741a91.5.1785908813563;
        Tue, 04 Aug 2026 22:46:53 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863b0c61sm12394631eec.6.2026.08.04.22.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 22:46:53 -0700 (PDT)
Message-ID: <2dc55d93-544f-47ec-b349-c206f5414f22@broadcom.com>
Date: Wed, 5 Aug 2026 07:46:46 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH wireless-next v2] wifi: brcmfmac: Add support for BCM4361
 PCIe chipset
To: markuss.broks@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260804-broadcom-staging-v2-1-cebdc69e938c@gmail.com>
Content-Language: en-US
In-Reply-To: <20260804-broadcom-staging-v2-1-cebdc69e938c@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 04/08/2026 16:07, Markuss Broks via B4 Relay wrote:
> From: Markuss Broks <markuss.broks@gmail.com>
>
> Those are the required changes for the BCM4361 PCIe chipset support.

Hi Markuss,

That is a brief commit message. Maybe you can provide a bit of context 
for this patch answering these questions: Are you using this device in 
some project? What platform are you using (if any)? What works and what 
does not?

> Signed-off-by: Markuss Broks <markuss.broks@gmail.com>
> ---
> Changes in v2:
> - EDITME: describe what is new in this series revision.
> - EDITME: use bulletpoints and terse descriptions.

This really does not look very useful. Those EDITME: are for you! As the
actual patch did not change you can probably say:
   - fix subject format indicating wifi subsystem and wireless-next repo.

> - Link to v1: 
> https://patch.msgid.link/20260803-broadcom-staging-v1-1-f6f77e55b72e@gmail.com
> ---
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c       | 3 +++
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c       | 3 +++
> drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 2 ++
> 3 files changed, 8 insertions(+)

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 55f4d7b970f2..914ae72a7b74 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -59,6 +59,7 @@ BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
> BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
> BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
> BRCMF_FW_DEF(4359C, "brcmfmac4359c-pcie");
> +BRCMF_FW_CLM_DEF(4361, "brcmfmac4361-pcie");

Are you sure the CLM blob is required? Can you test without it being 
present in /lib/firmware?

> BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
> BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
> BRCMF_FW_DEF(4365B, "brcmfmac4365b-pcie");

[...]

> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h 
> b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> index df3b67ba4db2..b800cbfdece1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h

[...]

> @@ -86,6 +87,7 @@
> #define BRCM_PCIE_43602_2G_DEVICE_ID 0x43bb
> #define BRCM_PCIE_43602_5G_DEVICE_ID 0x43bc
> #define BRCM_PCIE_43602_RAW_DEVICE_ID 43602
> +#define BRCM_PCIE_4361_DEVICE_ID 0x441f

Please add:
+#define BRCM_PCIE_4361_2G_DEVICE_ID 0x4420
+#define BRCM_PCIE_4361_5G_DEVICE_ID 0x4421

Regards,
Arend

> #define BRCM_PCIE_4364_DEVICE_ID 0x4464
> #define BRCM_PCIE_4365_DEVICE_ID 0x43ca
> #define BRCM_PCIE_4365_2G_DEVICE_ID 0x43cb
