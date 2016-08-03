Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34227 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758388AbcHCWea (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 18:34:30 -0400
Received: by mail-pa0-f50.google.com with SMTP id fi15so77835516pac.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 15:34:12 -0700 (PDT)
Date: Wed, 3 Aug 2016 15:26:56 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Mahoney <jeffm@suse.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
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
Message-ID: <20160803222656.GG13516@tuxbot> (sfid-20160804_003435_586643_FE421726)
References: <20160730165817.GQ3296@wotan.suse.de>
 <C528E404-0CA5-46B4-B551-B1D4B58BC053@gmail.com>
 <37a3cd66-262e-ffbe-ea7a-a6d5b1ca1c8b@bmw-carit.de>
 <20160801194408.GZ3296@wotan.suse.de>
 <0f9350fa-e8b5-9d64-b2d3-afda5e5f6bbf@bmw-carit.de>
 <20160802063419.GG3296@wotan.suse.de>
 <2713d779-ef55-793d-f37e-d1414bb1bfc2@bmw-carit.de>
 <20160802074106.GI3296@wotan.suse.de>
 <ef14dc68-d2f8-0934-7be5-dfb3a4771f27@bmw-carit.de>
 <20160803155540.GL3296@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160803155540.GL3296@wotan.suse.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed 03 Aug 08:55 PDT 2016, Luis R. Rodriguez wrote:

> On Wed, Aug 03, 2016 at 08:57:09AM +0200, Daniel Wagner wrote:
> > On 08/02/2016 09:41 AM, Luis R. Rodriguez wrote:
[..]
> > Not sure if I get you here correctly. Is the 'system configurable
> > deterministic file' is a knob which controlled by user space? Or it
> > this something you define at compile time?
> 
> I meant at compile time on the kernel. So CONFIG_READ_READY_SENTINEL
> or something like this, and it be a string, which if set then when
> the kernel read APIs are used, then a new API could be introduced
> that would *only* enable reading through once that sentinel has
> been detected by the kernel to allowed through reads. Doing this
> per mount / target filesystem is rather cumbersome given possible
> overlaps in mounts and also pivot_root() being possible, so instead
> targeting simply the fs/exec.c enum kernel_read_file_id would seem
> more efficient and clean but we would need a decided upon set of
> paths per enum kernel_read_file_id as base (or just one path per
> enum kernel_read_file_id). For number of paths I mean the number
> of target directories to look for the sentinel per enum kernel_read_file_id,
> so for instance for READING_FIRMWARE perhaps just deciding on /lib/firmware/
> would suffice, but if this supported multiple paths another option may be
> for the sentinel to also be looked for in /lib/firmware/updates/,
> /lib/firmware/" UTS_RELEASE -- etc. It would *stop* after finding one
> sentinel on any of these paths.
> 
> If a system has has CONFIG_READ_READY_SENTINEL it would mean an agreed upon
> system configuration has been decided so that at any point in time reads
> against READING_FIRMWARE using a new kernel_read_file_from_path_sentinel()
> (or something like it) would only allow the read to go through once
> the sentinel has been found for READING_FIRMWARE on the agreed upon
> paths.
> 
> The benefit of the sentintel approach is it avoids complexities with
> pivot_root(), and makes the deterministic aspect of the target left
> only to a system-configuration enabled target path / file.
> 

This sounds reasonable, it could be configured to wait for a certain
static file or userspace could generate this file once it reaches some
checkpoint.


Just to provide some additional input to "will rootfs mounted be enough
of a sentinel".

In an Android device you have a initramfs that will read an fstab file
and mount /system that holds most firmware, for some platforms
additional firmware will come from a third partition (in the Qualcomm
case mounted in /persist by the same mechanism).

With the sentinel approach one could configure the system either point
it at a file in the last file system to be mounted or have init generate
a file once its done with this; or in the generic configuration just
wait for /lib/firmware to show up.

I like this approach.

> This is just an idea. I'd like some FS folks to review.
> 

Regards,
Bjorn
