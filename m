Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEF429BD9A;
	Wed, 14 Oct 2026 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983062; cv=none; b=ulFX9ZP8IoxCtEiAtjRYoNG0AE08mCDCYeqRFneAZ3WpBANwljWgD/LGwLV9WU63Jvka9nuWqylloV2f37GRkRg50pYMnjj2JF5Nd2vtpg6w8mJRLs/KRIPRLPSVNpFsIPOIg0nx1fCcz0kPlCRskCyrnGSpnwfcLz8NKUQj+nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983062; c=relaxed/simple;
	bh=ptLnCE7zOBxkxahejBJE/p797FO+YNScPSLPSPJvccw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hm/KEd9zAeWD+xML6zaVY+RJMc2yWlggqCfyYuBJOaXw1ZhAG0nYMq7mQa+MmYmrgw5yfbfGfCVLGOnnTVZBLSF5yk+9JpDHcn10A30hAmpXljQ2K7lGaI7GwnURujnYOTYLwK9B2Fdt55uVQZD6ZklhtdyBTuAArxPfyNeRExw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dW7D++mx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dW7D++mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B071F000FF;
	Wed, 14 Oct 2026 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791983060;
	bh=b6rZoCWrpJX5Mv+LHM4nf6Kjojq4EI7a7291JjA+f5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dW7D++mxv3TtkcE+UnApDVfLyqZcFih9O1Dg/jaXxPi96f4WBUFJPKWuo15MpiViC
	 zEzy885Yf0itUumKS/0qXahCpOdzZySIgxKHceTZrhs78cmbeWQAP8RDjLhRaJbUdF
	 E04wIYPOh+yXasjry0/2Df6sTTlYmdiDK2DJb+3Y=
Date: Wed, 14 Oct 2026 15:04:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Message-ID: <2026101452-chapter-friday-dada@gregkh>
References: <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
 <d403e88ca53841fba87190764e2a45cc@realtek.com>
 <2026100746-delicate-carless-a04c@gregkh>
 <3028b229a6fbe02d2bcfa30c497b6a768ba8c928@linux.dev>
 <2026101046-transport-unnerving-96de@gregkh>
 <4464409846710dfa13134265f0f99523714cfa92@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4464409846710dfa13134265f0f99523714cfa92@linux.dev>

On Mon, Oct 12, 2026 at 11:31:57AM +0000, Luka Gejak wrote:
> October 10, 2026 at 12:18 PM, "Greg KH" <gregkh@linuxfoundation.org> wrote:
> 
> 
> > 
> > On Wed, Oct 07, 2026 at 10:35:25AM +0000, Luka Gejak wrote:
> > 
> > > 
> [...]
> > >  
> > >  Hi Greg,
> > >  
> > >  I have sent the patch, and I think you are going to like this
> > >  number: 66186 deletions
> > > 
> > Very happy :)
> > 
> > > 
> > > Not sure what people are going to use to learn though. It seems to
> > >  me everyone is repeating the same patches.
> > > 
> > Yeah, we need to dig up some more out-of-tree kernel code to add it for
> > them to churn on. But really, this is a good thing, it's nice to see
> > real support for this hardware finally.
> 
> Hi Greg,
> 
> As both of you and I know there are not many young people in the
> kernel community and the steep learning curve is a big reason for that.

Really?  We average about 200-250 new contributors every kernel release
until recently when it's shot up to 600-700 if not more.  So we don't
seem to have a lack of new contributors for some reason...

> I was not sure whether you were joking or not about the comment
> above so I decided to find that appropriate replacement for staging
> rtl8723bs. After searching I found this interesting xradio driver,
> which is a mac80211 based driver for some orange pies and other devices.
> It is around 18,000 lines of code and upon check it out I fixed bunch
> of security issues per se and lockups that caused kernel to hang and it
> is decently stable. I'm not gonna claim some extreme stability but it
> is at least usable and it has many coding standard issues. It is a good
> candidate because newcomers would be learning the modern architecture
> and on top of it there is a lot of janitor work so people can learn
> the workflow and etc. Link is [1] so you can see for yourself and tell
> me what you think about it.

If you think it is worth adding, sure, but normally we need someone to
actually care about it getting into the tree (i.e. real users
somewhere).  Also look at the bottom of the readme, shouldn't the
existing in-kernel driver just be tweaked for this hardware instead?

thanks,

greg k-h
