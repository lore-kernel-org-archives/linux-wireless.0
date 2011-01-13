Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37799 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756506Ab1AMAoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 19:44:05 -0500
Received: by iwn9 with SMTP id 9so1087467iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 16:44:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D28E94B.1010806@hauke-m.de>
References: <4D28E94B.1010806@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 12 Jan 2011 16:43:44 -0800
Message-ID: <AANLkTimg_MRW4R-boTqUh+z_ioGMJJHvfwKzbm4RyjjT@mail.gmail.com>
Subject: Re: compat-wireless-2.6.37-3-sn contains wrong files
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 8, 2011 at 2:46 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> plusquezero on IRC complained about compat-wireless-2.6.37-3-sn not
> compiling on his system with kernel 2.6.32 (
> http://pastebin.com/bKyZpKSr ). I tried to create such a release and had
> no problems, but the released tar balls at
> http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.37/ are
> containing some extra files. These files are available in
> compat-wireless based on linux-next but not in the version based on
> 2.6.27. Something in the script creating this release went wrong.
>
> Attached is the diffstat beetween compat-wireless-2.6.37-3-sn.tar.bz2
> and the version I generated myself with "./scripts/admin-refresh.sh -s
> -n" from the git branch remotes/origin/linux-2.6.37.y of
> compat-wireless.git and compat.git.
>
> Hauke
>
> hauke@hauke:~/compat-wireless/compat-wireless-2.6.37-3-sn$ diff -Naurx
> .git -x pending-stable -x tmp.patch -x build.sh -x compiletest.sh -x
> scripts . ../compat-wireless-git |diffstat
>  code-metrics.txt             |   12
>  compat/compat-2.6.38.c       |   50 --
>  compat/kfifo.c               |  608 ------------------------------
>  compat_base_tree             |    2
>  include/linux/average.h      |    5
>  include/linux/kfifo.h        |  857
> -------------------------------------------
>  include/linux/rfkill.h       |   32 -
>  include/net/bluetooth/mgmt.h |   87 ----
>  net/bluetooth/mgmt.c         |  308 ---------------
>  net/wireless/mesh.c          |  142 -------
>  10 files changed, 7 insertions(+), 2096 deletions(-)
>


Thanks, I likely didn't rm -rf * before regenerating the tarball.

  Luis
