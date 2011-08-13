Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:20880 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043Ab1HMSo0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:44:26 -0400
Subject: Re: [PATCH 00/11]  update for 3.2
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313252287-22858-1-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Aug 2011 11:04:33 -0700
Message-ID: <1313258673.15170.20.camel@wwguy-huron> (sfid-20110813_204428_727988_6BE22C71)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

Please ignore this patch set, I don't mean to send it.
The only patch I need to send is the "handle GO powersave" path.

I will send the single patch separated.

Sorry for the mistake.

Wey


On Sat, 2011-08-13 at 09:17 -0700, Guy, Wey-Yi W wrote:
> We enable new P2P implementation with GO powersave
> We bump firmware API version for number of new devices
> We also adjust the sensitivity value for number of devices
> 
> 
> Johannes Berg (7):
>   iwlagn: reserve queue 10 for TX during scan dwell
>   iwlagn: handle GO powersave
>   iwlagn: separate firmware version warning
>   iwlagn: bump firmware API for some devices
>   iwlagn: move context init after firmware loading
>   iwlagn: support new P2P implementation
>   mac80211: remove offchannel_tx API
> 
> Wey-Yi Guy (4):
>   iwlagn: default smps mode for 1000 series device
>   iwlagn: Remove ht40 support from 5.2GHz for _bgn devices
>   iwlagn: change default sensitivity value for 5000 and 6000 series
>   iwlagn: support v2 of enhanced sensitivity table
> 
>  drivers/net/wireless/iwlwifi/Kconfig         |   17 -
>  drivers/net/wireless/iwlwifi/iwl-1000.c      |   15 +-
>  drivers/net/wireless/iwlwifi/iwl-2000.c      |   23 +-
>  drivers/net/wireless/iwlwifi/iwl-5000.c      |   12 +-
>  drivers/net/wireless/iwlwifi/iwl-6000.c      |   19 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-calib.c |   69 +++--
>  drivers/net/wireless/iwlwifi/iwl-agn-hw.h    |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   47 +--
>  drivers/net/wireless/iwlwifi/iwl-agn-rxon.c  |   28 +--
>  drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   30 +-
>  drivers/net/wireless/iwlwifi/iwl-agn.c       |  455 ++++++++++++++------------
>  drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 +
>  drivers/net/wireless/iwlwifi/iwl-commands.h  |   34 ++-
>  drivers/net/wireless/iwlwifi/iwl-core.c      |    5 +
>  drivers/net/wireless/iwlwifi/iwl-core.h      |    5 +
>  drivers/net/wireless/iwlwifi/iwl-dev.h       |   32 ++-
>  drivers/net/wireless/iwlwifi/iwl-scan.c      |   19 +-
>  drivers/net/wireless/iwlwifi/iwl-trans.c     |   10 +-
>  include/net/mac80211.h                       |   10 -
>  net/mac80211/cfg.c                           |   39 ---
>  net/mac80211/driver-ops.h                    |   31 --
>  net/mac80211/ieee80211_i.h                   |    1 -
>  net/mac80211/status.c                        |    3 -
>  23 files changed, 449 insertions(+), 460 deletions(-)
> 


