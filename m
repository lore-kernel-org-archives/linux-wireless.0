Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab0IIU6o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 16:58:44 -0400
To: Steve deRosier <steve@cozybit.com>
Subject: Re: [PATCH 5/9] =?UTF-8?Q?libertas=5Ftf=3A=20Moved=20firmware=20loading?=
 =?UTF-8?Q?=20to=20probe=20in=20order=20to=20fetch=20MAC=20address?=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Thu, 09 Sep 2010 22:58:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<javier@cozybit.com>
In-Reply-To: <AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-6-git-send-email-steve@cozybit.com> <e23a1b600a18f179fa72d2cadf724d17@localhost> <AANLkTi=r_RdEG-2=gzV7uFNJt1Nynp3qNC-38SQkzhO2@mail.gmail.com>
Message-ID: <c9d7238e26d9e276d9c9ef9792f7c7f8@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 9 Sep 2010 12:13:52 -0700, Steve deRosier <steve@cozybit.com>
wrote:
> Before doing any of this stuff (back in patch 1), my driver goes
> through and loads the firmware using the request_firmware() calls
> anyway.

Right.

> In other words, I haven't changed that part.  Is the problem
> specifically with my "get the MAC from the hardware before setting up
> mac80211" change, or with waiting on firmware loading?

Well, so previously mac80211 had some support for *not* knowing
the MAC address before setting up all of the mac80211 stuff, but
that broke and I'd like to remove it as well because it advertises
wrong things to userspace. So you need to know the MAC address
before registering with mac80211.

Now, on libertas_tf (correct me if I'm wrong), the firmware has to
be loaded to read the MAC address. So you need to load the firmware
in probe or so, like you do now. Then, however, building it into
the kernel may fail to load the firmware.

> For fun, I just tried compiling the driver into the kernel.  Mixed
> results: with two cards on the system, the first card found failed on
> the call to request_firmware() with a -ENOENT, while the second card
> came up just fine.  When done as modules, both work fine.  So there's
> clearly something to what you're saying. Is it that the filesystem is
> not up and available yet when we try to load the firmware for the
> first card?

Yeah, userspace needs to be up and running to load firmware.

> From looking through the drivers, iwl and ar9170_usb are the only ones
> to use the request_firmware_nowait().  I don't know if those are the
> only mac80211 cards with firmware or not everyone's following the
> model.

Well, not everyone's following the model _yet_ (look at mwl8k for
example), but nobody but libertas_tf needs firmware loaded to know
the MAC address. So they don't have the MAC address issue there.

> Do you have specific pointers of which code I should look at as a
> model, or a better way to solve the problem?

You should probably look at ar9170 or iwlwifi.

> In the short term, can we limit libertas_tf to build as module only
> via Kconfig, and I can add the request_firmware_nowait() as a new
> feature later with a new patch? 

Certainly. I just wanted to point it out. This wasn't meant as
a comment that should stop merging of these patches.

> Looking at the examples, it looks
> like the changes for this would be fairly involved and I would prefer
> to break such a change out separately. 

Yeah, I tried to do it in libertas_tf at some point last year and
failed miserably :-)

> I'd like to get
> libertas_tf_sdio accepted as a base so I can then do smaller change
> sets going forward. Is that a reasonable plan or just plain silly?

Makes sense to me.

johannes

