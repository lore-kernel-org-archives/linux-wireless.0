Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55000 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750828AbcIPEhC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2016 00:37:02 -0400
Message-ID: <1474000615.5664.57.camel@coelho.fi> (sfid-20160916_063908_067266_2327F891)
From: Luca Coelho <luca@coelho.fi>
To: kvalo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>
Date: Fri, 16 Sep 2016 07:36:55 +0300
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi-next 2016-09-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Huomenta Kalle,

The kbuild bot scripts reported a compilation error, because
DMA_ERROR_CODE is not defined in some platforms (e.g. alpha).

So please drop this pull request.  I'll fix the problem and send a new
version.

----------8<----------

All errors (new ones prefixed by >>):

   In file included from drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h:32:0,
                    from drivers/net/wireless/intel/iwlwifi/iwl-io.h:32,
                    from drivers/net/wireless/intel/iwlwifi/iwl-io.c:34:
   drivers/net/wireless/intel/iwlwifi/iwl-trans.h: In function 'iwl_trans_get_txq_byte_table':
>> drivers/net/wireless/intel/iwlwifi/iwl-trans.h:1079:9: error: 'DMA_ERROR_CODE' undeclared (first use in this function)
     return DMA_ERROR_CODE;
            ^
   drivers/net/wireless/intel/iwlwifi/iwl-trans.h:1079:9: note: each undeclared identifier is reported only once for each function it appears in
--
   In file included from drivers/net/wireless/intel/iwlwifi/dvm/../iwl-eeprom-read.h:66:0,
                    from drivers/net/wireless/intel/iwlwifi/dvm/main.c:48:
   drivers/net/wireless/intel/iwlwifi/dvm/../iwl-trans.h: In function 'iwl_trans_get_txq_byte_table':
>> drivers/net/wireless/intel/iwlwifi/dvm/../iwl-trans.h:1079:9: error: 'DMA_ERROR_CODE' undeclared (first use in this function)
     return DMA_ERROR_CODE;
            ^
   drivers/net/wireless/intel/iwlwifi/dvm/../iwl-trans.h:1079:9: note: each undeclared identifier is reported only once for each function it appears in
--
   In file included from drivers/net/wireless/intel/iwlwifi/mvm/fw.c:70:0:
   drivers/net/wireless/intel/iwlwifi/mvm/../iwl-trans.h: In function 'iwl_trans_get_txq_byte_table':
>> drivers/net/wireless/intel/iwlwifi/mvm/../iwl-trans.h:1079:9: error: 'DMA_ERROR_CODE' undeclared (first use in this function)
     return DMA_ERROR_CODE;
            ^
   drivers/net/wireless/intel/iwlwifi/mvm/../iwl-trans.h:1079:9: note: each undeclared identifier is reported only once for each function it appears in

vim +/DMA_ERROR_CODE +1079 drivers/net/wireless/intel/iwlwifi/iwl-trans.h

  1073  
  1074  static inline dma_addr_t iwl_trans_get_txq_byte_table(struct iwl_trans *trans,
  1075                                                        int queue)
  1076  {
  1077          if (trans->ops->get_txq_byte_table)
  1078                  return trans->ops->get_txq_byte_table(trans, queue);
> 1079          return DMA_ERROR_CODE;
  1080  }
  1081  
  1082  static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,

---------->8----------

--
Cheers,
Luca.



