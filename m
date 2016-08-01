Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754901AbcHAUH0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2016 16:07:26 -0400
Date: Mon, 1 Aug 2016 21:44:08 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
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
Message-ID: <20160801194408.GZ3296@wotan.suse.de> (sfid-20160801_220748_590862_FCECCD16)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws>
 <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 01, 2016 at 02:26:04PM +0200, Daniel Wagner wrote:
> On 07/31/2016 09:23 AM, Dmitry Torokhov wrote:
> >On July 30, 2016 9:58:17 AM PDT, "Luis R. Rodriguez" <mcgrof@kernel.org> wrote:
> >>On Sat, Jul 30, 2016 at 02:42:41PM +0200, Arend van Spriel wrote:
> >>>On 29-07-16 08:13, Daniel Wagner wrote:
> >>>>On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
> >>>>>On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
> 
> >>>+ Luis (again) ;-)
> 
> That was not on purpose :) My attempt to keep the Cc list a bit
> shorter was a failure.
> 
> >>>>>>Do not quite like it... I'd rather asynchronous request give out
> >>>>>>firmware status pointer that could be used later on.
> >>>
> >>>Excellent. Why not get rid of the callback function as well and have
> >>>fw_loading_wait() return result (0 = firmware available, < 0 = fail).
> >>>Just to confirm, you are proposing a new API function next to
> >>>request_firmware_nowait(), right?
> >>
> >>If proposing new firmware_class patches please bounce / Cc me, I've
> >>recently asked for me to be added to MAINTAINERS so I get these
> >>e-mails as I'm working on a new flexible API which would allow us
> >>to extend the firmware API without having to care about the old
> >>stupid usermode helper at all.
> 
> These patches here are a first attempt to clean up a bit of the code
> around the completion API. As Dmitry correctly pointed out, it makes
> more sense to go bit further and make the async loading a bit more
> convenient for the drivers.
> 
> >I am not sure why we started calling usermode helper "stupid". We
> >only  had to implement direct kernel firmware loading because udev/stsremd
> >folks had "interesting" ideas how events should be handled; but having
> >userspace to feed us data is not stupid.
> 
> I was ignorant on all the nasty details around the firmware loading.
> If I parse Luis' patches correctly they introduce an API which calls
> kernel_read_file_from_path() asynchronously:
> 
> sysdata_file_request_async(..., &cookie)
>   *coookie = async_schedule_domain(request_sysdata_file_work_func(), ..)
> 
>   request_sysdata_file_work_fun()
>     _sysdata_file_request()
>       fw_get_filesystem_firmware()
> 	kernel_read_file_from_path()
> 
> sysdata_synchronize_request(&cookie);
> 
> Doesn't look like what your asking for.

No, but its also a generic kernel read issue as I noted in my last
reply.

> >If we want to overhaul firmware loading support we need to figure
> >out  how to support case when a driver want to [asynchronously] request
> >firmware/config/blob and the rest of the system is not ready. Even if we
> >want kernel to do read/load the data we need userspace to tell kernel
> >when firmware partition is available, until then the kernel should not
> >fail the request.
> 
> I gather from Luis' blog post and comments that he is on the quest
> on removing userspace support completely.

No, I explained in my last proposed documentation patch series that we cannot
get rid of the usermode helper. Its not well understood why so I explained and
documented why. Best we can do is compartamentalize its uses.

The sysdata API's main goal rather is to provide a flexible API first,
compartamentalizing the usermode helper was secondary. But now it seems
I may just also add devm support too to help simplify code further.

What Dmitry notes is an existential issue with kernel_read_file_from_path()
and we need a common solution for it.

> Maybe this attempt here could be a step before. Step 1 would be
> changing request_firmware_nowait() to request_firmware_async so
> drivers don't have to come up with their own sync primitives, e.g.
> 
>   cookie = request_firmware_async()
>   fw_load_wait(cookie)

That's one of the features already part of async mechanism of the sysdata API :)

  Luis
