Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58059 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbcHCQHp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 12:07:45 -0400
Date: Wed, 3 Aug 2016 18:03:34 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Jeff Mahoney <jeffm@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Takashi Iwai <tiwai@suse.de>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Daniel Wagner <daniel.wagner@bmw-carit.de>,
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
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	linux-kselftest@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
Message-ID: <20160803160334.GM3296@wotan.suse.de> (sfid-20160803_180808_547596_7D97E5BC)
References: <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
 <20160802074106.GI3296@wotan.suse.de>
 <CAKdAkRR=NC4Agen9ad3CK8hgZh+zbZhzhr2MP169JwisgWvP_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKdAkRR=NC4Agen9ad3CK8hgZh+zbZhzhr2MP169JwisgWvP_w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 03, 2016 at 12:42:14AM -0700, Dmitry Torokhov wrote:
> On Tue, Aug 2, 2016 at 12:41 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > On Tue, Aug 02, 2016 at 08:53:55AM +0200, Daniel Wagner wrote:
> >> On 08/02/2016 08:34 AM, Luis R. Rodriguez wrote:
> >> >On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
> >> >>>The sysdata API's main goal rather is to provide a flexible API first,
> >> >>>compartamentalizing the usermode helper was secondary. But now it seems
> >> >>>I may just also add devm support too to help simplify code further.
> >> >>
> >> >>I missed the point that you plan to add usermode helper support to
> >> >>the sysdata API.
> >> >
> >> >I had no such plans, when I have asked folks so far about "hey are you
> >> >really in need for it, OK what for? " and "what extended uses do you
> >> >envision?" so I far I have not gotten any replies at all. So -- instead
> >> >sysdata currently ignores it.
> >>
> >> So you argue for the remoteproc use case with 100+ MB firmware that
> >> if there is a way to load after pivot_root() (or other additional
> >> firmware partition shows up) then there is no need at all for
> >> usermode helper?
> >
> > No, I'm saying I'd like to hear valid uses cases for the usermode helper and so
> > far I have only found using coccinelle grammar 2 explicit users, that's it. My
> > patch series (not yet merge) then annotates these as valid as I've verified
> > through their documentation they have some quirky requirement.
> 
> In certain configurations (embedded) people do not want to use
> initramfs nor modules nor embed firmware into the kernel. In this case
> usermode helper + firmware calss timeout handling provides necessary
> wait for the root filesystem to be mounted.
> 
> If we solve waiting for rootfs (or something else that may contain
> firmware) then these cases will not need to use usermode helper.

Given most distributions already disable FW_LOADER_USER_HELPER_FALLBACK and
grammar shows we only have 2 explicit users of the usermode helper I'd
prefer if we indeed could just compartamentalize the usermode helper
and not rely on it further. Furthermore I think its possible address
this issue, and suggested at least one idea how for now. With a bit
further review I'm in hope we can address this well, not only
for the firmware API but for all other kernel_read_file*() users.

  Luis
