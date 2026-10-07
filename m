Received: from mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6AB33FE05
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 07:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791356510; cv=none; b=X8k6UXgdKdPydHQzvD17yoOgs/BUr8BoyAu8gycmdZ/FfOX6a5WGr3abBZIV18wQkzP4Pi0UjcIKTOBUKFXSluSvQo9YpX/yIVOf9Rl11WumTpgm6GWO3mPgsZkW2XLsFiUsmEdJnxMa11O9eIkbqeUXLHAKSc3bG+sxDUuZtdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791356510; c=relaxed/simple;
	bh=BhOoplpH8aQ2/P2FDuekf9zvrM4AlsAqzq2fRd/+8Jc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=PMBoaEph4VLsNZyNJO3v+Sd1PgyTJv2BGafWSLDTPlT5i5nlJQlqsMw/Ac/hBTKQ1t6lkZh+yitTv7pB2lYx9EJHz+opx5VTH3a2sPvZZFTAX8kn0N1PVFfJaNQyYEatWXkTgUOhuHLRpPZbHLQzgVe8DXAHvTC5iLzCFEXxWPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fMU42EHd; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fMU42EHd"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=BhOoplpH8aQ2/P2FDuekf9zvrM4AlsAqzq2fRd/+8Jc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791356507; v=1; x=1791961307;
 b=fMU42EHdCgE5/3mhor1N0KTBiI3dywuU9vg6UAZaTpMFiIIiFgX8xZ2caiYozvIeAra5JMy6
 F8I1f30MdsphvClKf9PLkacrs2JqXSDRxpNw9eJF0wFeyp/K9T+cksbSYJQHr5EsXs1hpie10ts
 OTAiakUKYkl6cse5lwCVdqds=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id c6333aa925ab6f2a;
	Wed, 07 Oct 2026 06:18:38 +0000
X-Mizu-Trace-ID: c6333aa925ab6f2a
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 07 Oct 2026 06:18:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <f9b5c4d2aad190bde1ad403ab3ab9491a18343f4@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v4 2/4] wifi: rtw88: sdio: Track running state
 and cancel TX worker on stop
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Alastair D'Silva"
 <alastair@d-silva.org>, linux-wireless@vger.kernel.org, "Kalle Valo"
 <kvalo@kernel.org>
Cc: "Martin Blumenstingl" <martin.blumenstingl@googlemail.com>, "Jernej 
 Skrabec" <jernej.skrabec@gmail.com>, "Ulf Hansson" <ulfh@kernel.org>,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 luka.gejak@linux.dev
In-Reply-To: <9f5d3b374ac9793b745e96121fcfc875083dc873@linux.dev>
References: <20261005084849.3109337-1-alastair@d-silva.org>
 <20261005084849.3109337-3-alastair@d-silva.org>
 <6665409e1d374c1face4936b827a6a9d@realtek.com>
 <ccc69689fe2a2cccc39d40221056722e24263f2f@linux.dev>
 <1b8a86e84c474693bfa71f39e946e7e6@realtek.com>
 <9f5d3b374ac9793b745e96121fcfc875083dc873@linux.dev>

October 7, 2026 at 07:21, "Luka Gejak" <luka.gejak@linux.dev mailto:luka.=
gejak@linux.dev?to=3D%22Luka%20Gejak%22%20%3Cluka.gejak%40linux.dev%3E > =
wrote:


[...]

Sorry for duplicated email, migadu was down and I thought email didn't se=
nd so I resent it.

Best regards,
Luka Gejak
