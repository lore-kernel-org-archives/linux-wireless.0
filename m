Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:57905 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbBMWNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 17:13:07 -0500
Message-ID: <54DE76F2.4080107@candelatech.com> (sfid-20150213_231311_584595_EAFF1225)
Date: Fri, 13 Feb 2015 14:13:06 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC] mac80211: use rhashtable for station table
References: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1423864049-8961-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/13/2015 01:47 PM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> We currently have a hand-rolled table with 256 entries and are
> using the last byte of the MAC address as the hash. This hash
> is obviously very fast, but collisions are easily created and
> we waste a lot of space in the common case of just connecting
> as a client to an AP where we just have a single station. The
> other common case of an AP is also suboptimal due to the size
> of the hash table and the ease of causing collisions.
> 
> Convert all of this to use rhashtable with jhash, which gives
> us the advantage of a far better hash function (with random
> perturbation to avoid hash collision attacks) and of course
> that the hash table grows and shrinks dynamically with chain
> length, improving both cases above.

Oooh, maybe finally time to mix local addr with peer addr to
make lots of vifs connected to same AP hash well too? :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

