Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A8435DA68;
	Sat, 10 Oct 2026 10:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791627525; cv=none; b=L414VNBo3wIHU8ibxVg2JPyVWVQDT5AoJtPK0CpKpfM27Am0qIgqCP46Ahw1itgRLffhnEkUu0y+yle5TlY+qG20/Qvw3i/vRulWdsjxR8fegMeKiFK3vNDs5Yhfdl6EE6ba1r2n5fmdfuY/9l1dLqn7PyPFfeybbsp23Hqij+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791627525; c=relaxed/simple;
	bh=u4fS4+Gr0Z4oZ+rx5uuJu4na497BmTWbICDLerp3ZyY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AK054JhBjfizG7uGTquX/R+Xd7RFmMAuESCNzQlExLHBSo2OxZaJFaP0tPVTcQ8qzP5oHqq1CoFK4WTzSXc6br6ZI+1htGqHV0cZ2Xd8Shpudqk9VuPgH6IakSa0j8TnRbiNeD7lH4P8RpZ9Xm/mHQAu1b+jZX0OvQunZ/9LA8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFl4J+hM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFl4J+hM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86F101F000FF;
	Sat, 10 Oct 2026 10:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791627524;
	bh=PFJuhzoVrpQZuTpaRI2h9RuwqxLaHz09kowFKeLYSng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jFl4J+hMe2IvDZ3io2Qbjiww6D7DiwTQYpjNcXTFdC0GZEoSH7QtRk4fMaUQJhbti
	 QKFDc4T+S14utk5nhBj3mWaztrPgF/ZyyrLbwCr+U4RW9FLBmM/HKja+Uh0p7tXCR4
	 XBSg+m4UTnRAZwdDniyNKB+VFdJ22XumUXWWqBa4=
Date: Sat, 10 Oct 2026 12:18:39 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
Message-ID: <2026101046-transport-unnerving-96de@gregkh>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
 <d403e88ca53841fba87190764e2a45cc@realtek.com>
 <2026100746-delicate-carless-a04c@gregkh>
 <3028b229a6fbe02d2bcfa30c497b6a768ba8c928@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3028b229a6fbe02d2bcfa30c497b6a768ba8c928@linux.dev>

On Wed, Oct 07, 2026 at 10:35:25AM +0000, Luka Gejak wrote:
> October 7, 2026 at 12:06, "Greg KH" <gregkh@linuxfoundation.org mailto:gregkh@linuxfoundation.org?to=%22Greg%20KH%22%20%3Cgregkh%40linuxfoundation.org%3E > wrote:
> 
> 
> > 
> > On Wed, Oct 07, 2026 at 08:54:03AM +0000, Ping-Ke Shih wrote:
> > 
> > > 
> > > + Greg to staging rtl8723bs driver question
> > >  
> > >  Hi Greg,
> > >  
> > >  Luka Gejak <luka.gejak@linux.dev> wrote:
> > >  October 7, 2026 at 10:32, "Ping-Ke Shih" <pkshih@realtek.com
> > >  mailto:pkshih@realtek.com?to=%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wrote:
> > >  
> > >  
> > >  >
> > >  > Luka Gejak <luka.gejak@linux.dev> wrote:
> > >  >
> > >  > >
> > >  > > October 7, 2026 at 04:57, "Ping-Ke Shih" <pkshih@realtek.com
> > >  > > mailto:pkshih@realtek.com?to=%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wrote:
> > >  > >
> > >  > >
> > >  > >
> > >  > > Luka Gejak <luka.gejak@linux.dev> wrote:
> > >  > >
> > >  > > >
> > >  > > > Add the Realtek RTL8723B 802.11n chip driver: the chip operations, the
> > >  > > > power sequences, the efuse layout, the RF and IQ calibration, and the
> > >  > > > chip specific coexistence handling.
> > >  > > >
> > >  > > > The RTL8723B chip support is based on the initial work by
> > >  > > > Michael Straube <straube.linux@gmail.com>.
> > >  > > > Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> > >  > > >
> > >  > > > Co-developed-by: Michael Straube <straube.linux@gmail.com>
> > >  > > > Signed-off-by: Michael Straube <straube.linux@gmail.com>
> > >  > > > Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> > >  > > > Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> > >  > > >
> > >  > > Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> > >  > >
> > >  > >
> > >  > > Hi Ping-Ke,
> > >  > >
> > >  > > Thanks for helping and reviewing the series throughout this
> > >  > > upstreaming process. Just one question, when is the series planned to
> > >  > > be applied to rtw-next? I am planning to send a patch to staging to
> > >  > > remove staging rtl8723bs and I need to have information when is it
> > >  > > landing.
> > >  > >
> > >  > I'll merge this patchset and send pull-request tomorrow, but I think you
> > >  > should remove staging rtl8723bs until this patchset drains to upstream.
> > >  >
> > >  > Ping-Ke
> > >  >
> > >  
> > >  Ok. Thanks for information. However, by the time this series reaches
> > >  upstream, won't the merge window be closed? Therefore 2 drivers for
> > >  the same chip will exist for one kernel version, and Greg previously
> > >  said that when a driver is merged we should remove staging so there
> > >  are no two drivers for the same chip.
> > >  
> > >  Luka did rewrite RTL8723BS vendor driver (i.e. staging rtl8723bs) into
> > >  upstream rtw88 driver, and I plan to merge this patchset and send
> > >  pull-request to wireless maintainer tomorrow. However, the two drivers
> > >  are existing at this moment. 
> > >  
> > >  My question is that can Luka send a patch to remove staging rtl8723bs,
> > >  and goes via my tree? Then you don't need to wait for my pull-request
> > >  being upstream. Can it work to you?
> > > 
> > That's fine with me, delete away!
> > 
> > thanks,
> > 
> > greg k-h
> >
> 
> Hi Greg,
> 
> I have sent the patch, and I think you are going to like this
> number: 66186 deletions

Very happy :)

> Not sure what people are going to use to learn though. It seems to
> me everyone is repeating the same patches.

Yeah, we need to dig up some more out-of-tree kernel code to add it for
them to churn on.  But really, this is a good thing, it's nice to see
real support for this hardware finally.

greg k-h
