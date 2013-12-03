Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42638 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab3LCJeb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 04:34:31 -0500
Message-ID: <1386063265.4393.3.camel@jlt4.sipsolutions.net> (sfid-20131203_103436_474873_EEBB931F)
Subject: Re: [RFC] cfg80211/mac80211: drop GTK-protected unicast IP packets
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, j@w1.fi
Date: Tue, 03 Dec 2013 10:34:25 +0100
In-Reply-To: <CABPxzYJfBG0YtCrfkg_PqV4MP+MdLePhD2QdFQF9D+EfPObnZQ@mail.gmail.com> (sfid-20131203_102026_263382_A70E781F)
References: <1386010316-2540-1-git-send-email-johannes@sipsolutions.net>
	 <CABPxzYJfBG0YtCrfkg_PqV4MP+MdLePhD2QdFQF9D+EfPObnZQ@mail.gmail.com>
	 (sfid-20131203_102026_263382_A70E781F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-12-03 at 14:50 +0530, Krishna Chaitanya wrote:
> On Tue, Dec 3, 2013 at 12:21 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > The GTK is shared by all stations in an 802.11 BSS and as such any
> > one of them can send forged group-addressed frames. To prevent this
> > kind of attack, drop unicast IP packets if they were protected with
> > the GTK, i.e. were multicast packets at the 802.11 layer.
> >
> > Based in part on a patch by Jouni that did the same but in the IP
> > stack, which was considered too intrusive.
> >
> As per RFC 1122 this is an invalid case:
>          When a host sends a datagram to a link-layer broadcast address,
>          the IP destination address MUST be a legal IP broadcast or IP
>          multicast address.
> 
>          A host SHOULD silently discard a datagram that is received via
>          a link-layer broadcast (see Section 2.4) but does not specify
>          an IP multicast or broadcast destination address.
> 
> We can simply drop this frame irrespective of GTK/PTK is used.

Interesting. Can you point out where this is implemented in the IP
stack(s)?

johannes

