Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55783 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832Ab0IXT3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 15:29:37 -0400
Date: Fri, 24 Sep 2010 15:17:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: greg@kroah.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH wireless-2.6.35] use long timer for un-necessary reload
 the firmware
Message-ID: <20100924191713.GF8077@tuxdriver.com>
References: <1285275864-12703-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1285275864-12703-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 23, 2010 at 02:04:24PM -0700, Wey-Yi Guy wrote:
> Different devices has different timing requirement, change the timeout
> value for 5000 series devices to avoid un-necessary firmware reload which
> can cause device become unstable.For 5000 series of devices, use long monitor timer to check
> stuck tx queues.
> 
> It is being reported firmware got reload more
> often than necessary, so extend the timer to avoid un-necessary reload.
> 
> This fixes:
> http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
> 
> Cc: stable@kernel.org [2.6.35]
> Reported-by: drago01 <drago01@gmail.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> this patch is also available from wireless-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

Well, something isn't right...

/home/linville/git/wireless-2.6
[linville-8530p.local]:> git pull git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git wireless-2.6
>From git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6
 * branch            wireless-2.6 -> FETCH_HEAD
Already up-to-date.

So then I try applying it directly...

[linville-8530p.local]:> git am -s fixes.mbox 
Applying: use long timer for un-necessary reload the firmware
error: patch failed: drivers/net/wireless/iwlwifi/iwl-1000.c:257
error: drivers/net/wireless/iwlwifi/iwl-1000.c: patch does not apply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-3945.c:2895
error: drivers/net/wireless/iwlwifi/iwl-3945.c: patch does not apply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-4965.c:2274
error: drivers/net/wireless/iwlwifi/iwl-4965.c: patch does not apply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-5000.c:462
error: drivers/net/wireless/iwlwifi/iwl-5000.c: patch does not apply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-6000.c:438
error: drivers/net/wireless/iwlwifi/iwl-6000.c: patch does not apply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-dev.h:1057
error: drivers/net/wireless/iwlwifi/iwl-dev.h: patch does not apply

??

Also, please make sure your subject starts with "iwlwifi: " or whatever
else is appropriate for the subsystem you are patching.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
