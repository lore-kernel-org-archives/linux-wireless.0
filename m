Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40022 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3C0Rlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:41:36 -0400
Message-ID: <1364406085.8388.11.camel@jlt4.sipsolutions.net> (sfid-20130327_184141_852661_FDB8F266)
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
From: Johannes Berg <johannes@sipsolutions.net>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 27 Mar 2013 18:41:25 +0100
In-Reply-To: <87r4j021ac.fsf@sycorax.lbl.gov>
References: <87li993mug.fsf@sycorax.lbl.gov>
	 <1364390086.8388.7.camel@jlt4.sipsolutions.net>
	 <87r4j021ac.fsf@sycorax.lbl.gov>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-27 at 10:35 -0700, Alex Romosan wrote:

> ...i did a bisect using the above and it came up with this:
> 
> 89afe614c0c737fd40eda1f8c8ef686246cf3cb6 is the first bad commit
> commit 89afe614c0c737fd40eda1f8c8ef686246cf3cb6
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Wed Feb 13 15:39:57 2013 +0100
> 
>     mac80211: fix auth/assoc timeout handling
> 
> which makes a lot more sense. i'll try reverting it to see if it fixes
> the problem, or i can try patches if you have any.

Humm, yes, that makes more sense. That commit fixed a bug in another
commit though, I'm surprised you ended up there?! Curious ... I'll check
over the commit and see if I can find anything wrong with it.

johannes

