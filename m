Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792559316;
	b=P1iC0B/0RdGJ5vwC/StLF9oqy0Mf3pg64GPoaC4WoDKq3V6hkNPO+WMssOuExMZwcDmP
	 UDv4ihrP+Dus1QPdH5VNiTAKyGMNvYW86357+WQipMKC3iCfJoJeL7e7GNpIQagDINuO1
	 DP6PvqDYuSuimxgKhweh05hkB2y06G3lJaOSVUZZbLVqdskbGtMeHN7+wtJGZE4EXNcjp
	 /CD3lx7FuokQ61RcTWmWCLM0H8nd5SEhHtXi3LodOKxEmOXf+o4ui8rUAE9ukMkdv0wxV
	 Ug/0bhSOOEYZiQi94of2ZU8uqKl/u+g/IiiDH/PIuN+C6Xa1hSDKWKqqb4rNYaoswWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792559316;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=QkX0db4m40DGwuOP5Wxaheolr6mMnrhzfPJ3IEdQt68=;
	b=0GNXXZ5PypdV9nKqzlwmT3YXy/oCe+4+V76sJMpF2zS0vGRqi6jnG2doDxtyIujL0cO3
	 dursTQwVSpGKq1kAFF0OJd2d5H2WoduK42SxO/Y+LJb0k8ReyiYHsc7KQrI/TVIwQSvDC
	 5u7TCGZJsmACoflHmCX+zPbbIvqeIio6UqFRfCkrL4+5DQ7Rb9gSODskYLNvLjUqW6zkD
	 xhS903GmxuWE94USm4Z+/3q3ILN0raMLdMosQgERLxVhRXm1nDwkTEv3w/PjQwoVXKJ+f
	 YsUzqNiBehrhIhVmOMYO94f8MGOjre5SxTKrNYsYCvk3R+mEK9V7kiMd0kzN9PKwWqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cAuON3Sh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3087B606A319;
	Wed, 21 Oct 2026 05:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cAuON3Sh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D111F000CE;
	Wed, 21 Oct 2026 05:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792559316;
	bh=QkX0db4m40DGwuOP5Wxaheolr6mMnrhzfPJ3IEdQt68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cAuON3ShW2wBA2gcnkl7H4wIdlmQH0gfJo8zFiGjopvTEQF0v4/2jKDmQmvvU1Ywu
	 gGc5fVTJoSUrA733BvZsMnAM+Lmt4LpCW4OHoCNVM/OQPw90v/9c2F25Dn1xNN7fSl
	 Gfk7ZjX+bttaxZlGhiEojpJlrc1udHDC8i9mMnAiGqpP40GhW5ih+HLMRNPqUbRoVz
	 XHL2EkDcQaIXl6GQxM1mXGmYo/TUnPtruTkrCnYc2qtzWu6iTAC3Mfp5n9PPmvjPiu
	 KbkMzgXVHCYRGXVrQ8bUnnHxss7C06HvmWHzTHhYHnUz303empsFAUUkr4iQQ7GjSa
	 JonhXcFMqk7NA==
Date: Wed, 21 Oct 2026 07:08:19 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: Shawn Guo <shengchao.guo@oss.qualcomm.com>, 
	Yingying Tang <yingying.tang@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, ath12k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, yintang@qti.qualcomm.com
Subject: Re: [PATCH ath-next] wifi: ath12k: change MAC buffer ring size to
 4096
Message-ID: <5ygj4wgwd7tvuma4f4cmvc46cw2lhabmruk2nxeh44iktn3owg@cxzsmik52fh2>
References: <20260610031358.2043716-1-yingying.tang@oss.qualcomm.com>
 <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <atcr70WFLxp8zreK@QCOM-aGQu4IUr3Y>

+ Jeff

On Tue, Oct 20, 2026 at 04:53:03PM +0800, Shawn Guo wrote:
> + linux-arm-msm
> 
> On Tue, Jun 09, 2026 at 08:13:58PM -0700, Yingying Tang wrote:
> > For WCN7850, MAC buffer ring size is updated to 2048 in
> > 955df16f2a4c3 ("wifi: ath12k: change MAC buffer ring size to 2048")
> > to increase peak throughput.
> > 
> > But during the RX process, a phenomenon can still be observed where
> > the throughput drops by about 30% from its peak value and then recovers,
> > and this behavior repeats during RX.
> > 
> > After increasing MAC buffer ring size to 4096, the data rate drop has
> > gone.
> > 
> > Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.1.1.c5-00302-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1.115823.3
> > 
> > Signed-off-by: Yingying Tang <yingying.tang@oss.qualcomm.com>
> 
> FYI, in case someone else runs into this: with this change (merged in
> v7.3), WiFi on my Lenovo Yoga Slim 7x (X1E80100, WCN7850 hw2.0) stopped
> working with the older firmware that Debian trixie still ships
> (firmware-atheros 20250410-2):
> 
>   WLAN.HMT.1.0.c5-00481-QCAHMTSWPL_V1.0_V2.0_SILICONZ-3
> 
> Probe and firmware download succeed, but every WMI command times out
> once the interface is brought up:
> 
>   ath12k_wifi7_pci 0004:01:00.0: wmi command 16387 timeout
>   ath12k_wifi7_pci 0004:01:00.0: failed to send WMI_PDEV_SET_PARAM cmd
>   ath12k_wifi7_pci 0004:01:00.0: failed to enable PMF QOS: -11
>   ath12k_wifi7_pci 0004:01:00.0: fail to start mac operations in pdev idx 0 ret -11
> 
> Bisecting ath12k between v7.2 and v7.3 lands on this commit, and
> reverting it on v7.3 brings WiFi back with the old firmware.
> 
> Unmodified v7.3 works fine after updating to the current linux-firmware
> image:
> 
>   WLAN.HMT.1.1.c7-00108-QCAHMTSWPL_V1.0_V2.0_SILICONZ_UPSTREAM-3
> 
> On Debian trixie that one is available from trixie-backports
> (firmware-atheros 20260916-1~bpo13+1).
> 
> So nothing needs fixing on the driver side. I'm just leaving this here
> so that anyone who sees "wmi command ... timeout" on WCN7850 after a
> kernel upgrade knows to update the firmware first.
> 

Thanks Shawn for reporting this regression!

Jeff, this is unacceptable in two grounds:

1. Driver change *must not* break userspace, in this case the old firmware. The
driver must maintain backwards compatibility even if the data rate drops with
the old firmware. This is the promise, kernel strives to keep up from the
start.

2. The offending patch didn't mention anything about the firmware
incompatibility, which is too bad. How does the users be notified of needing a
firmware update?

So I'd suggest reverting this commit and come up with a new change that
preserves the backwards compatibility with the old firmware while fixing the
throughput issue.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
