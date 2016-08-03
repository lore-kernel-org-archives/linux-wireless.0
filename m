Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46623 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758063AbcHCSor (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 14:44:47 -0400
Date: Wed, 3 Aug 2016 20:40:58 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Tom Gundersen <teg@jklm.no>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	kay@vrfy.org, Hannes Reinecke <hare@suse.de>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Mahoney <jeffm@suse.com>, Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	David Howells <dhowells@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>,
	David Woodhouse <dwmw2@infradead.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	linux-input@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160803184058.GS3296@wotan.suse.de> (sfid-20160803_204511_476658_E33D2425)
References: <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
 <20160802074106.GI3296@wotan.suse.de>
 <ef14dc68-d2f8-0934-7be5-dfb3a4771f27@bmw-carit.de>
 <20160803155540.GL3296@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160803155540.GL3296@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 03, 2016 at 05:55:40PM +0200, Luis R. Rodriguez wrote:
> On Wed, Aug 03, 2016 at 08:57:09AM +0200, Daniel Wagner wrote:
> > On 08/02/2016 09:41 AM, Luis R. Rodriguez wrote:
> > >On Tue, Aug 02, 2016 at 08:53:55AM +0200, Daniel Wagner wrote:
> > >>On 08/02/2016 08:34 AM, Luis R. Rodriguez wrote:
> > >>>On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
> > >>So you argue for the remoteproc use case with 100+ MB firmware that
> > >>if there is a way to load after pivot_root() (or other additional
> > >>firmware partition shows up) then there is no need at all for
> > >>usermode helper?
> > >
> > >No, I'm saying I'd like to hear valid uses cases for the usermode helper and so
> > >far I have only found using coccinelle grammar 2 explicit users, that's it. My
> > >patch series (not yet merge) then annotates these as valid as I've verified
> > >through their documentation they have some quirky requirement.
> > 
> > I got that question wrong. It should read something like 'for the
> > remoteproc 100+MB there is no need for the user help?'.
> 
> That's not a question for me but for those who say that the usermode helper
> is needed for remoteproc, so far from what folks are saying it seems the only
> reason for the usermodehelper was to try to avoid the deterministic issue,
> but I suggested a way to resolve that without the usermode helper now so
> would be curious to hear if there are any more reasons for it.
> 
> > I've gone
> > through your patches and they make perfectly sense too. Maybe I can
> > convince you to take a better version of my patch 3 into your queue.
> > And I help you converting the exiting drivers. Obviously if you like
> > my help at all.
> 
> I accept all help and would be glad to make enhancements instead of
> the old API through new API. The biggest thing here first I think is
> adding devm support, that I think should address what seemed to be
> the need to add more code for a transformation into the API. I'd
> personally only want to add that and be done with an introduction
> of the sysdata API. Further changes IMHO are best done atomically
> after that on top of it, but I'm happy to queue in the changes.
> 
> > >Other than these two drivers I'd like hear to valid requirements for it.
> > >
> > >The existential issue is a real issue but it does not look impossible to
> > >resolve. It may be a solution to bloat up the kernel with 100+ MB size just to
> > >stuff built-in firmware to avoid this issue, but it does not mean a solution
> > >is not possible.
> > >
> > >Remind me -- why can remoteproc not stuff the firmware in initramfs ?
> > 
> > I don't know. I was just bringing it up with the hope that Bjorn
> > will defend it. It seems my tactics didn't work out :)
> 
> OK.
> 
> > >Anyway, here's a simple suggestion: fs/exec.c gets a sentinel file monitor
> > >support per enum kernel_read_file_id. For instance we'd have one for
> > >READING_FIRMWARE, one for READING_KEXEC_IMAGE, perhaps READING_POLICY, and this
> > >would in turn be used as the system configurable deterministic file for
> > >which to wait for to be present before enabling each enum kernel_read_file_id
> > >type read.
> > >
> > >Thoughts ?
> > 
> > Not sure if I get you here correctly. Is the 'system configurable
> > deterministic file' is a knob which controlled by user space? Or it
> > this something you define at compile time?
> 
> I meant at compile time on the kernel. So CONFIG_READ_READY_SENTINEL
> or something like this, and it be a string, which if set then when
> the kernel read APIs are used, then a new API could be introduced
> that would *only* enable reading through once that sentinel has
> been detected by the kernel to allowed through reads. Doing this
> per mount / target filesystem is rather cumbersome given possible
> overlaps in mounts and also pivot_root() being possible, so instead
> targeting simply the fs/exec.c enum kernel_read_file_id would seem
> more efficient and clean but we would need a decided upon set of
> paths per enum kernel_read_file_id as base (or just one path per
> enum kernel_read_file_id). For number of paths I mean the number
> of target directories to look for the sentinel per enum kernel_read_file_id,
> so for instance for READING_FIRMWARE perhaps just deciding on /lib/firmware/
> would suffice, but if this supported multiple paths another option may be
> for the sentinel to also be looked for in /lib/firmware/updates/,
> /lib/firmware/" UTS_RELEASE -- etc. It would *stop* after finding one
> sentinel on any of these paths.
> 
> If a system has has CONFIG_READ_READY_SENTINEL it would mean an agreed upon
> system configuration has been decided so that at any point in time reads
> against READING_FIRMWARE using a new kernel_read_file_from_path_sentinel()
> (or something like it) would only allow the read to go through once
> the sentinel has been found for READING_FIRMWARE on the agreed upon
> paths.
> 
> The benefit of the sentintel approach is it avoids complexities with
> pivot_root(), and makes the deterministic aspect of the target left
> only to a system-configuration enabled target path / file.
> 
> This is just an idea. I'd like some FS folks to review.
> 
> > Hmm, so it would allow to decided to ask a userspace helper or load
> > the firmware directly (to be more precised the kernel_read_file_id
> > type). If yes, than it is what currently already have just
> > integrated nicely into the new sysdata API.
> 
> Sorry, no, the above description is better of what I meant. This
> actually would not need to go into the sysdata API, unless of
> course we wanted it just as a new "feature" of it, but I don't
> think that's needed unless it has some implications behind the
> scenes. Given that firmware_class now uses a common core kernel
> API for reading files kernel_read_file_from_path() we could
> for instance add kernel_read_file_from_sentintel() and only
> if CONFIG_READ_READY_SENTINEL() would it block and wait until
> the sentinel clears. This should mean being able to make the
> change for both the old API and the new proposed sysdata API.
> Likewise for other kernel_read_file*() users -- they'd benefit
> from it as well.

A file sentinel would implicate a file namespace thing being used on the
filesystem -- to me this just means the Linux distribution / system integrator
would add this per filesystem, but agree this is pretty hacky.  Furthermore
we'd wait forever if the Linux distribution / system integrator forgot to set
the sentinel file. That's not good. To avoid that a generic "root fs ready"
event could be sent from userspace to know when to clear stale reads... but if
that's going to be done best just replace all sentintels with a simple "root fs
ready" which would mean all reads from the kernel are ready. If we wanted
further granularity I suppose we could further have one event per enum
kernel_read_file_id, and a generic all-is-ready one.

To start off with then a simple event from userspace should suffice. But do keep
in mind that granularity might help given that a big iron system might have some
large array of disks to mount during bootup and that may take a long while, and
you likely want to read /lib/firmware way before that filesystem is ready.

Not sure if granularity fixated by enum kernel_read_file_id should suffice,
perhaps given its also enough for LSMs...

This indeed would mean a kernelspace and userspace change, but it would mean 
not having to deal with the usermode helper crap anymore.

Anyway -- these are just ideas, patches welcomed !

  Luis
