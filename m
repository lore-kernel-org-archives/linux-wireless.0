Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A323769F0
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397540; cv=none; b=S2yZkmq+yOy4+TtkJfZ0/G5od0hdL8Z6OP3OK6HE9Pa8dVJM8BEMynKrhSxjSu/Wkk6kbU/VtaXkAG76xp3EB626XpjKwq5QiRGT9+bk8q1PHxQdZZtLkrTjpzYgdrCpekeRf4tchmOhiELtFdzp4/32v8U9jiPemf09h3dCbbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397540; c=relaxed/simple;
	bh=6voSCIg4c3kH6M6b/gceGAV3pCxoV1TZBCQkL5Vl6ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0i/vbPwqLMpjvxo5zSz3Iucr74jpFzayMTaW7isTft3Oq48sHDlczSR/g5gvqT7q0LCwNdHziBzbYfpahM/LX+TUn2Gk+v6phaUenHBngQ6O2KM9a9qXXw/Bn57rDr8ZlPWm3y/zrfNhwh9p+zIfxs6GvQFnMFtUuolqsHq6qE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EAfhVplQ; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EAfhVplQ"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDZrv9PJcTF5nY6EQQgc7uu+oYGf9/Vv1bvfE0YdMAM=;
	b=EAfhVplQpyN6s8A7tmgNLAKyETUz0yI+QHwhLbdVVmxv7c62UuAaHnSHWle7PnqcLYqsu6
	ZbN6DlXOst1ZFPooPDKrR09sZfK9QirZkc6jy/iVue2hIFpKgzRIQRtp5t+RUHD1xcIj19
	j3sgKTPx6Jxu3bZHtxRZxECLOQFqlic=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 02/11] wifi: rtw88: rx: mark zero length packets on RTL8723BS
Date: Thu, 30 Jul 2026 07:44:56 +0000
Message-ID: <20260730074504.19725-2-luka.gejak@linux.dev>
In-Reply-To: <e0ba8a366df54843a8d9f65bbc028b41@realtek.com>
References: <e0ba8a366df54843a8d9f65bbc028b41@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 07:14, Ping-Ke Shih wrote:
>> +       if ((rtwdev->chip->id == RTW_CHIP_TYPE_8703B ||
>> +            rtw_is_8723bs(rtwdev)) &&
> 
> Straighten it. Though it is over 80 characters, but still acceptable.

Done in v3:

	if ((rtwdev->chip->id == RTW_CHIP_TYPE_8703B || rtw_is_8723bs(rtwdev)) &&
	    pkt_stat->pkt_len == 0) {

Best regards,
Luka Gejak
