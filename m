Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2841 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbYDWVad (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 17:30:33 -0400
Date: Wed, 23 Apr 2008 16:51:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: tomas.winkler@intel.com, torvalds@linux-foundation.org,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
Message-ID: <20080423205159.GB30048@tuxdriver.com> (sfid-20080423_233108_449118_D5F36761)
References: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com> <20080423.034943.15067739.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080423.034943.15067739.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2008 at 03:49:43AM -0700, David Miller wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>

> > --- a/drivers/net/wireless/iwlwifi/Makefile
> > +++ b/drivers/net/wireless/iwlwifi/Makefile
> > @@ -1,4 +1,4 @@
> > -obj-$(CONFIG_IWLCORE)	:= iwlcore.o
> > +obj-$(CONFIG_IWLCORE)	+= iwlcore.o
> >  iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
> 
> I had to apply this patch by hand because "iwl-power.o" is not
> present in the iwlcore-objs line in the current tree.
> 
> Does it exist in John's wireless tree or something like that?  This
> new iwl-power.o object looks like it would be new code and a new
> feature, which we wouldn't be able to add into the tree at this time
> as all networking new features have gone into the merge window
> already.

FWIW, I don't have an iwl-power.c either.  Please be careful to
send patches against the actual upstream tree rather than a working
tree. :-)

> To expedite getting this bug fix applied, I've added this fix
> by hand and will push it to Linus tonight.

Thanks, Dave!

John
-- 
John W. Linville
linville@tuxdriver.com
