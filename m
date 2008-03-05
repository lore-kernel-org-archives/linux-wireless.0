Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:1734 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933484AbYCEL7W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 06:59:22 -0500
Received: by rv-out-0910.google.com with SMTP id k20so870289rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 03:59:19 -0800 (PST)
Message-ID: <c85cb4470803050359x398a685ekb1b94de6cf65ad62@mail.gmail.com> (sfid-20080305_115928_724010_432923AD)
Date: Wed, 5 Mar 2008 13:59:19 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags andHT flags
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1204715685.25502.66.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
	 <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com>
	 <1204711417.25502.59.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com>
	 <1204713755.25502.62.camel@johannes.berg>
	 <c85cb4470803050301p63b3568epe989ef042f9b11f5@mail.gmail.com>
	 <1204715685.25502.66.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > It seems to me that these flags aren't entirely orthogonal to the
> > > bitrates?
> >
> > no, they are all orthogonal to each other. the example you gave will
> > give us 108MBit. all flags can be used, as long they match the spec,
> > and that's the algorithm responsibility to check and determine.
> > I guess that the flag that is more confusing is OFDM_HT. since 11n
> > supports (theoretically...) n streams of data, using flags like SISO /
> > MIMO / MIMO_3_ANT / MIMO_... seemed the wrong way. in stead, once you
> > know OFDM_HT is up, a check to antenna_sel_tx will determine the Tx
> > expected method.
>
> Ahh! Ok, thanks for the explanation. Is antenna_sel_tx really the right
> thing though? Tomas mentioned that you can have three antennas and only
> two chains so should that rather be a chain selection?
>

yes, this is correct from low level driver's perspective, but i think
that from rate scaling perspective keeping the antenna term is clearer
then a chain.

> > It may be good to add this to the file's documentation.
>
> Indeed. Or to a DOC: section somewhere so it can be added to an 11n
> chapter of the mac80211 book (since the patch is merged I'm
> automatically generating it nightly at
> http://linuxwireless.org/mac80211book/)
>

I'll make a patch with the explanation
