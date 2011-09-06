Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25988 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1IFHVn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 03:21:43 -0400
Date: Tue, 6 Sep 2011 10:21:38 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/4] ath6kl: Allow enabling of P2P support
Message-ID: <20110906072138.GA3125@jouni.qca.qualcomm.com> (sfid-20110906_092147_511551_23EB2951)
References: <1315233527-6234-1-git-send-email-jouni@qca.qualcomm.com>
 <1315233527-6234-5-git-send-email-jouni@qca.qualcomm.com>
 <4E65C49B.2000201@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E65C49B.2000201@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 06, 2011 at 09:58:35AM +0300, Kalle Valo wrote:
> On 09/05/2011 05:38 PM, Jouni Malinen wrote:
> > --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > +static unsigned int ath6kl_p2p;
> > +
> > +module_param(ath6kl_p2p, uint, 0644);
> 
> Currently all module parameters are in init.c. It's not the best place
> and most likely will move to core.c soon, but I still would prefer to
> have them all in one place. I think moving this to init.c would make sense.

I started with this in init.c, but that causes checkpatch warnings when
the variable needs to be accessed as extern in cfg80211.c. Or well, I
guess I could hide that by defining the extern in a header file, but
this parameter should not really be used in any other file than
cfg80211.c to initialize the flag in struct ath6kl. As such, I would
prefer not to make its visibility any larger that necessary. Why would
all module parameters need to be defined in the same C file?

> > --- a/drivers/net/wireless/ath/ath6kl/core.h
> > +++ b/drivers/net/wireless/ath/ath6kl/core.h
> > @@ -471,6 +471,8 @@ struct ath6kl {
> > +	bool p2p;
> 
> We have struct ath6kl::conf_flags exactly for this purpose, see
> ATH6KL_CONF_ENABLE_11N for an example. I think we should use it also
> with P2P.

Sounds reasonable.

> > +	if (ar->p2p) {
> > +		ret = ath6kl_wmi_info_req_cmd(ar->wmi,
> > +					      P2P_FLAG_CAPABILITIES_REQ |
> > +					      P2P_FLAG_MACADDR_REQ |
> > +					      P2P_FLAG_HMODEL_REQ);
> > +		if (ret) {
> > +			ath6kl_dbg(ATH6KL_DBG_TRC, "failed to request P2P "
> > +				   "capabilities (%d) - assuming P2P not "
> > +				   "supported\n", ret);
> > +			ar->p2p = 0;
> > +		}
> > +	}
> > +
> > +	if (ar->p2p) {
> 
> Can we combine this if block with the first one?

Sure, but that would add extra indentation level for the following code,
so this separate check-if-P2P-is-supported followed by
if-P2P-is-supported looks cleaner to me.

> If it's ok for you, I'll commit the first three patches and we can talk
> more about this patch.

Yes, please do.

-- 
Jouni Malinen                                            PGP id EFC895FA
