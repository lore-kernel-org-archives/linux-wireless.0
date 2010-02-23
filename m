Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36347 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373Ab0BWPdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 10:33:19 -0500
Received: by fxm19 with SMTP id 19so3933091fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 07:33:16 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] Improve software scan timing
Date: Tue, 23 Feb 2010 16:33:06 +0100
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
References: <201002231619.55189.helmut.schaa@googlemail.com> <1266938710.3934.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266938710.3934.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002231633.06394.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 23 Februar 2010 schrieb Johannes Berg:
> On Tue, 2010-02-23 at 16:19 +0100, Helmut Schaa wrote:
> > Should we also consider the current listen_interval for deciding how
> > long
> > we could stay away from the operating channel? That should prevent us
> > from losing too many frames but since most drivers don't register a
> > max_listen_interval we usually end up with a listen_interval of
> > 1 which is quite short (which means only scanning one channel in a
> > row).
> >
> > Kalle, Johannes, how is the listen_interval handled in the powersave
> > code?
> > Are we only sleeping for one beacon interval or are we ignoring the
> > listen_interval currently.
>
> I figured this listen interval stuff would come back to bite us at some
> point. I don't think we should negotiate a listen interval of 1. OTOH,
> I'm not convinced that all APs would reject it with a status code of 51
> if it's too large? Or is that tested anywhere like WFA?

No idea. However for iwlwifi for example we always used a listen interval
of 20 any I never saw any associations getting rejected because of this.

So maybe we could just increase the default to something between 5 and 10
to be on the safe side?

> In any case, right now the powersave code pretty much ignores it,
> although that's not really a good plan.

Right.

Helmut
