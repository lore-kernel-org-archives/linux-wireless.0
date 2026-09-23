Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E5D368D66
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 02:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790129334; cv=none; b=dVVTjTB95nPGi6YOcRjmn4qLh2d3ZYqslpOYmpKrqsJL5BwPLVz9XezMfvQA6VpPyTNIddI1jUaBBpXB7Wh8RDnnr4K5A9sq+lULP3KeEMMQ7vY7wxy+0N14ItXHac5bU/S/7TffYe/+2RESOiTs0JGmAzCHeI+yzXIqO6cND8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790129334; c=relaxed/simple;
	bh=3XDPJlhISE7vrr2Jpd+G6rdz7pi1+GM5DwSUdsyifrc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=IQX4+DuOSnlCd2n2jV3fcxa/qFFlmVVjyf/upVgDsR4RF/ozTB7//Yw9Xkb+ZQAllcIaN9xrICqLzksBSsTjpSgVoNB/f2MxqQ9Sju4ZJjSxi/BF6VJF7AZO6b8Bz/c6UBSX7+sYKWkGF+CPBLiUkDWIBlnlHgOl37qxQWKOpvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=dQ3/jxFe; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="dQ3/jxFe"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N28m6M24162889, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790129328; bh=p59CtEbrYwNKQbGh3EihwPAMi0wLdFNOirufMTFK+UY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=dQ3/jxFe0VelUGxUYbJAfqvwFHyIhcxqimVTQ6XKrFoVB1UI1sXPrYF460pV7hxvQ
	 npmhJzIp5UYm7oFz0/U/tf2pleY6GxwZnd8CMJvkrI3cozBAfKV1RlwG77ioEiK6Uk
	 toBzQ+//pT3mTpoMSt4eZiMm/efD7DE4eo3smRuISDOce9OIzRNL/4c8SHXFjHDzZA
	 AgfI9aNMEHt9vwXd4VIJYzSmLq9YgVefG/xxk0AZEtq6nCFWmA4ADJNM/V0MOQpKew
	 0W1YuBK9jomLtwDVUVIAFXRx1XTLixuQPilSbYeeHLat8YVNs73pEjzELEZenS/Vu7
	 QpeCVn+rvgctQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N28m6M24162889
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 23 Sep 2026 10:08:48 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 10:08:47 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 10:08:46 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 10:08:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>, <securelevelone@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: use one single BA CAM entry per MLD instead of per link
In-Reply-To: <20260916073831.65809-1-pkshih@realtek.com>
References: <20260916073831.65809-1-pkshih@realtek.com>
Message-ID: <533d3fef-4982-493f-89ab-05e3bbef64be@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 23 Sep 2026 10:08:46 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Zong-Zhe Yang <kevin_yang@realtek.com>
> 
> Previously each link took one BA CAM entry, and then when a MLD (MLSR)
> switches the target link, the relation between old link and old BA CAM
> entry got missing and could not correctly release the old BA CAM entry.
> Besides, it would cause list_del corruption problems once BA CAM entry
> replacing process was activated after all BA CAM entries were leaked.
> 
> Since HW supports to use single BA CAM entry per MLD, no need to maintain
> multiple BA CAM entries across different links. So, set MLD_EN bit when a
> MLD acquire a BA CAM entry and tweak the flow correspondingly.
> 
> Reported-by: Aiden Calloway <securelevelone@gmail.com>
> Closes: https://lore.kernel.org/linux-wireless/CAH-fA9oS2N-D05BSd0DDp_hGtBEH==cLuxr1XCUiL_UC3CN+bg@mail.gmail.com/
> Signed-off-by: Zong-Zhe Yang <kevin_yang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

3b68565ba767 wifi: rtw89: use one single BA CAM entry per MLD instead of per link

---
https://github.com/pkshih/rtw.git

