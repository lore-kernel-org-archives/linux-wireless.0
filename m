Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752249Ab1GTQEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 12:04:09 -0400
Subject: Re: [PATCH 4/4] libertas: reimplement mesh channel selection
From: Dan Williams <dcbw@redhat.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	libertas-dev@lists.infradead.org
Date: Wed, 20 Jul 2011 11:07:50 -0500
In-Reply-To: <CAGq3pz6OP5CNHMvCtxkRKhU-dx097k66d1h0eGJT0Lhs9oM+Cw@mail.gmail.com>
References: <20110717170346.45A739D401C@zog.reactivated.net>
	 <1311089696.2647.4.camel@dcbw.foobar.com>
	 <CAGq3pz6OP5CNHMvCtxkRKhU-dx097k66d1h0eGJT0Lhs9oM+Cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1311178071.21004.4.camel@dcbw.foobar.com> (sfid-20110720_180419_003364_AE070FC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-07-19 at 16:40 +0100, Daniel Drake wrote:
> On 19 July 2011 16:34, Dan Williams <dcbw@redhat.com> wrote:
> > On Sun, 2011-07-17 at 18:03 +0100, Daniel Drake wrote:
> >> This reimplements code allowing for mesh channel selection according
> >> to how NetworkManager expects.
> >
> > Originally I was trying to get away from magical functions that used
> > variables of the internal private structure to change state, ie moving
> > most of the actual data for the firmware commands to the function
> > argument list instead of accessing priv->xxxx internally.  The idea
> > there was that it would be easier to follow the code flow through the
> > driver if you knew that these functions weren't touching all sorts of
> > internal variables.  Any chance we can preserve that?  Thoughts?  That
> > was my intent at least but it's not set in stone.
> 
> I assume you are referring to priv->mesh_channel;
> 
> We need to store the selected channel somewhere for 2 reasons.
> 1. For the SIOCGIWFREQ implementation
> 2. for knowing which channel to start the mesh on when the device is brought up.

Storing it is fine; I was just trying to keep the functions that built
firmware commands from poking priv->xxx stuff.  Hence why there was a
'chan' parameter to the function, to push the actual decision about what
channel to change to up to the thing that actually decided it was
necessary to change the channel at all.  In this case it's not as
relevant as other cases, so in the end I don't really care as much.

Dan

> I'm open to other suggestions for where such information can be kept,
> but I don't see a way to not store it.
> 
> Note that this was already done before as priv->channel. I have
> separated that into channel and mesh_channel based on the observation
> that at the hardware/firmware level, the mesh channel is programmed
> and stored separately. You can connect to one channel "normally" and
> program the mesh to run on another channel. Once your "normal"
> connection is brought down, it automatically starts meshing on the
> other channel. etc.
> 
> Thanks,
> Daniel
> 
> _______________________________________________
> libertas-dev mailing list
> libertas-dev@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/libertas-dev


