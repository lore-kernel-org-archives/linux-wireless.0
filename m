Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53180 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab0C2I1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 04:27:25 -0400
Subject: Re: [PATCH 1/2] mac80211: explicitly disable/enable QoS
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
In-Reply-To: <20100329071733.GB2732@dhcp-lab-161.englab.brq.redhat.com>
References: <1269621992-5034-1-git-send-email-sgruszka@redhat.com>
	 <1269624363.4342.2.camel@jlt3.sipsolutions.net>
	 <20100329071733.GB2732@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 10:27:16 +0200
Message-ID: <1269851236.4131.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 09:17 +0200, Stanislaw Gruszka wrote:
> On Fri, Mar 26, 2010 at 10:26:03AM -0700, Johannes Berg wrote:
> > >  void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
> > > @@ -816,7 +824,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
> > >  	else
> > >  		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
> > >  
> > > -	ieee80211_set_wmm_default(sdata);
> > > +	ieee80211_set_wmm_default(sdata, true);
> > 
> > Shouldn't that be false though?
> 
> I think so, I did like that just to not change old behaviour (on iwlwifi).
> 
> But I think also, that all ieee80211_set_wmm_default function calls
> should be with false, in other words, we should disable QoS in
> ieee80211_set_wmm_default().
> 
> What is your opinion?

Yeah that seems right to me, if we're going to set to the default then
that should probably mean off, even if we do configure the queues. I'm
just not exactly sure how AP should be handled wrt. turning QoS on,
probably on the first queue config from userspace?

johannes

