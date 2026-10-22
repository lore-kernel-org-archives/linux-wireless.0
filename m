Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.172
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792696751;
	b=qrGcCL8jhAyDLohV65p/2viYhKfcF9Ao5lDj34WosABSsJ2OWS8AfoftrwpNGRr+DOuG
	 x0cUt9FEgJ8uRk64LEnReHxn0WT3xt/XFIslMdYnJ8rR8rg25E7mfhkzlIGYTE9hTnoJM
	 dZg7eNt8OsyhRjUd1kdVPvw+7HtnMA3CFt8w2YuxYR3Dh5jfda3HNpc9WU4jD7TbNFegu
	 2hFQ/JDC1vONkCDM6JSqWgm8BgOkySbSZwT3cpDoHlJiAd8Exqg6EaudAMZAj5IL2RzNR
	 CkP2TML4wWLvWwZuOW+iiWrj9pyiIM+SFbOTectmPYjqYSFvOMfpeqYg5ITWAQgjxqg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792696751;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=HFbV3ZmoQh8VWrTxWa/9IJZkIiSATHZIo9x6Qfdhxic=;
	b=FEQepnb8oySenMnQbm+3PbcSisYzpGuf0gPq04/jNnfXnDRTiNte/1Mj+3bnyO8I3KH/
	 xV/A/nbnMzHKDiMpBY4vii9X0PTPXtFAiPbM98ZBwfT+qymtxqYJJkGEwW3yBZXeU71mT
	 Dvk7PGmAZewVY2z3ackvv4uqCXysvm/rnMBHFmgIbZ3ek7K0oFHcPotJ4hcrR8Ava8JeB
	 phSr39dGlni1EyxN/BSvhJH2RaHaFJgHwLz96ptY/cUW6f3Azx2vGl6bgXjG9DpkRFf/7
	 lkE2Syh6B2OjZHbiYd6OWu+1qx5kLD09C7uKLkZtb+Gmqu6+94ZW9DFAR+PMImmilDg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HUHYJWNV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.214.172
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7828E606A319
	for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 19:19:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7828E606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HUHYJWNV
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e9ae391a05so472965ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 Oct 2026 12:19:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792696751; cv=none;
        d=google.com; s=arc-20260327;
        b=T8dgdSOx3W1Hn8CIj6SQXZbh7L3J4tHauEKHYh1Jt+n6trz6N1e1iwnxCDipdXuRDs
         7MwEUcts8wLNCSdFldjGetLjlQrIh5pymgiy+8GUrNBYOLfTBJ2339I4lMIgSEbKkOAe
         ZJIkJ5tR4wWz2WBUYUtmkwiDjEVGV0mZ6C04vgdE5imf7jAWIMPLhg8JJBKRu5nN+C1O
         oGzu+zR8Vweb83sWaXbHBMjHCBH5lIewLp/mp7lyapKx/vRl+M6D9k5LFhKQS9D6RyaO
         UKQRuy/4okpeerQ8ADkI8gNHYCg/Bbyo+RtTKmo2O/3h0cyeJXX13nay0imkq7FDwxWY
         OUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=HFbV3ZmoQh8VWrTxWa/9IJZkIiSATHZIo9x6Qfdhxic=;
        fh=dvptm0SZc/b9W/H49PkesP9QTGZr3D09FOFxreW7XLI=;
        b=icLcWwxCMFzKKCTR4tKkPZXqsDDSrmTud1BO/D3v0BYLACsnVINi7T2JcWlvPkewei
         7gBHhTRha5CI2j3AYSU/I87n03TTbacBdhApeFLvcKkI2o5Gca2E6Vtj4uAWbp+xfAk5
         cM6qn0NKHJYekbj5OB82M88B0AAI/elwKMqy2Krsen3iPgK/uAOqP/AH/yatF2MjIuVf
         Xpax0lO8fl8E8Ba63Y4pIgPWzj6ZH77E5G+nXxLjeFS9qMgSCPPmM4x4nih6Gtd7mQP0
         TjNj1ga+sqnT0HJAyyc4UnhqZX9OzYim1FhwoCprlYKGFbNIJ1U9JVpoggrD93aubn6Y
         gi8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792696751; x=1793301551; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HFbV3ZmoQh8VWrTxWa/9IJZkIiSATHZIo9x6Qfdhxic=;
        b=HUHYJWNVBBzzw12TGgb1Gjx1LAdBaTPU5PR4UvWHnwn1TznHA3EosZX1jitM48WqZ7
         wwJus2/16oth39VfzNYF2xCx/BtrIyn9ZURdxQ9T7PfExDF+Q/4X3EbYKeeh3C//ALQz
         XJcmhDow6n5WPE8ykvpnLfupl3qWNpse+5MdIs+j2Rg4E4MMcXyCzm7Ek9jRHj5Y4f9E
         xhgsC14or7ceXSUD0OFXAWiO1RhZbYZPqcf/+26wf6rG4/jPlzTkBzGNnZyPj7Ia230p
         6RRUYsLx09iDCd7kl3BwAluqhhvbG0jJcvU4Sn4LSUOrwmpnDMIxGYu6CiBJV3T31X1+
         IKiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792696751; x=1793301551;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=HFbV3ZmoQh8VWrTxWa/9IJZkIiSATHZIo9x6Qfdhxic=;
        b=xyr7kq5sodZ2PMmY8tgYg2QCbV1uvc5c/RqVxI/i/JepyaYsX71cr3OdM1yv6xjBWS
         aiVcEdtNVRjNveZUpRveXHbrTs9Di6TBiIo8GTqQ+vT2tlQGemdKaNkM54n69LoqXIHI
         UMu13CRLnR2bSuEOi5Iv/6u0BYrDS7bdlXDpcYVvzvtT8JT7w10pCp8zbHYuifL2vveD
         MMSUCICQVM8wh2ydo0fI0wDEdw+mMos3fLT/wPYuQw/KjwXHo2LIsdt9ZZeb2jlG8XtB
         8I00x23nE3xv7DzHeeE+aqyg0gKhuftBFKqU/1T166w/7UrssR1ToE6Ql6S/1BVnJIx7
         xiKA==
