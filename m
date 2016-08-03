Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35011 "EHLO
	mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758AbcHCPfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 11:35:10 -0400
Date: Wed, 3 Aug 2016 08:35:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
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
Message-ID: <20160803153506.GC29702@dtor-ws> (sfid-20160803_173535_428014_63386AFA)
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
> And there are people who don't have a usermode helper running at all in
> their configuration, but I guess they should disable the helper.

Right, if they don't that means their system is misconfigured.

> 
> In my opinion the kernel should provide functionality to user-space and
> user-space providing functionality to the kernel should be avoided.

Why? We have bunch of stuff running in userspace for the kernel. Fuse
for example. I am sure there are more.

> 
> > If we solve waiting for rootfs (or something else that may contain
> > firmware) then these cases will not need to use usermode helper.
> 
> If firmware (or whatever) API could get notification of mount syscall it
> could be used to retry firmware loading instead of periodic polling.
> That leaves the question raised by you about when to stop trying. The
> initlevel stuff is probably a user-space only concept, right? So no
> ideas how the kernel itself could decide except for a "long" timeout.

The kernel really does not know, it can only guess. The firmware may get
delivered by motorized carrier pidgeons. But distribution does know how
they set up, so they are in position to tell the kernel "go" or "give
up".

Thanks.

-- 
Dmitry
