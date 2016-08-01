Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37537 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971AbcHAUNx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 16:13:53 -0400
Date: Mon, 1 Aug 2016 21:36:59 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
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
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160801193659.GY3296@wotan.suse.de> (sfid-20160801_221414_028385_019AA61B)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws>
 <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 31, 2016 at 12:23:09AM -0700, Dmitry Torokhov wrote:
> On July 30, 2016 9:58:17 AM PDT, "Luis R. Rodriguez" <mcgrof@kernel.org> wrote:
> >On Sat, Jul 30, 2016 at 02:42:41PM +0200, Arend van Spriel wrote:
> >> + Luis (again) ;-)
> >> 
> >> On 29-07-16 08:13, Daniel Wagner wrote:
> >> > On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
> >> >> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
> >> >>
> >> >>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
> >> >>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> >> >>>>
> >> >> [..]
> >> >>>
> >> >>> Do not quite like it... I'd rather asynchronous request give out
> >a
> >> >>> firmware status pointer that could be used later on.
> >> 
> >> Excellent. Why not get rid of the callback function as well and have
> >> fw_loading_wait() return result (0 = firmware available, < 0 = fail).
> >> Just to confirm, you are proposing a new API function next to
> >> request_firmware_nowait(), right?
> >
> >If proposing new firmware_class patches please bounce / Cc me, I've
> >recently asked for me to be added to MAINTAINERS so I get these
> >e-mails as I'm working on a new flexible API which would allow us
> >to extend the firmware API without having to care about the old
> >stupid usermode helper at all.
> 
> I am not sure why we started calling usermode helper "stupid".

OK Fair, how systemd implemented kmod timeout for the usermode helper
was stupid and it affected tons of systems.

> We only had to
> implement direct kernel firmware loading because udev/stsremd folks had
> "interesting" ideas how events should be handled; but having userspace to
> feed us data is not stupid.

It really should just be an option. The problem was the collateral due to the
way it was handled in userspace.

> If we want to overhaul firmware loading support we need to figure out how to
> support case when a driver want to [asynchronously] request
> firmware/config/blob and the rest of the system is not ready.

There's a lot of issues. So let's break them down.

1) First the sysdata API came about to help avoid the required set of collateral
evolutions whenever the firmware API was expanded. A new argument added meant
requiring to modify all drivers with the new argument, or a new exported
symbol. The sysdata API makes the API flexible, enabling extensions by just
expanding on the descriptor passed. The few features I've added to sysdata
(like avoiding drivers having to declare their own completions, waits) are
just small enhancements, but it seems now supporting devm may be desirable
as well.

2) The usermode helper cannot be removed, however we can compartamentalize it.
The sysdata API aims at helping with that, it doesn't touch it. There are
only 2 explicit users of the usermode helper now in the kernel. If there are
further users that really want it, I'd like to hear about them.

3) The firmware API having its own kernel read thing was fine but there were
other places in the kernel doing the same, this begged sharing that code
and also allowing then two LSM hooks to take care of handling doing whatever
with a kernel read, a pre-read hook and post-read hook. Mimi completed this
work and we now have the firmware API using kernel_read_file_from_path().

4) The asynchronous firmware loading issue you describe above is just *one*
issue, but it becomes more of an generic issue if you consider 3) above...
because naturally there could potentially be other users of kernel_read_file()
or kernel_read_file_from_path() and whereby a race also can happen. We may
decide that this is up to the subsystem/user to figure out. If that's the
case lets discuss that. It however occurs to me that it could just be as
simple as adding another fs/exec.c helper like kernel_read_file_from_path_wait()
which passes a completion and fs/exec.c just signals back when its ready.
If we have this both the old firmware_class and new sysdata API could benefit
from this behind the scenes -- no new API extension would be needed, this
would just be a firmware_class fix to use a more deterministic kernel
read API.

> Even if we want kernel to do read/load the data we need userspace to tell
> kernel when firmware partition is available, until then the kernel should not
> fail the request.

pivot_root() is possible as well, so exactly when the *real* partition is
ready is very system specific -- best I think we can do is perhaps just
see when the *first* file path becomes available and signal back. Problem
with this is we would still need a way to know -- *everything is ready*
as a limit condition for waiting.

  Luis
