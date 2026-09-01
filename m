Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BB846EC62;
	Tue,  1 Sep 2026 08:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788249988; cv=none; b=eWZtqCU7TiQgz8u4yHWBocI4C9ubQbuJPa4Nfc0vi7cfv1PryMnSD7DUG9iJtfACY93vlqViQNXdsmsUEme6SyS5/bb9qjrHLAdLK02oaz1wAdSoQjoYS/EzpETIO2fnP78e0JPqdXJFuNqXi9ncQdccODFvYQr8BfxPHn0GDGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788249988; c=relaxed/simple;
	bh=cQ0VKjzzBn4lnIvRRKhBBZXsQ5qGxOVYBI+CNGVX48k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxpTODSln+JdAOPIlhdwrDfDoWbIS74DvmXwOH3vqkYw6dOl32eXGBsRp8mNcw2jJY6i8PqbvHndh9GMVs0WAYC+RFcG5NdRQiF61O5tSw87FxpatsLjXMHO8ovcTLahcr4TKHIZa9mwWL9tLNo/waZLSQ5YvVhIwkD+p7+z//4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbRbsjfv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbRbsjfv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8E81F00A3D;
	Tue,  1 Sep 2026 08:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788249984;
	bh=U9bwqjzCxpQGyOH6T5XiHxQafAKabtxYiX65cyonlc0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kbRbsjfvc7p41dNhCRd2hJuYih9Hfi2wcLb95PXqKL41rRU/08xQg2zhgmP0p7/UX
	 aCBgNqAafGb1u8ZcpV3k6B+OHqaBRbiISXeL4UtUncjnK+Rkxqh/VfIp6jGUvNRGeZ
	 +i52Nc8J3gVpipR6XllPURBs8ykNJDroZTrGft+YKuTcRN75wcS7wNMsS48WVqiMOt
	 JRE6ODRvQobQ+4jwJVT4xHZXgvTSjxLefA1lS95WGdjzhEnW2jGLTGsB/2sNiR2EXU
	 4WfdzLpOi4oHlA9BHHoKVkb8ueK9mfVj1mgyRJzPN0cBqTneA65FZxWhRsXKhYISQg
	 MzDDcdQAG9hGA==
Date: Tue, 1 Sep 2026 10:06:05 +0200
From: Manivannan Sadhasivam <mani@kernel.org>
To: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, 
	Ilpo =?utf-8?B?SsOkcnZpbmVu?= <ilpo.jarvinen@linux.intel.com>, Jingoo Han <jingoohan1@gmail.com>, 
	Lorenzo Pieralisi <lpieralisi@kernel.org>, Rob Herring <robh@kernel.org>, 
	Jeff Johnson <jjohnson@kernel.org>, Bartosz Golaszewski <brgl@bgdev.pl>, 
	Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, mhi@lists.linux.dev, linux-wireless@vger.kernel.org, 
	ath11k@lists.infradead.org, qiang.yu@oss.qualcomm.com
Subject: Re: [PATCH v5 4/6] bus: mhi: host: Add support for Bandwidth scale
Message-ID: <tm33xb3nrq7v6ezoewvn34rteg47pmow27kda5mdmoufsckw7t@tzssd2mqm5zt>
References: <20260819-bwscale-v5-0-6dea79786b37@oss.qualcomm.com>
 <20260819-bwscale-v5-4-6dea79786b37@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260819-bwscale-v5-4-6dea79786b37@oss.qualcomm.com>

