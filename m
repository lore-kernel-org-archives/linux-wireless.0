Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:58773 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab0BWQot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 11:44:49 -0500
Received: by fxm19 with SMTP id 19so4011960fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 08:44:48 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] Improve software scan timing
Date: Tue, 23 Feb 2010 17:44:39 +0100
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
References: <201002231619.55189.helmut.schaa@googlemail.com> <201002231633.06394.helmut.schaa@googlemail.com> <1266939493.3934.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1266939493.3934.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201002231744.39133.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag 23 Februar 2010 schrieb Johannes Berg:
> On Tue, 2010-02-23 at 16:33 +0100, Helmut Schaa wrote:
> > > > Kalle, Johannes, how is the listen_interval handled in the
> > > > powersave code?
> > > > Are we only sleeping for one beacon interval or are we ignoring
> > > > the listen_interval currently.
> > >
> > > I figured this listen interval stuff would come back to bite us at
> > > some point. I don't think we should negotiate a listen interval of 1.
> > > OTOH, I'm not convinced that all APs would reject it with a status code of
> > > 51 if it's too large? Or is that tested anywhere like WFA?
> >
> > No idea. However for iwlwifi for example we always used a listen
> > interval
> > of 20 any I never saw any associations getting rejected because of
> > this.
> >
> > So maybe we could just increase the default to something between 5 and
> > 10 to be on the safe side?
>
> Yeah, maybe. Could it be useful for userspace to ask for a specific
> value with assoc? Though I'm not really sure what it would use ...

I don't think so. Basically user space only wants to set parameters like
pm_qos and if the configured latency allows us to sleep for x ms we should
make use of it to improve battery life.

Ok, I'll just update the listen_interval to default to 5 and make use of it
in the scan implementation. That should allow us in most cases to leave the
channel for around 500ms which is enough time to scan maybe 3-10 channels
depending on active/passive flags.

Would that be ok for you?

Helmut
