Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8939538D6AD
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 06:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780469040; cv=none; b=LwAEjWZ0z29sWaUzr70RdZuBq1qXyvGOt7rd6v7SF/VfDpddDmD2WRiP6q5W7RjRtggogvZ7p1hw4yUtkG4SvsUkhIeqCBc7EI73oYgaU69MHYcQwU8g8/D5bNHXx4YoghJpnYHZ671DA2ubNzM3e6YGDoAKYuECLiJ92dbGCC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780469040; c=relaxed/simple;
	bh=fxiPTdPwLIv+EBygDLVcMivKZSWoff2hQY36WtuaSbE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=qlzsuBq0N1ypdzUX2OKl2Rn19z/Y+QshN/HBaFW9+0WNhR6G4hIK5Ad1C+hr1OZC3qkHOQgb/7Ui2Qy6CFsqaBY5LRXw0qd4l7Pmv8JIpeTFdwUeW7EDn6qqkAoPjNUB+dLbyGY5Bn6gaf/DfttsZybf1ohBZVUQuxdfeve/CPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qTZz+cEw; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qTZz+cEw"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6536hqxG73638045, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1780469032; bh=xZpD7vu+mMc7weZdfjOWdC0YRRiXn5aqxoDE9bVg454=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=qTZz+cEwX8ICdZ7stHXQkh+5OFCC1th7WolMJAwlwgH1z8cDxgjBQWGCfQ1wm9gLJ
	 rgYibMZJyNMVSrZbc5p8vv1ejSs1sd3zBm/On+AnbfbY0rZ3icrQ8bVAO/IT/Ad5u+
	 WMLQds9rQdKmVX/8fcuwt7nxZoMBggztWykVFgY0ky0YSgzN0yL3k8w1f0zNPYW/hZ
	 8D44Dix+nmb+LuirJT6fEjBdfwKxkxlT9AKXnPAT82d/VHipD+RKTPRPA9w6DfONgJ
	 tPvep+ZIk2cWFiS3rFrH4ya517Rt2Y3D87EGDnCi7DpPlWfwfZtwQG0ApLXzTPzKi8
	 Ks9LBU+ST5yWA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 6536hqxG73638045
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 3 Jun 2026 14:43:52 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Jun 2026 14:43:52 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 3 Jun 2026 14:43:52 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <guillem@gservera.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: 8851bu: add Mercusys MA60XNB (2c4e:0128)
In-Reply-To: <20260525011728.6836-1-pkshih@realtek.com>
References: <20260525011728.6836-1-pkshih@realtek.com>
Message-ID: <b6c8e341-071a-4482-87a6-eeceae5c0fde@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 3 Jun 2026 14:43:52 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Add the specific USB device ID which adapter tested fully functional on
> Fedora 44 with kernel 7.0.8-200.fc44.x86_64 and linux-firmware
> 20260410-1.fc44.
> 
> Reported-by: Guillermo Servera Negre <guillem@gservera.com>
> Tested-by: Guillermo Servera Negre <guillem@gservera.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

575e6a72bd68 wifi: rtw89: 8851bu: add Mercusys MA60XNB (2c4e:0128)

---
https://github.com/pkshih/rtw.git

