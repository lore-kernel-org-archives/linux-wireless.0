Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MAIL.IHTFP.ORG ([204.107.200.6]:37299 "EHLO mail.ihtfp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885AbXHBQWV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 12:22:21 -0400
To: dragoran <drago01@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Winkler\, Tomas" <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	<1186058047.24230.38.camel@johannes.berg> <46B1D28F.1080006@gmail.com>
	<1186059192.24230.44.camel@johannes.berg>
	<f6ca9fed0708020643p53ceedcav76b14814b1b1cabd@mail.gmail.com>
From: Derek Atkins <warlord@MIT.EDU>
Date: Thu, 02 Aug 2007 11:52:26 -0400
In-Reply-To: <f6ca9fed0708020643p53ceedcav76b14814b1b1cabd@mail.gmail.com> (dragoran's message of "Thu\, 2 Aug 2007 15\:43\:24 +0200")
Message-ID: <sjmir7yx7b9.fsf@pgpdev.ihtfp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dragoran <drago01@gmail.com> writes:

> On 8/2/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>     On Thu, 2007-08-02 at 14:48 +0200, dragoran wrote:
>    
>     > > Nono, you cannot solve it in the driver. The whole design of mac80211
>     > > mandates that assumption and I think it is a valid one to make.
>     > why? did the old way (allow mode changing while up) caused any problems?
>    
>     Why should it be allowed? Can you come up with a good reason for that
>     since you lose all state anyway when doing mode transitions?
>    
>     Until then (and I guess somebody *really* wants it) it's just a lot
>     easier to not even try to change these low-level things while the
>     interface is operating.
>
> ok fair enough

Well, for one thing in many cases the interface needs to be "up" in
order to scan.  Also, many times the driver itself will incorrectly
associate on insert before NetworkManager gets a chance to chime in
and then you're stuck in a situation where you never get to the band
you want.

Regardless, you should NEVER require a driver reload to switch bands
and if you do that's a bug.  If mac80211 requires a driver reload then
that's a MAJOR flaw in that layer.

Still, NM keeps the interface "up" even when there's no packets,
because it's required to scan.  So that may be why I've had trouble
going between 802.11(a) and 802.11(b/g) networks at times.  It's quite
frustrating.

-derek

-- 
       Derek Atkins, SB '93 MIT EE, SM '95 MIT Media Laboratory
       Member, MIT Student Information Processing Board  (SIPB)
       URL: http://web.mit.edu/warlord/    PP-ASEL-IA     N1NWH
       warlord@MIT.EDU                        PGP key available
