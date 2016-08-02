Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38121 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161AbcHBH5e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 03:57:34 -0400
Date: Tue, 2 Aug 2016 09:41:06 +0200
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Daniel Wagner <daniel.wagner@bmw-carit.de>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
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
Message-ID: <20160802074106.GI3296@wotan.suse.de> (sfid-20160802_095741_806359_D2FAEBE8)
References: <20160728190151.GV13516@tuxbot>
 <c05a7b98-5ada-701f-9a77-65d81b841c17@bmw-carit.de>
 <ee9a29aa-0d29-a33f-e43a-057dc359cf89@broadcom.com>
 <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 02, 2016 at 08:53:55AM +0200, Daniel Wagner wrote:
> On 08/02/2016 08:34 AM, Luis R. Rodriguez wrote:
> >On Tue, Aug 02, 2016 at 07:49:19AM +0200, Daniel Wagner wrote:
> >>>The sysdata API's main goal rather is to provide a flexible API first,
> >>>compartamentalizing the usermode helper was secondary. But now it seems
> >>>I may just also add devm support too to help simplify code further.
> >>
> >>I missed the point that you plan to add usermode helper support to
> >>the sysdata API.
> >
> >I had no such plans, when I have asked folks so far about "hey are you
> >really in need for it, OK what for? " and "what extended uses do you
> >envision?" so I far I have not gotten any replies at all. So -- instead
> >sysdata currently ignores it.
> 
> So you argue for the remoteproc use case with 100+ MB firmware that
> if there is a way to load after pivot_root() (or other additional
> firmware partition shows up) then there is no need at all for
> usermode helper?

No, I'm saying I'd like to hear valid uses cases for the usermode helper and so
far I have only found using coccinelle grammar 2 explicit users, that's it. My
patch series (not yet merge) then annotates these as valid as I've verified
through their documentation they have some quirky requirement.

Other than these two drivers I'd like hear to valid requirements for it.

The existential issue is a real issue but it does not look impossible to
resolve. It may be a solution to bloat up the kernel with 100+ MB size just to
stuff built-in firmware to avoid this issue, but it does not mean a solution
is not possible.

Remind me -- why can remoteproc not stuff the firmware in initramfs ?

Anyway, here's a simple suggestion: fs/exec.c gets a sentinel file monitor
support per enum kernel_read_file_id. For instance we'd have one for
READING_FIRMWARE, one for READING_KEXEC_IMAGE, perhaps READING_POLICY, and this
would in turn be used as the system configurable deterministic file for
which to wait for to be present before enabling each enum kernel_read_file_id
type read.

Thoughts ?

  Luis
