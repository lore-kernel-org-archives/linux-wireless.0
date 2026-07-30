Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC363806D6
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 07:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397541; cv=none; b=Wwds0D6RZLY0oe98RacOfhWDxnqrERS7eQyYwwOy4yyBZ5rwlLSg5smu4ZTYe1AR6GD9RA5wqhTtWVXR9Jne/xyzNlFS+wKAMo28YxQBV1pVv1nXWmbWng7cPtUzaQnRiy59lxcbX//KrM/fRZB3Rf4xbbnOXDDl5bEKP7y+uaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397541; c=relaxed/simple;
	bh=b3dl7xsPo8dtDpoRd7tjTk40o1vPcDaICsKrrGSKnsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CSZMdUuAC/wP9GZZFxcdgQWaEKNeJl1w2AdtGjyrYagKlxSPeNC/9wP4LT/H32eMWFhxIrmf4sf+xws9qDfMarQLU7WvYmHOm6hIiD7TrWp1wz7QWTerla+TyDBFOWrqn+PQtXGEB/8OfoXAZc6/uqTu0c/kkD6vNIo3GkU0oco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WSNWl/Gp; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WSNWl/Gp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785397537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FUNBDZ4PyHQnEk4DEas2aSIJ/PkzGEwiQ+7ry5oIfUk=;
	b=WSNWl/GpO/vWBbwPHMTe1BH2Ep+zb7wK9bMD0bpOJvfAZz2QPWyE3VeCZBaX+flIs+Mn44
	Fy3JTiuSqsCd/BwklgxpLzuPS1bNcq4Yvq3kjzrkH5sho84EdjgpTrvPb9ik44mBnGhYLV
	ELV/Z3WSthAbhh9gjAbrS16Oe3nN1Vc=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v2 04/11] wifi: rtw88: fw: fix the reserved page upload on RTL8723BS
Date: Thu, 30 Jul 2026 07:44:57 +0000
Message-ID: <20260730074504.19725-3-luka.gejak@linux.dev>
In-Reply-To: <1415f8a22c99437f8137304690edbcb3@realtek.com>
References: <1415f8a22c99437f8137304690edbcb3@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

On 27/07/2026 07:37, Ping-Ke Shih wrote:
>> +/* REG_DWBCN1_CTRL bit 20 (SW_BCN_SEL for port 0), relative to byte +2 */
>> +#define BIT_OFFSET_DWBCN1_SW_BCN_SEL_PORT0     (20 - 16)
> 
> define along its register REG_DWBCN1_CTRL

Done. reg.h now has

  #define REG_DWBCN1_CTRL		0x0228
  #define BIT_DWBCN1_SW_BCN_SEL_PORT0	BIT(20)

and the write is

  val &= ~(BIT_DWBCN1_SW_BCN_SEL_PORT0 >> 16);

as you suggested.

> Currently, not use networking specific comment style anymore
> 
>    /*
>     * first line
>     * second
>     */

Right, I had missed 82b8000c28b5 ("net: drop special comment style").
Converted every block comment the series adds, in all patches.

Best regards,
Luka Gejak
