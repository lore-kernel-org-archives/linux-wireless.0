Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0F74BD7B6
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791217926; cv=none; b=Te1c5pyCVb7hgggfFLWubeCkZLzib4OIjqwjjTcL9J+6gUlqjKitws48dI9VfDEBuYsulUQMWOtBIXcdSMhwFLEkTG5co//bZ/mcNoKYAjwrAL6Umh2z1TqrfnKFORAMEobP0QpG8shWVWtH9+9D242UC2fKSF8eXPCxCt8OpKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791217926; c=relaxed/simple;
	bh=t1p8IXQWCe6JXrYhb1ZRToxX1eE/YXZFtPZX/xQ9J6g=;
	h=From:To:CC:Date:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=sqicLL6ZihmYSMYkOA1DwD98fCp9CPWeuzVYZeZu7qNDpS17xkkPwofKseMnHLUAjD0/lOjriOJy6OTBnA8TTLCSCdaIY0p2UPtNHEJ4n6GrXSLcAeN2IlPZc1ODGoG70epNYGZDy0Bv9PZUuQ7mt2DIz5hOFPEOIVRa5y6bIho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=eOYhOrQU; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eOYhOrQU"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-823e4047037so559577a34.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 09:32:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791217924; x=1791822724;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from
         :dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ajrYDjtgXCfiLi8lpPhx25OD/gxlpMH/zqd4lkGdZpI=;
        b=onucaZnGD7YnNjkBWusGB52F9/HBIny3iKa1DQ//vGajDQFu4Qj5ZKh21OVSrs1VPB
         bpDRH5vfPaVzpoEcn75EnWY+G36PTIIxg2YC9dSoCTWEsN8Vyq40DSBkXOi5MetB3n0d
         LChCOsLDQ+DkR9sNXDIsEjQyPU7EhioCT9W8NHNkteDpfleBSwljTwuDKWXUbmU/sQXx
         IdaPrz1PXDlz0v1edii6F8qdlafpFaJUGUJaQ5bbhaD8Hk35OMD/+8mpQedvwFN2y+Sz
         xKk/2Fxyum/1x/QTa8+lW7d64QG9N0cATIW+94gxUDJmE/xjHF7HloHujGxjEyuHOGyB
         zWpg==
X-Forwarded-Encrypted: i=1; AKwUvByig9t/dsXh/p0RI9OG0VtqnFjSzjzzqig2KjhEt9bWrn8f0HXVUL0T+e1O4CJVS5pq/D4cbdnd4tR0a712Qg==@vger.kernel.org
X-Gm-Message-State: AFuF++mrc6E21Fd67P6q/29u//CWEn+jbYupVl5n+3MiywuXb3X7mSTS
	CtIhEW60IsLt8Shr8l2iNT+/0stmw2IhAb062P9w+6fXPjd4fkeOb8/bNUk+7XLErTgWHXLeD+R
	RAlO42e/QaVGKGjAGlHX1X/XSrw9KI59P58fodxmSS7kOCV3R7RD1Az2LHaVAmdS12rOHrwWcyd
	vO1J/jSDmDJqtoCfwxaMC8vegt4G/HpHUz5d3WjpD4hRaKQYruy0j3UlEpHdv7YWo68oyIowX60
	T3Okpy2FYlSgyBbw7SR2jnrfKAt
X-Gm-Gg: AYBFou1FulWzM/T2ou4rpLur4sT/VPBaouQeZD6RKuF7iOR9XcZh4CtE6evCL20NehP
	FayDxK3rcaLm0E37yw3huiCrcCgQL2Ypb4adSgd5K46Sy01AvxjOFtPJUdgew+1cpOl01HLSV75
	eFz6jh1Xvpyobb+xT9JEFXRS94ZQkd6ZMEVbqrP18VIuWLW9mo+WS/ifq5LCZZy4BshI3sIDR85
	Cty/EV3vxIRruxXvRALKFOboFlOiR0iIl7Dp9kz8OiooU6LlXkUEZFSQMeZ0dc9n1CqKJoSacBU
	/GKkJCO0QUVids1NECUo1Cay8pAxfaDuqxnNYJUOpTxmAlT/wXIJntCLxjbms+ux1UQtps0P7Bo
	ZG+7YDGgV2Lhm7zTCMYwOv4Ft5/LOqCbghAIC+1KwdTnPffkk7FPEe0WbzXCUJErROvrcbdKTbX
	EEzXzwbdmcw7Lxoz3/P1sC+n/Va6T66phnFntaQyVBGA==
