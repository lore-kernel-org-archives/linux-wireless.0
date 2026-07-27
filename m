Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04863B47D7;
	Mon, 27 Jul 2026 16:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785168891; cv=none; b=Ln3ebO5NKjw3EHnp6NJ8H7NcSgmd33vUo2ogMzmmuTM/xqAlDxlHgvgGOqIafYgDisz424lQiAM+dTGBziBzgpF2g1sIQ5idG8q1Z07/4mhzBDYwSZVzo+8aSmiuBVL6COL8+2U1KVduEJPNOXXL7Mt6FS9DOwMa6OJw9WUHCKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785168891; c=relaxed/simple;
	bh=zAmc9VwNAQjI+fakdokYHWkCqHJYfWqRG1avIn8NcWU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=XG8E0ulSiUmHyP7bMJrJECbuLwOz9+1fmZ8bMryDHd297E+ZSOUrQa+bwHv1cBQcCTSKz3HYdQ6qsp5sV/zi6nRt1Gt48DLdtNuT9bY98FlQLqs3Gdca+eXS0strA6XLtOXxrbuFwQBdtfuEWlfZRv2e8LmWuvr+4k55rUXVpDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBbJECsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBbJECsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B49F1F000E9;
	Mon, 27 Jul 2026 16:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785168877;
	bh=iUBQr0c6cfBgnBRtRZuOkHQjVx4FPP38ZqFPQO2xjHM=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=hBbJECsjR/ABBeFVEscDgGInU4tuipfquKm7gG5w2KTUm/uHA/D34VEFtHkQjg/1K
	 miBrZ9wWjb7UgdB/p/Gn4asAgaZocJCJswhPAdaANLNor67IZaNHGkvaXS/S0LonFz
	 kT9Da4hlDcQZGfjsQYJwCbePoRGN9TMkszo9tuwGjnBa1inKlR0zwMYeejWpqwYdXq
	 qkVxnJ3S9jBKmWAyF7GkdgmHSsBwF4FkroXOhSGnc7oNMw/zHJr/klYisDdD9dti6J
	 +C+0DmF2qJXCRnrQp9h6QR5c8pzLpTZ4H6fhpwvrprOgwmWEiSkMPvTa+6907YS1RP
	 f4Oort3IcgU5A==
Date: Mon, 27 Jul 2026 11:14:35 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Luigi Santivetti <luigi.santivetti@imgtec.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jeff Johnson <jjohnson@kernel.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chen-Yu Tsai <wens@kernel.org>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	linux-pm@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, imagination@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH RFC] power: sequencing: rename pwrseq_power_on/off() to
 pwrseq_vote_on/off()
Message-ID: <20260727161435.GA1219282@bhelgaas>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-pwrseq-vote-rename-v1-1-a2029aeeac65@oss.qualcomm.com>

On Mon, Jul 27, 2026 at 11:57:38AM +0200, Bartosz Golaszewski wrote:
> The way power sequencing works means that a call to pwrseq_power_on()
> does not necessarily result in the pwrseq target being powered-on at
> that time: it may have already been powered on before. Similarly: a call
> to pwrseq_power_off() does not have to result in an actual powering off
> of resources: there may still be other users that requested a power-on
> before.
> 
> We will also introduce the concept of "non-controllable" pwrseq targets
> soon which further increases the disconnect between the naming
> convention and the actual semantics.
> 
> What consumers of pwrseq descriptors actually do is: they *vote* for a
> powering on of a given target or retract that vote. These operations
> could be called get/put in line with runtime PM but this could become
> confusing since we already provide pwrseq_get/put() for a different
> purpose.

I see the possible confusion with get/put interfaces, but "vote"
doesn't seem exactly right because it really is refcounting, not a
majority vote thing.

Maybe enable/disable is a possibility, since regulator_enable() and
regulator_disable() have the same kind of refcount behavior?

Whatever you end up with:

Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# drivers/pci

