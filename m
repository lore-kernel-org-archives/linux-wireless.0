Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6883C8C46;
	Tue,  6 Oct 2026 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791321884; cv=none; b=KCES99HuR/KPqN8ocr/kkcNAdj/d7AquQn8wKoJasjha0Xh/Wjw5XQhMKwz+DqmAegqDzJY5brJX62GcH/m/JrsBzrEMaOTSB2KlqKHnIbR+1MjvOIRl+/LDId6AjozqyuzcK24v6XDAvsO1M7h0CoMme5rTgfhK+WA2yIW6Bl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791321884; c=relaxed/simple;
	bh=tMnnXuPi+SlyqXqXmRsx4Gx3vlbIxwZYt0lrc4Vx8TM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9Ck8tp1dG2SHclW7LqNenJOZQ7Cy/3Z3CTr5fEfXWWebo4O7NY7wM4m+tW9rp7S1hUdFvprZGH9SSConuKp6eOmJmyunzKk5aTaZc+5DXkbfRBOIS90g/9hkEGLhqkLLufevxAWhZ1RNAULGYGDhC2UlDGWY7OKKsXGDK8ubtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=oOYNBQ7N; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="oOYNBQ7N"
Received: from francesco-nb (unknown [81.0.251.149])
	by mail11.truemail.it (Postfix) with ESMTPA id 0097722BA0;
	Tue,  6 Oct 2026 23:24:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1791321876;
	bh=xikyVEMlNs2e/HBpNM9BkmXFnszCMbxeC6ukLrXFPa4=; h=From:To:Subject;
	b=oOYNBQ7NJqLxLJFlzLwTCbhyCO4QZznFs05+cPLGLK7/QnjVJZMHKEr8fQ141PcB1
	 BPddnX9CWkcsTCCIzn9zcUhyj5NcSQzl15VKgdZHHmB8TVDtQfsRGt0P/DkogZLbiF
	 vuiVT5LUGx7pdbgkU8Z+zDhXcoVfDwfgOYxQIOsAiZPurvP2Xk6KO7YmchnoSUyw8u
	 G4V8UPaqYRJSo/GHciarRM4VeH6+YzSY7IS3IkZcsJLDcHilsYKZeHVGpjO0jzfP7r
	 m1HZFNL+RZKwGQBxi4IGu1wbZp2r9rDPwy3qYUuOGrCWaxThiRK8H2OPtBW0gSwzRT
	 OoE6R0H/TficQ==
Date: Tue, 6 Oct 2026 23:24:31 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Vitor Soares <ivitro@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>,
	Vitor Soares <vitor.soares@toradex.com>,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-kernel@vger.kernel.org, baochen.qiang@oss.qualcomm.com,
	kang.yang@oss.qualcomm.com
Subject: Re: [PATCH ath-next v4] wifi: ath12k: advertise interface MAC
 address pool
Message-ID: <20261006212431.GA113439@francesco-nb>
References: <20260922200643.1133491-2-ivitro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922200643.1133491-2-ivitro@gmail.com>

Hello,
just a gentle ping

On Tue, Sep 22, 2026 at 09:06:42PM +0100, Vitor Soares wrote:
> From: Vitor Soares <vitor.soares@toradex.com>
> 
> ath12k supports creating vdevs with addresses provided by mac80211.
> Userspace can already make concurrent interfaces work by explicitly
> assigning different locally administered addresses.

[...]

> Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> Tested-on: QCC2072 hw1.0 PCI WLAN.COL.1.0.c2-00074-QCACOLSWPL_V1_TO_SILICONZ-1
> 
> Assisted-by: LLM
> Signed-off-by: Vitor Soares <vitor.soares@toradex.com>
> Tested-by: Kang Yang <kang.yang@oss.qualcomm.com>

Any plan or concern on merging this?

Francesco


