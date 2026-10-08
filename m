Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50DF547043
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791427206; cv=none; b=CErtPZzWHN6M1nMPW+pqtJOxDTOVXjWudEUuf9I2IXjIBFh45vZWTuRRZlnkdPY0BbR9hH/8dDoM0wgdseN+9xvSL1ElgIQEUUvFfzhp8U4PHgLqrsRiPbamKKC30KSIP3pB86DDikLxOpggXj9+pCTIbiSDXluFv0zOIJlT7Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791427206; c=relaxed/simple;
	bh=hTaZUofGA0C4zkh/qLBj6OJ2FCgwR2dNV21WspJk28E=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=pUPM+G+YD+kfc9+L8iOSF0miLVDBoLFAV1fjpOOV1bb6IS9vvvld6eExUpmK8HxYd8YBFYjsaCVGLx1PfnPntmyFLQaTyTCfZylUMucPWdJYma3vkUeZryvhqTVSgx1MAvC7GTX9siq7ZPq8gla21APlipB7Xjiioqm7x7z2WTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ChpH9xT8; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ChpH9xT8"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6982e0k05134011, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791427201; bh=7HbhMSYCNryS+kqIHRN88Mx+K/DR/MbSCAixiGL6FAM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ChpH9xT86na9ZAXpz2YWyogBpZhLG/dEOInNVlYx5vGnAslC70JZS5nCpwbH6U70Q
	 vGAfVIoTbOtJhErLvNL0wrkiswleM5TFazzCfJzXFLw7ed55Z/ZAkoiZRixB1VRyNe
	 pxLipX/o8I5DPOK3As1lDFSOBEO2w+L+kjEXoOR5hUc7xn76RtHp3RLTrn8qNavEBc
	 kcqrCvMAgCyy+DbnjviBBQ3pm4RacYorfpZ5lQtvkUAcKmH6yovw6UZ8LfICZHxx98
	 BMGWGL4rIxulDK6cEL4OVoK7dRrsWtykmCE+TG3kxqXMdKQ5epW7KlHqs7G96s12Sj
	 11h37NUD9eCIA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6982e0k05134011
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 8 Oct 2026 10:40:01 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 10:40:00 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 8 Oct 2026 10:40:00 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Thu, 8 Oct 2026 10:39:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <ku920601@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH v2 rtw-next 1/3] wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.2
In-Reply-To: <20261007011057.12125-2-pkshih@realtek.com>
References: <20261007011057.12125-1-pkshih@realtek.com> <20261007011057.12125-2-pkshih@realtek.com>
Message-ID: <903547bb-361b-4f6e-9c19-b20781a17b14@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 8 Oct 2026 10:39:59 +0800
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
> Update 0.35.119.3 Wi-Fi firmware support. Fix dual BT, dual MAC,
> MLO mechanism binding control not working issue. Fix AX/BE serial
> chips logic mixing error.
> 
> Signed-off-by: Ching-Te Ku <ku920601@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

19354c4b346a wifi: rtw89: coex: Update Wi-Fi/Bluetooth coexistence version to 9.24.2
52f00f0c99ef wifi: rtw89: regd: add NZ/BR/AR for individual TX power settings
b706b5f2fd24 wifi: rtw89: 8922d: update supported firmware format to 1

---
https://github.com/pkshih/rtw.git

