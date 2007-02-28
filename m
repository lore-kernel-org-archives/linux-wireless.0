Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:48440 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbXB1SYe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:24:34 -0500
Received: by nf-out-0910.google.com with SMTP id o25so636148nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 10:24:32 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/28] rt2x00:
Date: Wed, 28 Feb 2007 19:24:28 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.04933.IvDoorn@gmail.com> <200702281807.28551.IvDoorn@gmail.com> <1172682993.5015.52.camel@johannes.berg>
In-Reply-To: <1172682993.5015.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281924.28452.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 28 February 2007 18:16, Johannes Berg wrote:
> On Wed, 2007-02-28 at 18:07 +0100, Ivo van Doorn wrote:
> 
> > That is where rt2x00lib is coming in. This is only a recent addition to rt2x00
> > so not everything has moved in correctly. So you can expect more to be
> > merged into rt2x00lib.
> 
> Yeah, I see that.
> 
> > Merging rt2400pci and rt2500pci doesn't sound like a good idea to me,
> > once rt2x00lib has been optimally used most duplicate code is out,
> 
> Well you'll still have a lot of the registration code etc. duplicated.

Personally I think the amount of duplicated code will not be that bad,
but I can make a better comparison when rt2x00lib is better used than currently
is the case.

> > and merging those 2 could make the implementation of hardware encryption
> > for rt2500pci harder. rt2400pci is the only Ralink chip that is not capable of
> > hardware encryption.
> 
> That I don't understand at all; if it's a 2400pci chip you just return
> early from the set_key() callback and thereby tell mac80211 to use sw
> crypto.
 
It goes a bit further than that, interrupt handling is done differently as well,
and still a lot of checks during register intialization have to be performed about
what to do when. Some functions, like channel selection, would have to be
implemented twice due to the number of checks for each indivudual RF chipset.

But to be honest, the last time I had looked into rt2400pci and rt2500pci merger
was in the early days of rt2x00 when there wasn't a Linux wireless stack yet. Not
even Intel had announced its stack yet. (rt2x00 started in 2004) so back then
I had to try to extract the stack from the Ralink drivers.

Personally I think that merging the 2 drivers would make the code too obscure
to be easily understandable after the implementation of hardware encryption.
But I could be wrong, as I haven't worked on the hardware encryption yet
(getting things working without HW encryption is hard enough). So I think it is best
to reinvestigate merging rt2400pci and rt2500pci, when both modules are
working independently and hardware encryption work is being done. That will give
the best comparison material for making a better decision.

Ivo
