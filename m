Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51537 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaIITPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 15:15:10 -0400
Date: Tue, 9 Sep 2014 15:01:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi 2014-09-08
Message-ID: <20140909190115.GL29412@tuxdriver.com> (sfid-20140909_211515_083178_CEA630C9)
References: <540DDF37.5030801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <540DDF37.5030801@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 08, 2014 at 07:54:15PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> I think I have caught up completely now - and because I had quite a bit to cover this pull request is rather big for an -rc5. Sorry about that.
> 
> I re-enable scheduled scan on firmware that contain the fix for the bug that Linus reported.
> A few trivial fixes: endianity issues, the same DTIM period fix that I did in mac80211.
> Eyal fixes a few issues we identified with EAPOL, we now send them just as if they were management frames, this solves interrop issues.
> Johannes has another set of trivial fixes, while Luca fixes the way we configure the filters in the firmware. Last but not least, a new device is added by Oren.
> 
> The following changes since commit d88c8958dc13b4e4eb7fc57e3f06dc1c4abc7b1f:
> 
>   iwlwifi: bump firmware API version to 10 for 7000 and 8000 (2014-09-01 09:50:14 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git for-john
> 
> for you to fetch changes up to 2cddddc56a1179aa71b460ad616176c237d4a243:
> 
>   iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength (2014-09-08 19:47:22 +0300)
> 
> ----------------------------------------------------------------
> Eliad Peller (1):
>       iwlwifi: increase DEFAULT_MAX_TX_POWER
> 
> Emmanuel Grumbach (4):
>       iwlwifi: mvm: enable scheduled scan on newest firmware
>       iwlwifi: mvm: fix endianity issues with Smart Fifo commands
>       iwlwiwi: mvm: use bss_conf->dtim_period instead of conf.ps_dtim_period
>       iwlwifi: dvm: disable power save by default
> 
> Eyal Shapira (2):
>       iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate
>       iwlwifi: mvm: fix an overflow in iwl_mvm_get_signal_strength
> 
> Johannes Berg (3):
>       iwlwifi: mvm: BT Coex - remove shadowing variable
>       iwlwifi: mvm: correctly handle PM/QoS changes from mac80211
>       iwlwifi: mvm: BT Coex - always initialize smps_mode
> 
> Luciano Coelho (1):
>       iwlwifi: mvm: set MAC_FILTER_IN_BEACON correctly for STA/P2P client
> 
> Oren Givon (1):
>       iwlwifi: add PCI IDs and add then new 3165 series

I'm pulling this, but some seem a bit questionable.  Please limit
any further pull requests for 3.17 to fixes for serious bugs only.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
