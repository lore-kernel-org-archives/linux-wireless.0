Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133Ab1D2N5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 09:57:37 -0400
Date: Fri, 29 Apr 2011 15:57:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH wireless-2.6] iwlagn: fix "Received BA when not expected"
Message-ID: <20110429135711.GA5537@redhat.com> (sfid-20110429_155749_376697_A942D693)
References: <20110428111011.GA6967@redhat.com>
 <1303990661.3558.3.camel@jlt3.sipsolutions.net>
 <20110428115947.GB7030@redhat.com>
 <1303992593.3558.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303992593.3558.7.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 02:09:53PM +0200, Johannes Berg wrote:
> > > Maybe we should make it clear here that it's about non-data frames and
> > > remove the multicast check since that ought to be handled in the other
> > > path?
> > 
> > We call iwl_sta_modify_sleep_tx_count(priv, sta_id, 1); for any frame
> > as long as some other conditions are true.
> 
> That can only happen in AP mode, and if the station is asleep, I don't
> think it's a concern.
> 
> > Also multicast frames are important. When we send data and multicast
> > frame we probably modify 
> > 
> > priv->stations[sta_id].tid[tid]
> > 
> > with wrong sta_id (other station with unicast address), what make related
> > aggregation data wrong for that other station.
> 
> Yeah, but multicast is already handled properly, since in that case
> info->control.sta will be set to NULL by mac80211. Keep in mind that
> again this is AP mode only, since a client connected to an AP never
> sends real multicast frames (if it sends 802.3 multicast frames they're
> still unicast to the AP).

We use sta_id for building tx command in:

if (info->control.hw_key)
	iwlagn_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);

/* TODO need this for burst mode later on */
iwlagn_tx_cmd_build_basic(priv, skb, tx_cmd, info, hdr, sta_id);

so problems seems to be that the firmware do not handle
unicast sta_id for management frames. I'll repost patches
that check only ieee80211_is_data(fc).

BTW, iwlagn_tx_skb function needs serious cleanup, it's
completely unreadable!

Stanislaw
