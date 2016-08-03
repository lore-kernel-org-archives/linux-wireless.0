Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35889 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690AbcHCQSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 12:18:25 -0400
Date: Wed, 3 Aug 2016 09:18:21 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jeff Mahoney <jeffm@suse.com>,
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
Message-ID: <20160803161821.GB32965@dtor-ws> (sfid-20160803_181847_275146_2DF1B182)
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

On Wed, Aug 03, 2016 at 05:55:40PM +0200, Luis R. Rodriguez wrote:
> 
> I accept all help and would be glad to make enhancements instead of
> the old API through new API. The biggest thing here first I think is
> adding devm support, that I think should address what seemed to be
> the need to add more code for a transformation into the API. I'd

I am confused. Why do we need devm support, given that devm is only
valid in probe() paths[*] and we do know that we do not want to load
firmware in probe() paths because it may cause blocking?

[*] Yes, I know there are calls to devm* outside of probe() but I am
pretty sure they are buggy unless they explicitly freed with devm* as
well and then there is no point. IN all other cases it is likely wrong
as it messes up with order of freeing resources.

Thanks.

-- 
Dmitry
