Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCCD33F8BE
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 01:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790127104; cv=none; b=QtAN89NSNxfUWyAQqnmMdculJK38qxi49ko9eQllHdK5nP96QbK8OOy01uTOz1JUOMUTJovoXW/sMYYImZLLVpP8mMtwbTbyTjqdd6lfplm0wqnnYR+jmUAVrFyGv7hqdQ4UJIvbW4r6Z7K76j77yYk8CFj8mMjQKF6p5CwQ8Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790127104; c=relaxed/simple;
	bh=lgXkptVXBOls9oVaeYNCCEb3MhgRMSAHrTNEKhxWAD4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=hYPfbSF8wWSBwJnWehkQ527CTcgAAJNqeEt1AgCXvWxPsXLTjA9EfVWWHsxd3xXupsSihBx+k5/3AxBh7BQpXH2pWGCJ7vGYL71//XW3SteDL5JnmNt3BllFycNPJ92r0KrwiMPC+Mc+hLOiJ+bVfguEU//HndMgzbdVVmoDU6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Yq/c61R7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Yq/c61R7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N1VbwE64125765, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790127097; bh=mL0jL87KlD5hAOpr/tFK30WgPCK3DQf/+QzUwgYCYHI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Yq/c61R7xjItzy10fevwWJaa29DSVy/QM8MwEAJ0sDTbyr0Sk0PFNya5tctH2Sm9q
	 bkrY62EYmjc1SguGvf+1eVq7k3gxoKO2E/TYnucDG++exy120ulmvtJNNSgO7NtjN8
	 uJ2LcWx/SUtFkaEyNEcf8wVbQimBWGVic4lRyJ2cpG4LRmK5mwc6qNgnWAGyvw+GTg
	 9M+ToAOaLmH2iuV/Dqu6ziNOAJJ3pmM4ch5yfjfm0EaSb1iof9Kz4H9HDtWbQYShBe
	 IuBvNZUrvgAl68VfRdhezpFTQdZLKw9Doh2ntvP4UPXrO+vwM3dZH93KSOl7Ru4pbS
	 NrkyXVUaicqgQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N1VbwE64125765
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 09:31:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 09:31:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 09:31:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ruslan Vagner <rusya92266@gmail.com>, <linux-wireless@vger.kernel.org>
CC: <pkshih@realtek.com>, Ruslan Vagner <rusya92266@gmail.com>
Subject: Re: [PATCH] wifi: rtlwifi: fix comment typo in hal_btc.c
In-Reply-To: <CAF9RqJ7DS5LU7+8N+=cWZdi1P1Z-X583Ue9n2uHT4xopkeadpg@mail.gmail.com>
References: <CAF9RqJ7DS5LU7+8N+=cWZdi1P1Z-X583Ue9n2uHT4xopkeadpg@mail.gmail.com>
Message-ID: <4dad4b44-93a5-4436-8591-1fe73b889433@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 23 Sep 2026 09:31:33 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ruslan Vagner <rusya92266@gmail.com> wrote:

> Fix the spelling in comments. No functional change.
> 
> Signed-off-by: Ruslan Vagner <rusya92266@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

A patch [1] fixed this already.

[1] https://lore.kernel.org/all/20260907044851.9884-3-hemanth.selam@gmail.com/

