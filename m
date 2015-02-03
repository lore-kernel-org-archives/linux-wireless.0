Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hofr.at ([212.69.189.236]:50468 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbbBCObE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 09:31:04 -0500
Date: Tue, 3 Feb 2015 15:31:02 +0100
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Anjana Sasindran <anjanasasindran123@gmail.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: multiple condition with no effect
	- if identical to else
Message-ID: <20150203143102.GA19670@opentech.at> (sfid-20150203_153109_967462_FF426AB2)
References: <1422968896-26562-1-git-send-email-hofrat@osadl.org> <wrfjlhkft9jp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjlhkft9jp.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 03 Feb 2015, Jes Sorensen wrote:

> Nicholas Mc Guire <hofrat@osadl.org> writes:
> > A number if/else if/else branches are identical - so the condition has no
> > effect on the effective code and can be significantly simplified - this 
> > patch removes the condition and the duplicated code.
> >
> > Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> > ---
> >
> > This looks like the output of some broken code-generator - unlikely someone
> > wrote this by hand. In any case it needs a review by someone that knows the
> > details of the driver. 
> >
> > Anyway the number of useless code repetition is potentially record breaking !
> >
> > Patch was compile tested for x86_64_defconfig + CONFIG_STAGING=y
> > CONFIG_R8723AU=m, CONFIG_8723AU_BT_COEXIST=y
> >
> > Patch is against 3.0.19-rc7 (localversoin = -next-20150203)
> >
> >  .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |   60 +++-----------------
> >  1 file changed, 8 insertions(+), 52 deletions(-)
> 
> Why make it simple if you can make it complicated :)
> 
> I presume it's against 3.19-rc7 since a 3.0.19 would be rather obsolete.
>

yes - thats a typo - sorry for that.
 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
