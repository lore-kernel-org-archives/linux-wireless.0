Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ABF16726E;
	Fri, 30 Aug 2024 08:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725005482; cv=none; b=flljD9ncViGPSR9xqER54QlCiBJ8e1KVCXABOmOJ0zsKVELJUKq5xqdcECKLIQDGlKa/eQOTk3vgWDpPqvyElOD/qqwdGarMoffK0AivNNVnhjnRrcWnE0wPr13kZFdVWuuUyVfNz+Nfbj+R3cwzTF+Qtgb3YcQjC0Vk2Lb9nCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725005482; c=relaxed/simple;
	bh=rd3nISwAehWjdOcs1GVJg4MzXQbtEid0uaCFsHgCbmY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=czEvOnnaLSKGUozlqWsqGdQGkt9cSj8nSf9ZZ9IYNUeo/kT2+iC6KfDHyzuF2ONtpqR4UbJQa2BbA4TQqPYEggHltIXqreuI4ZwmqBX+NQtFbW8UnJbEJ01M890IjbpahjBMd8BPGZ+Cmxg8fNEtjah9XBhb9V98JllaQiMMz8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Acrgp50l; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Acrgp50l"
Received: from gaggiata.pivistrello.it (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id BDC8B21155;
	Fri, 30 Aug 2024 10:11:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1725005477;
	bh=rd3nISwAehWjdOcs1GVJg4MzXQbtEid0uaCFsHgCbmY=;
	h=Received:From:To:Subject;
	b=Acrgp50lJsxzVAaBE3d6LNoZgXVaSsHn0MQno3hOnpIMUbdkXF8Z8h6ANkcTE9Npt
	 SYPTysUNhn2G6TFTmmjxmloANGV/+XDFPbB2SG6dGzuIFnPweFQFi3fCAqfYW4aq7a
	 bRFbE90kvgOkNoKuevl7X4/GxVQfDoDEUCwmQ4FcPnsotxbLUgzwFuJLCsk1cfVdTJ
	 CiGTynWhaY4Rn/mdq4WLMIOHzTYAztDCpsvVzGbq2gAdJUZxyRI2GWdTUv1LfnY8G8
	 W9gQ1BKp3Ig52TZIHBXtsKBezcFfI6b8hUsCV1UCK3d87ISaKV7MgdvnISl588W2LI
	 vRvOXuF4bTqXw==
Received: by gaggiata.pivistrello.it (Postfix, from userid 1000)
	id 741B87FCD4; Fri, 30 Aug 2024 10:11:17 +0200 (CEST)
Date: Fri, 30 Aug 2024 10:11:17 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: David Lin <yu-hao.lin@nxp.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	briannorris@chromium.org, kvalo@kernel.org, francesco@dolcini.it,
	tsung-hsien.hsieh@nxp.com
Subject: Re: [PATCH] wifi: mwifiex: fix firmware crash for AP DFS mode
Message-ID: <ZtF-pbt6-wXWe3zb@gaggiata.pivistrello.it>
References: <20240830080719.826142-1-yu-hao.lin@nxp.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830080719.826142-1-yu-hao.lin@nxp.com>

On Fri, Aug 30, 2024 at 04:07:19PM +0800, David Lin wrote:
> Firmware crashes when AP works on a DFS channel and radar detection occurs.
> This patch fixes the issue, also add "fake_radar_detect" entry to mimic
> radar detection for testing purpose.

Is this issue generic or specific to some firmware version or Wi-Fi device?

Francesco