X-Received: by 2002:a4a:ee14:0:b0:6d7:69c6:5292 with SMTP id 006d021491bc7-6df34291b3cmr8047641eaf.45.1791217923610;
        Mon, 05 Oct 2026 09:32:03 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-120.dlp.protect.broadcom.com. [144.49.247.120])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-49e1eda94aasm1198167fac.6.2026.10.05.09.32.03
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Oct 2026 09:32:03 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c2e2a9fa1fcso253174266b.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 09:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791217922; x=1791822722; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :user-agent:references:in-reply-to:message-id:date:cc:to:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ajrYDjtgXCfiLi8lpPhx25OD/gxlpMH/zqd4lkGdZpI=;
        b=eOYhOrQUzuJhPoo5k+Uhvq0GfxxgINr6tX7GaKMRI6AASrtdaX9DhfngSgUEAX5Wtw
         YKqnDAcqgGqDD5lxQPSujjLPlc8tvwBfcYtI4uWchiUT7oQUDZUXNfxMou2CQSk40MlB
         ZctPJDvhbEi5fyz334aiR0sByNqERs4AkVng8=
X-Forwarded-Encrypted: i=1; AKwUvBzvMwLhEhxQYM/Mr1aM4LXZye2Gm8tEmdne5VmPTbGo+UtWhrwIY8s3uAXoRssL0htAyzFlLU6JAhG8wvtw6Q==@vger.kernel.org
X-Received: by 2002:a17:907:720d:b0:c2d:d202:d1ee with SMTP id a640c23a62f3a-c2e4adaee21mr972821566b.36.1791217921817;
        Mon, 05 Oct 2026 09:32:01 -0700 (PDT)
X-Received: by 2002:a17:907:720d:b0:c2d:d202:d1ee with SMTP id a640c23a62f3a-c2e4adaee21mr972819066b.36.1791217921362;
        Mon, 05 Oct 2026 09:32:01 -0700 (PDT)
Received: from [192.168.178.59] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31563018d8sm99716966b.51.2026.10.05.09.32.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 09:32:00 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Nathan Chancellor <nathan@kernel.org>, <linux-wireless@vger.kernel.org>
CC: <brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>, <llvm@lists.linux.dev>, <stable@vger.kernel.org>
Date: Mon, 05 Oct 2026 18:31:59 +0200
Message-ID: <1a10ce86418.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <20261005-brcmsmac-clang-24-constant-conversion-v1-1-a30c5692d582@kernel.org>
References: <20261005-brcmsmac-clang-24-constant-conversion-v1-1-a30c5692d582@kernel.org>
User-Agent: AquaMail/2.7.0 (build: 200700061)
Subject: Re: [PATCH] wifi: brcmsmac: Adjust txpwrindex value in nphy_ipa_rxcal_gaintbl_2GHz
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="us-ascii"
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

Op 5 oktober 2026 12:33:07 schreef Nathan Chancellor <nathan@kernel.org>:

> After a recent change in clang to warn on signed char conversions within
> array initializers [1], there is a warning (or error with
> CONFIG_WERROR=y / W=e) from nphy_ipa_rxcal_gaintbl_2GHz:
>
>  drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c:224:18: error: 
>  implicit conversion from 'int' to 's8' (aka 'signed char') changes value 
>  from 128 to -128 [-Werror,-Wconstant-conversion]
>    224 |         {0, 0, 0, 0, 0, 128},
>        |         ~               ^~~
>  1 error generated.

[...]

> Cc: stable@vger.kernel.org
> Fixes: a9533e7ea3c4 ("Staging: Add initial release of brcm80211 - Broadcom 
> 802.11n wireless LAN driver.")
> Link: 
> https://github.com/llvm/llvm-project/commit/a5ef934a8d295dc03be3960f2b3744ec2e53238e 
> [1]
> Link: 
> https://lore.kernel.org/1a107e21b08.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com/ 
> [2]

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)



