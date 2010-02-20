Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0BTLHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2010 06:07:16 -0500
Subject: Re: [PATCH v3] mac80211: deprecate RX status noise
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: Pavel Roskin <proski@gnu.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <7f9d9abf1002181728q63c9f090je175681bc520f0ad@mail.gmail.com>
References: <1266437114.23447.0.camel@jlt3.sipsolutions.net>
	 <1266438137.23447.1.camel@jlt3.sipsolutions.net>
	 <1266438446.23447.2.camel@jlt3.sipsolutions.net> <4B7C561C.70702@free.fr>
	 <43e72e891002171429j7f47c86bqd4374bf07b8979de@mail.gmail.com>
	 <1266447118.12365.21.camel@mj>
	 <1266494831.6261.1.camel@jlt3.sipsolutions.net>
	 <7f9d9abf1002181728q63c9f090je175681bc520f0ad@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 20 Feb 2010 12:06:11 +0100
Message-ID: <1266663971.10741.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-02-18 at 17:28 -0800, Sam Leffler wrote: 
> Depends on your definition of channel.  For MIMO devices you can have
> NF per RX chain.

Indeed.

> NF is typically measured infrequently but the frequency is inherently
> hw-specific.

Right.

> Given radiotap is inherently packet-oriented there was little choice
> but to package noise in the way it is.  If you include it only when it
> changes but then you lose the ability to interpret each record
> independently.  Given this value is 8-bits I don't see the big deal.
>  Fixing drivers to include useful data seems more important.

Ah. No, this is not really what I'm debating. For radiotap, we can
include the value in every packet, no matter when it was measured. But
for actual measurement API etc. I think we need to take more care and
not require the driver to fill the status per packet. We can handle
that, for radiotap, in the stack; actually getting noise information out
of the card into userspace _when requested_ should have more of an
up-to-date guarantee (or just not give a value) though, I think. I'd be
happy to make the stack fill radiotap with whatever value we have, but
the way we report it now from the driver to the stack seems completely
bogus.

johannes 


