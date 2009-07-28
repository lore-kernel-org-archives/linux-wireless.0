Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51330 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbZG1Euq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jul 2009 00:50:46 -0400
Subject: RE: [PATCH] iwlwifi: Read outside array bounds
From: reinette chatre <reinette.chatre@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	Roel Kluin <roel.kluin@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1248748076.3747.1097.camel@debian>
References: <4A6B7A67.9070906@gmail.com> <1248658905.3747.97.camel@debian>
	 <6F5C1D715B2DA5498A628E6B9C124F040141D0B0DC@hasmsx504.ger.corp.intel.com>
	 <1248732735.1216.565.camel@rc-desk>  <1248748076.3747.1097.camel@debian>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 21:50:46 -0700
Message-Id: <1248756646.1216.662.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-27 at 19:27 -0700, Zhu, Yi wrote:
> On Tue, 2009-07-28 at 06:12 +0800, Chatre, Reinette wrote:
> > On Mon, 2009-07-27 at 01:28 -0700, Winkler, Tomas wrote:
> > > 
> > > > -----Original Message-----
> > > > From: Zhu, Yi
> > > > Sent: Monday, July 27, 2009 4:42 AM
> > > > To: Roel Kluin; Winkler, Tomas; Chatre, Reinette
> > > > Cc: linux-wireless@vger.kernel.org; ipw3945-devel@lists.sourceforge.net;
> > > > Andrew Morton
> > > > Subject: Re: [PATCH] iwlwifi: Read outside array bounds
> > > > 
> > > > On Sun, 2009-07-26 at 05:34 +0800, Roel Kluin wrote:
> > > > > tid is bounded (above) by the size of default_tid_to_tx_fifo (17
> > > > elements), but
> > > > > the size of priv->stations[].tid[] is MAX_TID_COUNT (9) elements.
> > > > 
> > > > I think MAX_TID_COUNT should be defined as 16 or 17. Tomas?
> > > >
> > > 
> > > In general it's 16. In practice we use only 8.
> > 
> > I think the above statement means that we are mostly using EDCA quality
> > of service which only uses 8 tids. We do not currently use HCCA (and
> > thus of course not the hybrid) which would cause more tids to be used.
> > 
> > A closer look at this flow to this function shows:
> > rs_tl_turn_on_agg 
> 
> rs_tl_add_packet
> {
> 	...
> 	u8 *qc = ieee80211_get_qos_ctl(hdr);
> 	tid = qc[0] & 0xf;
> 	...
> 
> 	tl = &lq_data->load[tid];
> }
> 
> This should be a problem.

Indeed. Are there any other cases like this that you can think of? It
seems like we need Roel's fix for iwl_tx_agg_stop also.

Reinette


