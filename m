Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:32828 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab3DEMLo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 08:11:44 -0400
Message-ID: <515EBF78.5020006@neratec.com> (sfid-20130405_141148_061562_18A1D021)
Date: Fri, 05 Apr 2013 14:11:36 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCH] mac80211: fix recalc_radar hwconf sync problem
References: <1364920789-14629-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1364993200.8351.35.camel@jlt4.sipsolutions.net> <515D8259.1030208@neratec.com> <20130404182219.GA24704@pandem0nium> <515EA285.5010004@neratec.com> <20130405112921.GA29188@pandem0nium>
In-Reply-To: <20130405112921.GA29188@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/05/2013 01:29 PM, Simon Wunderlich wrote:
> Hello Zefir,
> 
> 
> Thanks for explaining, I could now see what's happening. I've added another
> debug messages for "DFS not enabled" in the other case. What I get when running
> your example (and with my patch applied) is:
> 
> NOTE: hostapd started
> [  668.576380] ath: phy0: DFS not enabled at freq 5540
> [  668.594108] ath: phy0: DFS enabled at freq 5540
> [  672.607996] ath: phy0: DFS enabled at freq 5540
> [  672.928911] ath: phy0: DFS enabled at freq 5540
> [  672.939416] ath: phy0: DFS enabled at freq 5540
> [  704.128876] ath: phy0: DFS enabled at freq 5540
> NOTE: radar triggered here
> [  704.138482] ath: phy0: DFS enabled at freq 5240
> [  704.149684] ath: phy0: DFS not enabled at freq 5240
> 
> Now what happens is:
> 1. vif_use_channel() calls ieee80211_new_chanctx(), which calls ieee80211_hw_config().
>    radar flags are not "recalc"d, so the previous value is used
> 2. Later in vif_use_channel(), ieee80211_recalc_radar_chanctx() is called, which
>    sets the radar flag and calls ieee80211_hw_config() again.
> 
> As you can see in the output, the right value is applied ~10 - 20ms after the wrong
> value, at least with the patch originally posted here.
> 
> Of course this is not beautiful, but should work in practice.
> 
> We could consider changing this by already applying the correct radar flag in
> ieee80211_new_chanctx()? If you want, I can post a patch for that. SMPS probably
> has a similar problem to have the wrong value you set for a short time ...
> 
> 
Thanks for double-checking, Simon.

I failed to see the obvious (that ath_config() is called immediately again with
the correct DFS flag), sorry for raising dust.

Whether fix it or not, I'd say it is good enough for ath9k. Might be different for
other chips that don't allow enabling radar detection on non-DFS channels (even if
it is only for some ms).


Cheers,
Zefir
