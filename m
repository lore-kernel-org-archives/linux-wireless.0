Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0AC1A9F87
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 03:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788837324; cv=none; b=L4cByYJ/OoHMYbSkvNQfVrVDf4eBnWl8BzCyxCR05+f66g8LT7N2ksdoA9Tu+RQnty2bK5bgHhDIUJD/orLDBMVCRFnqR/jSAC6TE+dr6ICKVNClzqbsKqNz66O9AQctTCkjOkaI6N/+ZiXKHd4PwmlDC6HrJ0UtjtD1MQwe4aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788837324; c=relaxed/simple;
	bh=pSXVckPgwtAFCWp7+eoUGNGcMf9OQ0ilUmiNjwpsQkg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=hHuoDMfGpo4W6NE+1+Dbu2/45TO8o8Mo7OHoL3Ilv+C8vLCQmcHABhRgjxgR72knJN/Ng5BxH4CQty9xJxuV0R3Bjv9dbuKkmUlhIrTr/ZNouy1gJ6c7j2kQ78rv9LaHyWPWEhbRZoWgdsF6iDEd7IYQIDu69NygoQ5FtM86gZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=SyrDdnnC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="SyrDdnnC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6883FJgzC3435080, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788837320; bh=9DtYEHu1MFTOVscLMt/WGMroSt6jRQytKBsZyJzfl2U=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=SyrDdnnCWcnrOcSgDnC2ygIhgeQvEFsayd7Ynb/ReOn8iR6OHYsmE+V46DFnqbX4s
	 nO/3LAO/19vf6MfZPKUKQ5iEy7tTQzRiJmmWTwsUQJ4oz0SxZ4EXl6UMKHUTel/Drv
	 M19eXRz2MAjsLPh3y4zJOSPqsc7dmEO9irlpV4KHTo7SeuTbv1QOjC23Pg/6IHZgVT
	 JpCuJZh0X5lQ+8yas7Q12sLNHQw3z/BQSUGXIb0oaXzxyFlcQSmMAeA9fR5SlZNo7+
	 JYA3eXOe1LO82kS4yvgCkRfJZ51cvnwx5tDVCE2C6SI2OC/MwmsJTF4T7jBnO+Ds6E
	 waz+p4TPpqX5Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6883FJgzC3435080
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Tue, 8 Sep 2026 11:15:20 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 11:15:19 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 11:15:19 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 11:15:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <owen.hsiao@realtek.com>, <echuang@realtek.com>,
	<henchy.chen@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next v2 01/14] wifi: rtw89: 8922de: add low latency quirk for Valve device
In-Reply-To: <20260902052958.50371-2-pkshih@realtek.com>
References: <20260902052958.50371-1-pkshih@realtek.com> <20260902052958.50371-2-pkshih@realtek.com>
Message-ID: <a0d62997-2169-4446-b573-975bcf90b211@RTKEXHMBS04.realtek.com.tw>
Date: Tue, 8 Sep 2026 11:15:19 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Hsiao-Yung Chen <henchy.chen@realtek.com>
> 
> Add RTW89_QUIRK_LOW_LATENCY to the rtw89_quirks enum for
> latency-sensitive platforms. When set, the RA report handler skips
> computing max_agg_wait and leaves it at its default of zero, which
> makes rtw89_core_txq_agg_wait() bail out early, so frames are
> dispatched immediately instead of being held to build an aggregate,
> trading throughput for lower latency.
> 
> Apply the quirk for the Valve device (SSID 0x1e44:0x1400) on the
> 8922DE, and add RTW89_CUSTID_VALVE for that customer ID.
> 
> Signed-off-by: Hsiao-Yung Chen <henchy.chen@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

As we have generic approach to control AMSDU, drop patch 1/14.

Set patchset state to Rejected

[rtw-next,v2,01/14] wifi: rtw89: 8922de: add low latency quirk for Valve device

---
https://github.com/pkshih/rtw.git

