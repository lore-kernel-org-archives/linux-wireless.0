Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08AB36DA13
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 03:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777432134; cv=none; b=N0k8V75DoPFfaApLTVAfsWwmZCaewugx64V9CwJHl7ov0X5UxghafjN6Cz0Bm3b89EMi/BeVvO9EzXG+kYtgVCjWysNNv2f2A8fSmFoeLphDwPqhOPUwWlIEpbltURFQIieZNalmR2XgJ/YpQLw8zF8HFFOCDxmLhw8HZYYXgbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777432134; c=relaxed/simple;
	bh=+kNb3Xhx9cW3FsOxbzPihV/ZQlNIPm2NuC14pxJTiFo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=KJHfkQisUl2FUWWtKw63UReNo3+MMQx12h3KqoH3JpkqsRJdqWzr7a8q4qJQobcK0JwCw1JiIkDj4mrZEP8iN+mQ8rYwukMWgf7imSrj/XcigvK2Hloef2tyiwjOkuzrFJ6fK77nOkA7KgCUEiLc3z9vwHnrNI5GHgIPGZmMKU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QOyuDbOD; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QOyuDbOD"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63T38mMQ2918743, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777432128; bh=fZclANPthNPa53ZTPcibc4pPkB3FDqCaIx9xQojrCFg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=QOyuDbOD6kj9qLLbPjvYgZ5uYs0Kdo4/bMgSXAsrlFUptWXe/gG3STDuil60yh9pQ
	 K9sx36TwRO0PY6fdTGKPSS/e6/h/k9BIJrcj/0Xa8J++NgGrhMrrNp6Ny44EYHhYet
	 4J3EbWZ4CNro5Z6y+0UtsJClA4GL0mKbLYe6CiQIPEgI8CZSPX90aMVbwlXvZC3PJD
	 iPhnyVtkXAO7ig3ugUJjTWrMKwGxnpS2IZm+GBA+G7CHKZ7HEBMLwV8/eK0pksqtnh
	 DOk63UE4Ro6Ug9dKylkuzlEdW4jIdfLdZeXGQgS/5OFkyaodchrv5jRDYNq4UkMUTd
	 AN6wCL8Fc3eQQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 63T38mMQ2918743
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 11:08:48 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 11:08:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 29 Apr 2026 11:08:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>,
        <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>,
        Panagiotis Petrakopoulos
	<npetrakopoulos2003@gmail.com>,
        Oleksandr Havrylov <goainwo@gmail.com>
Subject: Re: [PATCH v3] wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()
In-Reply-To: <20260415052959.14844-1-npetrakopoulos2003@gmail.com>
References: <20260414194757.163339-1-npetrakopoulos2003@gmail.com> <20260415052959.14844-1-npetrakopoulos2003@gmail.com>
Message-ID: <bc8fe854-f605-4e2f-a9cc-59d18bd9491d@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 29 Apr 2026 11:08:43 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com> wrote:

> It was recently reported that rtw_fw_adaptivity_result()
> in fw.c dereferences rtwdev->chip->edcca_th without
> a NULL check. The issue is that devices with the
> 8821CE chip don't define edcca_th in their chip
> info. As a result, when rtw_fw_adaptivity_result()
> tries to dereference it, the kernel triggers an oops.
> 
> Add a NULL check for edcca_th before dereferencing
> it in rtw_fw_adaptivity_result() in fw.c. Placing
> the check at the function entry avoids logging any
> garbage values.
> 
> This change does not address the root cause for
> this behavior, but it prevents the NULL dereference
> and the resulting oops while a more permanent solution
> is developed.
> 
> Tested on a 8822CE chip which defines edcca_th, so
> this issue is not present on it, but it still uses
> this driver and I can verify there are no regressions.
> 
> Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
> Reported-by: Oleksandr Havrylov <goainwo@gmail.com>
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221286
> Signed-off-by: Panagiotis Petrakopoulos <npetrakopoulos2003@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Tested-by: Oleksandr Havrylov <goainwo@gmail.com>

1 patch applied to rtw-next branch of rtw.git, thanks.

d5e6f353 [v3] wifi: rtw88: Add NULL check for chip->edcca_th in rtw_fw_adaptivity_result()

---
https://github.com/pkshih/rtw.git

