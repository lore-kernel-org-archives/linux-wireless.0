Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39254 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932749Ab2CZSww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 14:52:52 -0400
Subject: Re: [PATCH] iwlwifi: do not nulify ctx->vif on reset
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20120326184209.GJ13806@tuxdriver.com>
References: <1331651434-4370-1-git-send-email-sgruszka@redhat.com>
	 <1331651730.3329.6.camel@jlt3.sipsolutions.net>
	 <20120314062549.GA2788@redhat.com>
	 <1331708304.3376.0.camel@jlt3.sipsolutions.net>
	 <20120314070748.GB2788@redhat.com> <20120314081424.GC2788@redhat.com>
	 <1332752906.7081.10.camel@jlt3.sipsolutions.net>
	 <1332772232.27767.14.camel@wwguy-huron>
	 <20120326184209.GJ13806@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Mar 2012 11:51:32 -0700
Message-ID: <1332787892.27767.17.camel@wwguy-huron> (sfid-20120326_205256_121843_BE8AFAAF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Mon, 2012-03-26 at 14:42 -0400, John W. Linville wrote:
> On Mon, Mar 26, 2012 at 07:30:32AM -0700, Guy, Wey-Yi wrote:
> > On Mon, 2012-03-26 at 11:08 +0200, Johannes Berg wrote:
> > > On Wed, 2012-03-14 at 09:14 +0100, Stanislaw Gruszka wrote:
> > > > On Wed, Mar 14, 2012 at 08:07:48AM +0100, Stanislaw Gruszka wrote:
> > > > > I'll update and recheck again.
> > > > 
> > > > On updated tree (head 035364916f75151b4b91ea53968c6beba7545317) devices
> > > > stop working here on any forced reset during TX as well. There are
> > > > messages like below in dmesg:
> > > > 
> > > > wlan3: dropped data frame to not associated station 00:00:00:00:00:00
> > > > 
> > > > And one time crash happened too, in:
> > > > 
> > > > (gdb) l *(iwl_remove_dynamic_key+0x1f0)
> > > > 0x15e20 is in iwl_remove_dynamic_key (drivers/net/wireless/iwlwifi/iwl-agn-sta.c:1105).
> > > > 1100		/*
> > > > 1101		 * The device expects GTKs for station interfaces to be
> > > > 1102		 * installed as GTKs for the AP station. If we have no
> > > > 1103		 * station ID, then use the ap_sta_id in that case.
> > > > 1104		 */
> > > > 1105		if (vif->type == NL80211_IFTYPE_STATION && vif_priv->ctx)
> > > > 1106			return vif_priv->ctx->ap_sta_id;
> > > > 1107	
> > > > 1108		return IWL_INVALID_STATION;
> > > > 1109	}
> > > > 
> > > > To reproduce problems, I'm doing "ping -f 192.168.1.1" on one console
> > > > and run script [1] on other console.
> > > 
> > > Ok so I finally got some time to look into this in some detail. It seems
> > > that the driver assumes a few calls from mac80211 like key settings can
> > > only happen while the vif pointers are valid, which is correct under
> > > normal circumstances but due to races with HW reset it's not really true
> > > there.
> > > 
> > > We could fix all of those, but it seems your patch is the better
> > > approach. Wey, can you pick it up?
> > 
> > yes
> 
> Should I just take it and try to get it merged for -rc1?

I am taking it into our internal tree for our regression, if it is ok
for you, could you wait a bit, I will push it with all our other
patches.

btw, I have pretty large queue of patches again (~50+), this time I will
break it up and push separated :-)

Thanks
Wey


