Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5989817FE;
	Mon, 18 Nov 2024 01:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731894514; cv=none; b=mklOK97c4ttSysMLOeqVQUTM35g2+RieLrrV4LKu70/c/L+cSV49sHIqWXdSVsB324OIhLWiOKibktPIMdGLM45DPjdip/53o1dfRlOMMpBqIeiLZTHzXR4NcXfrplbxTDhinubYxkYo2kFZwYehm9uij4R+dWK09Lm5386G1jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731894514; c=relaxed/simple;
	bh=UIDQ79NXPVjMdLsgl9nnghZU0uQkF0jSdCEcqXI9gd0=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date; b=uupwDg/s09wdoncPCFV2eWy4RQywlR7e0i+S/3BSN2uHF3ovr+BxuXvRrJitMVuW+TpuoGarW5H81oYcBG3fFP16VL974OxWbVpU4Kn0GtNR08JL1GD1M1eebEdiKKD/MMuMiPfVDsQx6Vm85z6KilB1jhTawEr9ntrf+snbtYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=temperror (0-bit key) header.d=realtek.com header.i=@realtek.com header.b=A2mUILxi; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror (0-bit key) header.d=realtek.com header.i=@realtek.com header.b="A2mUILxi"
X-SpamFilter-By: ArmorX SpamTrap 5.78 with qID 4AI1mM5P14129943, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=realtek.com; s=dkim;
	t=1731894502; bh=UIDQ79NXPVjMdLsgl9nnghZU0uQkF0jSdCEcqXI9gd0=;
	h=From:To:CC:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Message-ID:Date;
	b=A2mUILxiOLbqqptWpfVuSl1zt0qcosnazZcTQxjO220HhwpH6/5EQ2tJdr1lhEXlh
	 hDpouQ9TjV2VB2wvwUnua0QLkmymCsP+OYV8y8qisQohb7m392hY6MVlLuE6tYFO2B
	 TqWKg6gj3IfFKKldY9jV7o1DZz54keDwFvsnAmgshfDmS/P4BaNPEavJtZNJc7WlZE
	 ApUe4T+3n2xjBHn9flfxKu7juDDdf1I3qhW/csmlWIvC7Wm4QzhapnPYxNf6L3FiGU
	 scViUIYZw2aLmU1e1MYSXmh4CdGQe0dmDFhg8Yt1mpS4DhDwUPHwf+bJvciX7Wd3UC
	 xvsbTqtpAGjwg==
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
	by rtits2.realtek.com.tw (8.15.2/3.06/5.92) with ESMTPS id 4AI1mM5P14129943
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 18 Nov 2024 09:48:22 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 18 Nov 2024 09:48:22 +0800
Received: from [127.0.1.1] (172.21.69.94) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Mon, 18 Nov
 2024 09:48:19 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Colin Ian King <colin.i.king@gmail.com>,
        Ping-Ke Shih
	<pkshih@realtek.com>, Kalle Valo <kvalo@kernel.org>,
        Su Hui
	<suhui@nfschina.com>, <linux-wireless@vger.kernel.org>
CC: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] wifi: rtlwifi: rtl8821ae: phy: restore removed code to fix infinite loop
In-Reply-To: <20241106154642.1627886-1-colin.i.king@gmail.com>
References: <20241106154642.1627886-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <3b611dd3-a2c9-4092-8192-820b87cbda32@RTEXMBS04.realtek.com.tw>
Date: Mon, 18 Nov 2024 09:48:19 +0800
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)

Colin Ian King <colin.i.king@gmail.com> wrote:

> A previous clean-up fix removed the assignment of v2 inside a while loop
> that turned it into an infinite loop. Fix this by restoring the assignment
> of v2 from array[] so that v2 is updated inside the loop.
> 
> Fixes: cda37445718d ("wifi: rtlwifi: rtl8821ae: phy: remove some useless code")
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Tested-by: Ping-Ke Shih <pkshih@realtek.com>
> Reviewed-by: Su Hui <suhui@nfschina.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

5e5903a442bb wifi: rtlwifi: rtl8821ae: phy: restore removed code to fix infinite loop

---
https://github.com/pkshih/rtw.git

