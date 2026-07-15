Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407A03B19D8;
	Wed, 15 Jul 2026 16:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784132941; cv=none; b=BjoJFuckFTW+mLD3Q5YPQDbdiVSpwV6dvKG6h6mjN0hFGV0YK5Cwke0wCp+CLPI6iD5Zl/JPaQjXFPvsUdAxSmSjumputI1/0Qkoo7wVTOYaJEmM1JaPTcZWCYkjeLfoA0QaJj3LvPAC5ZSCWfXWHn1BU2dhQZ7El2tGJ/Gr6XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784132941; c=relaxed/simple;
	bh=OFXx8sWRRcJTkg/6K4X2CCS9AQUbhAjhmIy63QOF3ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HQG2Ak5a2bTrxamLX6a7J7BYS5Mfira0EWWgFo6tU26hCcrlcmBCn+7pc8Ryn8SllhPVlzqFPlCrinaX4mptP8CNgYZKR6RdR/BC/Hn5OAzBEOWVf2/33hsrAUfVI6DK3W84VjrYxeQFkBu8fHQYV+PDcrI3clmdxILTNIkxNIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Z/qsbjXB; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Z/qsbjXB"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id E9C5A22BC2;
	Wed, 15 Jul 2026 18:28:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784132937;
	bh=BzHouKF0ABdx7pMe6qeJ9755jHJTLM6hrPhImlN3t3A=; h=From:To:Subject;
	b=Z/qsbjXBAfEHnQoyuzTwO8/o5PIZBA6E6BiQXpaK7+WDqRGRPg8sdjpuRVBEy5/7a
	 bd641FE1496uIXD3XF7TuxDBbKOBH+gz9KapjihxGzfeVX2nVj2lxCzkVckAXJ6Te+
	 P+bsxlNbkIJhddFSVWXOYAkIuqAwI8qT86ospH035B2EeOwsqeu4Qaqs47ABv62JO6
	 5LzSKO2mNc7VttAvYun1LvwPuW3g4Qhh2lw+ZttqcZNzvsglnMDuCT7PShaFLGg/8K
	 iNWEF5nawSLxwrD2/nvPLeX4F6Bk1NJczj6WJw0yg9gD1DSKIzGPJKtizPeLL2uxpb
	 9x0tQpV/JhkcQ==
Date: Wed, 15 Jul 2026 18:28:55 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: HE WEI =?utf-8?B?KOOCruOCq+OCryk=?= <skyexpoc@gmail.com>
Cc: Brian Norris <briannorris@chromium.org>,
	Francesco Dolcini <francesco@dolcini.it>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Kees Cook <kees@kernel.org>, Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mwifiex: bound uAP association event IEs to the
 event buffer
Message-ID: <20260715162855.GB86836@francesco-nb>
References: <20260715135711.34688-1-skyexpoc@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260715135711.34688-1-skyexpoc@gmail.com>

On Wed, Jul 15, 2026 at 10:57:11PM +0900, HE WEI (ギカク) wrote:
> mwifiex_process_uap_event() handles EVENT_UAP_STA_ASSOC by exposing the
> (re)association request IEs that the firmware copies into the event:
> 
> 	sinfo->assoc_req_ies = &event->data[len];
> 	len = (u8 *)sinfo->assoc_req_ies - (u8 *)&event->frame_control;
> 	sinfo->assoc_req_ies_len = le16_to_cpu(event->len) - (u16)len;
> 
> event->len is supplied by the device firmware and is never validated,
> and the subtraction is unchecked.  assoc_req_ies points into
...

> 
> Fixes: e568634ae7ac ("mwifiex: add AP event handling framework")
> Signed-off-by: HE WEI (ギカク) <skyexpoc@gmail.com>

Where you able to test this? It looks ok, but you never know ...

Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>

