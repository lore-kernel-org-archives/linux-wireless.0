Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60043 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbaJWSAJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 14:00:09 -0400
Date: Thu, 23 Oct 2014 13:48:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: pull request: iwlwifi 2014-10-21
Message-ID: <20141023174807.GB3639@tuxdriver.com> (sfid-20141023_200014_578675_A75C4FA4)
References: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P0iZO6AGwcsKO3+xZZcH5ns+vMUimo+BxHNpyBhhURKRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I do not have the 3.18-rc1 tag, because Dave doesn't have it yet in
the net.git tre.  Please rebase.

Thanks,

John

On Tue, Oct 21, 2014 at 12:29:08PM +0300, Emmanuel Grumbach wrote:
> Hi John,
> 
> Here is a first pull request for 3.18. This time I chose to work with
> signed tags instead of signing emails.
> Let me know if this is an issue for you.
> Description of the content below.
> 
> Note that this you haven't updated your trees yet and Linus released
> 3.18-rc1 already,
> I decided to base my trees on Linus's tag. Let me know you want me to
> change this.
> 
> Thanks!
> 
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> 
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> tags/iwlwifi-for-john-2014-10-21
> 
> for you to fetch changes up to ae35aee606d0ea5678c75fa058ea6eb048fc1d79:
> 
>   Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"
> (2014-10-21 09:00:27 +0300)
> 
> ----------------------------------------------------------------
> I revert here a patch that caused interoperability issues.
> dvm gets a fix for a bug that was reported by many users.
> Two minor fixes for BT Coex and platform power fix that helps
> reducing latency when the PCIe link goes to low power states.
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (5):
>       iwlwifi: configure the LTR
>       iwlwifi: mvm: BT Coex - update the MPLUT Boost register value
>       iwlwifi: mvm: BT coex - fix BT prio for probe requests
>       iwlwifi: dvm: drop non VO frames when flushing
>       Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"
> 
> Haim Dreyfuss (1):
>       iwlwifi: mvm: Add tx power condition to bss_info_changed_ap_ibss
> 
> Liad Kaufman (1):
>       iwlwifi: 8000: fix string given to MODULE_FIRMWARE
> 
> Matti Gottlieb (1):
>       iwlwifi: mvm: ROC - bug fixes around time events and locking
> 
>  drivers/net/wireless/iwlwifi/dvm/mac80211.c     | 24 +++++++++++++-----------
>  drivers/net/wireless/iwlwifi/iwl-8000.c         |  3 ++-
>  drivers/net/wireless/iwlwifi/iwl-trans.h        |  2 ++
>  drivers/net/wireless/iwlwifi/mvm/coex.c         |  4 ++--
>  drivers/net/wireless/iwlwifi/mvm/coex_legacy.c  |  4 ++--
>  drivers/net/wireless/iwlwifi/mvm/fw-api-power.h | 35
> ++++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/iwlwifi/mvm/fw-api.h       |  1 +
>  drivers/net/wireless/iwlwifi/mvm/fw.c           |  9 +++++++++
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c     | 32
> +++++++++++++++++++++++---------
>  drivers/net/wireless/iwlwifi/mvm/ops.c          |  1 +
>  drivers/net/wireless/iwlwifi/mvm/scan.c         |  3 ++-
>  drivers/net/wireless/iwlwifi/mvm/time-event.c   |  2 +-
>  drivers/net/wireless/iwlwifi/mvm/tx.c           |  8 ++------
>  drivers/net/wireless/iwlwifi/pcie/trans.c       | 16 +++++++++-------
>  14 files changed, 103 insertions(+), 41 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
