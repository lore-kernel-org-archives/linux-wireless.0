Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132173624B3;
	Wed,  1 Jul 2026 05:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782884228; cv=none; b=NqUy+ma3iu6JnsFWhDNPSkuSZZsSB6HxZw5/1lNEhFA/BttjOwXlSFkjaAfWriMMNnWOkMvLcG0pD165Me2r2jpdNiBJgsXUq/AA8zMZcvi07PsEcld3ncQGs3nVg+p+/2LR8GypTxipBHR42v4uNpW036TMGbst62T+oRbeK6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782884228; c=relaxed/simple;
	bh=32HqC6YK7qwV+gA/FX6GsxiHJbXny44ENICuqdqO7JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RcVU393VS/mG8ATAm9IaWh4k01YvUP305QZq/SqKKtF21dDRW9NFVY6NnLpcCf2ms1Ga5KmfZsrtUEfu9b0T5hockqu68geTUQfFaKmJMMukkyMvikpYsJiqpXinYU+07Z3PhNl3PULbGSaJ0hMXIesDhZ93S9TkYj3nRpNsb7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cvu3oWYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cvu3oWYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE451F000E9;
	Wed,  1 Jul 2026 05:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782884226;
	bh=AxpIkGUR3B/YQ+use+jlgeTg1Rp3sEV28YNx2zBhiBo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cvu3oWYo7MvnOYf+fng4McUfNgKTxtvvPTsKPCovTBnop/zsHeV+5xoq0S0wGuQZo
	 NDZ/50FVKK/c7equFbh2mTBsm3B29ywpsQc7MUicYWLPOHp8ftk9d9ou6Zv0h4vwHa
	 ugxgIZwqihSxbLQza8Y2Nn5x9szQNgH9/m5QPvQqhqn3FzhFRIfZfYWnjNOof6axQ1
	 2x/nCi1CTOmOHj9Qw8wI7wirCSVR4hautUVK6XcunMFvOL2XkSU1vdll90oJhAKJQJ
	 cEJNcPPoUNVKPx85p8uZdSen2xELIsFevFn4unA0DyKIxqgE8XgZ71e8f/yYhQLTLT
	 mJp/klMAcBY8A==
Date: Wed, 1 Jul 2026 11:06:49 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: andersson@kernel.org, linux-arm-msm@vger.kernel.org,
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org, konradybcio@kernel.org,
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
	robin.clark@oss.qualcomm.com, sean@poorly.run,
	akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com, marijn.suijten@somainline.org,
	airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
	bod@kernel.org, mchehab@kernel.org, elder@kernel.org,
	andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, jjohnson@kernel.org,
	mathieu.poirier@linaro.org, trilokkumar.soni@oss.qualcomm.com,
	mukesh.ojha@oss.qualcomm.com, pavan.kondeti@oss.qualcomm.com,
	jorge.ramirez@oss.qualcomm.com, tonyh@qti.qualcomm.com,
	vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
	op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH v8 07/14] remoteproc: qcom: Select QCOM_PAS generic
 service
Message-ID: <akSncWwMc9tntyD4@sumit-xelite>
References: <20260626133440.692849-1-sumit.garg@kernel.org>
 <20260626133440.692849-8-sumit.garg@kernel.org>
 <64e425ab-dddc-4221-81d3-3283e2961bea@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64e425ab-dddc-4221-81d3-3283e2961bea@oss.qualcomm.com>

Hi Konrad,

On Tue, Jun 30, 2026 at 02:37:59PM +0200, Konrad Dybcio wrote:
> On 6/26/26 3:34 PM, Sumit Garg wrote:
> > From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > 
> > Select PAS generic service driver to enable support for multiple PAS
> > backends like OP-TEE in addition to SCM.
> > 
> > Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
> > Tested-by: Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com> # IPQ9650
> > Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > ---
> >  drivers/remoteproc/Kconfig | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
> > index c521c744e7db..65befdbfa5f7 100644
> > --- a/drivers/remoteproc/Kconfig
> > +++ b/drivers/remoteproc/Kconfig
> > @@ -210,6 +210,7 @@ config QCOM_Q6V5_MSS
> >  	select QCOM_Q6V5_COMMON
> >  	select QCOM_RPROC_COMMON
> >  	select QCOM_SCM
> > +	select QCOM_PAS
> 
> This is a NOP, SCM already requires QCOM_PAS

That's true but I think we should rather have explicit modules
dependencies whose APIs are being used by their clients. QCOM_SCM is a
special module in this case exporting direct SCM calls apart from being
the backend for the PAS service.

I would prefer explicit dependencies but let me know if you feel
strongly otherwise.

> 
> >  	help
> >  	  Say y here to support the Qualcomm self-authenticating modem
> >  	  subsystem based on Hexagon V5. The TrustZone based system is
> > @@ -230,6 +231,7 @@ config QCOM_Q6V5_PAS
> >  	select QCOM_Q6V5_COMMON
> >  	select QCOM_RPROC_COMMON
> >  	select QCOM_SCM
> > +	select QCOM_PAS
> 
> Likewise
> 
> >  	help
> >  	  Say y here to support the TrustZone based Peripheral Image Loader for
> >  	  the Qualcomm remote processors. This is commonly used to control
> > @@ -282,7 +284,7 @@ config QCOM_WCNSS_PIL
> >  	select QCOM_MDT_LOADER
> >  	select QCOM_PIL_INFO
> >  	select QCOM_RPROC_COMMON
> > -	select QCOM_SCM
> > +	select QCOM_PAS
> 
> This is OK
> 
> _however_
> 
> It leads to a situation where no back-ends can be enabled

The TEE backend is enabled by default if ARCH_QCOM is enabled, if you
agree then we can similarly enable SCM backend too.

-Sumit
