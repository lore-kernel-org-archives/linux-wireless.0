Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:47572 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbZCPXtL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 19:49:11 -0400
Received: by ewy25 with SMTP id 25so3680050ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 16:49:08 -0700 (PDT)
Message-ID: <49BEE56C.9050202@gmail.com> (sfid-20090317_004916_357285_DC4D475F)
Date: Mon, 16 Mar 2009 19:49:00 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: [RFC] fix wireless-regdb enforcement oddities
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For the sake of sanity, I think that the way rules from wireless-regdb 
are enforced needs to be changed. An example:

country US:
        (5170 - 5250 @ 40), (3, 17)
        (5250 - 5330 @ 40), (3, 20), DFS

In this case, you will see that I have removed all of the rules that I 
do not intend to cite to lower the complexity of the ruleset.

Take for example, channel 48, center frequency 5240.  A standard 20 mhz 
mode will work as expected, as well as HT40-, however HT40+ cannot be 
set because it would need to cross the rule boundary.  Each line of a 
regulatory domain section is enforced by itself.  Channel 52 has a 
similiar problem where 20 and HT40+ work but HT40- will not.

As this specific example includes frequencies in the DFS range, you can 
obviously see why no one has noticed this failing before.  The obviously 
expected result is that if two rules abut and a channel is requested 
that stradles them, it should take the most restrictive mix between the 
two.  For instance, if I set channel 48 in HT40+ mode (and we have DFS 
support) the rule would be enforced as (3, 17), DFS; while HT40- would 
be enforced as the standard (3, 17).

Does this make sense? Right now each rule line is being treated as an 
island, and any adjacent rules are ignored.  Due to this narrow field of 
vision, the proper way to rewrite the above rule is as follows:

country US:
        (5170 - 5260 @ 40), (3, 17)
        (5240 - 5330 @ 40), (3, 20), DFS

This of course has it's own obvious problem of allowing people to use 48 
HT40+ without DFS or allowing people to use 52 HT40- at 20dBm.  Not to 
mention what happens if we set channel 50 because it would fall into 
both rules as it has a center frequency of 5250.  Of course in this 
example the point is moot because channel 50 isn't allocated anywhere in 
the world but the introductions of 5 and 10mhz channels (which are 
allowed in the 802.11j standard) may cause some settings that would span 
between multiple rules.

The only proper way to fix this is to change the enforcement to view the 
entire regdomain and not just enforce one line at a time. so that we can 
use legal settings like 48 HT40+ and 52HT40- (presuming we meet the DFS 
requirement).  I realize that this is currently completely pointless as 
we _in fact_ do not support DFS, but this is going to be a problem and I 
would like to see it properly resolved so I can stop writing overlapping 
rules (which are at best a HACK and at worst clearly allowing people to 
break the law).

Thank you for your consideration.

-Rick Farina
