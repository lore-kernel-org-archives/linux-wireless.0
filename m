Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:58651 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757953Ab3EHSEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 14:04:23 -0400
Message-ID: <1368036259.8279.26.camel@jlt4.sipsolutions.net> (sfid-20130508_200426_848130_9986917D)
Subject: Re: mac80211 warning in 3.9.0+ when unloading ath9k driver.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 08 May 2013 20:04:19 +0200
In-Reply-To: <518A8DB1.7080904@candelatech.com> (sfid-20130508_193902_610347_FF7CDB2D)
References: <518A8DB1.7080904@candelatech.com>
	 (sfid-20130508_193902_610347_FF7CDB2D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-08 at 10:38 -0700, Ben Greear wrote:
> I saw the WARN_ON_ONCE hit below on 3.9.0+ (+ hacks)
> on a system with ath9k and ath9k_htc driver.

Were you using VLANs?

> I'll be happy to add more debugging if someone has suggestions.

> 		compat = cfg80211_chandef_compatible(
> 				&sdata->vif.bss_conf.chandef, compat);
> 		if (!compat)
> 			break;
> 	}
> 	rcu_read_unlock();
> 
> 	if (WARN_ON_ONCE(!compat))
> 		return;

Might be helpful to know whether chandef_compatible() returned NULL, or
if the loop simply never found an interface with a matching pointer.

johannes

