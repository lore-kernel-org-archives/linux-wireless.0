Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB71F346FB5
	for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2026 03:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777431757; cv=none; b=S6F3antdoj4Dstc+V1mEhLnBmZUf4Txi7WvLVv1v6hACWvVQpJDGyUVIU/gx7BhN5HIGeaPApBPRRRKEBtOZj0tllRl/kTZ1Dn4LNJ+SD2rfTFQykh3sDuh163Q6c4fDy+jTyRQCTjcsuMYnSM61Xom9EtILz+lSgNygV/zRzKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777431757; c=relaxed/simple;
	bh=8FIh5GX/Wjw2aModRAL3RgZRtPdD63CH3bFGi0CDaJs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=VmSjretCyANhXe1Q/nfi3j1JjM1e1oEaKEkr5OkfBXtkovrQYTjgUpNPBgg2VDLhmVcbDFE2x95hO6LpEpRrZgpLjGnYZPfuXOYK6V8RmDquu07XAGllKVmAUzZZzSASI/0B80qOEy0Fj2iYu7oABojHZyW2YTzXuMufniGtcAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MRIyXyb/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MRIyXyb/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63T32WX80916443, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1777431752; bh=BweIiVydCo799QgibV0bjkUxrgGm+/GkCa8LhK4JKZs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=MRIyXyb/6kC4IiT0CkceznRjbjPi54UpDfq8cyQRo5ilzlfdxbatdNu54Tad7qsBn
	 WMmKWrQnBYIshCPpNDwHxMM4Dp5xfWZtBmIHFkyxhNGWNddgotQ6hjTw/C2oqjav1J
	 D4irdyJ+jWHSO0Q07qsGD4bU9EgdrYlnI2hLWmYygahDYAqdIcxGPfA+mz7v5WhIRd
	 TeHvLX7ySvZx9AGa6Lfhu84zqtvpUH7Vv01elRFPvGiXi18bL05hSkj1x6z23ecBmd
	 4fpAO8YYdWJ5gVFp6HygvRT1MqOPZj7P/WzBNmDtLdiaEZ2pzZ4OeXn9fWRGIkkcIl
	 p4FNZO39K6YJg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 63T32WX80916443
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Apr 2026 11:02:32 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 11:02:32 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Wed, 29 Apr 2026 11:02:29 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Wed, 29 Apr 2026 11:02:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH rtw-next 1/3] wifi: rtl8xxxu: validate action frame size before using in rtl8xxxu_dump_action()
In-Reply-To: <20260414062229.21047-2-pkshih@realtek.com>
References: <20260414062229.21047-1-pkshih@realtek.com> <20260414062229.21047-2-pkshih@realtek.com>
Message-ID: <7bdba1b1-04b5-4155-9a80-7361c87801d8@RTKEXHMBS03.realtek.com.tw>
Date: Wed, 29 Apr 2026 11:02:29 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The rtl8xxxu_dump_action() is to print action frames when turning on
> debug mask. Validate the skb->len size to prevent potential broken in
> monitor mode injection.
> 
> Compile tested only.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

26769329c40a wifi: rtl8xxxu: validate action frame size before using in rtl8xxxu_dump_action()
c9f10419c38e wifi: rtlwifi: validate action frame size in rtl_action_proc()
043f09bb78dd wifi: rtlwifi: validate action frame size before using in _rtl_pci_tx_isr()

---
https://github.com/pkshih/rtw.git

