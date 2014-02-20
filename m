Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60141 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaBTJmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 04:42:51 -0500
Message-ID: <1392889368.5073.17.camel@jlt4.sipsolutions.net> (sfid-20140220_104256_666518_C373168B)
Subject: Re: [PATCH 3.14] mac80211: fix AP powersave TX vs. wakeup race
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Thu, 20 Feb 2014 10:42:48 +0100
In-Reply-To: <20140220094057.GE23439@redhat.com>
References: <1392886365-31206-1-git-send-email-johannes@sipsolutions.net>
	 <20140220092154.GD23439@redhat.com>
	 <1392888468.5073.11.camel@jlt4.sipsolutions.net>
	 <20140220094057.GE23439@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-02-20 at 10:40 +0100, Stanislaw Gruszka wrote:

> > This area is a bit confusing, but I don't think WLAN_STA_PS_STA will be
> > clear until after WLAN_STA_PS_DRIVER is?
> 
> Hmm, actually looks like we call ps_deliver_wakeup() with WLAN_STA_PS_STA
> flag currently cleared.
> 
> tatic void sta_unblock(struct work_struct *wk)
> {
>         if (!test_sta_flag(sta, WLAN_STA_PS_STA)) {
>                 local_bh_disable();
>                 ieee80211_sta_ps_deliver_wakeup(sta);
>                 local_bh_enable();
> 
> so on TX we should rather check WLAN_STA_PS_DRIVER flag .

But that flag may never be set if the driver doesn't support/use it
(which means it's racy, but anyway), so we need to check both.

Now I'm confused though. It seems the intent here was to clear the
WLAN_STA_PS_STA flag in something like sta_ps_end() in the RX path, but
we don't do that. I'm not sure how it works now, but I know from testing
that it does ;-)

Do you think the v2 patch is fine?

johannes

