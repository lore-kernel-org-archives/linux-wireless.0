Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga17.intel.com ([192.55.52.151]:34839 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729385AbeGZPon (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Jul 2018 11:44:43 -0400
Message-ID: <6aa9e0a60a24377b3ef38782d4cc50c5a89fe759.camel@intel.com> (sfid-20180726_162741_171792_BDD83168)
Subject: Re: [linuxwifi] pull-request: iwlwifi-next 2018-07-26
From: Luciano Coelho <luciano.coelho@intel.com>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi@intel.com,
        david.e.box@intel.com, joe.konno@intel.com
Date: Thu, 26 Jul 2018 17:27:34 +0300
In-Reply-To: <27cf64cc8a3b6633a19ff83295297ece366b4af7.camel@coelho.fi>
References: <27cf64cc8a3b6633a19ff83295297ece366b4af7.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oops, wrong subject.  Fixed now, it should obviously have been 2018-07-
26.

--
Luca.

On Thu, 2018-07-26 at 15:38 +0300, Luca Coelho wrote:
> Hi Kalle,
> 
> This is the first batch of patches intended for v4.19.  It includes
> the
> two patches sets I sent a few weeks ago, with HE support and new
> hardware (22560) support.  More details about the contents in the tag
> description.
> 
> I have sent this out before and kbuildbot this morning, but I didn't
> get any replies from it yet.
> 
> Please let me know if there are any issues.
> 
> Cheers,
> Luca.
> 
> 
> The following changes since commit
> bf9b608e63dfd71ab225c9d4211eb6d8dc582a3b:
> 
>   Merge ath-next from
> git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-07-
> 25 10:50:54 +0300)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-
> next.git tags/iwlwifi-next-for-kalle-2018-07-26
> 
> for you to fetch changes up to
> 1a4968d1230c9233f50a89abb3b32d94f81146d0:
> 
>   iwlwifi: pcie: support 2k rx buffers (2018-07-26 13:16:18 +0300)
> 
> ----------------------------------------------------------------
> First batch of iwlwifi patches for 4.19
> 
> * Implement 802.11ax D2.0;
> * Changes in the base code to support the new 22560 devices;
> * Support for the new 22560 device family;
> 
> ----------------------------------------------------------------
> Golan Ben Ami (13):
>       iwlwifi: allow different csr flags for different device
> families
>       iwlwifi: introduce device family 22560
>       iwlwifi: pcie: allocate and free rx cr's and tr's tails
>       iwlwifi: pcie: support context information for 22560 devices
>       iwlwifi: pcie: update bytes in the byte count table
>       iwlwifi: pcie: start early debug for 22560 devices
>       iwlwifi: update gen3 interrupts - sw error and image response
>       iwlwifi: cancel the injective function between hw pointers to
> tfd entry index
>       iwlwifi: support multiple tfd queue max sizes for different
> devices
>       iwlwifi: support new tx api
>       iwlwifi: introduce new rx structures used by 22560 RFH
>       iwlwifi: update registers changed for 22560 devices
>       iwlwifi: pcie: support 2k rx buffers
> 
> Johannes Berg (1):
>       iwlwifi: 22000 devices: restrict to HT A-MPDU size
> 
> Luca Coelho (5):
>       iwlwifi: fw: add FW APIs for HE
>       iwlwifi: add support for IEEE802.11ax
>       iwlwifi: add module parameter to disable 802.11ax
>       iwlwifi: mvm: add radiotap data for HE
>       iwlwifi: add support for 22560 devices
> 
>  drivers/net/wireless/intel/iwlwifi/Makefile                |   3 +-
>  drivers/net/wireless/intel/iwlwifi/cfg/2000.c              |   2 +
>  drivers/net/wireless/intel/iwlwifi/cfg/22000.c             | 161
> +++++++++++++++++++++++++++++++++------------------
>  drivers/net/wireless/intel/iwlwifi/cfg/5000.c              |   1 +
>  drivers/net/wireless/intel/iwlwifi/cfg/6000.c              |   3 +
>  drivers/net/wireless/intel/iwlwifi/cfg/7000.c              |   1 +
>  drivers/net/wireless/intel/iwlwifi/cfg/8000.c              |   1 +
>  drivers/net/wireless/intel/iwlwifi/cfg/9000.c              |   1 +
>  drivers/net/wireless/intel/iwlwifi/fw/api/commands.h       |   3 +-
>  drivers/net/wireless/intel/iwlwifi/fw/api/datapath.h       |   5 ++
>  drivers/net/wireless/intel/iwlwifi/fw/api/mac.h            | 172
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/fw/api/nvm-reg.h        |   4 +-
>  drivers/net/wireless/intel/iwlwifi/fw/api/rs.h             |  36
> ++++++++++--
>  drivers/net/wireless/intel/iwlwifi/fw/api/rx.h             |  53
> +++++++++++++++--
>  drivers/net/wireless/intel/iwlwifi/fw/api/tx.h             |  25
> ++++++++
>  drivers/net/wireless/intel/iwlwifi/fw/smem.c               |   4 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-config.h            |   7 ++-
>  drivers/net/wireless/intel/iwlwifi/iwl-context-info-gen3.h | 286
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> ++++++++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/iwl-context-info.h      |   5 ++
>  drivers/net/wireless/intel/iwlwifi/iwl-csr.h               |   5 ++
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c               |   7 ++-
>  drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c      |   8 +--
>  drivers/net/wireless/intel/iwlwifi/iwl-fh.h                |  28
> +++++++--
>  drivers/net/wireless/intel/iwlwifi/iwl-modparams.h         |  12
> +++-
>  drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c         | 110
> +++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/iwl-trans.h             |   2 +
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c                |   4 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c          |   4 ++
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c          | 200
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h               |   2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c               |   9 ++-
>  drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c             |  44
> +++++++++++++-
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c                |  39
> +++++++++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.h                |  21
> +++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c              | 281
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> +++++++++++++++++++-
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c               |   8 +--
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.h               |   6 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c                |  48
> +++++++++++-----
>  drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info-gen3.c   | 207
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/pcie/ctxt-info.c        |  62 ++-
> -----------------
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c              |   2 -
>  drivers/net/wireless/intel/iwlwifi/pcie/internal.h         | 220
> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
> -
>  drivers/net/wireless/intel/iwlwifi/pcie/rx.c               | 232
> ++++++++++++++++++++++++++++++++++++++++++++++-----------------------
> -----
>  drivers/net/wireless/intel/iwlwifi/pcie/trans-gen2.c       |  11
> +++-
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c            |  63
> +++++++++++++++-----
>  drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c          |  58
> ++++++++++++++-----
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c               |  92
> +++++++++++++++++------------
>  47 files changed, 2205 insertions(+), 353 deletions(-)
>  create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-context-
> info-gen3.h
>  create mode 100644 drivers/net/wireless/intel/iwlwifi/pcie/ctxt-
> info-gen3.c
