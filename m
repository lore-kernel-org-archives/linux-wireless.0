Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455782EEE90
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 01:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790128585; cv=none; b=YZwVYlBmQm/LEt2dA/FDn8oSkIxoki3rAxmYwAe9B7wlFX61/VbggaPY5N9qohAGrfywTHwWtoY/zls9unTv6kZNsDU9DnrFm6R7AVloK3drlznqjjUTIO9sAVTg3FShlDFf3twbZuLmDD6ho5YKdpN91s6V4AvUrpaUxn3CEdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790128585; c=relaxed/simple;
	bh=29q/V/0H5q4w5jj0XWD03nJ+oO00eB+MBPImNwntuDE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=lbWd+gTbZ+Z3YehIXv90uF9Q5rDxu+UKo+uc79z9SsRTuwIVKiTVQyYaQs3hoCq74rqNz0+66Ogt3yJPb/bWjygotaj396RJYzsKapOF2zYjSmMqVOknIaO6t9k4QuMAIIRzyOZ7Sxzpj9wc4Ohob7tMvt534N7YcIOSqz68IHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XHBrgLGF; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XHBrgLGF"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N1uKL114156509, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790128580; bh=w/Y979O/Jari47VRy/IAwAckYtQDsa3dWIFb3EmUssI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=XHBrgLGFTb+cGOp/v+Xbt/GT7dTzKmFzHooa+JtieJ9/FS42tGs/hPJZU7JmuBEUA
	 FTyiGlMlC5RDM0T7jlnTQ9HW6foCiZzI0L77ttRDYGnSdpH79ivKVNNH6vd9PM5urs
	 9kXiWrqYFg1Z0bvK2Suu4SaZ52L7D2Pm4edUjP8lK75R516QcxjuZV6EvxkAIsABqK
	 5cEhX7bkDYMH2xvnWVcT3YVUKCtZ16i7SHQMndjmYCHvOzcmvO5Ki7mSsFfxrO6quO
	 fyhPW9eTVMZyTuTZqVfOkIGMjn8FmX/o49rb2bOr5c13n4/1OIX/KDni7zUea7pBfX
	 YEEsI6aUv6Wfw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N1uKL114156509
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 09:56:20 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 09:56:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 09:56:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next 01/15] wifi: rtw89: coex: fix SET_H2C_MACRO not sent for BTC_FEAT_H2C_MACRO chips
In-Reply-To: <20260916072238.62574-2-pkshih@realtek.com>
References: <20260916072238.62574-1-pkshih@realtek.com> <20260916072238.62574-2-pkshih@realtek.com>
Message-ID: <4170fedf-ee05-496e-8b9a-f67fb367d33e@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 23 Sep 2026 09:56:19 +0800
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
> For chips with BTC_FEAT_H2C_MACRO (e.g. RTL8922D), _send_fw_cmd
> buffers each BTC H2C command as a TLV entry into hbuf, then falls
> through to the shared rtw89_fw_h2c_raw_with_hdr call. The else-
> branch was missing the reassignment of h2c_func, buf, and len to
> SET_H2C_MACRO and hbuf before that shared send, causing each
> command to be delivered directly rather than through the MAC FW
> macro mechanism 8922D requires. Add the three assignments and
> reset hbuf after the macro is sent.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

15 patch(es) applied to rtw-next branch of rtw.git, thanks.

a4eb406f1705 wifi: rtw89: coex: fix SET_H2C_MACRO not sent for BTC_FEAT_H2C_MACRO chips
0a53612e780c wifi: rtw89: coex: fix out-of-bounds read of report gnt_val
4b639de3bd85 wifi: rtw89: coex: fix rlink index bound check in _update_wl_info
f9ce5e528df7 wifi: rtw89: coex: support version 8 for gpio_dbg FCX report
78aec73b9b9d wifi: rtw89: coex: support fcxtdma version 8 in TDMA policy
62edaf91541e wifi: rtw89: coex: add fcxcysta v8 report support
d5a10f34689c wifi: rtw89: coex: route BT sub-reports by bt_id for dual-BT support
d5f8a5e443a1 wifi: rtw89: coex: split bt_profile into per-device fields in trx H2C
a8cdddb20b27 wifi: rtw89: coex: add fcxtxpwr version dispatch for CXDRVINFO_TXPWR
6e8e123df1d8 wifi: rtw89: coex: set dbcc_en for dual-band-active MLO modes
b53e6acb7048 wifi: rtw89: coex: evaluate CO-RX Hi-LNA request per band
98ded88f18c0 wifi: rtw89: coex: detect BT HID activity from scoreboard
87abb9b102a4 wifi: rtw89: coex: check null-tx fail ratio in nullsta report
c84836d628ed wifi: rtw89: coex: detect BT slot flood via A2DP empty-streak in cysta
b55b58d9178b wifi: rtw89: coex: add AFH conflict detection on BT AFH report

---
https://github.com/pkshih/rtw.git

