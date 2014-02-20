Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaBTJik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:38:40 -0500
Date: Thu, 20 Feb 2014 10:40:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: [PATCH 3.14] mac80211: fix AP powersave TX vs. wakeup race
Message-ID: <20140220094057.GE23439@redhat.com> (sfid-20140220_103845_499257_15F99CCC)
References: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
 <20140220092154.GD23439@redhat.com>
 <1392888468.5073.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392888468.5073.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 10:27:48AM +0100, Johannes Berg wrote:
> On Thu, 2014-02-20 at 10:21 +0100, Stanislaw Gruszka wrote:
> > On Thu, Feb 20, 2014 at 09:52:45AM +0100, Johannes Berg wrote:
> > > +
> > > +		/* sync with ieee80211_sta_ps_deliver_wakeup */
> > > +		spin_lock(&sta->ps_lock);
> > > +		/*
> > > +		 * STA woke up the meantime and all the frames on ps_tx_buf have
> > > +		 * been queued to pending queue. No reordering can happen, go
> > > +		 * ahead and Tx the packet.
> > > +		 */
> > > +		if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
> > > +			spin_unlock(&sta->ps_lock);
> > 
> > Actually I'm not sure if we should check if both WLAN_STA_PS_DRIVER 
> > and WLAN_STA_PS_STA flags are clear ?
> 
> This area is a bit confusing, but I don't think WLAN_STA_PS_STA will be
> clear until after WLAN_STA_PS_DRIVER is?

Hmm, actually looks like we call ps_deliver_wakeup() with WLAN_STA_PS_STA
flag currently cleared.

tatic void sta_unblock(struct work_struct *wk)
{
        if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
                local_bh_disable();
                ieee80211_sta_ps_deliver_wakeup(sta);
                local_bh_enable();

so on TX we should rather check WLAN_STA_PS_DRIVER flag .

Stanislaw
