Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2940 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbZG0WMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 18:12:16 -0400
Subject: RE: [PATCH] iwlwifi: Read outside array bounds
From: reinette chatre <reinette.chatre@intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, Roel Kluin <roel.kluin@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <6F5C1D715B2DA5498A628E6B9C124F040141D0B0DC@hasmsx504.ger.corp.intel.com>
References: <4A6B7A67.9070906@gmail.com> <1248658905.3747.97.camel@debian>
	 <6F5C1D715B2DA5498A628E6B9C124F040141D0B0DC@hasmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 15:12:15 -0700
Message-Id: <1248732735.1216.565.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 01:28 -0700, Winkler, Tomas wrote:
> 
> > -----Original Message-----
> > From: Zhu, Yi
> > Sent: Monday, July 27, 2009 4:42 AM
> > To: Roel Kluin; Winkler, Tomas; Chatre, Reinette
> > Cc: linux-wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net;
> > Andrew Morton
> > Subject: Re: [PATCH] iwlwifi: Read outside array bounds
> > 
> > On Sun, 2009-07-26 at 05:34 +0800, Roel Kluin wrote:
> > > tid is bounded (above) by the size of default_tid_to_tx_fifo (17
> > elements), but
> > > the size of priv->stations[].tid[] is MAX_TID_COUNT (9) elements.
> > 
> > I think MAX_TID_COUNT should be defined as 16 or 17. Tomas?
> >
> 
> In general it's 16. In practice we use only 8.

I think the above statement means that we are mostly using EDCA quality
of service which only uses 8 tids. We do not currently use HCCA (and
thus of course not the hybrid) which would cause more tids to be used.

A closer look at this flow to this function shows:
rs_tl_turn_on_agg 
->rs_tl_turn_on_agg_for_tid
-->ieee80211_start_tx_ba_session
--->iwl_mac_ampdu_action
---->iwl_tx_agg_start

>From what I can tell the tid is not modified from rs_tl_turn_on_agg to
iwl_tx_agg_start and rs_tl_turn_on_agg will not call further with a
value of tid larger than 7 due to its checking.

I thus do not see that tid may be equal or larger than MAX_TID_COUNT at
this point of checking. Even so, having this check will not do harm and
will increase safety.

This patch is already merged and that is ok, I just wanted to add this
information to it.

Reinette



