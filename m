Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C578328B71;
	Thu, 30 Jul 2026 07:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785397194; cv=none; b=lueeH5OSsxYrWE/rTEYyoQDeIunqpL4zlzohSjIDr3cLdGmGkCY/Sy9S2TXuAJDW9kI5R9VVJ4jBrnVy5xE5YOZWiKlz3aW+IqvOxub9ekVMAnpjwIRaaQelmDws/DCqMY3o9xjtMqEhh9kEU17TV+T4zuui+bi6478E+ihPZ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785397194; c=relaxed/simple;
	bh=3P112EVIHzjzV+HRW3sycyMQC8VD6eJ4jtjN/mILxzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tNmgyk/yWBYQV6jo8I62NN4cawr+3vTc5h41VLQDmp/rZWsRGqQg+fE8aPp4v8gpucxNS6Q+bNf33pMMIsortCuioIUjaxb6sruLC52tbVRcx8vTahOXTbnTR5MPdIrQnmr+X0N012a/BvPi2t3RTwK4JJaB7s6uJckevrs+tIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8U9t4NX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8U9t4NX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051A41F000E9;
	Thu, 30 Jul 2026 07:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785397192;
	bh=svLe7s4QjDfCesasTA8vn+XDkYAYv+K8Z0uBYaXxNEk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e8U9t4NXHdEc2hbcy8XNay9RnFTFhWgYKw3EoY+v2IVGBZK1z9nPZBZosXh6qsW2D
	 R6i14C85FJdNGeNR9XfxMGHWEdkdGIsXOKKmD1BC/q0oJmKOG8GTNwjbyJgF21aaOu
	 6s1qEdIlULS8e4rScGzw4nGjwTGOoWryW+ITE2Jw=
Date: Thu, 30 Jul 2026 09:38:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yi Cong <cong.yi@linux.dev>
Cc: linux-staging@lists.linux.dev, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Yi Cong <yicong@kylinos.cn>
Subject: Re: [PATCH v2 2/4] staging: rtl8723bs: fix double free when
 register_netdev() fails
Message-ID: <2026073007-handoff-pajamas-63a3@gregkh>
References: <20260730060000.1944670-1-cong.yi@linux.dev>
 <20260730060000.1944670-3-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730060000.1944670-3-cong.yi@linux.dev>

On Thu, Jul 30, 2026 at 01:59:58PM +0800, Yi Cong wrote:
> From: Yi Cong <yicong@kylinos.cn>
> 
> When register_netdev() fails, the error_register_netdev label in
> _rtw_drv_register_netdev() frees the adapter and netdev via
> rtw_free_drv_sw()/rtw_free_netdev() and then returns _FAIL.
> 
> The caller rtw_drv_init(), however, still holds a non-NULL if1 on this
> failure path and jumps to free_if1, where rtw_sdio_if1_deinit() invokes
> rtw_free_drv_sw() and rtw_free_netdev() again on the same already-freed
> objects, resulting in a double free / use-after-free.
> 
> Drop the freeing from error_register_netdev and let rtw_sdio_if1_deinit()
> perform the tear-down, which is the single owner for this path.
> 
> Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
> Signed-off-by: Yi Cong <yicong@kylinos.cn>

You forgot to use the proper "Assisted-by:" tags for this series, right?

thanks,

greg k-h
