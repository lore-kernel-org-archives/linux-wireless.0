Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:60494 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbZBJCHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 21:07:52 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 18:07:52 -0800
Date: Mon, 9 Feb 2009 18:07:08 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tony Vroon <tony@linx.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090210020708.GC4386@tesla> (sfid-20090210_030756_554064_EC5E8AE0)
References: <1234202993.21570.18.camel@localhost> <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com> <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com> <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost> <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234230689.3793.15.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2009 at 05:51:29PM -0800, Tony Vroon wrote:
> On Mon, 2009-02-09 at 17:39 -0800, Luis R. Rodriguez wrote: 
> > In Intel's case the first regulatory domain is ignored (world). To see,
> > before associating to an AP try running 'iw list'.
> 
> I will remove NetworkManager & gdm from the default runlevel and try
> that, yes.
> 
> > I noticed that, what ends up happening then is the static world regulatory
> > domain is used from the kernel. I take it you used an initramfs with the
> > sda driver in there?
> 
> No. There's an initramfs, but it's only used to unlock the encrypted
> root filesystem. The actual driver for sda (ata_piix) is in the kernel.

Intersting -- this is the first case I hear about this.

> > I've been using initramfs too but for some reason
> > on my system udev triggers the request eventually after the drive
> > is mounted. So this is the first time I hear of this.
> 
> I have another user reporting it on PowerPC, without an encrypted root.

Are they also disabling OLD_REG? Note that the only routine I see
failing then in the initial:

err = __regulatory_hint(NULL, REGDOM_SET_BY_CORE, "00", 0, ENVIRON_ANY);

Is a kmalloc() (unlikely) or call_crda() failing, and call_crda() will
only fail if kobject_uevent_env() fails and last I checked that would
fail only if the kernel failed to build and emit the udev event (it doesn't mean
CRDA was not present, it should mean udev never got the udev event IIRC).

> > I also noticed though:
> > 
> > cfg80211: Calling CRDA for country: GB
> > cfg80211: Current regulatory intersected:
> >         (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
> >         (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
> > 
> > This seems to indicate to me you manually ran:
> > 
> > sudo iw reg set GB
> > 
> > Is that the case? 
> 
> Eventually, yes.

Oh? Hmm.. if we leave the channel intact before applying the intersected
regulatory domain and if 'iw list' shows the 5 GHz channels it should mean
they are left enabled, I'm a bit puzzled myself, unless I'm missing something.

> To see if that would clear things up, but it didn't.
> Even if I just leave the AP 802.11d info to fill in the regulatory
> information (which you can see higher up, as it has the information
> slightly wrong and includes channel 14 together with very high radio
> power) the 5GHz channels are not included.

Heh :)

> As said, will do an iw list with no other software having fiddled with
> anything yet. The Cisco APs are in the vicinity so I may not be able to
> stop them picking up the 80211d info though.

Actually we don't follow country IE hints in Linux until we associate
to an AP so you should be good.

  Luis
