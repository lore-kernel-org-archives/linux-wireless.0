Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC863BBFBC;
	Wed,  1 Jul 2026 07:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782891331; cv=none; b=aRSwdz/JYBuTVA4VVGNuHHBfoLFXNvVP8z2RJwMxDxroc0fBVpTTDsJK9jZKyFho+vY0xr7r28XJqSkjDpayr1yB9flORckADEoHDogdkydpNMjw4v2R4jgYBv17peXK3OZWqHl/1nyGEeeqAuxvAZFG3nt8wZzZ96KQXufyFGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782891331; c=relaxed/simple;
	bh=AS/o9NhNXcOqBn4KHzybhUDDFTKtJyf5CY6etHArtWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RblTjHInc8NU7TXw/KM/oMN3Y0H+l6LS+aq6bl5JSaw8ZLzSYNDy/KDR1SnSt+jfEeOVKnCrVtj5Z54lgQeS2M43NxM+5hgf1OobkEpKd2W1eK0ZPPeMvNGvp0hPD3p8lD1MLuPpMVhUce9LFWhX8qgEwy/3d5tQOCOD+oHkdmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZXazlFd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZXazlFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644DB1F000E9;
	Wed,  1 Jul 2026 07:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782891329;
	bh=kGEf3SeZYgm8dFwF9x3Ecpp2cSEz1doIyoAXcK2ExLk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZXazlFdkvJYULlF2W57c/IBuIHM5bksnlkhn4JZaEZIsV9u2rxfmgVZDWz/sZzM9
	 TqD+fNJP5Gg69c84izlEtOmv1hXtdA+ae6nzZAfzliStrhO5HzV2wLG4qKigklMyQv
	 q28Z1sdgYOeeXbjkxyXoJBjXn2qaEFZMf68fviUkyMhpHgkLiOBmo+aVmig+ldi9vy
	 o6htvUykVi39Ey/ZaVPRgmG7pTTIyJ8j7dR3CBapLqAzJnt7VK0UPPNcDN8kaUUbyn
	 XLt68BOXBx0lyB/fVegvFbVv6Y+rwjzrNI8Hs+1xo1QRp6g/qlg07x/zc2QicnMnSz
	 GHT3VNckuu4Qw==
Date: Wed, 1 Jul 2026 13:05:12 +0530
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
Subject: Re: [PATCH v8 04/14] remoteproc: qcom_q6v5_pas: Switch over to
 generic PAS TZ APIs
Message-ID: <akTDMOvu5H9qMDUK@sumit-xelite>
References: <20260626133440.692849-1-sumit.garg@kernel.org>
 <20260626133440.692849-5-sumit.garg@kernel.org>
 <594cf827-819e-4262-9dff-a35c7f69f86b@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <594cf827-819e-4262-9dff-a35c7f69f86b@oss.qualcomm.com>

On Tue, Jun 30, 2026 at 02:34:59PM +0200, Konrad Dybcio wrote:
> On 6/26/26 3:34 PM, Sumit Garg wrote:
> > From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > 
> > Switch qcom_q6v5_pas client driver over to generic PAS TZ APIs. Generic PAS
> > TZ service allows to support multiple TZ implementation backends like QTEE
> > based SCM PAS service, OP-TEE based PAS service and any further future TZ
> > backend service.
> > 
> > Since qcom_q6v5_pas depends on MDT loader for PAS firmware loading, it
> > has to be switched over to generic PAS APIs in this commit to avoid any
> > build issues.
> > 
> > Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
> > Tested-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com> # Lemans
> > Tested-by: Vignesh Viswanathan <vignesh.viswanathan@oss.qualcomm.com> # IPQ9650
> > Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > ---
> 
> I assume that the leftover qcom_scm_assign_mem() will be handled
> in a separate effort, presumably through something like FF-A lend
> on the backend

The qcom_scm_assign_mem() is already handled as a SiP call in TF-A.

> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 

Thanks.

-Sumit
