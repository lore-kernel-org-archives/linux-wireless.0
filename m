Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:36001 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756705AbZKQWyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:54:38 -0500
Date: Wed, 18 Nov 2009 00:54:08 +0200
From: Jouni Malinen <j@w1.fi>
To: David Acker <dacker@roinet.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	madwifi-devel@lists.sourceforge.net,
	madwifi-users@lists.sourceforge.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Madwifi-devel] Survey: What are you using MadWifi for, and
 why?
Message-ID: <20091117225408.GA20540@jm.kir.nu>
References: <2205.95.222.251.107.1258282369.squirrel@webmail.otaku42.de>
 <43e72e890911161701p61d0db5ag25a1459f900b3ab7@mail.gmail.com>
 <4B02DFF4.1060509@roinet.com>
 <45e8e6c40911171257m7c687380k6e6e2677fd11f851@mail.gmail.com>
 <43e72e890911171337p4b0d97fcp844266137bb51b56@mail.gmail.com>
 <4B03193E.2080304@roinet.com>
 <43e72e890911171345q2dc59d66g6ac2a9eec04c577c@mail.gmail.com>
 <4B031B48.1090105@roinet.com>
 <43e72e890911171404x1a46d07alb54946768d0f9cf5@mail.gmail.com>
 <4B032390.3080501@roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B032390.3080501@roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 05:28:32PM -0500, David Acker wrote:
> Luis R. Rodriguez wrote:
> >On Tue, Nov 17, 2009 at 1:53 PM, David Acker <dacker@roinet.com>
> >wrote:
> >>The problem with switching to ath5k would be the loss of
> >>performance related features (compression, fast frames, turbo),

> Yes, but it would be good if these features were supported over WDS
> links (and on AP to STA links where both support the features).

This type of vendor-specific extensions are somewhat difficult to get an
acceptable, clean implementation in mac80211; or well, at least it will
take major effort to convince the developers in why these should be
added. These Super A/G features have been discussed in the past and
there has not really been very enthusiastic support for adding them into
upstream mac80211/cfg80211..

Compression could, at least in theory, be done as a driver specific hack
(with somewhat ugly hack needed to handle negotiation for it in case of
AP/STA mode; could by statically configured for WDS links using the test
command, I think).

I don't see feasible path to get a clean implementation for fast frames
in mac80211. If you do not care about backwards compatibility with the
vendor-specific fast frames design, it would probably be much easier to
get A-MSDU aggregation (from 802.11n) implemented in mac80211 and then
as an additional option enable that with non-802.11n devices (that would
be the only part that is outside the context of the IEEE standard). This
would bring you something similar to fast frames that would potentially
be available with any mac80211-based driver.

I could see static turbo mode as a potential mode that could be
supported with ath5k if there is enough desire to do so. I would not go
with dynamic turbo mode, though.

> based.  I believe I misspoke when I said half/quarter rates.  It is
> better to say half width (10 MHz) or quarter width (5 MHz) channels.
> There are several miniPCI based radios that require half or quarter
> width channels on some channels.  For example, the Ubiquiti XR7
> requires quarter width channels on two of its four available
> channels.  The XR9 requires half width channels on two if its four
> available channels.  Sorry for any confusion I created.

Supporting half/quarter width channels sounds reasonable in general. The
main problem with this one seems to have been in getting someone
dedicated enough to go through the effort in a way that would cleanly
extend the regulatory framework in use with cfg80211. The additional
complexity of not so common frequency range for 802.11 devices is going
to make this somewhat more difficult to get accepted, though, at least
in the case of these couple of examples, but just getting 10 MHz
channels working with the more standard frequency bands would sounds
like a reasonable step towards being able to support something like
this.

-- 
Jouni Malinen                                            PGP id EFC895FA
