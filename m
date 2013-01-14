Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037Ab3ANQtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 11:49:13 -0500
Date: Mon, 14 Jan 2013 10:49:06 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH 1/2] mac80211: synchronize scan off/on-channel and PS
 states
Message-ID: <20130114164906.GA3596@thinkpad-t410> (sfid-20130114_174915_676658_8CE1F29C)
References: <1356010879-10054-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1356010879-10054-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 20, 2012 at 02:41:18PM +0100, Stanislaw Gruszka wrote:
> Since:
> 
> commit b23b025fe246f3acc2988eb6d400df34c27cb8ae
> Author: Ben Greear <greearb@candelatech.com>
> Date:   Fri Feb 4 11:54:17 2011 -0800
> 
>     mac80211: Optimize scans on current operating channel.
> 
> we do not disable PS while going back to operational channel (on
> ieee80211_scan_state_suspend) and deffer that until scan finish.
> But since we are allowed to send frames, we can send a frame to AP
> without PM bit set, so disable PS on AP side. Then when we switch
> to off-channel (in ieee80211_scan_state_resume) we do not enable PS.
> Hence we are off-channel with PS disabled, frames are not buffered
> by AP.
> 
> To fix remove offchannel_ps_disable argument and always enable PS when
> going off-channel and disable it when going on-channel, like it was
> before.
> 
> Cc: stable@vger.kernel.org # 2.6.39+
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

This patch makes a huge difference in performance and packet loss during
software scans in my testing with iperf.

Tested-by: Seth Forshee <seth.forshee@canonical.com>
