Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4585 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589AbYCaUeY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 16:34:24 -0400
Date: Mon, 31 Mar 2008 16:05:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>, Jouni Malinen <j@w1.fi>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: mac80211 MLME scanning - BSS list trouble
Message-ID: <20080331200536.GA13799@tuxdriver.com> (sfid-20080331_213426_952103_78087899)
References: <1206865999.22530.187.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206865999.22530.187.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 30, 2008 at 10:33:19AM +0200, Johannes Berg wrote:

> The first one is that there is no actual expiration of BSS structs. Each
> BSS struct has a 'last_update' member that contains (in jiffies) the
> time this item was last updated. This means that we accumulate BSS
> information forever, but due to the 'last_update' only the last few
> items will be returned to the user on asking for a scan result. This
> obviously has problems since a rogue station could bombard us with fake
> probe responses and cause us to build a huge BSS list which is never
> again freed until the hardware is deregistered. This will need to be
> fixed, of course.

Assuming this was fixed, does the rest of this issue go away?
It seems like it would.

> In any case, the problem then is that last_update is updated only along
> with the remaining information in a BSS struct, which is quite correct.
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

Should we consider allowing the beacon to update the info if
last_update is old enough to keep the BSS out of the scan results?

John
-- 
John W. Linville
linville@tuxdriver.com
