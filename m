Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:33583 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933549AbcCISOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 13:14:19 -0500
Received: by mail-lb0-f175.google.com with SMTP id k15so78555033lbg.0
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2016 10:14:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA64B1D@hasmsx107.ger.corp.intel.com>
Date: Wed, 9 Mar 2016 20:14:17 +0200
Message-ID: <CANUX_P29Mcpuv6y7GUttS9dukzgMNweKNHufW8NOWRvyc=1rJQ@mail.gmail.com> (sfid-20160309_191431_080580_6CB6139E)
Subject: Re: pull request: iwlwifi-next 2016-03-09
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Wed, Mar 9, 2016 at 7:43 PM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
> Hi Kalle,
>
> this is the very last pull request for 4.6. I hope it is not too late.
> Most of it are fixes for code that is already in
> wireless-drivers.next.git. There are a few other patches as well.
> Let me know if you have issues!
> Thank you.

As you saw, we have a compilation issue when THERMAL is not enabled.
I'll respin.

>
> The following changes since commit 53f09e742b0fdf14a2a2bfd2062ee96c9b3eedf0:
>
>   Merge branch 'fixes' into next (2016-03-02 09:35:38 +0200)
>
> are available in the git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git tags/iwlwifi-next-for-kalle-2016-03-09
>
> for you to fetch changes up to 0831fcd67fc5bddd360bca51a3892bbd33048dbb:
>
>   iwlwifi: mvm: update GSCAN capabilities (2016-03-09 16:55:39 +0200)
>
> ----------------------------------------------------------------
> * update GSCAN capabilities (Ayala)
> * fix AES-CMAC in AP mode (Johannes)
> * adapt prints to new firmware API
> * rx path improvements (Sara and Gregory)
> * fixes for the thermal / cooling device code (Chaya Rachel)
> * fixes for GO uAPSD handling
> * more code for the 9000 device family (Sara)
> * infrastructure work for firmware notification (Chaya Rachel)
> * improve association reliablity (Sara)
> * runtime PM fixes
> * fixes for ROC (HS2.0)
>
> ----------------------------------------------------------------
> Ayala Beker (1):
>       iwlwifi: mvm: update GSCAN capabilities
>
> Chaya Rachel Ivgi (4):
>       iwlwifi: mvm: fix unregistration of thermal in some error flows
>       iwlwifi: mvm: add ctdp operations to debugfs
>       iwlwifi: mvm: add support for async rx handler without hold the mutex
>       iwlwifi: mvm: return the cooling state index instead of the budget
>
> Emmanuel Grumbach (4):
>       iwlwifi: mvm: avoid panics with thermal device usage
>       iwlwifi: mvm: don't let NDPs mess the packet tracking
>       iwlwifi: mvm: remove RRM advertisement
>       iwlwifi: mvm: adapt the firmware assert log to new firmware
>
> Gregory Greenman (1):
>       iwlwifi: pcie: avoid restocks inside rx loop if not emergency
>
> Johannes Berg (1):
>       iwlwifi: mvm: don't try to offload AES-CMAC in AP/IBSS modes
>
> Luca Coelho (1):
>       iwlwifi: pcie: forbid RTPM on device removal
>
> Matti Gottlieb (1):
>       iwlwifi: mvm: ROC: cleanup time event info on FW failure
>
> Sara Sharon (8):
>       iwlwifi: pcie: refactor RXBs reclaiming code
>       iwlwifi: pcie: set RB chunk size back to 64
>       iwlwifi: refactor the code that reads the MAC address from the NVM
>       iwlwifi: mvm: set the correct amsdu enum values
>       iwlwifi: mvm: extend time event duration
>       iwlwifi: mvm: turn off AMSDU bit in QoS control for de-aggregated AMSDUs
>       iwlwifi: pcie: fine tune number of rxbs
>       iwlwifi: add support for getting HW address from CSR
>
>  drivers/net/wireless/intel/iwlwifi/dvm/main.c             |   8 ++--
>  drivers/net/wireless/intel/iwlwifi/iwl-9000.c             |   3 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-config.h           |   2 +
>  drivers/net/wireless/intel/iwlwifi/iwl-csr.h              |  10 +++++
>  drivers/net/wireless/intel/iwlwifi/iwl-devtrace-iwlwifi.h |  27 ++++++------
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c              |  38 ++++++++++-------
>  drivers/net/wireless/intel/iwlwifi/iwl-fh.h               |   9 ++--
>  drivers/net/wireless/intel/iwlwifi/iwl-fw-file.h          |  11 +++++
>  drivers/net/wireless/intel/iwlwifi/iwl-fw.h               |  13 ++++++
>  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c        | 146 ++++++++++++++++++++++++++++++++++++++++------------------------
>  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h        |   5 +--
>  drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c          |  42 +++++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/mvm/fw-api-rx.h        |   5 +--
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c         |  14 +++----
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h              |   5 +--
>  drivers/net/wireless/intel/iwlwifi/mvm/nvm.c              |  11 +----
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c              | 120 +++++++++++++++++++++++++++++++++--------------------
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c             |  12 ++++++
>  drivers/net/wireless/intel/iwlwifi/mvm/time-event.c       |  15 ++-----
>  drivers/net/wireless/intel/iwlwifi/mvm/time-event.h       |   2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/tt.c               | 175 ++++++++++++++++++++++++++++++++++++++++++-----------------------------------
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c               |  29 +++++++++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/utils.c            |  28 ++++++-------
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c             |  28 +++++++++++++
>  drivers/net/wireless/intel/iwlwifi/pcie/internal.h        |   2 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/rx.c              | 148 ++++++++++++++++++++++++++++++++---------------------------------
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c           |   6 ---
>  27 files changed, 563 insertions(+), 351 deletions(-)
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