On Wed, Aug 19, 2026 at 06:55:55PM +0530, Krishna Chaitanya Chundru wrote:
> As per MHI spec v1.2, sec 14, MHI supports bandwidth scaling to reduce
> power consumption. MHI bandwidth scaling is advertised by devices that
> contain the bandwidth scaling capability registers. If enabled, the device
> aggregates bandwidth requirements and sends them to the host through
> dedicated mhi event ring. After the host performs the bandwidth switch,
> it sends an acknowledgment by ringing a doorbell.
> 
> if the host supports bandwidth scaling events, then it must set
> BW_CFG.ENABLED bit, set BW_CFG.DB_CHAN_ID to the channel ID to the
> doorbell that will be used by the host to communicate the bandwidth
> scaling status and BW_CFG.ER_INDEX to the index for the event ring
> to which the device should send bandwidth scaling request in the
> bandwidth scaling capability register.
> 
> As part of mmio init check if the bw scale capability is present or not,
> if present advertise host supports bw scale by setting all the required
> fields.
> 
> MHI layer will only forward the bw scaling request to the controller
> driver since MHI doesn't have any idea about transport layer used by
> the controller, it is responsibility of the controller driver to do actual
> bw scaling and then pass status to the MHI. MHI will response back to the
> device based up on the status of the bw scale received.
> 
> Add a new get_misc_doorbell() to get doorbell for misc capabilities to
> use the doorbell with mhi events like MHI BW scale etc.
> 
> Use workqueue & mutex for the bw scale events as the pci_set_target_speed()
> which will called by the mhi controller driver can sleep.
> 
> Co-developed-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
> Signed-off-by: Qiang Yu <qiang.yu@oss.qualcomm.com>
> Signed-off-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
> ---
>  drivers/bus/mhi/common.h        |  13 +++++
>  drivers/bus/mhi/host/init.c     |  93 +++++++++++++++++++++++++++++++--
>  drivers/bus/mhi/host/internal.h |   6 ++-
>  drivers/bus/mhi/host/main.c     | 113 +++++++++++++++++++++++++++++++++++++++-
>  drivers/bus/mhi/host/pm.c       |  10 +++-
>  drivers/bus/mhi/host/trace.h    |   7 +++
>  include/linux/mhi.h             |  13 +++++
>  7 files changed, 247 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/bus/mhi/common.h b/drivers/bus/mhi/common.h
> index 4c316f3d5a68..267260901a41 100644
> --- a/drivers/bus/mhi/common.h
> +++ b/drivers/bus/mhi/common.h
> @@ -215,6 +215,19 @@
>  #define MHI_CAP_ID_MAX_TRB_LEN		0x5
>  #define MHI_CAP_ID_MAX			0x6
>  
> +/* MHI Bandwidth scaling offsets */
> +#define MHI_BW_SCALE_CFG_OFFSET		0x4
> +#define MHI_BW_SCALE_CAP_ID		(3)
> +#define MHI_BW_SCALE_DB_CHAN_ID		GENMASK(31, 25)
> +#define MHI_BW_SCALE_ENABLED		BIT(24)
> +#define MHI_BW_SCALE_ER_INDEX		GENMASK(23, 19)
> +
> +#define MHI_TRE_GET_EV_BW_REQ_SEQ(tre)	FIELD_GET(GENMASK(15, 8), (MHI_TRE_GET_DWORD(tre, 0)))
> +
> +#define MHI_BW_SCALE_RESULT(status, seq)	(FIELD_PREP(GENMASK(11, 8), status) | \
> +						FIELD_PREP(GENMASK(7, 0), seq))
> +#define MHI_BW_SCALE_NACK			0xF

0xf

