Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37958
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751263AbYDWKtm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 06:49:42 -0400
Date: Wed, 23 Apr 2008 03:49:43 -0700 (PDT)
Message-Id: <20080423.034943.15067739.davem@davemloft.net> (sfid-20080423_125020_160417_47F6DFAE)
To: tomas.winkler@intel.com
Cc: torvalds@linux-foundation.org, linville@tuxdriver.com,
	yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
From: David Miller <davem@davemloft.net>
In-Reply-To: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com>
References: <1208947121-22640-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>
Date: Wed, 23 Apr 2008 13:38:41 +0300

[ John Linville's email was corrupted in the CC: line, fixed. ]

> This patch fixes problem in Makefile that prevented
> built-in compilation of iwlcore
> 
> Commit that caused this problem: eadd3c4b

Please provide the header line tead of commits, don't just reference
them as SHA IDs, because SHA IDs change when patches are ported and
applied to other GIT trees.

When applying this patch I fixed it up to:

--------------------
Commit that caused this problem: eadd3c4b ("iwlwifi: make Makefile
more concise")
--------------------

Please do this in the future, thanks.

> diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
> index e83dd68..e2c05f5 100644
> --- a/drivers/net/wireless/iwlwifi/Makefile
> +++ b/drivers/net/wireless/iwlwifi/Makefile
> @@ -1,4 +1,4 @@
> -obj-$(CONFIG_IWLCORE)	:= iwlcore.o
> +obj-$(CONFIG_IWLCORE)	+= iwlcore.o
>  iwlcore-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o

I had to apply this patch by hand because "iwl-power.o" is not
present in the iwlcore-objs line in the current tree.

Does it exist in John's wireless tree or something like that?  This
new iwl-power.o object looks like it would be new code and a new
feature, which we wouldn't be able to add into the tree at this time
as all networking new features have gone into the merge window
already.

Please do not mix bug fixes with new code changes like that.

To expedite getting this bug fix applied, I've added this fix
by hand and will push it to Linus tonight.

Thank you.
