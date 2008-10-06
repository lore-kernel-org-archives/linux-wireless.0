Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57908 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYJFVm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 17:42:59 -0400
Date: Mon, 6 Oct 2008 17:42:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 5/7] iwlwifi: take a valid antenna upon rate scale init
Message-ID: <20081006214220.GO3448@tuxdriver.com> (sfid-20081006_234303_614536_1061D04C)
References: <1223280333-4383-1-git-send-email-yi.zhu@intel.com> <1223280333-4383-2-git-send-email-yi.zhu@intel.com> <1223280333-4383-3-git-send-email-yi.zhu@intel.com> <1223280333-4383-4-git-send-email-yi.zhu@intel.com> <1223280333-4383-5-git-send-email-yi.zhu@intel.com> <1223280333-4383-6-git-send-email-yi.zhu@intel.com> <20081006212511.GL3448@tuxdriver.com> <1ba2fa240810061439x219f5c0l2223c85042b39cee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240810061439x219f5c0l2223c85042b39cee@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 06, 2008 at 11:39:49PM +0200, Tomas Winkler wrote:
> On Mon, Oct 6, 2008 at 11:25 PM, John W. Linville
> <linville@tuxdriver.com> wrote:

> >> diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
> >> index c1300fb..56a3f0c 100644
> >> --- a/drivers/net/wireless/iwlwifi/iwl-5000.c
> >> +++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
> >> @@ -811,10 +811,14 @@ static int iwl5000_hw_set_hw_params(struct iwl_priv *priv)
> >>
> >>       switch (priv->hw_rev & CSR_HW_REV_TYPE_MSK) {
> >>       case CSR_HW_REV_TYPE_5100:
> >> +             priv->hw_params.tx_chains_num = 1;
> >> +             priv->hw_params.rx_chains_num = 2;
> >> +             priv->hw_params.valid_tx_ant = ANT_B;
> >> +             priv->hw_params.valid_rx_ant = ANT_AB;
> >> +             break;
> >>       case CSR_HW_REV_TYPE_5150:
> >>               priv->hw_params.tx_chains_num = 1;
> >>               priv->hw_params.rx_chains_num = 2;
> >> -             /* FIXME: move to ANT_A, ANT_B, ANT_C enum */
> >>               priv->hw_params.valid_tx_ant = ANT_A;
> >>               priv->hw_params.valid_rx_ant = ANT_AB;
> >>               break;
> >
> > Do you realize that both clauses are the same (i.e. there is no
> > functional change)?  How is this useful?
> 
> The change is tx_ant

Quite right.

> > You need to change the comment...
> 
> Right

Thanks.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
