Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:58285 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbXKPXyl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 18:54:41 -0500
Received: by py-out-1112.google.com with SMTP id u77so4505613pyb
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2007 15:54:40 -0800 (PST)
Message-ID: <43e72e890711161554k8dd641esb5731bf2f5ae410a@mail.gmail.com> (sfid-20071116_235445_616965_D08FF54A)
Date: Fri, 16 Nov 2007 18:54:38 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Linux wireless compatibility package for kernels >= 2.6.22
Cc: wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1195063324.1739.9.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890711101953w6e046b82j6b9087d30c8195b2@mail.gmail.com>
	 <1194841658.2276.8.camel@dv>
	 <43e72e890711131510v2189669di962214c46a2e96de@mail.gmail.com>
	 <1195063324.1739.9.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 14, 2007 1:02 PM, Pavel Roskin <proski@gnu.org> wrote:
> Hello, Luis!
>
> On Tue, 2007-11-13 at 18:10 -0500, Luis R. Rodriguez wrote:
>
> > I ran into to this but I had fixed it in compat.diff. Anyway, this
> > won't be necessary anymore as the directories match the kernel's now.
>
> OK, that's much better now.
>
> > > After some hack to make it compile, I still get:
> > >
> > >   CC [M]  /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.o
> > > /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:6: warning:
> > > "LINUX_VERSION_CODE" is not defined
> > > /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:28:
> > > warning: "KERNEL_VERSION" is not defined
> > > /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:42: error:
> > > missing binary operator before token "("
> >
> > I'm not sure what happened here as <linux/version.h> should have been
> > included in mac80211.h. Anyway, to be sure we won't run into these
> > I've added <net/compat.h> to <net/cfg80211.h> which much of the
> > wireless subsystem uses.
>
> This problem is still there.  I think the best approach would be to
> "force-feed" compat.h to the compiler.  It already includes
> linux/version.h, but since it's the first header, it needs
> linux/autoconf.h.
>
> The following patch works for me.  The compat.diff patch can be cleaned
> up, but it's a separate issue.
>
>
> Force inclusion of compat.h first.
>
> Include linux/autoconf.h before other headers.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Thanks, applied. More in the next e-mail.

  Luis
