Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37AB929827E;
	Thu, 26 Mar 2026 08:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774515019; cv=none; b=IwcTovHt5UmlAzMfoTnMkMZHlacBJ2Mq7BW+9KtxPX9gdfHoONtIgzAlYxKMSltUHS5p7TKczfacm/LFDhfE1A4sMqVNr+p0jf/Isjo9NdrWQlo4rZ9cnbw7b1fS2gg+teMH83RK0PqnUxurcMM5DatdY4cZGBbd4eoM/gxC3Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774515019; c=relaxed/simple;
	bh=Nk3OQJcQa7+IWGZDgf0ivm4hL2jKChEzfHAOrtGBL30=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SWM5s2p9rNuIMTwEBZ9mg6NenB/Omb+VUYMUNbJCzXVTUdvT+awH+dNvbR6HiGFo+iKgPKmJYNSPY7rQnpP4pPIpf1sWTeMjPmXowhWAexRS5B9id2/IW805gPiqHVt2ViXWtCsqfqpBjiBlJ7iD3wleENK+zgrdPzv3AW7hJn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eWGx2gOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eWGx2gOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42667C116C6;
	Thu, 26 Mar 2026 08:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774515019;
	bh=Nk3OQJcQa7+IWGZDgf0ivm4hL2jKChEzfHAOrtGBL30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eWGx2gOLvfHG1xA6EpBU5XssaH7AfwFrQA3TL8MLeYvE58DFfYB+nnd8vYfaFzkd5
	 tZa3gLuhJniQtc+eMnqm0Ci4fM8aZ8bZw0zdRPKw8aPsmlkX0QrttqDtSHEKcGgU0P
	 eSuGGXg+6WgNmt5i6568+PjflSOR56src4Ur83Ye/WgmFoofV3I6YFNt3sF/wd8bf3
	 4D3T+8od5S/QtunojXburPPXiBzJzjIyK4/8BljTxruiOtlHbtOQXSsvFooGr9s8mY
	 ENWjxKH8Ox3u0OzttcoWYRmtEVP+sj1YLfb6OvbG9+iC2I2DZ6VyEUFE/c+JHNVoVu
	 SyL5V108Zuppg==
Date: Thu, 26 Mar 2026 14:20:01 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org, andersson@kernel.org,
	konradybcio@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run,
	akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com, marijn.suijten@somainline.org,
	airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
	dikshita.agarwal@oss.qualcomm.com, bod@kernel.org,
	mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, jjohnson@kernel.org, mathieu.poirier@linaro.org,
	trilokkumar.soni@oss.qualcomm.com, mukesh.ojha@oss.qualcomm.com,
	pavan.kondeti@oss.qualcomm.com, jorge.ramirez@oss.qualcomm.com,
	tonyh@qti.qualcomm.com, vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
	op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com, Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH 10/14] drm/msm: Switch to generic PAS TZ APIs
Message-ID: <acTzOTUVL6uYQZwh@sumit-xelite>
References: <20260306105027.290375-1-sumit.garg@kernel.org>
 <20260306105027.290375-11-sumit.garg@kernel.org>
 <v4ffww2r4ljqqbmvsc5jcr4ztqjbpfb42xryjeuz4abqiwup3a@2gfeelhjzzz4>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v4ffww2r4ljqqbmvsc5jcr4ztqjbpfb42xryjeuz4abqiwup3a@2gfeelhjzzz4>

On Wed, Mar 25, 2026 at 06:34:18AM +0200, Dmitry Baryshkov wrote:
> On Fri, Mar 06, 2026 at 04:20:23PM +0530, Sumit Garg wrote:
> > From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > 
> > Switch drm/msm client drivers over to generic PAS TZ APIs. Generic PAS
> > TZ service allows to support multiple TZ implementation backends like QTEE
> > based SCM PAS service, OP-TEE based PAS service and any further future TZ
> > backend service.
> > 
> > Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > ---
> >  drivers/gpu/drm/msm/adreno/a5xx_gpu.c   |  4 ++--
> >  drivers/gpu/drm/msm/adreno/adreno_gpu.c | 11 ++++++-----
> >  2 files changed, 8 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
> > index ef9fd6171af7..3283852f9a14 100644
> > --- a/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
> > +++ b/drivers/gpu/drm/msm/adreno/a5xx_gpu.c
> > @@ -5,7 +5,7 @@
> >  #include <linux/kernel.h>
> >  #include <linux/types.h>
> >  #include <linux/cpumask.h>
> > -#include <linux/firmware/qcom/qcom_scm.h>
> > +#include <linux/firmware/qcom/qcom_pas.h>
> 
> Missing `select QCOM_PAS`.

Sure, I will add that in next spin.

-Sumit

> 
> 
> >  #include <linux/pm_opp.h>
> >  #include <linux/nvmem-consumer.h>
> >  #include <linux/slab.h>
> > @@ -653,7 +653,7 @@ static int a5xx_zap_shader_resume(struct msm_gpu *gpu)
> >  	if (adreno_is_a506(adreno_gpu))
> >  		return 0;
> >  
> > -	ret = qcom_scm_set_remote_state(SCM_GPU_ZAP_SHADER_RESUME, GPU_PAS_ID);
> > +	ret = qcom_pas_set_remote_state(SCM_GPU_ZAP_SHADER_RESUME, GPU_PAS_ID);
> >  	if (ret)
> >  		DRM_ERROR("%s: zap-shader resume failed: %d\n",
> >  			gpu->name, ret);
> 
> -- 
> With best wishes
> Dmitry
> 
