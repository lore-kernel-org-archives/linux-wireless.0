Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0C73FF8A9;
	Wed,  3 Jun 2026 06:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780469953; cv=none; b=DoXdOgVOQEG7KTATY2GxL8xvD5quFWZ3sKSkj+ixAPIrBfgODtcAPjgliiyX0B0sKy6aX/zd+0q3asOopEWgEcosgKx9Z7C971PujXFVA8UO0kOPgCpij5JUOqt3MYWvZtWOHe4rZDiwW8k4m3TvanG48UmLxFyYoegTEVE3vgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780469953; c=relaxed/simple;
	bh=RnDtmd5Wej+T2ViyisX3FeAMZc9agicby/TSjZYpi9U=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=GeU/0WF70EgLrjAcejhusKuiGfxsy1DQLFOdUH70nyu6IUk81bG30qyVlzs4jLl6LoeQXTLE4T5O4USJ9ZUI6mDrqGAEPpJMiD0fpV3IgPqu6pfVbD5V6Tp3qehen88LszVwqm+OybmY7k2Zx026VeLaEFk/U1AFkfwqcxpKEmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=duU8i+qv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="duU8i+qv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6536x5NR13643690, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1780469945; bh=7EtFDqL5gw9w3gvUwe433RbCcFvFiYsatKrWuBd7PgM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=duU8i+qvOroEdn3uSyfe35UsgAWp9ngq/GQeW6IbNtUCje6unn7dtWG+Kzf0Nit5C
	 y+DgIFP+m2ddwgpLFJGbkDOxMdgfZ+9G/MY/vMRSM3oGXUhwPYJCgFlPctbEY4IbBw
	 v2OpbTNXif6ZwNEQ0UrO9mvKR2x26QXdAUz/D38L2jYeuDnA7P89mAeSWxPw5a8Xfg
	 umguA9CR+mTbBCTs3LoiUSZDIIQdf49MRUAP6KZYVJFOZD8aDCa0fVdvoYAjv4lmOP
	 Z/WhtQUjV+Z62UKBExAFrXPj5vg5+g9367Krx/yMd/5IGqUF3WdG7ekCGLVvJ18cIP
	 jZZeKddoljzxg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.28/5.94) with ESMTPS id 6536x5NR13643690
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 3 Jun 2026 14:59:05 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 3 Jun 2026 14:59:06 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 3 Jun 2026 14:59:06 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <driver-core@lists.linux.dev>, <johannes@sipsolutions.net>,
	<mh_chen@realtek.com>, <wenjie.tsai@realtek.com>,
	<charlesl@valvesoftware.com>, <sabae@valvesoftware.com>
Subject: Re: [PATCH v3 rtw-next 1/2] wifi: rtw89: add dev_id_quirks to driver_info for per-device quirk control
In-Reply-To: <20260529075032.16807-2-pkshih@realtek.com>
References: <20260529075032.16807-1-pkshih@realtek.com> <20260529075032.16807-2-pkshih@realtek.com>
Message-ID: <3dd30036-d5ea-4cdb-84b4-b94b2d12d1ef@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 3 Jun 2026 14:59:06 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Johnson Tsai <wenjie.tsai@realtek.com>
> 
> Add a dev_id_quirks field to rtw89_driver_info so that per-device
> (VID/PID) quirks can be expressed independently of chip-level
> default_quirks. Apply the bitmap in rtw89_alloc_ieee80211_hw() so
> both USB and PCI probes benefit automatically.
> 
> All existing driver_info structs initialize dev_id_quirks to 0;
> no behavior change.
> 
> Signed-off-by: Johnson Tsai <wenjie.tsai@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

2 patch(es) applied to rtw-next branch of rtw.git, thanks.

7554f6602a80 wifi: rtw89: add dev_id_quirks to driver_info for per-device quirk control
384cc80f3097 wifi: rtw89: usb: add serial_number and uuid sysfs attributes for 0x28de:0x2432

---
https://github.com/pkshih/rtw.git

