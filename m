Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:8644 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbZG0I3C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 04:29:02 -0400
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>, Roel Kluin <roel.kluin@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 27 Jul 2009 11:28:56 +0300
Subject: RE: [PATCH] iwlwifi: Read outside array bounds
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F040141D0B0DC@hasmsx504.ger.corp.intel.com>
References: <4A6B7A67.9070906@gmail.com> <1248658905.3747.97.camel@debian>
In-Reply-To: <1248658905.3747.97.camel@debian>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: Zhu, Yi
> Sent: Monday, July 27, 2009 4:42 AM
> To: Roel Kluin; Winkler, Tomas; Chatre, Reinette
> Cc: linux-wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net;
> Andrew Morton
> Subject: Re: [PATCH] iwlwifi: Read outside array bounds
> 
> On Sun, 2009-07-26 at 05:34 +0800, Roel Kluin wrote:
> > tid is bounded (above) by the size of default_tid_to_tx_fifo (17
> elements), but
> > the size of priv->stations[].tid[] is MAX_TID_COUNT (9) elements.
> 
> I think MAX_TID_COUNT should be defined as 16 or 17. Tomas?
>

In general it's 16. In practice we use only 8.
Tomas

 
> Thanks,
> -yi
> 
> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> > ---
> > diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c
> b/drivers/net/wireless/iwlwifi/iwl-tx.c
> > index 85ae7a6..e9441c6 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl-tx.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
> > @@ -1170,6 +1170,8 @@ int iwl_tx_agg_start(struct iwl_priv *priv,
> const u8 *ra, u16 tid, u16 *ssn)
> >  		IWL_ERR(priv, "Start AGG on invalid station
> > ");
> >  		return -ENXIO;
> >  	}
> > +	if (unlikely(tid >= MAX_TID_COUNT))
> > +		return -EINVAL;
> >
> >  	if (priv->stations[sta_id].tid[tid].agg.state != IWL_AGG_OFF) {
> >  		IWL_ERR(priv, "Start AGG when state is not IWL_AGG_OFF !
> > ");

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

