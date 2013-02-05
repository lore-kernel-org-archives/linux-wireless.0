Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47914 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab3BERY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 12:24:27 -0500
Message-ID: <1360085086.8376.13.camel@jlt4.sipsolutions.net> (sfid-20130205_182448_778561_5497A3B6)
Subject: Re: [PATCH] mac80211: provide 64-bit traffic counters
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org, qca_vkondrat@qca.qualcomm.com
Date: Tue, 05 Feb 2013 18:24:46 +0100
In-Reply-To: <51113F98.8040209@candelatech.com>
References: <1360058204-12208-1-git-send-email-johannes@sipsolutions.net>
	 <51113F98.8040209@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 09:21 -0800, Ben Greear wrote:
> On 02/05/2013 01:56 AM, Johannes Berg wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > "unsigned long" is already 64-bit on (most?) 64-bit
> > machines, use u64 and tell cfg80211 that we provide
> > 64-bit counters now.
> 
>  From what I can tell, these counters are modified using
> += operators.  From what I recall, this is non-atomic on
> 32-bit systems when the variable is u64.
> 
> Is there any other locking that keeps this from blowing up?

Funny you should ask this, we were discussing RX locking in another
thread :-)

In any case, it's *already* non-atomic since incrementing is always a
read-modify-write cycle, and I think that updates can indeed get lost
for the TX counter (and only it) if frames for multiple ACs are
processed at the same time. The proper way to solve that would probably
be having counters for all ACs and summing them only when needed.

johannes

