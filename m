Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:11720 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997AbYICO2K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 10:28:10 -0400
Received: by fk-out-0910.google.com with SMTP id 18so2220204fkq.5
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2008 07:28:08 -0700 (PDT)
Message-ID: <1ba2fa240809030728p612f268fi718719df34f845c4@mail.gmail.com> (sfid-20080903_162823_417384_E6AA392B)
Date: Wed, 3 Sep 2008 17:28:08 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Zhu Yi" <yi.zhu@intel.com>, linville@tuxdriver.com
Subject: Re: [PATCH 31/39] iwlwifi: fix memory allocation of TX command
Cc: linux-wireless@vger.kernel.org, "Ian Schram" <ischram@telenet.be>
In-Reply-To: <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1220412419-15404-1-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-24-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-25-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-26-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-27-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-28-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-29-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-30-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-31-git-send-email-yi.zhu@intel.com>
	 <1220412419-15404-32-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2008 at 6:26 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
>
> This patch removes GFP_DMA from allocation tx command buffers
> GFP_DMA allows allocation only for memory under 16M which causes
> allocation problems suspend/resume flows.
>
> Using kmalloc is temporal solution and some consistent/coherent
> allocation schema will be more correct. Since iwlwifi hardware
> supports 64bit address this solution should work on x86 (32 and
> 64bit) for now. This patch also fixes memory freeing in error path.
>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Ian Schram <ischram@telenet.be>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>

Note: this address the same fix as

commit 49898852e6aa8a6de9a5bc0bab2cf305b3583bbf
Author: John W. Linville <linville@tuxdriver.com>
Date:   Tue Sep 2 15:07:18 2008 -0400

One line conflicts. Need just to merge the error path handling.
Tomas


>  drivers/net/wireless/iwlwifi/iwl-tx.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index 6cba5e9..68567fa 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -402,12 +402,11 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
>  /**
>  * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
>  */
> -static int iwl_tx_queue_init(struct iwl_priv *priv,
> -                            struct iwl_tx_queue *txq,
> +static int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
>                             int slots_num, u32 txq_id)
>  {
>        int i, len;
> -       int rc = 0;
> +       int ret;
>
>        /*
>         * Alloc buffer array for commands (Tx or other types of commands).
> @@ -426,19 +425,16 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
>                                continue;
>                }
>
> -               txq->cmd[i] = kmalloc(len, GFP_KERNEL | GFP_DMA);
> +               txq->cmd[i] = kmalloc(len, GFP_KERNEL);
>                if (!txq->cmd[i])
> -                       return -ENOMEM;
> +                       goto err;
>        }
>
>        /* Alloc driver data array and TFD circular buffer */
> -       rc = iwl_tx_queue_alloc(priv, txq, txq_id);
> -       if (rc) {
> -               for (i = 0; i < slots_num; i++)
> -                       kfree(txq->cmd[i]);
> +       ret = iwl_tx_queue_alloc(priv, txq, txq_id);
> +       if (ret)
> +               goto err;
>
> -               return -ENOMEM;
> -       }
>        txq->need_update = 0;
>
>        /* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
> @@ -452,6 +448,17 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
>        iwl_hw_tx_queue_init(priv, txq);
>
>        return 0;
> +err:
> +       for (i = 0; i < slots_num; i++) {
> +               kfree(txq->cmd[i]);
> +               txq->cmd[i] = NULL;
> +       }
> +
> +       if (txq_id == IWL_CMD_QUEUE_NUM) {
> +               kfree(txq->cmd[slots_num]);
> +               txq->cmd[slots_num] = NULL;
> +       }
> +       return -ENOMEM;
>  }
>  /**
>  * iwl_hw_txq_ctx_free - Free TXQ Context
> --
> 1.5.3.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
