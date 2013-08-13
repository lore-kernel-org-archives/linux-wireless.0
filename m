Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2494 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932141Ab3HMVLL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 17:11:11 -0400
Date: Tue, 13 Aug 2013 14:11:08 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Arik Nemtsov <arik@wizery.com>
CC: Hauke Mehrtens <hauke@hauke-m.de>,
	<linux-wireless@vger.kernel.org>, <mcgrof@kernel.org>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Subject: Re: [PATCH] backports: rename some mem functions to not break custom
 kernels
Message-ID: <20130813211108.GM17130@pogo> (sfid-20130813_231115_574608_AAC4EFE7)
References: <1375865563-1196-1-git-send-email-arik@wizery.com>
 <5202D173.4050408@hauke-m.de>
 <CA+XVXfdAUZGj7FjfRUxT2noa1b35xk1vn0bdcO70Vic6h9yXcg@mail.gmail.com>
 <52090C37.2000103@hauke-m.de>
 <CA+XVXfe65N5+iXQ6-5fST=PDKk4Hk0sRk04UH+oXoDpc1DTVyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CA+XVXfe65N5+iXQ6-5fST=PDKk4Hk0sRk04UH+oXoDpc1DTVyw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 13, 2013 at 05:47:53PM +0300, Arik Nemtsov wrote:
> On Mon, Aug 12, 2013 at 7:24 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> > adding the LINUX_BACKPORT() line should be enough to rename it
> > everywhere in backprots, so you do not have to modify
> > backport/compat/backport-3.11.c or manually add the prefix anywhere else.
> >
> > Could you try if this fixes your problems with phys_wc_to_mtrr_index:
> >
> >  ...
> > +#define phys_wc_to_mtrr_index LINUX_BACKPORT(phys_wc_to_mtrr_index)
> >  #ifdef CONFIG_MTRR
> >  extern int phys_wc_to_mtrr_index(int handle);
> >  #else
> >  static inline int phys_wc_to_mtrr_index(int handle)
> >  {
> >         return -1;
> >  }
> >  #endif /* CONFIG_MTRR */
> >
> 
> Thanks. It seems to do the trick. The attached patch solves the issue.
> Luis - any comments on this one?

I welcome a new patch in proper form with a Signed-off-by by the author.

  Luis
