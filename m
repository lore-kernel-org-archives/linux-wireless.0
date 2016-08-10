Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40638 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934612AbcHJScj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2016 14:32:39 -0400
Date: Wed, 10 Aug 2016 20:32:11 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Vetter <daniel.vetter@intel.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ming Lei <ming.lei@canonical.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Jeff Mahoney <jeffm@suse.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Takashi Iwai <tiwai@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Vikram Mulukutla <markivx@codeaurora.org>,
	Stephen Boyd <stephen.boyd@linaro.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Julia Lawall <Julia.Lawall@lip6.fr>,
	Tom Gundersen <teg@jklm.no>, Kay Sievers <kay@vrfy.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>,
	Josh Boyer <jwboyer@fedoraproject.org>,
	Michal Marek <mmarek@suse.com>,
	David Howells <dhowells@redhat.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Vetter <daniel.vetter@ffwll.ch>, Abhay_Salunke@dell.com,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Wu Fengguang <fengguang.wu@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Jiri Slaby <jslaby@suse.com>, Gilles.Muller@lip6.fr,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Richard Purdie <rpurdie@rpsys.net>, nicolas.palix@imag.fr
Subject: Re: [PATCH v2 8/8] p54: convert to sysdata API
Message-ID: <20160810183211.GL3296@wotan.suse.de> (sfid-20160810_220253_722099_5EC57C50)
References: <1466121559-22363-1-git-send-email-mcgrof@kernel.org>
 <1466121559-22363-9-git-send-email-mcgrof@kernel.org>
 <CA+55aFyD+Xa2auP05=pBSxQc2qcuR858syMW5fiQKowbqbkDzQ@mail.gmail.com>
 <20160617013657.GH11948@wotan.suse.de>
 <CA+55aFycG-YfukKpP3x7kbBpCzXGwg35SdTU2r4wBbxrfROLtQ@mail.gmail.com>
 <20160617183503.GV11948@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160617183503.GV11948@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 17, 2016 at 08:35:03PM +0200, Luis R. Rodriguez wrote:
> On Thu, Jun 16, 2016 at 05:09:30PM -1000, Linus Torvalds wrote:
> > On Thu, Jun 16, 2016 at 3:36 PM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > >
> > > Reason this could not wait is folks seem to want to keep extending the API,
> > > which is another reason for this, do we want to put an end to an unflexible
> > > API now or should we wait ?
> > 
> > So I absolutely abhor "changes for changes sake".
> > 
> > If the existing code works for existing drivers, let them keep it.
> > 
> > And if a new interface is truly more flexible, then it should be able
> > to implement the old interface with no changes, so that drivers
> > shouldn't need to be changed/upgraded.
> 
> Are we OK to leave only the usermode helper support in place for the
> 2 drivers I've noted that explicitly require the usermode helper in their
> firmware request [0] ?
> 
> If so then I can do what you recommend below.
> 
> > Then, drivers that actually _want_ new features, or that can take
> > advantage of new interfaces to actually make things *simpler*, can
> > choose to make those changes. But those changes should have real
> > advantages.

As I noted above -- this still needs to be decided.

We only have 2 more drivers using the usermode helper explicitly now. Other
than this we have the old CONFIG_FW_LOADER_USER_HELPER_FALLBACK -- which
explicitly forced the usermode helper on every call. This later option is no
longer widely used by distributions, and distros these days just enable
CONFIG_FW_LOADER_USER_HELPER, with this only 2 drivers are using the usermode
helper. This still should mean we should not break users of
CONFIG_FW_LOADER_USER_HELPER_FALLBACK, as stupid as it may have been.

My preferred approach is as follows (and this is what I'll follow unless
I hear otherwise):

Obviously let's not break CONFIG_FW_LOADER_USER_HELPER_FALLBACK -- even if it
logically means long term most drivers if not all will convert to the new API,
there is no need for a full swing change. Lets leave drivers as-is, given most
distros are sensible and only enabling CONFIG_FW_LOADER_USER_HELPER.  Given
most distros disable CONFIG_FW_LOADER_USER_HELPER_FALLBACK, and we have now
verified only 2 explicit user mode helper scallers exists this means we have
mostly put away most of the sore of the user mode helper. With Daniel Wagner's
change to change the firmware API to use the new swait stuff it further pushes
some other user mode helper crap away [0]. Then, only drivers *that care and
want to change* to the new API will do so but we put a stop gap measure so that
new features only go through the new API. This means we mark
CONFIG_FW_LOADER_USER_HELPER_FALLBACK as deprecated.

