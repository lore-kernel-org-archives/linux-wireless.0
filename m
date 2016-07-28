Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43680 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbcG1X22 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2016 19:28:28 -0400
Date: Fri, 29 Jul 2016 01:28:21 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Prarit Bhargava <prarit@redhat.com>,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>,
	Arend van Spriel <arend@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ming Lei <ming.lei@canonical.com>, mmarek@suse.com,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Takashi Iwai <tiwai@suse.de>, Tom Gundersen <teg@jklm.no>,
	Kay Sievers <kay@vrfy.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Jej B <James.Bottomley@hansenpartnership.com>,
	Kees Cook <keescook@chromium.org>,
	Fengguang Wu <fengguang.wu@intel.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hannes Reinecke <hare@suse.de>,
	"rafael.j.wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Message-ID: <20160728232821.GB3296@wotan.suse.de> (sfid-20160729_012850_072901_C58C2EB0)
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
 <20160721070938.GA2658@redhat.com>
 <CANUX_P3ADxi+RHkH=d8Ypcqy9WVKSu4JYH7K3HtTNCuWg3wCeQ@mail.gmail.com>
 <20160721080541.GB2658@redhat.com>
 <5790A28F.8030102@redhat.com>
 <20160721115122.GA31869@redhat.com>
 <a264e995-fc46-7fcd-69f9-80992385b6b1@broadcom.com>
 <20160722220526.GL5537@wotan.suse.de>
 <c3bbb2f3-f551-41bf-ba29-c75f78b5b9ed@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c3bbb2f3-f551-41bf-ba29-c75f78b5b9ed@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 28, 2016 at 09:23:35PM +0200, Arend van Spriel wrote:
> On 23-07-16 00:05, Luis R. Rodriguez wrote:
> > The firmware API is a mess and I've been trying to correct that
> > with a more flexible API.

<-- snip -->

> > Extensions to the fw API are IMHO best done through a newer flexible
> > API, feel free to refer to this development tree if you'd like to
> > contribute:
> > 
> > https://git.kernel.org/cgit/linux/kernel/git/mcgrof/linux-next.git/log/?h=20160616-sysdata-v2
> 
> So I had a look and noticed commit c8df68e83392 ("firmware: annotate
> thou shalt not request fw on init or probe"). Now this conflicts with
> our wireless driver. The original suggestion a long, long time ago was
> to use IFF_UP as trigger to go and request firmware. However, for that
> we would need to register a netdevice during probe, and consequently we
> should also have a wiphy instance registered. However, that has all kind
> of feature flags for which we need firmware running on the device to
> query what is supported and what not. I can make a fair bet that
> brcmfmac is not the only driver with such a requirement. So how can we
> crack that nut.

Glad you asked.

Despite my latest set of updates on documentation for the firmware_class [0] (not
yet merged), and it being based on the latest discussed and agreed upon we
really have nothing well ironed out for what you describe, so let's try
to figure that out now.

To be clear, folks had originally said using the firmware API on *init* was
dumb, and some of this came up because of the infamous systemd udev timeout.
For completeness, I've documented some of the history of this issue
in great detail [1], mostly because I had to deal with a bug at SUSE about
this, and find a proper solution. Avoiding re-iterating *exactly why* the
timeout for kmod was ill-founded, and assuming you all now buy that,
the summary of facts of the *why* it turns out to be a bad idea to use the
firmware API on init *or* probe:

  a) by default the driver model actually calls both init and probe serially and
     synchronously
  b) we have no deterministic way of being certain we have whatever filesystem
     the driver needed as ready, the firmware may live in initramfs, or may only
     be available later on the real filesystem, and even after that the system
     may be designed to pivot_root.

In terms of solutions, lets discuss, here are a few options I can think of:

  1) Because of b) if you know you are going to use the firmware API you should
     just stuff firmware that is needed on init or probe as built-in
     (CONFIG_EXTRA_FIRMWARE) or stuff it into initramfs. This approach is generally
     accepted, however there is no systematic approach to ensure this is done. Now
     that we have coccinelle grammar to find these drivers it should be relatively
     easy to identify them and require the firmware as part of the distribution's
     initramfs or peg them as part of CONFIG_EXTRA_FIRMWARE if a distro prefers that.

     The only issue with this approach is its left up to the distribution to resolve.

  2) If the driver *knows* that probe may take a while it can request the driver core
     to probe the driver asynchronously, it can do so by using:

static struct pci_driver foo_pci_driver = {
      ...
      .driver.probe_type = PROBE_PREFER_ASYNCHRONOUS,
};

    This would not really resolve the deterministic issues listed in b) and for
    this reason this is not really a firmware-API-on-probe solution -- its an
    annotation to help avoid delays boot due to knowing probe may take a while.

  3) Userspace that loads modules can / should pass the async probe generic
     module parameter "async_probe" (for instance 'modprobe ath10k async_probe')
     when loading all modules. This should already be relatively
     safe when using on modules. This is what systemd long ago assumed was
     being done anyway. Again, also this is not really a firmware-API-on-probe solution,
     it can however be used by systemd for instance to help avoid delays on
     boot due to module lengthy probe calls

As it stands we have no resolution for the deterministic existential issues of
the firmware but in practice 1-3 should help. 2-3 should probably be done
regardless. I've been meaning to send patches for 3) but haven't had time.

As far as the deterministic existential firmware issue... Since we're just
reading files from the filesystem now (there are exceptions to this, but my
goal is to corner-case this code with the sysdata API), if we really wanted
something rock solid for these drivers I suppose we could consider implementing
an event driven probe if a driver requests for async probe. For instance, if
async probe was requested and the driver has MODULE_FIRMWARE(firmware_name)
we could add a notifier to probe the driver once the firmware is accessible.

For all intents and purposes though -- although I know the real issue here
the deterministic way of knowing when firmware is available, in practice
annotating your driver with PROBE_PREFER_ASYNCHRONOUS should solve most
races. This would not be a resolution, but rather an annotation to the fact
your driver probe does take a while -- and should make most folks happy until
we have a proper deterministic firmware solution, I think.

I welcome other ideas.

[0] https://lkml.kernel.org/r/1466117661-22075-1-git-send-email-mcgrof@kernel.org
[1] http://www.do-not-panic.com/2015/12/linux-asynchronous-probe.html

  Luis
