Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MAIL.IHTFP.ORG ([204.107.200.6]:54324 "EHLO mail.ihtfp.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762029AbXHCOdN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 10:33:13 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: dragoran <drago01@gmail.com>,
	"Winkler\, Tomas" <tomas.winkler@intel.com>,
	linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] chaning mode only when interface down?
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	<1186058047.24230.38.camel@johannes.berg> <46B1D28F.1080006@gmail.com>
	<1186059192.24230.44.camel@johannes.berg>
From: Derek Atkins <warlord@MIT.EDU>
Date: Fri, 03 Aug 2007 10:33:07 -0400
In-Reply-To: <1186059192.24230.44.camel@johannes.berg> (Johannes Berg's message of "Thu\, 02 Aug 2007 14\:53\:11 +0200")
Message-ID: <sjmy7gswuvw.fsf@pgpdev.ihtfp.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2007-08-02 at 14:48 +0200, dragoran wrote:
>
>> > Nono, you cannot solve it in the driver. The whole design of mac80211
>> > mandates that assumption and I think it is a valid one to make.
>> why? did the old way (allow mode changing while up) caused any problems?
>
> Why should it be allowed? Can you come up with a good reason for that
> since you lose all state anyway when doing mode transitions?

Um, what state?  Sure you lose your layer 2 state, but why force a
layer 3 lossage when you don't necessarily have to do so?  For
example, I've seen plenty of networks that have both 802.11(a) and
802.11(b/g) networks that share absolutely everything at layer 3.
Indeed, at home I have an a/b/g AP where layer 3 is always shared.  At
the IETF last week it was also shared.  I could easily roam from the
802.11(a) to the 802.11(b/g) network if my wireless driver would let
me; the IP Address I've got is certainly valid on both networks.  Why
should the driver try to be smarter than I am?

> Until then (and I guess somebody *really* wants it) it's just a lot
> easier to not even try to change these low-level things while the
> interface is operating.

Easier for the driver developer or easier for the user?  In general
it's better to implement more challenging code in order to make life
easier for the end user.  In this case it certainly looks like you're
foresaking your users to make the developer's life (maybe) a tiny bit
easier.

> johannes

-derek

-- 
       Derek Atkins, SB '93 MIT EE, SM '95 MIT Media Laboratory
       Member, MIT Student Information Processing Board  (SIPB)
       URL: http://web.mit.edu/warlord/    PP-ASEL-IA     N1NWH
       warlord@MIT.EDU                        PGP key available
