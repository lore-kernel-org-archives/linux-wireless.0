Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58850 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbZBJBkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 20:40:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 17:40:25 -0800
Date: Mon, 9 Feb 2009 17:39:41 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tony Vroon <tony@linx.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
	ranges
Message-ID: <20090210013941.GA4386@tesla> (sfid-20090210_024031_638591_C1E3DDA4)
References: <1234202993.21570.18.camel@localhost> <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com> <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com> <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1234208152.6694.4.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 09, 2009 at 11:35:52AM -0800, Tony Vroon wrote:
> Do correct me if I'm missing something here, but:
> cfg80211: Leaving channel 5180 MHz intact on phy0 - no rule found in
> band on Country IE

Looks good.

> How will leaving the channel intact help, if the static world domain
> turned it off in the first place?

In Intel's case the first regulatory domain is ignored (world). To see,
before associating to an AP try running 'iw list'.

> (Note that the CRDA request for the
> world domain is emitted by the kernel before /dev/sda is even attached,
> so needless to say that goes unserviced)

I noticed that, what ends up happening then is the static world regulatory
domain is used from the kernel. I take it you used an initramfs with the
sda driver in there? I've been using initramfs too but for some reason
on my system udev triggers the request eventually after the drive
is mounted. So this is the first time I hear of this.

I also noticed though:

cfg80211: Calling CRDA for country: GB
cfg80211: Current regulatory intersected:
        (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
        (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)

This seems to indicate to me you manually ran:

sudo iw reg set GB

Is that the case? If so then that would explain your 5 GHz channels
going missing. Technically we should not allow this though as the country
IE already had GB, I can send a patch for that but you could also not set
one up with iw manually and see the output if 'iw list'. Reason they would
have gone missing is that cfg80211 already has the intersected regulatory
domain present and if you issue a a user that you the country you are in
we will perform an intersection with what we have already and that of
the country you specificy and in that case the intersection yields no 5 GHz
channels. The band exception only occurs on country IEs. But regardless
trying to set the reg domain to manually if the country IE already had that
should result in a no-op. Will have to fix that.

  Luis
