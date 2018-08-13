Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:33905 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728540AbeHMWuW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 18:50:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id y5-v6so8032476pgv.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 13:06:39 -0700 (PDT)
Date: Mon, 13 Aug 2018 13:06:35 -0700
From: Brian Norris <briannorris@chromium.org>
To: Govind Singh <govinds@codeaurora.org>
Cc: niklas.cassel@linaro.org, bjorn.andersson@linaro.org,
        david.brown@linaro.org, andy.gross@linaro.org, robh@kernel.org,
        devicetree@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 6/6] ath10k: Add QMI message handshake for wcn3990
 client
Message-ID: <20180813200633.GA38014@ban.mtv.corp.google.com> (sfid-20180813_220642_708870_F4A97FAA)
References: <20180723123428.12993-1-govinds@codeaurora.org>
 <20180723123428.12993-7-govinds@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180723123428.12993-7-govinds@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Govind,

On Mon, Jul 23, 2018 at 06:04:28PM +0530, Govind Singh wrote:
> Add WCN3990 QMI client handshakes for Q6 integrated WLAN connectivity
> subsystem. This layer is responsible for communicating qmi control
> messages to wifi fw QMI service using QMI messaging protocol.
> 
> Qualcomm MSM Interface(QMI) is a messaging format used to communicate
> between components running between remote processors with underlying
> transport layer based on integrated chipset(shared memory) or
> discrete chipset(PCI/USB/SDIO/UART).
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig  |    1 +
>  drivers/net/wireless/ath/ath10k/Makefile |    4 +-
>  drivers/net/wireless/ath/ath10k/core.c   |    6 +-
>  drivers/net/wireless/ath/ath10k/core.h   |    2 +
>  drivers/net/wireless/ath/ath10k/qmi.c    | 1019 ++++++++++++++++++++++
>  drivers/net/wireless/ath/ath10k/qmi.h    |  129 +++
>  drivers/net/wireless/ath/ath10k/snoc.c   |  262 +++++-
>  drivers/net/wireless/ath/ath10k/snoc.h   |    4 +
>  8 files changed, 1417 insertions(+), 10 deletions(-)
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/qmi.h
> 

> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> new file mode 100644
> index 000000000000..d91499a7354c
> --- /dev/null
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -0,0 +1,1019 @@

...

> +int ath10k_qmi_deinit(struct ath10k *ar)
> +{
> +	struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
> +	struct ath10k_qmi *qmi = ar_snoc->qmi;
> +
> +	cancel_work_sync(&qmi->event_work);
> +	destroy_workqueue(qmi->event_wq);

I believe this is incorrect ordering. You should not be destroying the
work queue that handles QMI event responses before you release the QMI
handle. As it stands, this means you segfault during 'rmmod'.

> +	qmi_handle_release(&qmi->qmi_hdl);

I think this should be:

	qmi_handle_release(&qmi->qmi_hdl);
	cancel_work_sync(&qmi->event_work);
	destroy_workqueue(qmi->event_wq);

> +	qmi = NULL;

This assignment is pointless, as 'qmi' is a local variable. Maybe you
meant to clear the struct member, as a precaution? So this would be:

	ar_snoc->qmi = NULL;

Brian

> +
> +	return 0;
> +} 
