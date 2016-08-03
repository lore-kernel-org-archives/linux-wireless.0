Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52421 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609AbcHCPTR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 11:19:17 -0400
Date: Wed, 3 Aug 2016 17:18:51 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@kernel.org>,
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
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160803151851.GK3296@wotan.suse.de> (sfid-20160803_171938_577651_86CEA799)
References: <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
 <20160802074106.GI3296@wotan.suse.de>
 <CAKdAkRR=NC4Agen9ad3CK8hgZh+zbZhzhr2MP169JwisgWvP_w@mail.gmail.com>
 <0e20a2dc-ed76-b209-5c01-387f1c444b19@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0e20a2dc-ed76-b209-5c01-387f1c444b19@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 03, 2016 at 01:43:31PM +0200, Arend van Spriel wrote:
> On 03-08-16 09:42, Dmitry Torokhov wrote:
> > On Tue, Aug 2, 2016 at 12:41 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> >> On Tue, Aug 02, 2016 at 08:53:55AM +0200, Daniel Wagner wrote:
> >>> On 08/02/2016 08:34 AM, Luis R. Rodriguez wrote:
> >>>> On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
> >>>>>> The sysdata API's main goal rather is to provide a flexible API first,
> >>>>>> compartamentalizing the usermode helper was secondary. But now it seems
> >>>>>> I may just also add devm support too to help simplify code further.
> >>>>>
> >>>>> I missed the point that you plan to add usermode helper support to
> >>>>> the sysdata API.
> >>>>
> >>>> I had no such plans, when I have asked folks so far about "hey are you
> >>>> really in need for it, OK what for? " and "what extended uses do you
> >>>> envision?" so I far I have not gotten any replies at all. So -- instead
> >>>> sysdata currently ignores it.
> >>>
> >>> So you argue for the remoteproc use case with 100+ MB firmware that
> >>> if there is a way to load after pivot_root() (or other additional
> >>> firmware partition shows up) then there is no need at all for
> >>> usermode helper?
> >>
> >> No, I'm saying I'd like to hear valid uses cases for the usermode helper and so
> >> far I have only found using coccinelle grammar 2 explicit users, that's it. My
> >> patch series (not yet merge) then annotates these as valid as I've verified
> >> through their documentation they have some quirky requirement.
> > 
> > In certain configurations (embedded) people do not want to use
> > initramfs nor modules nor embed firmware into the kernel. In this case
> > usermode helper + firmware calss timeout handling provides necessary
> > wait for the root filesystem to be mounted.
> 
> And there are people who don't have a usermode helper running at all 

Correction: most Linux distributions these days have
CONFIG_FW_LOADER_USER_HELPER but disable CONFIG_FW_LOADER_USER_HELPER_FALLBACK.

And then let me re-iterate from my patches then the implications:

+When CONFIG_FW_LOADER_USER_HELPER_FALLBACK is enabled request_firmware()
+*always* calls the usermode helpers. When CONFIG_FW_LOADER_USER_HELPER is
+enabled, only if you specifically ask for it will the usermode helper be
+called. If CONFIG_FW_LOADER_USER_HELPER_FALLBACK is disabled drivers can
+still require the usermode helper by using request_firmware_nowait().

The issues with CONFIG_FW_LOADER_USER_HELPER_FALLBACK are so much so
(the kmod timeout was an engineering mishap refer to my post with
details about it [0]) that these days most distributions disable it
and there have been huge efforts to ensure its not even called
explicitly, to the point now we only have TWO explicit users for it.
Keep in mind as well that in my series of patches to help clarify the
situation with the usermode helper I also proposed a fix to the firmware_class
to avoid the usermode helper completely when the firmware cache, this is
because the firmware cache purposely *kills* any pending usermode helpers
on the way to suspend anyway, so calling a new instance would be an error
and just delay suspend further.

[0] http://www.do-not-panic.com/2015/12/linux-asynchronous-probe.html

> in
> their configuration, but I guess they should disable the helper.

Yes. I have gone to good lengths to ask why the hell its needed and so 
far I have not gotten any technical reason for it.

> > If we solve waiting for rootfs (or something else that may contain
> > firmware) then these cases will not need to use usermode helper.
> 
> If firmware (or whatever) API could get notification of mount syscall it
> could be used to retry firmware loading instead of periodic polling.
> That leaves the question raised by you about when to stop trying. The
> initlevel stuff is probably a user-space only concept, right?

No init levels here refer to include/linux/init.h init calls that one
wraps the kernel module inits, or subsystem inits. If it wasn't for
pivot_root() existing and also the fact that systems can be complex
I would have suggested simply that we make firmware_class move to
late_initcall() -- this however would not solve all races given how
complex systems could be set up with a partition.

> So no
> ideas how the kernel itself could decide except for a "long" timeout.

If we wanted to learn from history -- the timeout for this would be a bad idea
so this makes it a bit more complex.  I proposed a technical idea here which
would avoid this and I think enable making this deterministic as well for new
systems that want that.

  Luis
