Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59008 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755642AbeBPPDQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 10:03:16 -0500
Message-ID: <1518793392.7832.56.camel@coelho.fi> (sfid-20180216_160320_734955_C5027C77)
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Date: Fri, 16 Feb 2018 17:03:12 +0200
In-Reply-To: <1518788935.7832.46.camel@coelho.fi>
References: <1518788935.7832.46.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: pull-request: iwlwifi 2018-02-16
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ooops, please hold on.  Now kbuildbot reported a compilation error. 
And now that I checked, it seems that it didn't run for some reason
when I pushed my patches out last week.

Anyway, I'll send a second pull request in a bit, so please ignore this
one.

--
Cheers,
Luca.


On Fri, 2018-02-16 at 15:48 +0200, Luca Coelho wrote:
> Hi Kalle,
> 
> Here is my first set of fixes for 4.16.  More details in the tag
> description.
> 
> I have sent this out before and kbuildbot didn't find any issues. 
> Please let me know if there are any issues.
> 
> Cheers,
> Luca.
> 
> 
> The following changes since commit
> 7ac8ff95f48cbfa609a060fd6a1e361dd62feeb3:
> 
>   mvpp2: fix multicast address filter (2018-02-11 22:37:04 -0500)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-
> fixes.git tags/iwlwifi-for-kalle-2018-02-16
> 
> for you to fetch changes up to
> e1233ae4095b77a966af457ed7ebc3053c5821c8:
> 
>   iwlwifi: mvm: always init rs with 20mhz bandwidth rates (2018-02-16 
> 15:34:33 +0200)
> 
> ----------------------------------------------------------------
> First batch of iwlwifi fixes intended for 4.16:
> 
> * A couple of bugzilla fixes
>   - Fix a bogus warning when freeing a TFD;
>   - Fix severe throughput problem with 9000 series;
> * Fix for a bug that caused queue hangs in certain situations;
> * Fix for an issue with IBSS;
> * Fix an issue with rate-scalingin AP-mode.
> 
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: pcie: don't warn if we use all the transmit pointers
> 
> Naftali Goldstein (1):
>       iwlwifi: mvm: always init rs with 20mhz bandwidth rates
> 
> Sara Sharon (2):
>       iwlwifi: mvm: fix security bug in PN checking
>       iwlwifi: mvm: fix IBSS for devices that support station type
> API
> 
> Shaul Triebitz (1):
>       iwlwifi: align timestamp cancel with timestamp start
> 
>  drivers/net/wireless/intel/iwlwifi/fw/init.c      |  6 ------
>  drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c |  3 ++-
>  drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c |  4 ++++
>  drivers/net/wireless/intel/iwlwifi/mvm/mvm.h      |  1 +
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  2 --
>  drivers/net/wireless/intel/iwlwifi/mvm/rs.c       | 28
> ++++++++++++++++++++--------
>  drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c     | 39
> ++++++++++++++++++++-------------------
>  drivers/net/wireless/intel/iwlwifi/mvm/sta.c      | 24 ++++++++++++-
> -----------
>  drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c |  2 +-
>  drivers/net/wireless/intel/iwlwifi/pcie/tx.c      |  2 +-
>  10 files changed, 61 insertions(+), 50 deletions(-)
