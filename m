Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.135]:49873 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbcGSPje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 11:39:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@codeaurora.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org,
	Michal Marek <mmarek@suse.com>, netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, akpm <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 05/11] Kbuild: don't add obj tree in additional includes
Date: Tue, 19 Jul 2016 17:38:51 +0200
Message-ID: <3906958.MrNt71DzrU@wuerfel> (sfid-20160719_173954_868933_4490EE69)
In-Reply-To: <87a8hdae9j.fsf@purkki.adurom.net>
References: <20160615154553.3177021-1-arnd@arndb.de> <21521763.EfAflxWUP8@wuerfel> <87a8hdae9j.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 19, 2016 5:33:44 PM CEST Kalle Valo wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > On Monday, July 18, 2016 10:14:39 PM CEST Michal Marek wrote:
> >> On Wed, Jun 15, 2016 at 05:45:47PM +0200, Arnd Bergmann wrote:
> >> > When building with separate object directories and driver specific
> >> > Makefiles that add additional header include paths, Kbuild adjusts
> >> > the gcc flags so that we include both the directory in the source
> >> > tree and in the object tree.
> >> > 
> >> > However, due to another bug I fixed earlier, this did not actually
> >> > include the correct directory in the object tree, so we know that
> >> > we only really need the source tree here. Also, including the
> >> > object tree sometimes causes warnings about nonexisting directories
> >> > when the include path only exists in the source.
> >> > 
> >> > This changes the logic to only emit the -I argument for the srctree,
> >> > not for objects. We still need both $(srctree)/$(src) and $(obj)
> >> > though, so I'm adding them manually.
> >> > 
> >> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> 
> >> Hi Arnd,
> >> 
> >> I applied the series up to this patch to kbuild.git#kbuild. The rest
> >> seem to be related but not dependent patches, so I'll leave it up to the
> >> respective maintainers to pick them up. Is that OK with you?
> >
> > I think that's fine, a couple were already picked up, and what I have
> > left now is
> >
> > a281bfa5713a [SUBMITTED 20160615] [EXPERIMENTAL] Kbuild: enable -Wmissing-include-dirs by default
> > 83934921e68e [SUBMITTED 20160615] rtlwifi: don't add include path for rtl8188ee
> 
> Apparently[1] you didn't CC linux-wireless and that's why I didn't see
> the rtlwifi patch in wireless patchwork. Care to resend?
> 
> [1] https://patchwork.kernel.org/patch/9178861/
> 

Done. I've also thrown in two patches for drivers/staging/rtl8*/ that I submitted
a while ago, but I'm not sure if they should get merged through the staging
tree or the wireless tree. I had previously submitted those two as a combined
patch along with a third one that turned out to be unnecessary.

	Arnd
