Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757938Ab0JVQsV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 12:48:21 -0400
Subject: Re: [PATCH 1/2] iwlwifi: fix set_tx_power vs scan
From: Dan Williams <dcbw@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20101022125628.GA4527@redhat.com>
References: <1286977193-12144-1-git-send-email-sgruszka@redhat.com>
	 <1286983100.10446.1.camel@wwguy-ubuntu> <20101014083204.GA2286@redhat.com>
	 <20101021131348.GA5654@redhat.com>  <20101022125628.GA4527@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 11:51:34 -0500
Message-ID: <1287766294.19356.1.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-22 at 14:56 +0200, Stanislaw Gruszka wrote:
> On Thu, Oct 21, 2010 at 03:13:48PM +0200, Stanislaw Gruszka wrote:
> > On Thu, Oct 14, 2010 at 10:32:05AM +0200, Stanislaw Gruszka wrote:
> > > > Looks good, the only thing is if priv->tx_power_user_lmt ==
> > > > priv->tx_power_next, we don't even have to call set_tx_power, but I
> > > > guess calling it won't hurt, so its your decision check or not.
> > > 
> > > I'll will call iwl_set_tx_power( ... , false); what seems to be right
> > > thing to do.
> > 
> > Set tx power have to be forces. Without that I get  
> > 
> > iwlagn 0000:40:00.0: low ack count detected, restart firmware
> > iwlagn 0000:40:00.0: On demand firmware reload
> > iwlagn 0000:40:00.0: Stopping AGG while state not ON or starting
> > iwlagn 0000:40:00.0: queue number out of range: 0, must be 10 to 19
> > iwlagn 0000:40:00.0: Aggregation not enabled for tid 0 because load = 0
> > iwlagn 0000:40:00.0: Aggregation not enabled for tid 0 because load = 1
> > iwlagn 0000:40:00.0: Aggregation not enabled for tid 0 because load = 0
> > iwlagn 0000:40:00.0: Aggregation not enabled for tid 0 because load = 0
> > iwlagn 0000:40:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
> > iwlagn 0000:40:00.0: low ack count detected, restart firmware
> > iwlagn 0000:40:00.0: On demand firmware reload
> > iwlagn 0000:40:00.0: Stopping AGG while state not ON or starting
> > iwlagn 0000:40:00.0: queue number out of range: 0, must be 10 to 19
> > iwlagn 0000:40:00.0: iwlagn_tx_agg_start on ra = 00:23:69:35:d1:3f tid = 0
> > iwlagn 0000:40:00.0: low ack count detected, restart firmware
> > iwlagn 0000:40:00.0: On demand firmware reload
> > iwlagn 0000:40:00.0: Stopping AGG while state not ON or starting
> > iwlagn 0000:40:00.0: queue number out of range: 0, must be 10 to 19
> > iwlagn 0000:40:00.0: Aggregation not enabled for tid 0 because load = 4
> > iwlagn 0000:40:00.0: Aggregation not enabled for tid 0 because load = 0
> > 
> > on 5300 and device was unusable in general. Hence I will only comment
> > that forcing send tx power after scan is needed.
> 
> Not true. I have the same problem with vanilla 2.6.36 without any of my
> patches (further investigation show this is 2.6.34 -> 2.6.35
> regression). Problem happens only on 5Ghz, that confused me 
> because NetworkManager in some cases connects to 5Ghz, in others to
> 2.4Ghz on my system.

NM doesn't yet send a list of approved frequencies down to
wpa_supplicant for a network, which is how we'd implement "locking" a
connection to a particular band.  So at this point, which band the
driver uses depends on wpa_supplicant scan results and the driver
itself.  Something I intend to fix soon; we've always had a "band"
config option, it's just not hooked up to anything.

Dan
 

