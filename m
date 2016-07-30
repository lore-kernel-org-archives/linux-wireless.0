Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34470 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752094AbcG3Q6W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2016 12:58:22 -0400
Date: Sat, 30 Jul 2016 18:58:17 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160730165817.GQ3296@wotan.suse.de> (sfid-20160730_185900_121791_A1F3B992)
References: <1469692512-16863-1-git-send-email-wagi@monom.org>
 <1469692512-16863-8-git-send-email-wagi@monom.org>
 <20160728183343.GD16852@dtor-ws>
 <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 30, 2016 at 02:42:41PM +0200, Arend van Spriel wrote:
> + Luis (again) ;-)
> 
> On 29-07-16 08:13, Daniel Wagner wrote:
> > On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
> >> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
> >>
> >>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
> >>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
> >>>>
> >> [..]
> >>>
> >>> Do not quite like it... I'd rather asynchronous request give out a
> >>> firmware status pointer that could be used later on.
> 
> Excellent. Why not get rid of the callback function as well and have
> fw_loading_wait() return result (0 = firmware available, < 0 = fail).
> Just to confirm, you are proposing a new API function next to
> request_firmware_nowait(), right?

If proposing new firmware_class patches please bounce / Cc me, I've
recently asked for me to be added to MAINTAINERS so I get these
e-mails as I'm working on a new flexible API which would allow us
to extend the firmware API without having to care about the old
stupid usermode helper at all.

> >>>     pcu->fw_st = request_firmware_async(IMS_PCU_FIRMWARE_NAME,
> >>> -                       pcu,
> >>> -                       ims_pcu_process_async_firmware);
>     +			    pcu);
> >>>     if (IS_ERR(pcu->fw_st))
> >>>         return PTR_ERR(pcu->fw_st);
> >>>
> >>>     ....
> >>>
> >>>     err = fw_loading_wait(pcu->fw_st);
> 	if (err)
> 		return err;
> 
> 	fw = fwstat_get_firmware(pcu->fw_st);
> 
> Or whatever consistent prefix it is going to be.
> 
> >>>
> >>
> >> In the remoteproc case (patch 6) this would clean up the code, rather
> >> than replacing the completion API 1 to 1. I like it!
> > 
> > IIRC most drivers do it the same way. So request_firmware_async() indeed
> > would be good thing to have. Let me try that.
> 
> While the idea behind this series is a good one I am wondering about the
> need for these drivers to use the asynchronous API. The historic reason
> might be to avoid timeout caused by user-mode helper, but that may no
> longer apply and these drivers could be better off using
> request_firmware_direct().

BTW I have in my queue for the sysdata API something like firmware_request_direct()
but with async support. The only thing left to do I think is just add the devm
helpers so drivers no longer need to worry about the release of the firmware.

> There have been numerous discussions about the firmware API. Here most
> recent one:
> 
> http://www.spinics.net/lists/linux-wireless/index.html#152755

And more importantly, the sysdata API queue:

https://git.kernel.org/cgit/linux/kernel/git/mcgrof/linux-next.git/log/?h=20160616-sysdata-v2

  Luis
