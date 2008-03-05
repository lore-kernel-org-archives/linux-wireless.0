Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:8387 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbYCELBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 06:01:12 -0500
Received: by rv-out-0910.google.com with SMTP id k20so855364rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 03:01:10 -0800 (PST)
Message-ID: <c85cb4470803050301p63b3568epe989ef042f9b11f5@mail.gmail.com> (sfid-20080305_110116_698122_CD293EA1)
Date: Wed, 5 Mar 2008 13:01:10 +0200
From: "Ron Rindjunsky" <rindjon@googlemail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags andHT flags
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1204713755.25502.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-3-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-4-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
	 <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com>
	 <1204711417.25502.59.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com>
	 <1204713755.25502.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > >What, for example, is OFDM_HT? What happens when you select a bitrate
> > >of, say, 11MBit and have the 40_MHZ_WIDTH flag set?
> >
> > HT doesn't work on CCK modulations, so this flag just basically says
> > it's HT rate and not legacy rate.
>
> Ok, so what does it mean to set the flag along with a 54MBit rate?
>
> It seems to me that these flags aren't entirely orthogonal to the
> bitrates?

no, they are all orthogonal to each other. the example you gave will
give us 108MBit. all flags can be used, as long they match the spec,
and that's the algorithm responsibility to check and determine.
I guess that the flag that is more confusing is OFDM_HT. since 11n
supports (theoretically...) n streams of data, using flags like SISO /
MIMO / MIMO_3_ANT / MIMO_... seemed the wrong way. in stead, once you
know OFDM_HT is up, a check to antenna_sel_tx will determine the Tx
expected method.
It may be good to add this to the file's documentation.
