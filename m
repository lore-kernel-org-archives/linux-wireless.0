Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33358 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751454AbdFHHt7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Jun 2017 03:49:59 -0400
Date: Thu, 8 Jun 2017 09:49:54 +0200
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "luca@coelho.fi" <luca@coelho.fi>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Coelho, Luciano" <luciano.coelho@intel.com>,
        linuxwifi <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:INTEL WIRELESS WIFI LINK (iwlwifi)"
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [linuxwifi] [PATCH] net: wireless: intel: iwlwifi: dvm: fix tid
 mask
Message-ID: <20170608074954.qihkavvqdtwn4zmp@macchiaveli> (sfid-20170608_095022_342538_FFAE8E41)
References: <20170607223354.22399-1-kirkseraph@gmail.com>
 <0BA3FCBA62E2DC44AF3030971E174FB3E5520A41@hasmsx107.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB3E5520A41@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 08, 2017 at 06:31:01AM +0000, Grumbach, Emmanuel wrote:
> Hi,

Hi,

> True, OTOH we need tid to be 8 sometimes. We *just* need to make sure
> that we don't index tid_data with this. Hence I think the proper fix is:
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
> index 06ac3f1..16a8646 100644
> --- a/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
> +++ b/drivers/net/wireless/intel/iwlwifi/dvm/tx.c
> @@ -1190,11 +1190,11 @@ void iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_cmd_buffer *rxb)
>                                 next_reclaimed;
>                         IWL_DEBUG_TX_REPLY(priv, "Next reclaimed packet:%d\n",
>                                                   next_reclaimed);
> +                       iwlagn_check_ratid_empty(priv, sta_id, tid);
>                 }
> 
>                 iwl_trans_reclaim(priv->trans, txq_id, ssn, &skbs);
> 
> -               iwlagn_check_ratid_empty(priv, sta_id, tid);
>                 freed = 0;
> 
>                 /* process frames */

I can confirm it works. You can add my Tested-By.

Thanks,
Seraph
