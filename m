Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D9C3C196B;
	Fri,  1 May 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777644014; cv=none; b=lD9Gi+ik6/eMkbINqIfBJ1ZpItNNFr7oJW6vMKr3IdmOE0ZnPArb+mB+ewaHmzLm6bp6ENofT61yu6wHpsdWdWI0yrsIeAzhTIh1UAfVGGbkUOPKLw8g8B10QnrRCZY5q8ePwHgzK6ar1gR6Cr3+ARCQCTCVWQ8xk/iAPCezeXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777644014; c=relaxed/simple;
	bh=e9qq+VwXLefAq4gTECeQmQftjSoYyeTGHieCtYm/GNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jAV9pVMWMdsi6JrXhnc00q20m3MlKcec3/nyfLD3YXA0IBkzU+Laik9WajBJiCbNIaTpTJhM01f3V+YVSl++vogr5u7ebJu667nIomM78dSyxZ92gmRicNj/bSufXWgT4HX6a+uO7PrA9JIHtG0t/31RcZ2dCQ9VzfTnd5CNmEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miD4z4sA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miD4z4sA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0395CC2BCB4;
	Fri,  1 May 2026 13:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777644013;
	bh=e9qq+VwXLefAq4gTECeQmQftjSoYyeTGHieCtYm/GNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=miD4z4sAu+2Nxj3yLh8APL1hMcsNfokQiP+Ck63ukHOsSx6b1rQZB5LufDIfeqaUw
	 36LGRLYQwMxmSLXpwZCzo51cPgrW9oOaUKhaCHc2vTF3beXibjleS+0wYugts7swKA
	 K4/KpLQ5RnazFfAIdoXCPO/HcemiCmlhQ9zpP3ah1WlEhN8ECtR/3oTbVU/eJAsWl8
	 ZvfvLYqf4X39EWHWJcSq/NcAj0nraceTyQjksNKh9zfDoGymXjCQ7WKno3dP4hiGza
	 +Eyi/AdF1gw3CVn8jbletKDGzQ0JVrVPX1stm8EXqX+fpMqaht+kngCbxVSvN7zIN1
	 N8XczX3/pOuSw==
Date: Fri, 1 May 2026 19:29:56 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Cc: andersson@kernel.org, konradybcio@kernel.org,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org, robh@kernel.org,
	krzk+dt@kernel.org, conor+dt@kernel.org,
	robin.clark@oss.qualcomm.com, sean@poorly.run,
	akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com, marijn.suijten@somainline.org,
	airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
	dikshita.agarwal@oss.qualcomm.com, bod@kernel.org,
	mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, jjohnson@kernel.org, mathieu.poirier@linaro.org,
	trilokkumar.soni@oss.qualcomm.com, pavan.kondeti@oss.qualcomm.com,
	jorge.ramirez@oss.qualcomm.com, tonyh@qti.qualcomm.com,
	vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
	op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com, linux-kernel@vger.kernel.org,
	Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH v4 07/15] soc: qcom: mdtloader: Switch to generic PAS TZ
 APIs
Message-ID: <afSx3GpKhCpUIWv4@sumit-xelite>
References: <20260427095603.1157963-1-sumit.garg@kernel.org>
 <20260427095603.1157963-8-sumit.garg@kernel.org>
 <20260429134208.pqo67sh3jkvsa5ka@hu-mojha-hyd.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429134208.pqo67sh3jkvsa5ka@hu-mojha-hyd.qualcomm.com>

