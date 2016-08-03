Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:34440 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435AbcHCUuX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 16:50:23 -0400
Received: by mail-pf0-f176.google.com with SMTP id p64so80841098pfb.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 13:50:23 -0700 (PDT)
Subject: Re: [RFC v0 7/8] Input: ims-pcu: use firmware_stat instead of
 completion
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
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
 <20160803153506.GC29702@dtor-ws>
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
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c630b349-3e2e-5a2e-56f9-aaef4893f28e@broadcom.com> (sfid-20160803_225028_619188_D18D1BE9)
Date: Wed, 3 Aug 2016 22:42:43 +0200
MIME-Version: 1.0
In-Reply-To: <20160803153506.GC29702@dtor-ws>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03-08-16 17:35, Dmitry Torokhov wrote:
>> In my opinion the kernel should provide functionality to user-space and
>> > user-space providing functionality to the kernel should be avoided.
> Why? We have bunch of stuff running in userspace for the kernel. Fuse
> for example. I am sure there are more.

To me "running in user-space" is not the same as providing
functionality, but I see your point given below.

>> > 
>>> > > If we solve waiting for rootfs (or something else that may contain
>>> > > firmware) then these cases will not need to use usermode helper.
>> > 
>> > If firmware (or whatever) API could get notification of mount syscall it
>> > could be used to retry firmware loading instead of periodic polling.
>> > That leaves the question raised by you about when to stop trying. The
>> > initlevel stuff is probably a user-space only concept, right? So no
>> > ideas how the kernel itself could decide except for a "long" timeout.
> The kernel really does not know, it can only guess. The firmware may get
> delivered by motorized carrier pidgeons. But distribution does know how
> they set up, so they are in position to tell the kernel "go" or "give
> up".

What distro employs pidgeons. Like to give it a spin ;-)

Maybe the latest idea from Luis is a viable option.

Regards,
Arend
