Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab0C2ITf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 04:19:35 -0400
Date: Mon, 29 Mar 2010 09:17:33 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>, wey-yi.w.guy@intel.com
Subject: Re: [PATCH 1/2] mac80211: explicitly disable/enable QoS
Message-ID: <20100329071733.GB2732@dhcp-lab-161.englab.brq.redhat.com>
References: <1269621992-5034-1-git-send-email-sgruszka@redhat.com> <1269624363.4342.2.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1269624363.4342.2.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 26, 2010 at 10:26:03AM -0700, Johannes Berg wrote:
> >  void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
> > @@ -816,7 +824,7 @@ void ieee80211_sta_def_wmm_params(struct ieee80211_sub_if_data *sdata,
> >  	else
> >  		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
> >  
> > -	ieee80211_set_wmm_default(sdata);
> > +	ieee80211_set_wmm_default(sdata, true);
> 
> Shouldn't that be false though?

I think so, I did like that just to not change old behaviour (on iwlwifi).

But I think also, that all ieee80211_set_wmm_default function calls
should be with false, in other words, we should disable QoS in
ieee80211_set_wmm_default().

What is your opinion?

Stanislaw
