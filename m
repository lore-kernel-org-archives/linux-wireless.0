Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474522BE053
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 03:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788321132; cv=none; b=ecbXR+dxkZ6e6I5ANHlhBDPRfVdtWKnRFmznsMMHf7h56lFQJ1iX/ofd+fmLMguak/OVAsnjWAgeuLJBXzHygqUXfsu5rMeeSZoDTbTG0eLYRIQbDHppR/7iBIWzGo+yXZeLEmSIeoGnxILdw41z8JZ6O2JtkoBSyz+ihxdWvi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788321132; c=relaxed/simple;
	bh=ODho4Z44CD5EdRkMgS9YAO9vizjH0e6iZ/+O1sT4A3M=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=Qx+rDc4Lvv808gXbSsUz9N0Ff+uDtPhOUnTQ8KBw2EZdwjGmwOhRZjc1siFWZK3Njvq3YR6lI8EcD7U21Nu1LusGYbqHJpsNm9eSJGUffKMDFJjt941xYKc6UisvNZ/yIE9N5DspqOD3Y39GEFGZVi/oBN29FS0s7O8P0x3jTJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=vikDL7J6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="vikDL7J6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6823ppDgB2293233, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788321112; bh=vowlXAd26mBKmY+n/wfyfTacCuCW9mTxTmj2fcOyGR0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=vikDL7J6V9k0xaA430R87M0lyWxT7ZlkSVwIlNVjB2nK0X4rwJMPZPKQa3xOtmND3
	 arfs1btMhNSV/FZF7+jTG64Fqpe+/BPKCG+GjnkW9PiQq9MoIABZOV/Za3g1JP7CBv
	 IHPEI0x/3VIXjbSEBmfXZXIYgeoloIitnIUnDusHu3IUm7tAA8ZUFr+id/dHUB3uzl
	 RV2R1Mp3Pf5aXqiTa+O8yIVFRpDfNdDUSmv8RYUIIEb4PDkcAMtif0OQeN+sjI7+1H
	 P42JpIbZy/dkZBnlPHNGCHCJvi/TeCF2kQNLdql9LdvKrRlL2cwPgU3sUrdwTkbxsB
	 VIEIDcHQs0GVQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6823ppDgB2293233
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 11:51:51 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:51:53 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:51:52 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 11:51:47 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>,
	<linux-wireless@vger.kernel.org>
CC: <pkshih@realtek.com>, <johannes@sipsolutions.net>, <kvalo@kernel.org>,
	<briannorris@chromium.org>, Abdurrahman Karadag
	<abdurrahmankaradag19@gmail.com>
Subject: Re: [PATCH v2 wireless] wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured
In-Reply-To: <20260827131244.35623-1-abdurrahmankaradag19@gmail.com>
References: <20260827124837.14370-1-abdurrahmankaradag19@gmail.com> <20260827131244.35623-1-abdurrahmankaradag19@gmail.com>
Message-ID: <a71e5c37-5d86-42c0-b4e8-c0c42019491d@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 2 Sep 2026 11:51:47 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Abdurrahman Karadag <abdurrahmankaradag19@gmail.com> wrote:

> Reading the rsvd_page debugfs entry before writing a page offset and
> count to it calls vzalloc() with a size of zero, because
> rsvd_page.page_num defaults to 0.  vmalloc warns about this:
> 
>   WARNING: mm/vmalloc.c:4019 at __vmalloc_node_range_noprof+0x9ac/0xa30
>   ...
>   Call Trace:
>    __vmalloc_node_noprof+0x4c/0x70
>    rtw_debugfs_get_rsvd_page+0x4c/0x110 [rtw88_core]
>    seq_read_iter+0x132/0x4b0
>    seq_read+0x12e/0x1c0
>    full_proxy_read+0x6f/0xc0
>    vfs_read+0xdd/0x490
> 
> rtw_fw_dump_fifo() would reject the zero size anyway, but only after
> the allocation.  Check for a zero buffer size first and print a short
> usage hint instead of allocating.
> 
> Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")
> Signed-off-by: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

81510c3d6f21 wifi: rtw88: debugfs: don't vzalloc(0) when rsvd_page is read unconfigured

---
https://github.com/pkshih/rtw.git

