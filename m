Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f67.google.com ([209.85.220.67]:36646 "EHLO
	mail-pa0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbcGaHXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jul 2016 03:23:25 -0400
In-Reply-To: <20160730165817.GQ3296@wotan.suse.de>
References: <1469692512-16863-1-git-send-email-wagi@monom.org> <1469692512-16863-8-git-send-email-wagi@monom.org> <20160728183343.GD16852@dtor-ws> <20160728190151.GV13516@tuxbot> <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de> <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com> <20160730165817.GQ3296@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of completion
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sun, 31 Jul 2016 00:23:09 -0700
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
CC: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Daniel Wagner <wagi@monom.org>,
	Bastien Nocera <hadess@hadess.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Ohad Ben-Cohen <ohad@wizery.com>, linux-input@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com> (sfid-20160731_092349_682080_102017D2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On July 30, 2016 9:58:17 AM PDT, "Luis R. Rodriguez" <mcgrof@kernel.org> wrote:
>On Sat, Jul 30, 2016 at 02:42:41PM +0200, Arend van Spriel wrote:
>> + Luis (again) ;-)
>> 
>> On 29-07-16 08:13, Daniel Wagner wrote:
>> > On 07/28/2016 09:01 PM, Bjorn Andersson wrote:
>> >> On Thu 28 Jul 11:33 PDT 2016, Dmitry Torokhov wrote:
>> >>
>> >>> On Thu, Jul 28, 2016 at 09:55:11AM +0200, Daniel Wagner wrote:
>> >>>> From: Daniel Wagner <daniel.wagner@bmw-carit.de>
>> >>>>
>> >> [..]
>> >>>
>> >>> Do not quite like it... I'd rather asynchronous request give out
>a
>> >>> firmware status pointer that could be used later on.
>> 
>> Excellent. Why not get rid of the callback function as well and have
>> fw_loading_wait() return result (0 = firmware available, < 0 = fail).
>> Just to confirm, you are proposing a new API function next to
>> request_firmware_nowait(), right?
>
>If proposing new firmware_class patches please bounce / Cc me, I've
>recently asked for me to be added to MAINTAINERS so I get these
>e-mails as I'm working on a new flexible API which would allow us
>to extend the firmware API without having to care about the old
>stupid usermode helper at all.

I am not sure why we started calling usermode helper "stupid". We only had to implement direct kernel firmware loading because udev/stsremd folks had "interesting" ideas how events should be handled; but having userspace to feed us data is not stupid.

If we want to overhaul firmware loading support we need to figure out how to support case when a driver want to [asynchronously] request firmware/config/blob and the rest of the system is not ready. Even if we want kernel to do read/load the data we need userspace to tell kernel when firmware partition is available, until then the kernel should not fail the request.


Thanks.

-- 
Dmitry
