Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:46995 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3KNQOD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 11:14:03 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
Date: Thu, 14 Nov 2013 17:13:59 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com> <1384442962.13941.36.camel@jlt4.sipsolutions.net> <CAB=NE6WX9JV-Lx11iiPHPinDCxy7u-Q--ucQ-9Mjy-nndKTeqQ@mail.gmail.com>
In-Reply-To: <CAB=NE6WX9JV-Lx11iiPHPinDCxy7u-Q--ucQ-9Mjy-nndKTeqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201311141714.00098.sw@simonwunderlich.de> (sfid-20131114_171408_169408_59B28CF1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> On Thu, Nov 14, 2013 at 4:29 PM, Johannes Berg
> 
> <johannes@sipsolutions.net> wrote:
> > On Thu, 2013-11-14 at 07:33 -0800, Luis R. Rodriguez wrote:
> >> > Still doesn't make sense - HANDLE_DFS means "I'll react to radar
> >> > detection events and will do the CSA". It has absolutely nothing to do
> >> > with DFS regions. Please keep those things separate.
> >> 
> >> How you deal with radar detection is completely dependent on the DFS
> >> region, no?
> > 
> > You're missing *my* point :-)
> > 
> > Radar *detection* is region-dependent.
> > 
> > What happens *after* that (announce a channel switch, etc.) isn't at
> > all.
> 
> Sorry, I misread the documentation then, so HANDLE_DFS *does* not mean
> userspace will implement the radar detection in userspace?
> 

Right, it does not mean userspace implements radar detection/pattern 
matching/etc.

HANDLE_DFS only means that userspace lets the kernel know that it will react 
to nl80211-dfs-radar events (these only contain "i detected a radar on freq 
XXX" [1] and similar) and that it will do a channel switch (CSA) in this case 
to move away.

We still assume that the radar detection/pattern matching/etc, which is indeed 
region-specific, is done in the drivers (as done for ath9k now) or by other 
means independent of this HANDLE_DFS attribute.

Cheers,
    Simon

[1] http://lxr.free-electrons.com/source/include/uapi/linux/nl80211.h#L3836
