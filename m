Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AFA1FFC59
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 02:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791426215; cv=none; b=B+GfFB434soF//8t74W1e7s4d/WKMFV5Mr9MoWzvY+YujNGfU9ULGrXAZkAOge0e5ahOoM8szCtQG63HwiLfOXxvMPjGtmKytNdzrRJWzIkTtFFAK5Y6wzAOYgIWqCkbQQ5SaG3ipc9a5vYGLCt/9wUNVUqxHtaXUOGWl4OeKsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791426215; c=relaxed/simple;
	bh=E41fXle/Ftsq2HlJBJXWli36x5csQYWuej7MJXZLggs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=sosCw25ap3GDIoiBwENUYeyDwhSDJTOYTAUemzYB687cOA8GMF6Tjgy+9xRHanw8QbT+7qtR4+0csbQaaP6PqFqYhbFb9TQNAWKLNnoIG6z79Gtan7RP0rfKPfzkSXZw32zqmya592IwNF4Tn7plSKnA6PthoMz4GR1QrCYFraM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DdmR7J5X; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DdmR7J5X"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6982NVaD4110046, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791426211; bh=CRhcauVifpHhLi+GTGLwv1SB2fwlDVQtMyrYxybG6rk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=DdmR7J5Xx7NT2vxrawn8jGJJMuzKsev5q0gnPaNE9Sd2KzSdkPpPgflhhBv2Mf0Zg
	 Uw1//YQFm6qHg7N45ffQcUCmuAc6bNI4MDGZmYm4f0eqlExPo3jMvDlCruc4zlLyqE
	 tZio5amfDkja+cuydp58kCG6y1VXFZe3rdxFVi7xK8Nu4UECIbNzIWknZNkjeJ6SM0
	 0oLYzZT+dEijDVyMxLOJgh5V7nYxDA+y2MdWKSwMnHA6cmc8TXB1D4bM/Q/OdK6TN+
	 lI5aEVVBkccp+jBcC2+DkDCs3bHBbH1alxMovhbjpQfEKNCebANYNDP97kdwylP9mk
	 rUZcizBpKiDqg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6982NVaD4110046
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:23:31 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 10:23:31 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 8 Oct 2026 10:23:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: coex: fix off-by-one in H2C macro buffer full check
In-Reply-To: <20261005053855.17740-1-pkshih@realtek.com>
References: <20261005053855.17740-1-pkshih@realtek.com>
Message-ID: <77d1b1d7-8853-4070-9141-33cbf572416d@RTKEXHMBS06.realtek.com.tw>
Date: Thu, 8 Oct 2026 10:23:31 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Ching-Te Ku <ku920601@realtek.com>
> 
> The buffer full check used >=, which rejects a command that would
> exactly fill the buffer even though it still fits. Change to > so a
> command is only rejected when it would actually overflow hbuf.
> 
> Also drop the duplicate BTC_H2C_MAXLENC definition in core.h and keep
> BTC_H2C_MAXLEN from coex.h as the single source of truth for the H2C
> macro buffer size.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

c43d4f8796dc wifi: rtw89: coex: fix off-by-one in H2C macro buffer full check

---
https://github.com/pkshih/rtw.git

