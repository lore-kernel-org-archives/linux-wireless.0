Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37992 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231Ab1AGXZE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 18:25:04 -0500
Message-ID: <4D27A0C7.9080709@openwrt.org>
Date: Fri, 07 Jan 2011 16:24:55 -0700
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "greearb@candelatech.com" <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH v2 3/3] ath9k: Keep track of stations for
 debugfs.
References: <1294375752-3946-1-git-send-email-greearb@candelatech.com> <20110107201204.GG21588@tux>
In-Reply-To: <20110107201204.GG21588@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-01-07 1:12 PM, Luis R. Rodriguez wrote:
> On Thu, Jan 06, 2011 at 08:49:12PM -0800, greearb@candelatech.com wrote:
>>  From: Ben Greear<greearb@candelatech.com>
>>
>>  The stations hold the ath_node, which holds the tid
>>  and other xmit logic structures.  In order to debug
>>  stuck xmit logic, we need a way to print out the tid
>>  state for the stations.
>>
>>  Signed-off-by: Ben Greear<greearb@candelatech.com>
>>  ---
>>
>>  v1 ->  v2:  Use linked list instead of array.  Protect with spinlock.
>
> Again, see my comments about the # STAs limit. I think this can go in
> as a cfg80211 driver limitation which can be exposed. If you want to go
> over the supported number (known to work, safe, call it what you want)
> then a kconfig option can be used.
I disagree with putting in an essentially arbitrary restriction based on 
what has been tested, unless we can actually point at a *specific* 
limitation that makes the limit necessary.
If ath9k gets unstable with too many STA interfaces, then we should 
identify the underlying cause or fix it.

- Felix
