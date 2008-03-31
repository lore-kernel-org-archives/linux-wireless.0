Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:51563 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751270AbYCaN4q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 09:56:46 -0400
Date: Mon, 31 Mar 2008 15:57:18 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
Subject: Re: mac80211 MLME scanning - BSS list trouble
Message-ID: <20080331155718.357d88b0@griffin.suse.cz> (sfid-20080331_145648_902036_65B3303B)
In-Reply-To: <1206865999.22530.187.camel@johannes.berg>
References: <1206865999.22530.187.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 30 Mar 2008 10:33:19 +0200, Johannes Berg wrote:
> The question, however, is: why are beacons not allowed to override probe
> response information? That is, why does this piece of code exist:
> 
>         if (sdata->vif.type != IEEE80211_IF_TYPE_IBSS &&
>             bss->probe_resp && beacon) {
>                 /* STA mode:
>                  * Do not allow beacon to override data from Probe Response. */
>                 ieee80211_rx_bss_put(dev, bss);
>                 return;
>         }  
> 
> I failed to find any explanation for it in the git archive (it was part
> of the first code drop from Jiri that made it into a wireless tree and I
> don't have any older git archives handy) nor in my email though I
> vaguely remember there was a reason for it (or I may have made it up).

It was already in the initial Devicescape release:

1478         if (bss->probe_resp && beacon) {
1479                 /* Do not allow beacon to override data from Probe Response. */
1480                 ieee80211_rx_bss_put(dev, bss);
1481                 return;
1482         }

The only reason I can think of is handling of hidden SSIDs. Seems it
was necessary at that time. I'd vote for removing it.

> However, that actually seems to have another bug, if you have such an AP
> will you find two BSSes, one with a hidden and one with a visible SSID?

That's what I would consider a correct behaviour. You in fact do have
two distinct BSSes. But I don't know how the current user space handles
that.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