> +
>  enum mhi_pkt_type {
>  	MHI_PKT_TYPE_INVALID = 0x0,
>  	MHI_PKT_TYPE_NOOP_CMD = 0x1,
> diff --git a/drivers/bus/mhi/host/init.c b/drivers/bus/mhi/host/init.c
> index 32db4aa4bbe8..d0975b6c2df0 100644
> --- a/drivers/bus/mhi/host/init.c
> +++ b/drivers/bus/mhi/host/init.c
> @@ -497,10 +497,66 @@ static int mhi_find_capability(struct mhi_controller *mhi_cntrl, u32 capability)
>  	return 0;
>  }
>  
> +static int mhi_get_er_index(struct mhi_controller *mhi_cntrl,
> +			    enum mhi_er_data_type type)
> +{
> +	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
> +	int i;
> +
> +	/* Find event ring for requested type */
> +	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
> +		if (mhi_event->data_type == type)
> +			return mhi_event->er_index;
> +	}
> +
> +	return -ENOENT;
> +}
> +
> +static int mhi_init_bw_scale(struct mhi_controller *mhi_cntrl,
> +			     int bw_scale_db)
> +{
> +	struct device *dev = &mhi_cntrl->mhi_dev->dev;
> +	struct mhi_event *mhi_event;
> +	u32 bw_cfg_offset, val;
> +	int er_index, i;
> +
> +	bw_cfg_offset = mhi_find_capability(mhi_cntrl, MHI_BW_SCALE_CAP_ID);
> +	if (!bw_cfg_offset)
> +		return 0;
> +
> +	er_index = mhi_get_er_index(mhi_cntrl, MHI_ER_BW_SCALE);
> +	if (er_index < 0)
> +		return er_index;
> +
> +	/* Initialize BW scale event ring resources */
> +	mhi_event = mhi_cntrl->mhi_event;
> +	for (i = 0; i < mhi_cntrl->total_ev_rings; i++, mhi_event++) {
> +		if (mhi_event->data_type == MHI_ER_BW_SCALE) {
> +			INIT_WORK(&mhi_event->work, mhi_process_ev_work);
> +			mutex_init(&mhi_event->mutex);

Why do you need mutex only for this event and not for other events?

> +			break;
> +		}
> +	}
> +
> +	bw_cfg_offset += MHI_BW_SCALE_CFG_OFFSET;
> +
> +	/* Advertise host support */
> +	val = FIELD_PREP(MHI_BW_SCALE_DB_CHAN_ID, bw_scale_db) |
> +			 FIELD_PREP(MHI_BW_SCALE_ER_INDEX, er_index) |
> +			 MHI_BW_SCALE_ENABLED;
> +
> +	mhi_write_reg(mhi_cntrl, mhi_cntrl->regs, bw_cfg_offset, val);
> +
> +	dev_dbg(dev, "Bandwidth scaling setup complete with event ring: %d\n",
> +		er_index);
> +
> +	return 0;
> +}
> +
>  int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
>  {
> -	u32 val;
> -	int i, ret;
> +	u32 val, chdb_offset;
> +	int i, ret, doorbell = 0;
>  	struct mhi_chan *mhi_chan;
>  	struct mhi_event *mhi_event;
>  	void __iomem *base = mhi_cntrl->regs;
> @@ -581,6 +637,8 @@ int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
>  		return -ERANGE;
>  	}
>  
> +	chdb_offset = val;
> +
>  	/* Setup wake db */
>  	mhi_cntrl->wake_db = base + val + (8 * MHI_DEV_WAKE_DB);
>  	mhi_cntrl->wake_set = false;
> @@ -634,6 +692,17 @@ int mhi_init_mmio(struct mhi_controller *mhi_cntrl)
>  		return ret;
>  	}
>  
> +	if (mhi_cntrl->get_misc_doorbell)
> +		doorbell = mhi_cntrl->get_misc_doorbell(mhi_cntrl, MHI_ER_BW_SCALE);

Why can't you add the doorbell number to 'mhi_event_config'?

> +
> +	if (doorbell > 0) {
> +		ret = mhi_init_bw_scale(mhi_cntrl, doorbell);
> +		if (!ret)
> +			mhi_cntrl->bw_scale_db = base + chdb_offset + (8 * doorbell);
> +		else
> +			dev_warn(dev, "Failed to setup bandwidth scaling: %d\n", ret);
> +	}
> +
>  	return 0;
>  }
>  
> @@ -778,6 +847,9 @@ static int parse_ev_cfg(struct mhi_controller *mhi_cntrl,
>  		case MHI_ER_CTRL:
>  			mhi_event->process_event = mhi_process_ctrl_ev_ring;
>  			break;
> +		case MHI_ER_BW_SCALE:
> +			mhi_event->process_event = mhi_process_bw_scale_ev_ring;
> +			break;
>  		default:
>  			dev_err(dev, "Event Ring type not supported\n");
>  			goto error_ev_cfg;
> @@ -1001,10 +1073,12 @@ int mhi_register_controller(struct mhi_controller *mhi_cntrl,
>  
>  		mhi_event->mhi_cntrl = mhi_cntrl;
>  		spin_lock_init(&mhi_event->lock);
> -		if (mhi_event->data_type == MHI_ER_CTRL)
> +		if (mhi_event->data_type == MHI_ER_CTRL) {
>  			tasklet_init(&mhi_event->task, mhi_ctrl_ev_task,
>  				     (ulong)mhi_event);
> -		else
> +		} else if (mhi_event->data_type == MHI_ER_BW_SCALE) {
> +		/* BW scale resources will be initialized in mhi_init_mmio() if capability exists */

But you are just skipping the tasklet here. Provide an apt reason for that.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