We can strive to mark CONFIG_FW_LOADER_USER_HELPER as deprecated but to be fair
this requires more work:

Despite my best efforts to call out for valid new uses of the user mode helper
the only valid use I've heard so far over CONFIG_FW_LOADER_USER_HELPER was for
huge files for remoteproc as explained by Bjorn Andersson given the
deterministic aspect issue of ensuring a file is ready and also that they
cannot use initramfs to stuff the firmware [1]. As recently discussed in that
same thread with Bjorn though we can easily just add this upstream either as
a simple file sentinel or better yet -- a simple event from userspace [2] to
be used either to indicate the rootfs is ready or if we wanted farther
granularity per enum kernel_read_file_id (READING_FIRMWARE, READING_MODULE,
READING_KEXEC_IMAGE, READING_KEXEC_INITRAMFS, READING_POLICY), and that would
seem to put everyone's concerns over direct file loading at ease, including
Bjorn's [1]. This needs to be implemented. When that is done -- unless we hear
otherwise over requirements for the usermode helper -- we can finally mark
CONFIG_FW_LOADER_USER_HELPER as deprecated.

[0] https://lkml.kernel.org/r/1470313636-670-1-git-send-email-wagi@monom.org
[1] https://lkml.kernel.org/r/20160803173955.GD13516@tuxbot
[2] https://lkml.kernel.org/r/20160803184058.GS3296@wotan.suse.de

> Sure agreed.
> 
> > Having to have a callback, 
> 
> This is because devm is not used, as such the consumer is needed prior to
> freeing. I can give adding devm support a shot if folks seem to be generally 
> agree its the right approach. I do expect this will mean tons of code
> deletions and helping with bugs.

Regarding this -- Dmitry recenlty noted devm only works if used on the probe
path, and as we now determined, we don't want firmware loading on probe [3], unless
async probe is used, so this would make a devm solution here not ideal for
freeing the firmware. Even if you use async probe -- that seems very special
use case and adding devm support for the firmware API just for that seems silly.

As such the current devised solution in the sysdata API is called for, given
if you indicated that keep = false, you are explicitly telling the firmware
API that your firmware will certainly not be needed after the callback is
called.

So for the sync case, a new callback is needed, and that explains the extra
bit of code if someone conerts from the old API to the new one.

[3] https://lkml.kernel.org/r/20160803161821.GB32965@dtor-ws

> > or a magical "sysdata_desc" descriptor,
> 
> This is one way to make a flexible and extensible API without affecting drivers
> with further collateral evolutions as it gets extended. Its no different than
> the "flags" lesson learned from writing system calls, for instance.
> 
> Descriptor seemed, fitting, let me know if you have any other preference.

I haven't heard otherwise so will be sticking to that.

> > and having a new name ("sysdata") that is less descriptive than the old one
> > ("firmware")
> 
> Well no, the APIs are used in *a lot* of cases for things that are not firmware
> already, and let's recall I originally started working on this to replace CRDA
> from userspace to be able to just fetch the signed regulatory database file
> from the kernel. Calling it firmware simply makes no sense anymore.

So help me bike shed. This seems to be sticking point and I frankly don't
care what we call it. I've asked others for name suggestions and here are
a few suggestions:

 o driver_data
 o dsd: device specific data
 o xfw - eXtensible firmware API
 o bbl - binary blob loader

Can someone just pick something? I really, really do not care.

If I don't hear anything concrete I will go with driver_data.

> > are all in my opinion making the example patch be a
> > step _backwards_ rather than an improvement. It does not look like a
> > simpler or more natural interface for a driver.
> 
> Hope the above explains the current state. Feedback on desirable changes
> welcomed.
> 
> [0] https://lkml.kernel.org/r/1466117661-22075-5-git-send-email-mcgrof@kernel.org

All this said, this series is still justified, the extra code only comes in
place when porting the sync requests due to the callback stuff described above
and the inability to use devm there. As far as I can tell, just the bike
shedding is left.

As it stands then, unless I hear back, I'll roll Daniel Wagner's changes into
my series to be applied first, then rename sysdata driver_data, rebase all this
and shoot it out again.

Only a few drivers will be converted over as demos. The SmPL grammar can be used
by those who do want a change due to the few features added. Long term we'll
add more features to the new API:

 o the whole ihex conversion is crap, we should do this within the API and
   this can just be specified as a descriptor preference, then drivers
   don't have to deal with the ihex crap themselves.

 o firmware singing - this lets us kill CRDA as a requirement

  Luis