On Wed, Apr 29, 2026 at 07:12:08PM +0530, Mukesh Ojha wrote:
> On Mon, Apr 27, 2026 at 03:25:55PM +0530, Sumit Garg wrote:
> > From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > 
> > Switch mdtloader client driver over to generic PAS TZ APIs. Generic PAS
> > TZ service allows to support multiple TZ implementation backends like QTEE
> > based SCM PAS service, OP-TEE based PAS service and any further future TZ
> > backend service.
> > 
> > Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> > ---
> >  drivers/soc/qcom/mdt_loader.c       | 12 ++++++------
> >  include/linux/soc/qcom/mdt_loader.h |  6 +++---
> >  2 files changed, 9 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/soc/qcom/mdt_loader.c b/drivers/soc/qcom/mdt_loader.c
> > index c004d444d698..fdde7eda538a 100644
> > --- a/drivers/soc/qcom/mdt_loader.c
> > +++ b/drivers/soc/qcom/mdt_loader.c
> > @@ -13,7 +13,7 @@
> >  #include <linux/firmware.h>
> >  #include <linux/kernel.h>
> >  #include <linux/module.h>
> > -#include <linux/firmware/qcom/qcom_scm.h>
> > +#include <linux/firmware/qcom/qcom_pas.h>
> >  #include <linux/sizes.h>
> >  #include <linux/slab.h>
> >  #include <linux/soc/qcom/mdt_loader.h>
> > @@ -229,7 +229,7 @@ EXPORT_SYMBOL_GPL(qcom_mdt_read_metadata);
> >  
> >  static int __qcom_mdt_pas_init(struct device *dev, const struct firmware *fw,
> >  			       const char *fw_name, int pas_id, phys_addr_t mem_phys,
> > -			       struct qcom_scm_pas_context *ctx)
> > +			       struct qcom_pas_context *ctx)
> >  {
> >  	const struct elf32_phdr *phdrs;
> >  	const struct elf32_phdr *phdr;
> > @@ -271,7 +271,7 @@ static int __qcom_mdt_pas_init(struct device *dev, const struct firmware *fw,
> >  		goto out;
> >  	}
> >  
> > -	ret = qcom_scm_pas_init_image(pas_id, metadata, metadata_len, ctx);
> > +	ret = qcom_pas_init_image(pas_id, metadata, metadata_len, ctx);
> >  	kfree(metadata);
> >  	if (ret) {
> >  		/* Invalid firmware metadata */
> > @@ -280,7 +280,7 @@ static int __qcom_mdt_pas_init(struct device *dev, const struct firmware *fw,
> >  	}
> >  
> >  	if (relocate) {
> > -		ret = qcom_scm_pas_mem_setup(pas_id, mem_phys, max_addr - min_addr);
> > +		ret = qcom_pas_mem_setup(pas_id, mem_phys, max_addr - min_addr);
> >  		if (ret) {
> >  			/* Unable to set up relocation */
> >  			dev_err(dev, "error %d setting up firmware %s\n", ret, fw_name);
> > @@ -472,7 +472,7 @@ EXPORT_SYMBOL_GPL(qcom_mdt_load);
> >   * firmware segments (e.g., .bXX files). Authentication of the segments done
> >   * by a separate call.
> >   *
> > - * The PAS context must be initialized using qcom_scm_pas_context_init()
> > + * The PAS context must be initialized using qcom_pas_context_init()
> 
> Should devm_qcom_pas_context_alloc() now

Ack.

> 
> >   * prior to invoking this function.
> >   *
> >   * @ctx:        Pointer to the PAS (Peripheral Authentication Service) context
> > @@ -483,7 +483,7 @@ EXPORT_SYMBOL_GPL(qcom_mdt_load);
> >   *
> >   * Return: 0 on success or a negative error code on failure.
> >   */
> > -int qcom_mdt_pas_load(struct qcom_scm_pas_context *ctx, const struct firmware *fw,
> > +int qcom_mdt_pas_load(struct qcom_pas_context *ctx, const struct firmware *fw,
> >  		      const char *firmware, void *mem_region, phys_addr_t *reloc_base)
> >  {
> >  	int ret;
> > diff --git a/include/linux/soc/qcom/mdt_loader.h b/include/linux/soc/qcom/mdt_loader.h
> > index 82372e0db0a1..142409555425 100644
> > --- a/include/linux/soc/qcom/mdt_loader.h
> > +++ b/include/linux/soc/qcom/mdt_loader.h
> > @@ -10,7 +10,7 @@
> >  
> >  struct device;
> >  struct firmware;
> > -struct qcom_scm_pas_context;
> > +struct qcom_pas_context;
> >  
> >  #if IS_ENABLED(CONFIG_QCOM_MDT_LOADER)
> >  
> > @@ -20,7 +20,7 @@ int qcom_mdt_load(struct device *dev, const struct firmware *fw,
> >  		  phys_addr_t mem_phys, size_t mem_size,
> >  		  phys_addr_t *reloc_base);
> >  
> > -int qcom_mdt_pas_load(struct qcom_scm_pas_context *ctx, const struct firmware *fw,
> > +int qcom_mdt_pas_load(struct qcom_pas_context *ctx, const struct firmware *fw,
> >  		      const char *firmware, void *mem_region, phys_addr_t *reloc_base);
> >  
> >  int qcom_mdt_load_no_init(struct device *dev, const struct firmware *fw,
> > @@ -45,7 +45,7 @@ static inline int qcom_mdt_load(struct device *dev, const struct firmware *fw,
> >  	return -ENODEV;
> >  }
> >  
> > -static inline int qcom_mdt_pas_load(struct qcom_scm_pas_context *ctx,
> > +static inline int qcom_mdt_pas_load(struct qcom_pas_context *ctx,
> >  				    const struct firmware *fw, const char *firmware,
> >  				    void *mem_region, phys_addr_t *reloc_base)
> >  {
> > -- 
> > 2.51.0
> > 
> 
> With above nit
> 
> Reviewed-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

Thanks.

-Sumit