On Thu, 2016-09-15 at 21:00 +0300, Luca Coelho wrote:
> Hi Kalle,
> 
> One more pull request intended for 4.9.  There are changes all over,
> mostly new hardware support, DQA, multiqueue MSIx work, and a bunch
> of
> cleanups and improvements.  More details in the tag description.
> 
> Let me know if everything's fine (or not). :)
> 
> Luca.
> 
> 
> The following changes since commit
> 76f8c0e17edc6eba43f84952e5a87c7f50f69370:
> 
>   iwlwifi: pcie: remove dead code (2016-08-30 14:16:43 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-
> next.git tags/iwlwifi-next-for-kalle-2016-09-15
> 
> for you to fetch changes up to
> ace403cf409d68c61ae75e71fd8a681263d73e20:
> 
>   iwlwifi: mvm: tighten BAID range check (2016-09-15 20:43:47 +0300)
> 
> ----------------------------------------------------------------
> * work for new hardware support continues
> * dynamic queue allocation stabilization
> * improvements in the MSIx code
> * multiqueue support work continues
> * new firmware version support
> * general cleanups and improvements
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: mvm: bump max API to 26
> 
> Haim Dreyfuss (3):
>       iwlwifi: pcie: Configure shared interrupt vector in MSIX mode
>       iwlwifi: pcie: Set affinity mask for rx interrupt vectors per
> cpu
>       iwlwifi: pcie: replace possible_cpus() with online_cpus() in
> MSIX mode
> 
> Johannes Berg (3):
>       iwlwifi: mvm: make RSS RX more robust
>       iwlwifi: mvm: remove pointless _bh from spinlock in timer
>       iwlwifi: mvm: tighten BAID range check
> 
> Liad Kaufman (3):
>       iwlwifi: mvm: don't free queue after delba in dqa
>       iwlwifi: mvm: fix pending frames tracking on tx resp
>       iwlwifi: mvm: free reserved queue on STA removal
> 
> Oren Givon (2):
>       iwlwifi: add the new 9560 series
>       iwlwifi: add the new 8275 series
> 
> Sara Sharon (10):
>       iwlwifi: mvm: call a different txq_enable function
>       iwlwifi: pcie: introduce new tfd and tb formats
>       iwlwifi: mvm: remove dump of locked registers
>       iwlwifi: mvm: support new shared memory config API
>       iwlwifi: introduce trans API to get byte count table
>       iwlwifi: pcie: assign and access a000 TFD & TBs
>       iwlwifi: change byte count table for a000 devices
>       iwlwifi: pcie: merge iwl_queue and iwl_txq
>       iwlwifi: mvm: support new BA notification response
>       iwlwifi: pcie: change indentation of
> iwl_pcie_set_interrupt_capa()
> 
> Sharon Dvir (1):
>       iwlwifi: unify iwl_get_ucode_image() implementations
> 
> Wei Yongjun (1):
>       iwlwifi: mvm: use setup_timer instead of init_timer and data
> fields
> 
> kbuild test robot (1):
>       iwlwifi: fix semicolon.cocci warnings
> 
>  drivers/net/wireless/intel/iwlwifi/dvm/ucode.c     |  11 +--
>  drivers/net/wireless/intel/iwlwifi/iwl-7000.c      |   4 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-8000.c      |  15 ++-
>  drivers/net/wireless/intel/iwlwifi/iwl-9000.c      |  13 ++-
>  drivers/net/wireless/intel/iwlwifi/iwl-a000.c      |   2 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-config.h    |   2 +
>  drivers/net/wireless/intel/iwlwifi/iwl-csr.h       |   2 +
>  drivers/net/wireless/intel/iwlwifi/iwl-fh.h        |  57 +++++++++
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-fw.h        |   9 ++
>  drivers/net/wireless/intel/iwlwifi/iwl-io.c        |   2 +-
>  drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |   1 +
>  drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  14 ++-
>  drivers/net/wireless/intel/iwlwifi/mvm/fw-api-tx.h |  79
> ++++++++++++++++
>  drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  22 ++++-
>  drivers/net/wireless/intel/iwlwifi/mvm/fw-dbg.c    |   4 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c        | 109
> ++++++++++++----------
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   9 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c      |   8 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c       |  36 ++++++--
>  drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 175
> +++++++++++++++++++++++------------
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c      |   5 +
>  drivers/net/wireless/intel/iwlwifi/pcie/internal.h | 127
> +++++++++++++++----------
>  drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |  16 +++-
>  drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 247
> +++++++++++++++++++++++++++++++++----------------
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 384
> +++++++++++++++++++++++++++++++++++++++++++++----------------------
> ---------
>  26 files changed, 896 insertions(+), 459 deletions(-)