X-Gm-Message-State: AFq9FYIHbzl4QdH0k9+nYQLsjOEY8vMeMG04N/ZyzI9DO2nuUwwicjlI
	6PpDy35NtLalAuMb24xTOKD4JLBKhh/NERW2A3ubN+TQ8dtt2eNbBXkn9vGWCEX7phY5ibBGShT
	HfJUxOyd9K8q9qdjZT3b5ppwLdo1tvx7CZMyZ
X-Gm-Gg: AYBFou3vxsuIdQMD6lHZDu6ROCPawf6+NHaTHOM6Zo2xj0Nb+6mAq3Ay3oC4MC2V27j
	XwjxThLJNOEWUSGkypz6TAgN/PtxLbRCFwpK5CcKNdYPMs33KhXvBXHxPY2TFUPbNLQxML4us9G
	QQEoXG6y5bo4T98OPMkA3FjMo7zpaZXt/RhxV9QOUXSqFQ20k0d7PrTWBoI0x4wuTaeeBzqbVAI
	KHo55NcWC+9hKNTtT1Y3uLl/wHwfARTMmg5zVZsFvcnK1cOErHVLGpdMSzvAeoIErhtvM355dRI
	Nj8736R5Nrcueu0pZFbJmkUNzkvI4TyeAY8Ta5VT7JjFyVPT7/nl5/9HREy86nKau4z8auZngbU
	mvSpuulLily18p3yKFjdJ7AT9E94dMIwmcsCU1A==
X-Received: by 2002:a17:902:d50a:b0:2e3:643:279b with SMTP id
 d9443c01a7336-2ea7c2fb41cmr2298195ad.31.1792696750798; Thu, 22 Oct 2026
 12:19:10 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261001184529.502048-1-hoopyfrood42@gmail.com>
In-Reply-To: <20261001184529.502048-1-hoopyfrood42@gmail.com>
From: Chris <hoopyfrood42@gmail.com>
Date: Thu, 22 Oct 2026 15:18:53 -0400
X-Gm-Features: AclHuK_JdEOtm1oQQ0eGO--vDE49kxltYgJazkvOFHQacXc2cYGPhuXJcpgeJrA
Message-ID: <CAHaeJsTsCP9SEejH=RT=9vu59vqq+iFXaOUYAo75UXpb0U6qTw@mail.gmail.com>
Subject: Re: [PATCH wireless] wifi: mt76: connac3: check headroom before
 pushing EHT radiotap TLVs
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, deren.wu@mediatek.com, 
	mingyen.hsieh@mediatek.com, lucid_duck@justthetip.ca, stable@vger.kernel.org, 
	greearb@candelatech.com
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 1, 2026 at 2:45 PM Chris Kelly <hoopyfrood42@gmail.com> wrote:
>
> mt76_connac3_mac_decode_eht_radiotap() pushes the EHT and U-SIG radiotap
> TLVs, 64 bytes, in front of the frame without checking that the skb has
> room for them.
> [...]

Gentle ping on this one. Felix, is anything needed from my side?

It fixes an skb_under_panic in monitor mode on mt7925u (and on PCIe,
per Devin's check). Devin's Tested-by is on the patch, and Ben agreed
it is sufficient as the minimal fix for stable.

Thanks,
Chris
