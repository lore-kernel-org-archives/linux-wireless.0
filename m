Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60CC32C942
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 03:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789530657; cv=none; b=E8saS9WMkkbW4m1IVQmc/mB/7nTE305CiTKdMXkb/FtJlWyI+vMh5+88YHxv2i467jP9P+SiXS01jwmdBja7Bv7DVuTXVZxfL3+aC14W59W6lZgB5pUb/qWApw/YVrvb8Z5XFAOV/o0KNFgEEroCnbIgDDNk7OlXwUeaiP3GDHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789530657; c=relaxed/simple;
	bh=+QN6gO8upbI9Zom4PZDUYE6PLVUoM+HBu8eF1OJBZq0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=lRcDNM3U6net64j+0Eyq++GD5VWn2Bt94BIyOYedxbQ/bcbaOcIUFeE9iTgVslzcAWjdkJXYRPTCQK/cE29tKcKuF5MLijihR32VuXEjzD3AbcMvMtLrTR+DW8KWtgtIY0fqqSCms7izXij9t+PEj04Hgtmc215/JtY7H2mCeaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LwrOYp/P; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LwrOYp/P"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G3oqT132070104, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789530653; bh=xmYqVN7gp6FSQWx6U2I8xc2Cx3ium+VoyvJTQfbsEJc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=LwrOYp/P73dJhZQH1JmBY0SmZbfbANecmbtxMleBGUKbNjcQnivEEyWNxBk5kSOJJ
	 tBEpttCNU0+zvnLvZiA9LSDHiywjegNNvc5zyuTTHw86DJOUY5RouT3RA2fStqVgSO
	 EYYlhIc954chCqXVbAfDBMyfl8H7gptknPUbGev6bzWjNAtkPdxKswMofvn2TzT1FK
	 8p0kaxUan1iqDdTqaTgylYt2rJUGisKWdlHikVIdl1kTlsXgRGJZPtjme8Vj/OLvg9
	 Vw5qaARM9V6sX2Tdl//Vr9Xg/bDz19PCodzj6vKA4DWK0t4oN3ndNen5DWs/c4yiFh
	 Ug8gNGej4RVbw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G3oqT132070104
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 11:50:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 11:50:52 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 11:50:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <echuang@realtek.com>,
	<phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 01/15] wifi: rtw89: consider sta maximum AMSDU subframes number to decide TX work waiting
In-Reply-To: <20260909070004.35353-2-pkshih@realtek.com>
References: <20260909070004.35353-1-pkshih@realtek.com> <20260909070004.35353-2-pkshih@realtek.com>
Message-ID: <b64ed34d-b2d1-41a3-94c0-9144b0790308@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 16 Sep 2026 11:50:52 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Consider the sta maximum AMSDU subframes as a factor to set agg_wait to 0
> to avoid TX work waiting to yield better latency if real-time application
> lets AMSDU off by
> 
>    iw dev wlan0 set tidconf tids 0xff amsdu off
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

15 patch(es) applied to rtw-next branch of rtw.git, thanks.

eed90f3e4e10 wifi: rtw89: consider sta maximum AMSDU subframes number to decide TX work waiting
134e60644995 wifi: rtw89: mlo: update link id to FW upon connection
de9da54622ba Revert "wifi: rtw89: fix unable to receive probe responses under MLO connection"
0788bad5d012 wifi: rtw89: modify active scan rule for 6GHz band
6c6130c4d53f wifi: rtw89: fix ctrl_sco_cck for Wi-Fi 7
cfa33d16a418 wifi: rtw89: 8852a: prevent potential OOB in ctrl_sco_cck
a6e919d1473f wifi: rtw89: fw: cmd_ofld_flush always reset counter
3ed30788192d wifi: rtw89: explicitly declare TX queue flags by DECLARE_BITMAP()
95f4fee98572 wifi: rtw89: 8922d: add extra data to PS H2C
9db72f4caa21 wifi: rtw89: mac: change beamformee CSI direct forward to CMAC_TXDMA
74f50393f3f3 wifi: rtw89: fw: extend ch_info format of hw_scan to v2
31f222ebee23 wifi: rtw89: 8922d: update BA cam format to G7
5a2a6b9e092d wifi: rtw89: 8851b: rfk: set DCK start and delay time
0bd0557aefe6 wifi: rtw89: 8852b: update default value for ANA SWR
6894826d9a51 wifi: rtw89: phy: correct PHY-1 EDCCA report register access

---
https://github.com/pkshih/rtw.git

