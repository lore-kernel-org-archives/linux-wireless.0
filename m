Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:62397 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760165AbXKMXKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 18:10:40 -0500
Received: by py-out-1112.google.com with SMTP id u77so2343066pyb
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2007 15:10:37 -0800 (PST)
Message-ID: <43e72e890711131510v2189669di962214c46a2e96de@mail.gmail.com> (sfid-20071113_231042_934134_116AD2A9)
Date: Tue, 13 Nov 2007 18:10:36 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: Linux wireless compatibility package for kernels >= 2.6.22
Cc: wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1194841658.2276.8.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890711101953w6e046b82j6b9087d30c8195b2@mail.gmail.com>
	 <1194841658.2276.8.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 11, 2007 11:27 PM, Pavel Roskin <proski@gnu.org> wrote:
> Hello!
>
> On Sat, 2007-11-10 at 22:53 -0500, Luis R. Rodriguez wrote:
> > I've started a compatibility package for the Linux wireless subsystem
> > for kernels >= 2.6.22. You can download it here:
> >
> > http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>
> I would prefer that you use exactly the same path for all drivers, so
> that the patches are compatible.  Wireless drivers should be in
> drivers/net/wireless.

Thanks for reviewing this. I've changed the directories to match the
kernel's. As a consequence the updates/ directory also have a similar
structure now. Upon install we'll be sure to remove the old
directories if present for now.

> Also, I cannot compile it against current wireless-2.6/everything
> compiled outside the source tree:
>
> /home/proski/src/compat-wireless-2.6/drivers/iwlwifi/iwl-3945-rs.c:40:40: error: ../mac80211/ieee80211_rate.h: No such file or directory

I ran into to this but I had fixed it in compat.diff. Anyway, this
won't be necessary anymore as the directories match the kernel's now.

> After some hack to make it compile, I still get:
>
>   CC [M]  /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.o
> /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:6: warning:
> "LINUX_VERSION_CODE" is not defined
> /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:28:
> warning: "KERNEL_VERSION" is not defined
> /home/proski/src/compat-wireless-2.6/mac80211/ieee80211.c:24:42: error:
> missing binary operator before token "("

I'm not sure what happened here as <linux/version.h> should have been
included in mac80211.h. Anyway, to be sure we won't run into these
I've added <net/compat.h> to <net/cfg80211.h> which much of the
wireless subsystem uses.

Please give this new release a try:

http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2

I've also started documenting this online:

http://linuxwireless.org/en/users/download

Note: This link will be gone soon and replaced with:

http://linuxwireless.org/en/users/Download

I need 2.6.23 testers (hint Fedora people).

  Luis
