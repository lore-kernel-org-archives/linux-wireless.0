Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:34863 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467AbcHAVrN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 17:47:13 -0400
Date: Mon, 1 Aug 2016 14:34:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160801213440.GA28610@dtor-ws> (sfid-20160801_234751_383344_DE631E53)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws>
 <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <20160801171951.GC13516@tuxbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160801171951.GC13516@tuxbot>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 01, 2016 at 10:19:51AM -0700, Bjorn Andersson wrote:
> On Sat 30 Jul 09:58 PDT 2016, Luis R. Rodriguez wrote:
> 
> > On Sat, Jul 30, 2016 at 02:42:41PM +0200, Arend van Spriel wrote:
> > > + Luis (again) ;-)
> > > 
> > > On 29-07-16 08:13, Daniel Wagner wrote:
> > > > On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
> > > >> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
> > > >>
> > > >>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
> > > >>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > > >>>>
> > > >> [..]
> > > >>>
> > > >>> Do not quite like it... I'd rather asynchronous request give out a
> > > >>> firmware status pointer that could be used later on.
> > > 
> > > Excellent. Why not get rid of the callback function as well and have
> > > fw_loading_wait() return result (0 = firmware available, < 0 = fail).
> > > Just to confirm, you are proposing a new API function next to
> > > request_firmware_nowait(), right?
> > 
> > If proposing new firmware_class patches please bounce / Cc me, I've
> > recently asked for me to be added to MAINTAINERS so I get these
> > e-mails as I'm working on a new flexible API which would allow us
> > to extend the firmware API without having to care about the old
> > stupid usermode helper at all.
> > 
> 
> In the remoteproc world there are several systems where we see 100+MB of
> firmware being loaded. It's unfeasible to have these files in an
> initramfs, so we need a way to indicate to the kernel that the
> second/primary (or a dedicated firmware partition) is mounted.
> 
> We're currently loading these files with request_firmware_nowait(), so
> either one can either use kernel modules or the user-helper fallback to
> delay the loading until the files are available. (I don't like to
> enforce the usage of kernel modules)
> 
> I'm open to alternative ways of having firmware loading wait on
> secondary filesystems to be mounted, but have not yet tried to tackle
> this problem. I do believe something that waits and retries the firmware
> load as additional file systems gets mounted would be prettier than
> forcing user space to tell us it's time to move on.

Hmm, but when do you stop? How do you know that you are not going to get
yet another fs mounted and that one will finally have the firmware you
are looking for? The kernel does now, but distribution/product
integrator does. That is why I think the most reliable way is to see if
firmware is built-in, otherwise wait and let userspace do its thing.

Thanks.

-- 
Dmitry
