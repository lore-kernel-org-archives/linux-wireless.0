Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848892472B6
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 02:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788317123; cv=none; b=W5Zg+JCXowPDYaCP/83GKYcisp2Su+81ytr7qm7Pt0o2l3RbKhs2sjknNyPamxYElZxwaNP3858ApqNDNx1WABhy5/FWsAacIQ3ztXolwXIetYg1TIg6LCrFE3H53L9U7MxrZ6bg1CjWs+Bs9wAn17ke3IV2AzU25jalexYSnoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788317123; c=relaxed/simple;
	bh=4SaScgUeTbTmjEjv8trbQkCUHkq2CKZoB4DLC2k83Dg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=tD22KhCkwJXHq/oUpwYIvrt4PoGPlCdyZN+1zH/ZdZxmg1AYG1QjbsJ7OnfboPOkhv5486ZeAGOcLGVMvlkB5Y1S7aZyoR1+qHG2emFH76uTGiAHbBlFlH2ho1LToXxc2dHjLoToZG9VRCBqSyNSzPT2TqDzHQqDrAZ81zsc85U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dDM0pr5t; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dDM0pr5t"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822jHLK12253237, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788317117; bh=X091aBbiMmZFT8SkSMRj7leSB+EOiIingAJEKKrwew4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=dDM0pr5tjlH8H1QSRsquUDH+JKZHRJDqgqSGtPBzUCnZmbVamLK5llH8Fn/bgjx9D
	 9JWYIcpuJAeXaXtvw5p10s0OAsuX7xyRtKVFtuUNU6WFpzNxTEi10xxB/DnYDj8nrr
	 dDmFvOsMf9tpgRTIRIU/mZerfZyHyh8GBIf2bYG9/6/g4wZwp1hAexJ6kd3kMa8xlW
	 So4dabUS4pTjGSyls3zMuUvxgaOj8Bp92cTh4r2Ydf5gL2Y9bdyuGG69BVrCwa2YbB
	 tCihdRfslrfLjp+VgzouDHLuMCV/0fwI3obs8mJ53UFCZuPZxbFQ3AfCsCexoL+6K7
	 fM4iCDKRFZD8Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822jHLK12253237
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:45:17 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:45:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 10:45:09 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>, <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, Chelsy Ratnawat
	<chelsyratnawat2001@gmail.com>
Subject: Re: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate update code
In-Reply-To: <20260814165556.1102547-1-chelsy.ratnawat1@ibm.com>
References: <20260814165556.1102547-1-chelsy.ratnawat1@ibm.com>
Message-ID: <b2f67c8a-cfcc-4a96-bdbd-7a8fec82ff02@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 10:45:09 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:

> From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> 
> Several rtlwifi drivers declare mimo_ps as IEEE80211_SMPS_OFF
> and never modify it. As a result, conditionals checking for
> IEEE80211_SMPS_STATIC or IEEE80211_SMPS_DYNAMIC are false,
> making those branches unreachable.
> 
> Remove the unused mimo_ps variables, drop the dead SMPS
> branches, and simplify the remaining rate mask selection logic
> without changing runtime behavior. Also move ratr_mask
> declarations out of the removed conditional blocks where
> appropriate.
> 
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

0de28b917fd3 wifi: rtlwifi: remove dead mimo_ps handling from rate update code

---
https://github.com/pkshih/rtw.git

