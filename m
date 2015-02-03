Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965320AbbBCNWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 08:22:02 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Anjana Sasindran <anjanasasindran123@gmail.com>,
	Roberta Dobrescu <roberta.dobrescu@gmail.com>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: multiple condition with no effect - if identical to else
References: <1422968896-26562-1-git-send-email-hofrat@osadl.org>
Date: Tue, 03 Feb 2015 08:21:46 -0500
In-Reply-To: <1422968896-26562-1-git-send-email-hofrat@osadl.org> (Nicholas Mc
	Guire's message of "Tue, 3 Feb 2015 08:08:16 -0500")
Message-ID: <wrfjlhkft9jp.fsf@redhat.com> (sfid-20150203_142208_257240_CB6BF8D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Nicholas Mc Guire <hofrat@osadl.org> writes:
> A number if/else if/else branches are identical - so the condition has no
> effect on the effective code and can be significantly simplified - this 
> patch removes the condition and the duplicated code.
>
> Signed-off-by: Nicholas Mc Guire <hofrat@osadl.org>
> ---
>
> This looks like the output of some broken code-generator - unlikely someone
> wrote this by hand. In any case it needs a review by someone that knows the
> details of the driver. 
>
> Anyway the number of useless code repetition is potentially record breaking !
>
> Patch was compile tested for x86_64_defconfig + CONFIG_STAGING=y
> CONFIG_R8723AU=m, CONFIG_8723AU_BT_COEXIST=y
>
> Patch is against 3.0.19-rc7 (localversoin = -next-20150203)
>
>  .../staging/rtl8723au/hal/rtl8723a_bt-coexist.c    |   60 +++-----------------
>  1 file changed, 8 insertions(+), 52 deletions(-)

Why make it simple if you can make it complicated :)

I presume it's against 3.19-rc7 since a 3.0.19 would be rather obsolete.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
