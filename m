Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4A1735E92F
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784257638; cv=none; b=eo8qRBhbGrqpTZPWbS+dyWrE/mVlJRfC+RMccG68yJCPfWR/VkXjNAh0SAdmNwFvMMs2amARD/55fNL18D3ly9nxXZ+Rty+BbYYtyIGM4uIK5ObwwKVgAUMWEElRPB0S+quvO0akpQGum89X/EnFIknE/4Eq/mTB84VKH6UsunE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784257638; c=relaxed/simple;
	bh=AwfFokggYEJZ/SumhrEL52YExz0bwyHph0C4I5Rq4d4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=iY9TWFdCmuZl4lxLoZpwE95Dklb2b8XxSAu8fIY8ZEQgAfzvROiXL+u9qJ596Bsm6OAt/mHVRxXpeDHmffyCO09U5FEVhADRbNF3oh3og/VhMVey6EEv9C11ALnq3W6CAw8vHxALy8fxmSTeZq53ErhMzXv4Gx1fHSFbQQsL4Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=jhsk7cb/; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="jhsk7cb/"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H37DZ904082208, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784257633; bh=zKB2Uc8hOo4PdenKl814qSoK7tEQd9XSdmgJJSGhHPo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=jhsk7cb/nzPODhPdElOKu3XEJAWrUX3BXNG6glMHACdvsW0xeWT6Eazj/TZQrvi3B
	 1D9B8dqkRR7tDpw4uTdwY56gyAp2uQa5C/vl9gsp4xDd1eZ8MqfQFp5nhBk7wH/Snq
	 0mRt3cOYnJrtjIjcJuz3toJJ3EsswDoC8R6EFWW5nm9HeKp6HyVLauEwGBNPgHeP9q
	 jDf7wcyCqoA2k9LRye4C9dmo6HSnDkNSVL6fIDRt/fJtavZ4J/QYTmrv8wDA4A6+GC
	 OuZNGPno4FQZQr2pJOlTyhAId/QI84OTmgyVpp18/PkLTyk/gWmN/QPusDqZJX5FIv
	 lA9nZc/zrHp9Q==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H37DZ904082208
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 11:07:13 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:07:12 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:07:12 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 11:07:11 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>
Subject: Re: [PATCH rtw-next 01/11] wifi: rtw89: coex: Add Wi-Fi role info version 10
In-Reply-To: <20260712030506.43438-2-pkshih@realtek.com>
References: <20260712030506.43438-1-pkshih@realtek.com> <20260712030506.43438-2-pkshih@realtek.com>
Message-ID: <52121bc9-de20-45a4-934c-df7ceb9ea158@RTKEXHMBS06.realtek.com.tw>
Date: Fri, 17 Jul 2026 11:07:11 +0800
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
> Because the new generation Bluetooth will able to work on 5/6GHz band,
> it will suffer 5/6GHz Wi-Fi, the mechanism need to cover more scenario
> with different Wi-Fi/Bluetooth combination.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

11 patch(es) applied to rtw-next branch of rtw.git, thanks.

af7f59e8e876 wifi: rtw89: coex: Add Wi-Fi role info version 10
3b6dd05aee28 wifi: rtw89: coex: Rearrange coexistence control structure
404edeea3b18 wifi: rtw89: coex: Update driver outsource info to firmware version 6
a20edfbc15a5 wifi: rtw89: ceox: Update antenna & grant signal setting
5d5a5eb7ae2e wifi: rtw89: coex: Rearrange Bluetooth firmware report entry
a67bb858ba4d wifi: rtw89: coex: Refine send firmware command function
aaba33e780f5 wifi: rtw89: coex: Refine _reset_btc_var()
f59f0767348a wifi: rtw89: coex: Correct SET_RFE settings
578f9b48276c wifi: rtw89: coex: Add firmware report control report v11
aed0d7771d52 wifi: rtw89: coex: update external control length by case
c2d96cd05c17 wifi: rtw89: coex: Update coexistence version to 9.24.0

---
https://github.com/pkshih/rtw.git

