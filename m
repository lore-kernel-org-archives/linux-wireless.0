Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:24068 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbYCEFhf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 00:37:35 -0500
Received: by ti-out-0910.google.com with SMTP id 28so1649473tif.23
        for <linux-wireless@vger.kernel.org>; Tue, 04 Mar 2008 21:37:31 -0800 (PST)
Message-ID: <445f43ac0803042137n6ce996f4radd58d3104fb49e1@mail.gmail.com> (sfid-20080305_053741_672338_F7DF76EA)
Date: Tue, 4 Mar 2008 21:37:29 -0800
From: "Javier Cardona" <javier@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mesh beaconing questions
Cc: "Luis Carlos Cobo" <luisca@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1204034825.13162.233.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1204034825.13162.233.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

>  The Draft states that beacons may be sent either as defined for IBSS or
>  as defined for infrastructure mode.
>
>  I have a few questions, some of which are related to our implementation
>  and others which are related to the Draft.
>
>  1. Are we going to let drivers choose which mode to use? Should they
>  indicate that somehow so userspace knows? Or are we going to make this
>  configurable? Can all hardware support both modes? (the last question
>  probably ties in with the next)

Beaconing and synchronization are the two areas that are still
actively debated at TGs, and they are somewhat dependent (
http://odysseus.ieee.org/cs.html?charset=iso-8859-1&url=http%3A//mentor.ieee.org/802.11/public-file/07/11-07-2853-00-000s-functional-interdependences.ppt&qt=url%3Amentor.ieee.org/802.11+||+jarkko+kneckt&col=mentor&n=2&la=en
). I would not invest much time in trying to support both modes at
this time.

That said, if things stay as they are now, we would have to make that
configurable (only if the driver supports both beaconing modes, of
course).

> (...)
> Hence, I think the draft needs to be expanded to modify 11.1.2.2 to
> explain under which circumstances an MP shall cancel its beacon if it
> opts to use IBSS-like beaconing.

Agreed.

> I think the only useful thing is to require it to look at the mesh IEs,

... and path selection method and metric.

> but that is not implementable with existing hardware, at least not
> without firmware changes.

Needing firmware changes is a problem for o11s, but not for TGs:
there will be other firmware (and maybe hardware) changes required to
implement the standard.  o11s challenge is to do as much as possible
with commodity hardware, and doing IBSS beaconing with null BSSID
seems like an OK compromise.  Every once in a while and MP may cancel
a beacon transmission because it receives a beacon from a different
mesh:  that's not such a big deal.

Cheers,

Javier

PS.  BTW, you should attend the IEEE meetings.  Really!

-- 
Javier Cardona
cozybit Inc.
