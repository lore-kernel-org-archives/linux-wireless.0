Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44871 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab0DHUpR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 16:45:17 -0400
Date: Thu, 8 Apr 2010 16:41:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: avoid warning by using result of
	iwl_send_cmd_pdu in iwl_sta_init_lq
Message-ID: <20100408204123.GF2999@tuxdriver.com>
References: <1270756089-9589-1-git-send-email-linville@tuxdriver.com> <1270758273.14052.217.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1270758273.14052.217.camel@rchatre-DESK>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 08, 2010 at 01:24:33PM -0700, reinette chatre wrote:
> Hi John,
> 
> On Thu, 2010-04-08 at 12:48 -0700, John W. Linville wrote:
> > CC [M]  drivers/net/wireless/iwlwifi/iwl-sta.o
> > drivers/net/wireless/iwlwifi/iwl-sta.c: In function ‘iwl_sta_init_lq’:
> > drivers/net/wireless/iwlwifi/iwl-sta.c:461: warning: ignoring return value of ‘iwl_send_cmd_pdu’, declared with attribute warn_unused_result
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl-sta.c |    5 +++--
> >  1 files changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
> > index e34ac03..91aaf11 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-sta.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
> > @@ -458,8 +458,9 @@ static void iwl_sta_init_lq(struct iwl_priv *priv, const u8 *addr, bool is_ap)
> >  	/* Update the rate scaling for control frame Tx to AP */
> >  	link_cmd.sta_id = is_ap ? IWL_AP_ID : priv->hw_params.bcast_sta_id;
> >  
> > -	iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
> > -			       sizeof(link_cmd), &link_cmd);
> > +	if (!iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
> > +			       sizeof(link_cmd), &link_cmd))
> > +		IWL_WARN(priv, "Tx link quality reply failed\n");
> >  }
> >  
> >  /*
> 
> I made a mistake here somewhere since this is fixed in iwlwifi-2.6 but
> did not propagate to wireless-next-2.6.
> 
> Wouldn't the above print the warning on success though?

Ha, yes...

> In iwlwifi-2.6 the code looks like (whitespace broken copy&pasted) ...
> it would be nice to have the return code available in error message:
> 
>         ret = iwl_send_cmd_pdu(priv, REPLY_TX_LINK_QUALITY_CMD,
>                                sizeof(link_cmd), &link_cmd);
>         if (ret)
>                 IWL_ERR(priv, "REPLY_TX_LINK_QUALITY_CMD failed (%d)\n", ret);
> 
> If you want I can just fix my merging mistake.

Works for me!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
