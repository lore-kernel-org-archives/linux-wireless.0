Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:17018 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0CROnX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 10:43:23 -0400
Subject: Re: [PATCH 2.6.32] iwlwifi: fix nfreed--
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Greg KH <gregkh@suse.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
In-Reply-To: <20100318142933.GB4063@dhcp-lab-161.englab.brq.redhat.com>
References: <6cf6b73e1003141144l5a549309xfc627fa7cb7bf817@mail.gmail.com>
	 <1268758859.2446.595.camel@rchatre-DESK>
	 <20100318142419.GA3904@dhcp-lab-161.englab.brq.redhat.com>
	 <20100318142933.GB4063@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain
Date: Thu, 18 Mar 2010 08:39:55 -0700
Message-Id: <1268926795.7892.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Gruszka,

On Thu, 2010-03-18 at 07:29 -0700, Stanislaw Gruszka wrote:
> During backporting of a120e912eb51e347f36c71b60a1d13af74d30e83
> ("iwlwifi: sanity check before counting number of tfds can be free")
> we forget one hunk, what make lot of messages "free more than
> tfds_in_queue" show up in dmesg.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-tx.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
> index f449f06..cf5ac00 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> @@ -1096,7 +1096,6 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
>  			priv->cfg->ops->lib->txq_inval_byte_cnt_tbl(priv, txq);
>  
>  		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
> -		nfreed++;
>  	}
>  	return nfreed;
>  }

Thanks for catch this one, it puzzle me a lot because I am using the
latest code and did not realize the "nfreed++" still there in the
backport version.

Wey

