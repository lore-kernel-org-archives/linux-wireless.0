Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:39172 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752377AbeERJaH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 May 2018 05:30:07 -0400
Message-ID: <1526635805.3805.7.camel@sipsolutions.net> (sfid-20180518_113016_202986_AD5A0C8D)
Subject: Re: [RFC 0/2] nl80211/mac80211 Add support for per-rate rx
 statistics
From: Johannes Berg <johannes@sipsolutions.net>
To: Sriram R <srirrama@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 18 May 2018 11:30:05 +0200
In-Reply-To: <44cd0e995e3caf7b44fcf5676cb57b5a@codeaurora.org>
References: <1526361481-7159-1-git-send-email-srirrama@codeaurora.org>
         <1526367603.3255.3.camel@sipsolutions.net>
         <44cd0e995e3caf7b44fcf5676cb57b5a@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-05-16 at 10:04 +0530, Sriram R wrote:

> But, I wanted to avoid,
> 	1. Static indexing and memory allocation based on MCS count((8x3)24 
> entries for HT and (10x3)30 for VHT within allocated 36 entries) so that 
> it's scalable.

Do you expect that the rate control on the other side flips through
MCSes so fast that this little cache will need to be flushed
significantly?

> 	2. Remote chance of dropping a stats(Though it does not have much 
> impact)

Yeah this doesn't seem like a concern either way. How many packets and
how little time ... :)

> And to allow,
> 	1. A 'station dump' kind of interface to dump the complete collected 
> stats instead of returning only current snapshot of the stats within 
> kernel.

This *completely* contradict keeping limits on the kernel memory
consumed, so basically I don't think this is feasible.

> Also, do you feel it would be good to have both ,i.e complete stats 
> collection within kernel(this approach) and dump+clear of stats on 
> reaching threshold(your approach) and have one of these two modes 
> selected based on the requirement.

No, honestly, I don't. If an application wants these statistics, then I
feel that we can impose *some* requirements and not leave it at "let me
just enable it and have the kernel do all the work for me".

johannes
