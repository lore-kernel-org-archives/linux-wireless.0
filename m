Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:39611 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbaFWVUR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 17:20:17 -0400
Message-ID: <53A89A0F.9090509@candelatech.com> (sfid-20140623_232021_690542_D01F4C41)
Date: Mon, 23 Jun 2014 14:20:15 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: linux-wireless@vger.kernel.org, kvalo@qca.qualcomm.com,
	wireless-regdb@lists.infradead.org
Subject: Re: [RFC] wireless:  improve dfs-region intersection.
References: <1402517314-20110-1-git-send-email-greearb@candelatech.com> <20140623191504.GD1390@garbanzo.do-not-panic.com> <53A89011.1010806@candelatech.com> <20140623205451.GG1390@garbanzo.do-not-panic.com>
In-Reply-To: <20140623205451.GG1390@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/23/2014 01:54 PM, Luis R. Rodriguez wrote:
> On Mon, Jun 23, 2014 at 01:37:37PM -0700, Ben Greear wrote:
>> On 06/23/2014 12:15 PM, Luis R. Rodriguez wrote:
>>>
>>> Adding wireless-regdb.
>>>
>>> Regulatory folks:
>>>
>>> if two cards are present on a system, in the worst case consider
>>> two different cards for AP mode, and one has a DFS region set for the
>>> country its on but the other does not, do we want to use the DFS region
>>> for both? DFS would not be allowed on system unless the DFS region is
>>> set. DFS operation requires a card to explicitly support DFS though so
>>> even though it can be set as an intersection each card would still
>>> require DFS suport for that region.
>>>
>>> As I see it this will depend on what we want cards to do if the DFS
>>> region is unknown for a region. If the DFS region is not known can
>>> we use any DFS algorithm? If we cannot then I think a DFS intersection
>>> would require agreement on the DFS region. That would also mean though
>>> that when shipping products if a system is built with one card that has
>>> DFS for ETSI for example, and then a secondary card is present and its
>>> regulatory domain does not have DFS then the first card would not be
>>> able to operate on the DFS. I think this is reasonable given that 
>>> the two cards must at least agree on the regulatory domain, otherwise
>>> the folks doing system integration probably did a bad job at thinking
>>> of things ahead of time. Even though this can be technically true I
>>> foresee folks this misconfiguration happening in the future and folks
>>> beingp puzzled by this as an issue. This means this should be documented
>>> for folks selling devices in a combined wifi system.
>>
>> Maybe some stuff should be per-NIC instead of per OS instance.  It would
>> suck if adding some ancient USB wifi NIC to a system disabled shiny new
>> features on already-existing NICs.
> 
> That indeed is a good example corner case that is needs to be thought of
> here. Say a system is designed that is DFS certified for DFS-ETSI and
> then someone plugs in a card that had a regulatory domain for a a
> country where the DFS region is not known -- what should we do with the
> system in terms of DFS support? Disable DFS ? Or force the DFS-ETSI for
> both devices? The safe thing IMHO is to disable DFS and ensure folks
> are aware of this, and to help add a print to the system logs to ensure
> its understood what just happened.

Why not let the DFS-ETSI NIC do DFS-ETSI, and let the other one not do
DFS at all?

As soon as you get two different NICS with different regulatory domains,
you basically should assume that the regulatory info based on those
NICs is close to worthless, so one shouldn't be able to impede the other.

Maybe just use time-zone or user hints in this case since NICs cannot
be fully trusted.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

