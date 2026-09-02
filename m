Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA511CA6F;
	Wed,  2 Sep 2026 03:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788320964; cv=none; b=PcwwCQW5J+AiELM7dQLqu9vPrrFa6PZBVaXC9mKUYekmlIBtGUzhQQAQlnYkxmE9GouXiUrAH5wQhE5Uj+ofhPUAVipzRDlmiyZ980yXElQtv+ZazNhgH8IwA99dHZJnk4P/UdVpsE7HblG9/zLzyVRsUuzBL0SAyg8nTGjF61o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788320964; c=relaxed/simple;
	bh=uYwxo77u/cXGQ+PtPZa6YUbZ87tvzbiEF2hKkdopLJs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=JUTOEUFWvGH3wj86Pm6O/l8cDS0R/idyzx+q/o36/jDIQwKSmHxPx4I7O/XgPRDURappZsLVSEEMZh1xdgwBWAxKzj2YpsPCLcIEAIgq+IAUJLVN7FpDUk0reu7LbReIybpGMirXWRJcD2hmBU8gSzvJH1RqyUHVDdpgeu5pTDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BqQ+xHwV; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BqQ+xHwV"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6823n4dZ52291847, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788320945; bh=HdFkQVKbkIuDN6+LOcUMQGr/M6Nm4sBZ9OcbljgtGOE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=BqQ+xHwV+1xrGQ/Ql5fNoJN84bz30QaNRsgKw3DAU+QWCt7o1BzuD1Vce4kN5Bt2Z
	 g7//1374DcOoHe6UF9dzJXoeywGEjP275oMgDaq7fZh87vfItIglgA7KutU7kRqQPx
	 CvgePpE7pMHGjHBIZ8C+ZCYwweLiy3Pkc6FBbMJSMpmn54SKfsqVJge8enGSCYJ+JF
	 E4JUigL67PWfjNjZPk4F0evninyH5qVprdRnvZnjqAvpIQomYJkQQ2DCYjfIMarQsB
	 r4A7+FoZySA5XHu5owpK2Fvk5RMmUdJsVg8pqguZDvgJl/8P6G63QFQgpkvguic4c+
	 dVp7d8mF1L1og==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6823n4dZ52291847
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 11:49:05 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 11:49:05 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 11:49:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Gongwei Li <13875017792@163.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gongwei
 Li <ligongwei@kylinos.cn>
Subject: Re: [PATCH] wifi: rtw89: coex: Fix wrong constant check of GPIO MUX signal
In-Reply-To: <20260826031959.2555359-1-13875017792@163.com>
References: <20260826031959.2555359-1-13875017792@163.com>
Message-ID: <23794fc6-6f21-428d-bddd-cc9bcfb011be@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 2 Sep 2026 11:49:05 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gongwei Li <13875017792@163.com> wrote:

> From: Gongwei Li <ligongwei@kylinos.cn>
> 
> In _fw_set_gpio(), the check for an invalid GPIO signal uses `sig == 0xff`.
> However, _get_gpiosig_for_ver() never returns 0xff. Both of its failure
> branches return BTC_DBG_NUM (defined as 32) when the requested signal is
> unsupported for the current firmware version.
> 
> Check the result against BTC_DBG_NUM instead, the same as _show_gpio_dbg()
> already does.
> 
> Fixes: 5c90259b9748 ("wifi: rtw89: coex: complete GPIO debug configuration handler")
> Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

fc17fd87d9f2 wifi: rtw89: coex: Fix wrong constant check of GPIO MUX signal

---
https://github.com/pkshih/rtw.git