> Change the name of the two functions to pwrseq_vote_on/off() which
> better reflects their purpose and semantics. No functional change
> intended.
> 
> If at any point users need to know *when* the exact power event happens,
> we can provide that information in the form of a notifier.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> I've floated the idea to rename the two pwrseq functions from "power
> on/off" to "vote on/off". Here's a concrete proposal.
> 
> I'm sending it as an RFC but if there's agreement, I can queue it as is.
> 
> I'm doing it in a single commit that should go through the pwrseq tree
> with Acks from subsystem maintainers.
> 
> [1] https://lore.kernel.org/all/CAMRc=Mefxn81d0VUwmQgwFtffkL1=Er_1VQZCbC1Sa-Qph4t1w@mail.gmail.com/
> ---
>  Documentation/driver-api/pwrseq.rst      |  4 ++--
>  drivers/bluetooth/hci_qca.c              |  4 ++--
>  drivers/gpu/drm/imagination/pvr_power.c  |  4 ++--
>  drivers/net/wireless/ath/ath10k/snoc.c   |  6 +++---
>  drivers/pci/pwrctrl/generic.c            |  4 ++--
>  drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c |  4 ++--
>  drivers/power/sequencing/core.c          | 16 ++++++++--------
>  include/linux/pwrseq/consumer.h          |  8 ++++----
>  8 files changed, 25 insertions(+), 25 deletions(-)
> 
> diff --git a/Documentation/driver-api/pwrseq.rst b/Documentation/driver-api/pwrseq.rst
> index ad18b2326b689a41471216f3889480b11768ca82..faba5a8e3337e878c6dac0cc91d23b3577cab6fd 100644
> --- a/Documentation/driver-api/pwrseq.rst
> +++ b/Documentation/driver-api/pwrseq.rst
> @@ -50,9 +50,9 @@ Consumer interface
>  The consumer API is aimed to be as simple as possible. The driver interested in
>  getting a descriptor from the power sequencer should call pwrseq_get() and
>  specify the name of the target it wants to reach in the sequence after calling
> -pwrseq_power_up(). The descriptor can be released by calling pwrseq_put() and
> +pwrseq_vote_on(). The descriptor can be released by calling pwrseq_put() and
>  the consumer can request the powering down of its target with
> -pwrseq_power_off(). Note that there is no guarantee that pwrseq_power_off()
> +pwrseq_vote_off(). Note that there is no guarantee that pwrseq_vote_off()
>  will have any effect as there may be multiple users of the underlying resources
>  who may keep them active.
>  
> diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> index e6d107f67759f54eee2647d92bb8bfd4e68c9358..5aaabc9fb1b66eb6b24da25f77158690a2f03c84 100644
> --- a/drivers/bluetooth/hci_qca.c
> +++ b/drivers/bluetooth/hci_qca.c
> @@ -2259,7 +2259,7 @@ static void qca_power_off(struct hci_uart *hu)
>  	}
>  
>  	if (power && power->pwrseq) {
> -		pwrseq_power_off(power->pwrseq);
> +		pwrseq_vote_off(power->pwrseq);
>  		set_bit(QCA_BT_OFF, &qca->flags);
>  		return;
>          }
> @@ -2319,7 +2319,7 @@ static int qca_regulator_enable(struct qca_serdev *qcadev)
>  	int ret;
>  
>  	if (power->pwrseq)
> -		return pwrseq_power_on(power->pwrseq);
> +		return pwrseq_vote_on(power->pwrseq);
>  
>  	/* Already enabled */
>  	if (power->vregs_on)
> diff --git a/drivers/gpu/drm/imagination/pvr_power.c b/drivers/gpu/drm/imagination/pvr_power.c
> index a71d5b35601e7b996428312028a4c0542a5b1350..c6dfa2685ee64086c53281d06563e6169109c00f 100644
> --- a/drivers/gpu/drm/imagination/pvr_power.c
> +++ b/drivers/gpu/drm/imagination/pvr_power.c
> @@ -352,12 +352,12 @@ static int pvr_power_init_pwrseq(struct pvr_device *pvr_dev)
>  
>  static int pvr_power_on_sequence_pwrseq(struct pvr_device *pvr_dev)
>  {
> -	return pwrseq_power_on(pvr_dev->pwrseq);
> +	return pwrseq_vote_on(pvr_dev->pwrseq);
>  }
>  
>  static int pvr_power_off_sequence_pwrseq(struct pvr_device *pvr_dev)
>  {
> -	return pwrseq_power_off(pvr_dev->pwrseq);
> +	return pwrseq_vote_off(pvr_dev->pwrseq);
>  }
>  
>  const struct pvr_power_sequence_ops pvr_power_sequence_ops_pwrseq = {
> diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
> index 3106502275781d32d17a45a661362206144df6b3..f87e56576e29124902dccd1a21600fd3407b2922 100644
> --- a/drivers/net/wireless/ath/ath10k/snoc.c
> +++ b/drivers/net/wireless/ath/ath10k/snoc.c
> @@ -1025,7 +1025,7 @@ static int ath10k_hw_power_on(struct ath10k *ar)
>  
>  	ath10k_dbg(ar, ATH10K_DBG_SNOC, "soc power on\n");
>  
> -	ret = pwrseq_power_on(ar_snoc->pwrseq);
> +	ret = pwrseq_vote_on(ar_snoc->pwrseq);
>  	if (ret)
>  		return ret;
>  
> @@ -1042,7 +1042,7 @@ static int ath10k_hw_power_on(struct ath10k *ar)
>  vreg_off:
>  	regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
>  pwrseq_off:
> -	pwrseq_power_off(ar_snoc->pwrseq);
> +	pwrseq_vote_off(ar_snoc->pwrseq);
>  
>  	return ret;
>  }
> @@ -1060,7 +1060,7 @@ static int ath10k_hw_power_off(struct ath10k *ar)
>  	ret_vreg = regulator_bulk_disable(ar_snoc->num_vregs, ar_snoc->vregs);
>  
>  	if (ar_snoc->pwrseq)
> -		ret_seq = pwrseq_power_off(ar_snoc->pwrseq);
> +		ret_seq = pwrseq_vote_off(ar_snoc->pwrseq);
>  
>  	return ret_vreg ? : ret_seq;
>  }
> diff --git a/drivers/pci/pwrctrl/generic.c b/drivers/pci/pwrctrl/generic.c
> index a7e599d841e6289db161b19a93ba5a61d9e0ab1c..8872f6501352d7273a9b4f20589c2f74d6accc65 100644
> --- a/drivers/pci/pwrctrl/generic.c
> +++ b/drivers/pci/pwrctrl/generic.c
> @@ -29,7 +29,7 @@ static int slot_pwrctrl_power_on(struct pci_pwrctrl *pwrctrl)
>  	int ret;
>  
>  	if (slot->pwrseq) {
> -		pwrseq_power_on(slot->pwrseq);
> +		pwrseq_vote_on(slot->pwrseq);
>  		return 0;
>  	}
>  
> @@ -48,7 +48,7 @@ static int slot_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
>  						struct slot_pwrctrl, pwrctrl);
>  
>  	if (slot->pwrseq) {
> -		pwrseq_power_off(slot->pwrseq);
> +		pwrseq_vote_off(slot->pwrseq);
>  		return 0;
>  	}
>  
> diff --git a/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c b/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
> index a308bf4b5fc01d23b75db4cd396201c3ba3fe695..86822f0f645eb757455f575000f81122bce82e60 100644
> --- a/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
> +++ b/drivers/pci/pwrctrl/pci-pwrctrl-pwrseq.c
> @@ -56,7 +56,7 @@ static int pwrseq_pwrctrl_power_on(struct pci_pwrctrl *pwrctrl)
>  	struct pwrseq_pwrctrl *pwrseq = container_of(pwrctrl,
>  					   struct pwrseq_pwrctrl, pwrctrl);
>  
> -	return pwrseq_power_on(pwrseq->pwrseq);
> +	return pwrseq_vote_on(pwrseq->pwrseq);
>  }
>  
>  static int pwrseq_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
> @@ -64,7 +64,7 @@ static int pwrseq_pwrctrl_power_off(struct pci_pwrctrl *pwrctrl)
>  	struct pwrseq_pwrctrl *pwrseq = container_of(pwrctrl,
>  					   struct pwrseq_pwrctrl, pwrctrl);
>  
> -	return pwrseq_power_off(pwrseq->pwrseq);
> +	return pwrseq_vote_off(pwrseq->pwrseq);
>  }
>  
>  static int pwrseq_pwrctrl_probe(struct platform_device *pdev)
> diff --git a/drivers/power/sequencing/core.c b/drivers/power/sequencing/core.c
> index 02f42da915985339d3de507fc36dd158b0035a99..c630b14f6f2c478f05e4b2893b386aab0cddaaf5 100644
> --- a/drivers/power/sequencing/core.c
> +++ b/drivers/power/sequencing/core.c
> @@ -708,7 +708,7 @@ void pwrseq_put(struct pwrseq_desc *desc)
>  	pwrseq = desc->pwrseq;
>  
>  	if (desc->powered_on)
> -		pwrseq_power_off(desc);
> +		pwrseq_vote_off(desc);
>  
>  	kfree(desc);
>  	module_put(pwrseq->owner);
> @@ -874,7 +874,7 @@ static int pwrseq_unit_disable(struct pwrseq_device *pwrseq,
>  }
>  
>  /**
> - * pwrseq_power_on() - Issue a power-on request on behalf of the consumer
> + * pwrseq_vote_on() - Issue a power-on request on behalf of the consumer
>   *                     device.
>   * @desc: Descriptor referencing the power sequencer.
>   *
> @@ -887,7 +887,7 @@ static int pwrseq_unit_disable(struct pwrseq_device *pwrseq,
>   * Returns:
>   * 0 on success, negative error number on failure.
>   */
> -int pwrseq_power_on(struct pwrseq_desc *desc)
> +int pwrseq_vote_on(struct pwrseq_desc *desc)
>  {
>  	struct pwrseq_device *pwrseq;
>  	struct pwrseq_target *target;
> @@ -925,14 +925,14 @@ int pwrseq_power_on(struct pwrseq_desc *desc)
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(pwrseq_power_on);
> +EXPORT_SYMBOL_GPL(pwrseq_vote_on);
>  
>  /**
> - * pwrseq_power_off() - Issue a power-off request on behalf of the consumer
> + * pwrseq_vote_off() - Issue a power-off request on behalf of the consumer
>   *                      device.
>   * @desc: Descriptor referencing the power sequencer.
>   *
> - * This undoes the effects of pwrseq_power_on(). It issues a power-off request
> + * This undoes the effects of pwrseq_vote_on(). It issues a power-off request
>   * on behalf of the consumer and when the last remaining user does so, the
>   * power-down sequence will be started. If one is in progress, the function
>   * will block until it's complete and then return.
> @@ -940,7 +940,7 @@ EXPORT_SYMBOL_GPL(pwrseq_power_on);
>   * Returns:
>   * 0 on success, negative error number on failure.
>   */
> -int pwrseq_power_off(struct pwrseq_desc *desc)
> +int pwrseq_vote_off(struct pwrseq_desc *desc)
>  {
>  	struct pwrseq_device *pwrseq;
>  	struct pwrseq_unit *unit;
> @@ -966,7 +966,7 @@ int pwrseq_power_off(struct pwrseq_desc *desc)
>  
>  	return ret;
>  }
> -EXPORT_SYMBOL_GPL(pwrseq_power_off);
> +EXPORT_SYMBOL_GPL(pwrseq_vote_off);
>  
>  /**
>   * pwrseq_to_device() - Get the pwrseq device pointer from a descriptor.
> diff --git a/include/linux/pwrseq/consumer.h b/include/linux/pwrseq/consumer.h
> index 3c907c9e1885dc2958043a9a733fbe20bdf95f6e..e4d2cb321354f0cb7e1d1d72e6b5a96b94129da3 100644
> --- a/include/linux/pwrseq/consumer.h
> +++ b/include/linux/pwrseq/consumer.h
> @@ -20,8 +20,8 @@ void pwrseq_put(struct pwrseq_desc *desc);
>  struct pwrseq_desc * __must_check
>  devm_pwrseq_get(struct device *dev, const char *target);
>  
> -int pwrseq_power_on(struct pwrseq_desc *desc);
> -int pwrseq_power_off(struct pwrseq_desc *desc);
> +int pwrseq_vote_on(struct pwrseq_desc *desc);
> +int pwrseq_vote_off(struct pwrseq_desc *desc);
>  
>  struct device *pwrseq_to_device(struct pwrseq_desc *desc);
>  
> @@ -43,12 +43,12 @@ devm_pwrseq_get(struct device *dev, const char *target)
>  	return ERR_PTR(-ENOSYS);
>  }
>  
> -static inline int pwrseq_power_on(struct pwrseq_desc *desc)
> +static inline int pwrseq_vote_on(struct pwrseq_desc *desc)
>  {
>  	return -ENOSYS;
>  }
>  
> -static inline int pwrseq_power_off(struct pwrseq_desc *desc)
> +static inline int pwrseq_vote_off(struct pwrseq_desc *desc)
>  {
>  	return -ENOSYS;
>  }
> 
> ---
> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> change-id: 20260727-pwrseq-vote-rename-b7cd21032668
> 
> Best regards,
> -- 
> Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> 
