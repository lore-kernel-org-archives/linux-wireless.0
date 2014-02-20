Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60095 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaBTJ1x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:27:53 -0500
Message-ID: <1392888468.5073.11.camel@jlt4.sipsolutions.net> (sfid-20140220_102758_573858_1BB8700E)
Subject: Re: [PATCH 3.14] mac80211: fix AP powersave TX vs. wakeup race
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 20 Feb 2014 10:27:48 +0100
In-Reply-To: <20140220092154.GD23439@redhat.com>
References: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
	 <20140220092154.GD23439@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 10:21 +0100, Stanislaw Gruszka wrote:
> On Thu, Feb 20, 2014 at 09:52:45AM +0100, Johannes Berg wrote:
> > +
> > +		/* sync with ieee80211_sta_ps_deliver_wakeup */
> > +		spin_lock(&sta->ps_lock);
> > +		/*
> > +		 * STA woke up the meantime and all the frames on ps_tx_buf have
> > +		 * been queued to pending queue. No reordering can happen, go
> > +		 * ahead and Tx the packet.
> > +		 */
> > +		if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
> > +			spin_unlock(&sta->ps_lock);
> 
> Actually I'm not sure if we should check if both WLAN_STA_PS_DRIVER 
> and WLAN_STA_PS_STA flags are clear ?

This area is a bit confusing, but I don't think WLAN_STA_PS_STA will be
clear until after WLAN_STA_PS_DRIVER is?

johannes

