Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472BB4756C6;
	Tue,  1 Sep 2026 09:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788255472; cv=none; b=fXyDtjn6CuKxIU3nrc0TCiG/A2cbsy5dMvHiuvtKC4PyLswUI26d0tZOoJa2aLZchfQUYpadFwVpPY1O2x4Xt6AVHWVUa8QJ72bQv3gx7XlfikQqNmDS3OoxX4or+nORj5xsvUfP4Vpva/BJhfJoFkJNY2En8PSnVugiAqK1m7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788255472; c=relaxed/simple;
	bh=xyiHZ8eCHA8Ex+gxojy6zdg2J/qRqTMXTXsbIjIWnw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mPbrlBJkDZHaA49fhI2Fx6KUrQBG1gWpc6VPUGNmGXwiw7DVr1+cmZngkOhQGC9hF/7NOUPpeQGWXUD6UGugxyfrpegypUdo6HVF8KaDPVhc6z3QweOfIm3KBKCz7YmdyfMz97X38mBsCcyv8AtI2ShWxApdnkApIym87AqNi+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YliBS9Bh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YliBS9Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073211F000E9;
	Tue,  1 Sep 2026 09:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788255460;
	bh=SWjUKAF7YFFnyw5e+qfcEAcM53/3OiOmPglVRHrDtv4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YliBS9BhYwvnURng67uiMMNbJsKzxT/pRy2CSYg9GKPwq43vdOWFwHCzaZ3YBf7xN
	 oX73CPhYZPhzhkZpN9SKTz11II86Pz5znF6SeCY0to1aReeyJQ7fzGIY77CNoGk5wu
	 UHR2oyeV9b0hPUeFYWv1WrlobJC1+LQ1zM1TOjPo=
Date: Tue, 1 Sep 2026 11:37:36 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Yi Cong <cong.yi@linux.dev>
Cc: error27@gmail.com, linux-staging@lists.linux.dev,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Yi Cong <yicong@kylinos.cn>
Subject: Re: [PATCH v3 0/4] staging: rtl8723bs: fix several memory-safety bugs
Message-ID: <2026090127-enrage-diaper-1c6f@gregkh>
References: <20260731011856.2006363-1-cong.yi@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731011856.2006363-1-cong.yi@linux.dev>

On Fri, Jul 31, 2026 at 09:18:52AM +0800, Yi Cong wrote:
> From: Yi Cong <yicong@kylinos.cn>
> 
> This small series fixes four memory-safety / resource-management bugs in
> the rtl8723bs SDIO staging driver.
> 
> v3:
>  - Add tag "Assisted-by" for each patch.

Please see:
	https://lore.kernel.org/r/2026080354-skater-urgent-31b2@gregkh

sorry,

greg k-h
