Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA6F299931
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 02:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785636463; cv=none; b=BS/KWEK3shG2BcXNAnRGkeOknweuHNIDDmtZs6xWkJOxIfOSMQUay+b6y3GGbWnziQcmGGEpIZU7mN+gFMdT4JTuC1Z2i5QqLWW/2+4bOt55nBwe+ebihfkPEeTPvIEA0GvkBl7vyojurEntOLrjVBMUBDj/eDcBm7dpscuDh+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785636463; c=relaxed/simple;
	bh=Ajm0i04Cw98h9Vas2VQwq94Yva6cK1oc/SkpUmIv66A=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=UL0Qz622yBTYfHjv3jqn/z0RVa6Jwu+de3ibZZo6gl425DPMzjZkuGM4mXkWbkhJiXIR0a5rJ9iBS4jhGwNvOy2tAH7IDDycRzpfchJsimiRuBkDegL3qVD09NMWERaKIy6UH6jT/YnlqF36FRVszKU8gTz6OvsKwpF7oihHhas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=pK0hTYCw; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="pK0hTYCw"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67227cyL63084017, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785636458; bh=qd59KjUot3Og3+iRlhXglmrKIeyh8kWED+bn9REkLIs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=pK0hTYCwcR34U2rmNSG9cmMpzo7xwY6mk9mL0CmjF2KZPvI/mM64/HH90NjrR1MEc
	 4qloznwojtn4s4OCNShStcIGYuDUN38p89KXMKhK9rEJ6WRp0KwRkUaO5QiTP1ezcH
	 QvsFXlh7oGK07ANEa76zwG4UPgBwEeLDkcJd0khZNgQhNKtBwooUdrcJKKdqyrKDUk
	 DfLBmrApxnd2Vqy4umCwq7C3uaO6aFAvwoRNupnb4OAAZ19PoH0fuFQiVEFbgDQRiS
	 s5BWBv+hoL5VGU5xI+ibKwIANnc5KTne+reBjBGVSp2yR1CroD59Oz1PMk/66Avvh1
	 iMM31yNtmgQVQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67227cyL63084017
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 2 Aug 2026 10:07:38 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 2 Aug 2026 10:07:38 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 2 Aug 2026 10:07:38 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next 1/7] wifi: rtw89: coex: Fix Bluetooth link weight not updated on profile change
In-Reply-To: <20260730060220.55844-2-pkshih@realtek.com>
References: <20260730060220.55844-1-pkshih@realtek.com> <20260730060220.55844-2-pkshih@realtek.com>
Message-ID: <633ccea8-cb4e-4dd9-9c0e-a9a20161749b@RTKEXHMBS05.realtek.com.tw>
Date: Sun, 2 Aug 2026 10:07:38 +0800
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
> _update_bt_link_cnt() was missing the bt->link_weight[].
> Without it, link_weight stays at the initial value of 5
> (set on BT re-enable) regardless of the active BT profile.
> 
> _set_bind_info() uses link_weight to compute b2g_score/b5g_score, which
> determines tdd_bind.rf_band. With a stale weight of 5 (below the active
> profile threshold), tdd_bind.rf_band may not reflect the actual RF band,
> causing mode_v0 in _run_coex() to remain 0 (BTC_WLINK_NOLINK), which
> incorrectly triggers _action_wl_nc() instead of the BT-profile action.
> 
> Add the link_weight calculation to _update_bt_link_cnt() using the same
> weighting table as Formal (BIS/A2DP-sink: 70, A2DP: 40-60, PAN/active: 30,
> no-profile: 5, else: 9) and call _update_bt_link_cnt() from
> _update_bt_info() after parsing the profile exist flags, replacing the
> open-coded link_cnt increment that omitted le-audio profiles.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

7 patch(es) applied to rtw-next branch of rtw.git, thanks.

e62f0baca06e wifi: rtw89: coex: Fix Bluetooth link weight not updated on profile change
cf7f33eb0461 wifi: rtw89: coex: Fix BT-info parsing for 5/6 GHz band & dual Bluetooth
8847c1b12bdd wifi: rtw89: coex: Clear BT link weight when BT is disabled
4d9f08115092 wifi: rtw89: coex: Change Wi-Fi link_mode_v0 translating timing
dd7e70e76bf6 wifi: rtw89: coex: Port _update_bt_ctrl_lps() for BT profile-based LPS control
97b81c10fe77 wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.1
86c3125c75d7 wifi: rtw89: 8922d: enable Makefile and Kconfig for RTL8922DE

---
https://github.com/pkshih/rtw.git

