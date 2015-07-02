Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46768 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbbGBMhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 08:37:21 -0400
Message-ID: <1435840637.2285.23.camel@sipsolutions.net> (sfid-20150702_143729_286393_0EC82FB0)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 02 Jul 2015 14:37:17 +0200
In-Reply-To: <CABPxzYLgYqL1M6tKx5fo7eJ_=_DJPNS0ttDvUpC3BKH+SyAEiA@mail.gmail.com> (sfid-20150702_141353_923615_65038BD0)
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	 <1435082418.2777.11.camel@ipeer-box>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
	 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
	 <1435822032.2285.2.camel@sipsolutions.net>
	 <CALhHN=ojLBA1AFGz=atjJhv+fJAr-Rkhd0cgYpma_4Rx+HYOaw@mail.gmail.com>
	 <1435837168.2285.8.camel@sipsolutions.net>
	 <CABPxzY+P+p18gVG-o9WhuQy_VVvR3QaS-CQMr8RuiD_2iSTFgw@mail.gmail.com>
	 <1435838499.2285.14.camel@sipsolutions.net>
	 <CABPxzYLgYqL1M6tKx5fo7eJ_=_DJPNS0ttDvUpC3BKH+SyAEiA@mail.gmail.com>
	 (sfid-20150702_141353_923615_65038BD0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 17:43 +0530, Krishna Chaitanya wrote:
> 
> Thismight still be relevant, if you remember our discussion
> (
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/135533
> )
> a while ago, in a passive scan environment beacon might have
> the latest information than probe response but we end up using
> probe response, so in those cases direct probe helps to
> get the right capabilities.
> 
> But i remember your argument about changing AP config is not
> much of a use case :-)

Yeah I still don't think this is much of an issue.

> In an environment where AP config is changed this might be helpful
> else not needed. Given the enterprise wifi deployments using 
> controllers auto-changing of AP config based on the environemnt may 
> not be far away

I can see the HT/VHT operation changing, and perhaps even channel
jumping, but staying on the channel and changing parameters that can't
actually be updated on the fly seems a bit strange. I'm not even sure
what parameters those would be.

That said, I found at least one issue with removing the direct probe:
If the beacon only has WMM info and not WMM parameters (as permitted by
the WMM spec) then we would disable WMM in ieee80211_mgd_assoc() if we
don't have a probe response. We'd thus have to move validation to after
having received the association response, but at that point it's not
clear to me what we should do if we don't receive good WMM parameters,
then we can't connect without WMM any more.

johannes
