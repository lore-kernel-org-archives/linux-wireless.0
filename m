Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37705 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab3APOGd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2013 09:06:33 -0500
Message-ID: <1358345216.22862.8.camel@jlt4.sipsolutions.net> (sfid-20130116_150641_579482_DED515F6)
Subject: Re: [PATCH 1/2] mac80211: synchronize scan off/on-channel and PS
 states
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Date: Wed, 16 Jan 2013 15:06:56 +0100
In-Reply-To: <20130114164906.GA3596@thinkpad-t410>
References: <1356010879-10054-1-git-send-email-sgruszka@redhat.com>
	 <20130114164906.GA3596@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-14 at 10:49 -0600, Seth Forshee wrote:
> On Thu, Dec 20, 2012 at 02:41:18PM +0100, Stanislaw Gruszka wrote:
> > Since:
> > 
> > commit b23b025fe246f3acc2988eb6d400df34c27cb8ae
> > Author: Ben Greear <greearb@candelatech.com>
> > Date:   Fri Feb 4 11:54:17 2011 -0800
> > 
> >     mac80211: Optimize scans on current operating channel.
> > 
> > we do not disable PS while going back to operational channel (on
> > ieee80211_scan_state_suspend) and deffer that until scan finish.
> > But since we are allowed to send frames, we can send a frame to AP
> > without PM bit set, so disable PS on AP side. Then when we switch
> > to off-channel (in ieee80211_scan_state_resume) we do not enable PS.
> > Hence we are off-channel with PS disabled, frames are not buffered
> > by AP.
> > 
> > To fix remove offchannel_ps_disable argument and always enable PS when
> > going off-channel and disable it when going on-channel, like it was
> > before.
> > 
> > Cc: stable@vger.kernel.org # 2.6.39+
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> 
> This patch makes a huge difference in performance and packet loss during
> software scans in my testing with iperf.
> 
> Tested-by: Seth Forshee <seth.forshee@canonical.com>

Applied, sorry about the delay.

johannes

