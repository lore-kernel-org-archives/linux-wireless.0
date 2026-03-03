Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F09373BF2
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 02:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772506118; cv=none; b=Fe2STLY2x6pMpF/QfhHXzNoO3p2n2dI/Z6Wx0CGl/P0P3p2S3lSCdift2tSUx6hDHwMSTErvWubwm5tLUXcuVNBDkyaCSj4mNQ/BbNyZ/88jM3ugpc9gc2Tmb2Qc2s0jmZKm1EpcgGMYQrdKBoJRG3umXhAA+6u0TAzl5LOp/kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772506118; c=relaxed/simple;
	bh=ivhrM0TjI7rYCiHcPKWVB3x5NidPcnJL83jfUthc58E=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=NjEFhDUtmYImideL93itQXwn4WzLj85cQOvjYPE5+6vLxOnugWtUTPbBVWwl8W4UxUg5TzrooYPv7WFiekNjkl9b1oSdiQPNWDeiy9QRL4RVEFtDOCbKq1D3iHX6zE1guodxdaUfmltnA+4nad66/2juL1tXbiPMsGrX8M3GvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Svb4G5k+; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Svb4G5k+"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6232mYOv9258480, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1772506114; bh=5Ja37MwLKOppugIgfg6+gQpqKVbV2nxjPliJIO50jl0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Svb4G5k+EKiE+Yefc4mPL4u5Z6gCfjcisW4rSnQA4imoh1ynpLniMyR7RHVZo784V
	 5Wn5q1NlODEGgsYaPlr36gL09qTRn+ZerRuVmivJfu4d+VkFoXM2c/eVVGIhtMYTHR
	 rzVoNbD5rs9+UGh/ZYRLlx+DsfKuVtW1/pL7UcZH8UThFuVO00a93gMEF34k5r+0wq
	 jSlyQf9xPCgsjOEDwKxuvBo2hgzsG1S+i+AWz9SNE0GwVCT+7ncYrReQ99SAtGmGAQ
	 9MKck7VTq/ySfPUJHe4x9agsOyyERGo4IXZW3XAtuw2ijSPLwn9RAx/A6Lg3VAG6V4
	 Z/m9xkksyzvfQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 6232mYOv9258480
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Tue, 3 Mar 2026 10:48:34 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Tue, 3 Mar 2026 10:48:33 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Tue, 3 Mar 2026 10:48:33 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <damon.chen@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 01/12] wifi: rtw89: fw: add fw_def struct to put firmware name and format version
In-Reply-To: <20260213061552.29997-2-pkshih@realtek.com>
References: <20260213061552.29997-1-pkshih@realtek.com> <20260213061552.29997-2-pkshih@realtek.com>
Message-ID: <c2054a59-4c42-48d7-b5bd-89fba4ecef2f@RTKEXHMBS05.realtek.com.tw>
Date: Tue, 3 Mar 2026 10:48:33 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The RTL8922DE has a RTL8922DE-VS variant which uses different firmware
> name and format version, and the rule to select firmware type will be
> needed to extend. Prepare for coming patches.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

12 patch(es) applied to rtw-next branch of rtw.git, thanks.

abaa59fb24ca wifi: rtw89: fw: add fw_def struct to put firmware name and format version
fdb626b79477 wifi: rtw89: fw: recognize firmware type B by AID
888226bd560a wifi: rtw89: add general way to generate module firmware string
1d67f1f8e9a0 wifi: rtw89: 8852b: update supported firmware format to 2
5cfda90c6384 wifi: rtw89: 8852a: move DIG tables to rtw8852a.c
b60796c07a79 wifi: rtw89: 8852a: update supported firmware format to 1
6b4fe140874b wifi: rtw89: 8851b: update supported firmware format to 1
79b3702bbc02 wifi: rtw89: add H2C command to protect TX/RX for unused PHY
dcd2326db843 wifi: rtw89: rfk: add hardware version to rtw89_fw_h2c_rf_pre_ntfy_mcc for new WiFi 7 firmware
a72de4d4599e wifi: rtw89: debug: add SER SW counters to count simulation
0cae26a78b14 wifi: rtw89: ser: Wi-Fi 7 reset HALT C2H after reading it
3d90c421341b wifi: rtw89: ser: post-recover DMAC state to prevent LPS

---
https://github.com/pkshih/rtw.git

