Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:46642 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab1GSPkY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 11:40:24 -0400
Received: by fxd18 with SMTP id 18so207377fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jul 2011 08:40:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311089696.2647.4.camel@dcbw.foobar.com>
References: <20110717170346.45A739D401C@zog.reactivated.net>
	<1311089696.2647.4.camel@dcbw.foobar.com>
Date: Tue, 19 Jul 2011 16:40:23 +0100
Message-ID: <CAGq3pz6OP5CNHMvCtxkRKhU-dx097k66d1h0eGJT0Lhs9oM+Cw@mail.gmail.com> (sfid-20110719_174027_735470_FFD79103)
Subject: Re: [PATCH 4/4] libertas: reimplement mesh channel selection
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 July 2011 16:34, Dan Williams <dcbw@redhat.com> wrote:
> On Sun, 2011-07-17 at 18:03 +0100, Daniel Drake wrote:
>> This reimplements code allowing for mesh channel selection according
>> to how NetworkManager expects.
>
> Originally I was trying to get away from magical functions that used
> variables of the internal private structure to change state, ie moving
> most of the actual data for the firmware commands to the function
> argument list instead of accessing priv->xxxx internally.  The idea
> there was that it would be easier to follow the code flow through the
> driver if you knew that these functions weren't touching all sorts of
> internal variables.  Any chance we can preserve that?  Thoughts?  That
> was my intent at least but it's not set in stone.

I assume you are referring to priv->mesh_channel;

We need to store the selected channel somewhere for 2 reasons.
1. For the SIOCGIWFREQ implementation
2. for knowing which channel to start the mesh on when the device is brought up.

I'm open to other suggestions for where such information can be kept,
but I don't see a way to not store it.

Note that this was already done before as priv->channel. I have
separated that into channel and mesh_channel based on the observation
that at the hardware/firmware level, the mesh channel is programmed
and stored separately. You can connect to one channel "normally" and
program the mesh to run on another channel. Once your "normal"
connection is brought down, it automatically starts meshing on the
other channel. etc.

Thanks,
Daniel
