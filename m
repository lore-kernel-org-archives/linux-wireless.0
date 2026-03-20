Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9144B29ACF6;
	Fri, 20 Mar 2026 06:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773988483; cv=none; b=JWm3/pEwGx4IPX59wrrR1vwurVXE4BJ9Vo4u+4nlN2aAODN23zIYN1EVQrWrQfcB9Veh+nW7Ym9PAzxgsdOUt393xYFBSPc80hpE9c9ltqrGym3nBiElmbWdUrTS6QjUUgKW74Qei+l/IydARZ40CrjOSu0ZQuJ+t5nXK3Exdv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773988483; c=relaxed/simple;
	bh=ciBHZnV+9yK+pIZcszoVm6DXvUTdjLGIKLPHuMtuItY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I85SF3omPCe8b7QhLfAYwLx3uMd09+JJyNjvYarDrVbE2G6CWRvgnzOXdSM5+QAF47hV/Qo+yfymxK0SAu/b2jNCevBmy6lf07gSdu3rtZWnYqeMrJjrxQCezCs406vDCpZCFV/iUxOk4FgMQ5Xk9nfsVh4s9cIeFOjEhXoGEY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hr7l1y+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hr7l1y+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92777C4CEF7;
	Fri, 20 Mar 2026 06:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773988483;
	bh=ciBHZnV+9yK+pIZcszoVm6DXvUTdjLGIKLPHuMtuItY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hr7l1y+J0EUPPlpaW2DMMsHVzKVQ5OVSvbaNwSgYhTHQkMwKVkDsbd71TtGyDHkN3
	 1cK74opYxwtw1SavLwjkeH+Sf9NX5d3IOTuWLfCD71nUEDlaMAiTYi0CsULoeq0WqR
	 A3tY/OdzY6/Qe/wUjnHOqb27ckhJs6N/HxluZyrg=
Date: Fri, 20 Mar 2026 07:34:22 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Lucid Duck <lucid_duck@justthetip.ca>
Cc: sean.wang@kernel.org, nbd@nbd.name, lorenzo@kernel.org,
	linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
	morrownr@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v4] wifi: mt76: mt7921: fix txpower reporting from rate
 power configuration
Message-ID: <2026032054-backroom-nearby-53b2@gregkh>
References: <20260319203854.30479-1-lucid_duck@justthetip.ca>
 <20260320011727.77939-1-lucid_duck@justthetip.ca>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320011727.77939-1-lucid_duck@justthetip.ca>

On Thu, Mar 19, 2026 at 06:17:27PM -0700, Lucid Duck wrote:
> Note for stable backport: this patch uses mt76_tx_power_path_delta()
> which was introduced in commit 56e38675c5bd ("mt76: support power delta
> calculation for 5 TX paths"). That commit renamed the older
> mt76_tx_power_nss_delta() and is needed as a prerequisite for the
> backport to compile.
> 
> For stable kernels that don't have 56e3867, a trivial substitution of
> mt76_tx_power_nss_delta for mt76_tx_power_path_delta produces identical
> results for 1-4 chain devices (the lookup tables match exactly).
> 
> Reported-by: sam8641 (compile failure on 6.12.74)

This "note for stable backport" will get lost, sorry.  Can you provide
working backports to stable@vger.kernel.org when this lands in Linus's
tree?

thanks,

greg k-h
