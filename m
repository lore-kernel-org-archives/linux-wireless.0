Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:39572 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbZLGPub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Dec 2009 10:50:31 -0500
Received: by bwz27 with SMTP id 27so3595982bwz.21
        for <linux-wireless@vger.kernel.org>; Mon, 07 Dec 2009 07:50:37 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, patrik.flykt@nokia.com
Subject: Re: WMM classification guideline for applications?
References: <87d42u6dnd.fsf@purkki.valot.fi>
	<1260097037.3461.10.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 07 Dec 2009 17:50:33 +0200
In-Reply-To: <1260097037.3461.10.camel@johannes.local> (Johannes Berg's message of "Sun\, 06 Dec 2009 11\:57\:17 +0100")
Message-ID: <87ein64wc6.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2009-12-04 at 16:02 +0200, Kalle Valo wrote:
>
>> Method 3 (IPv4 DSCP field) feels most portable to us, at least most,
>> if not all, wifi drivers should use it. And, in theory, the receiver
>> should also benefit from the classification, unless ISPs modify it of
>> course. But the standardisation for IPv4 QoS bits is a mess and I
>> don't really understand where the use of DSCP bits (as used in WMM
>> implementations) is specified. 
>
> http://tools.ietf.org/rfc/rfc2474.txt ?

This wasn't clear to me, so I investigated this a bit. This is what I
found:

The user priorities (0-7) are defined in IEEE 802.1D-2004 Annex G. I
believe this the output from task group 802.1p. The mapping from user
priorities (UP) to 802.11 queues is both in the WMM spec and in IEEE
802.11-2007 Table 9-1.

Like you said, DSCP is defined in RFC 2474 "Definition of the
Differentiated Services Field (DS Field) in the IPv4 and IPv6
Headers". But the definition is IMHO very vague:

4.3  Summary

   "This document defines codepoints 'xxx000' as the Class Selector
   codepoints, where PHBs selected by these codepoints MUST meet the
   Class Selector PHB Requirements described in Sec. 4.2.2.2. This is
   done to preserve a useful level of backward compatibility with
   current uses of the IP Precedence field in the Internet without
   unduly limiting future flexibility. In addition, codepoint '000000'
   is used as the Default PHB value for the Internet and, as such, is
   not configurable. The remaining seven non-zero Class Selector
   codepoints are configurable only to the extent that they map to
   PHBs that meet the requirements in Sec. 4.2.2.2."


4.2.2.2  The Class Selector PHB Requirements

   "We refer to a Class Selector Codepoint with a larger numerical
   value than another Class Selector Codepoint as having a higher
   relative order while a Class Selector Codepoint with a smaller
   numerical value than another Class Selector Codepoint is said to
   have a lower relative order. The set of PHBs mapped to by the eight
   Class Selector Codepoints MUST yield at least two independently
   forwarded classes of traffic, and PHBs selected by a Class Selector
   Codepoint SHOULD give packets a probability of timely forwarding
   that is not lower than that given to packets marked with a Class
   Selector codepoint of lower relative order, under reasonable
   operating conditions and traffic loads."

>From the text above you can, somehow, make the assumption that it's ok
to use priorities 0-7 in DSCP bits 0-3. There's also a requirement for
backwards support of IP Precedence bit:

   "PHBs selected by codepoints '11x000' MUST give packets a
   preferential forwarding treatment by comparison to the PHB selected
   by codepoint '000000' to preserve the common usage of IP Precedence
   values '110' and '111' for routing traffic."

Because '110' is mapped to UP 6 and '111' is UP 7, that requirement is
also fulfilled.

But I didn't find anywhere explicit mappings between DSCP and 802.1d
priorities. Being an 802 standard 802.1d only talks about MAC level,
just as it should. Also from RFCs I didn't find anything more concrete
than above.

So from this I guess I can conclude that it is acceptable to use
802.1d user priorities in DSCP. At least I hope so :)

>> Also I was told that root privileges
>> are needed to set this and that's somewhat cumbersome from application
>> developer's point of view.
>
> I don't see that IP_TOS, which will end up setting IP TOS/DSCP, requires
> any elevated privileges:

[...]

I tested with a small python script and you are correct, as usual. No
extra priviliges were needed.

> In any case, I think this topic would benefit of cross-posting to
> netdev :)

I will definitely do that. I just wanted to hear opinions from the
wireless crowd first.

I'll create a wiki page summarising this and then ask from netdev.

-- 
Kalle Valo
