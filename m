Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:34892 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760872Ab3DDNim (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Apr 2013 09:38:42 -0400
Message-ID: <515D8259.1030208@neratec.com> (sfid-20130404_153846_721079_0D1134FD)
Date: Thu, 04 Apr 2013 15:38:33 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de>  (sfid-20130402_184017_183870_B78BD6C4) <1364993200.8351.35.camel@jlt4.sipsolutions.net>
In-Reply-To: <1364993200.8351.35.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/03/2013 02:46 PM, Johannes Berg wrote:
> On Tue, 2013-04-02 at 18:39 +0200, Simon Wunderlich wrote:
>> local->hw.conf maybe not be synced when recalcing whether radar is
>> enabled, sometimes leaving radar enabled even if it's not neccesary
>> anymore.
> 
> I don't really see how, can you explain more?
> 
> johannes
> 

You seem to be right, the patch does not resolve the observed problem.

I am not deep enough in the DFS master code and its integration to resolve it
myself. What I see is that ath9k_config() is called with a non-DFS channel but
with ieee80211_hw->conf.radar_enabled set. For ath9k that's no problem at all
(radar pulse detection can be enabled on any channel), but indicates a problem in
the channel context handling for DFS.

To reproduce, start an AP on a DFS channel, wait until CAC is finished and fire a
radar. hostapd will switch to a non-DFS channel with the radar_enabled flag set.


