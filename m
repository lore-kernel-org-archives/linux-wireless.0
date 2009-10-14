Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:53443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764AbZJNELK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 00:11:10 -0400
Date: Tue, 13 Oct 2009 21:10:28 -0700
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/9] [compat-2.6 and compat-stable] Remove unused code
Message-ID: <20091014041028.GA14511@kroah.com>
References: <1255382358-20760-1-git-send-email-hauke@hauke-m.de> <1255382358-20760-4-git-send-email-hauke@hauke-m.de> <3ace41890910121932r6f832fe8of70d9b2bdd3d2635@mail.gmail.com> <4AD4ED23.7010200@hauke-m.de> <3ace41890910131712v700ebfe4vc1cd234f24abee9@mail.gmail.com> <43e72e890910131718x68a4a80ehc66a4daf2e299c46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890910131718x68a4a80ehc66a4daf2e299c46@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 13, 2009 at 05:18:04PM -0700, Luis R. Rodriguez wrote:
> On Tue, Oct 13, 2009 at 5:12 PM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
> > On Tue, Oct 13, 2009 at 10:12 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> >
> >> The condition #if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)) was
> >> added recently because without it openSuse with kernel 2.6.27 will not
> >> compile. OpenSuse backports the tracepoint part into their 2.6.27 kernel.
> >
> > I remember that thread now. It is probably wrong as a matter of policy
> > to incorporate patches for distro kernels with backport bits through.
> > - I am not saying you shouldn't be helpful and provide them - after
> > all, more users == better testing, and no doubt the investigation
> > itself throws more insights on the detailed mechanisms - but it is
> > just that compat-wireless probably should not try to support arbitrary
> > and substantial changes from a vanilla kernel. I know Suse is popular
> > so it is important to support Suse users, but I am wondering if
> > distro-specific changes should be separate or at least, clearly
> > documented.
> 
> Not sure why opensuse added round_jiffies_up() to their 2.6.27
> kernels, greg may know better, but since its only once change I'm
> willing to live with what we did to resolve for it.

We added that to the SLE 11 kernel as it was requred for a bunch of
block layer backports to resolve a number of issues that we needed to
do.

Hope this helps explain things,

greg k-h
