Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:36220 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbYLQKyJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 05:54:09 -0500
Date: Wed, 17 Dec 2008 18:53:17 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhu, Yi" <yi.zhu@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 3/8] iwlwifi: update comments on the debug interface
Message-ID: <20081217105317.GA20663@localhost> (sfid-20081217_115413_340422_A58842EC)
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com> <1229503954-30347-2-git-send-email-yi.zhu@intel.com> <1229503954-30347-3-git-send-email-yi.zhu@intel.com> <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 10:52:29AM +0200, Zhu, Yi wrote:
> From: Wu, Fengguang <fengguang.wu@intel.com>
> 
> Bring up-to-date some comments on the location of debug files.
> 
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c   |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-debug.h |   17 +++++++----------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 9d50fad..d0fb7a3 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -3354,7 +3354,7 @@ static int iwl_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb)
>  
>  /*
>   * The following adds a new attribute to the sysfs representation
> - * of this device driver (i.e. a new file in /sys/bus/pci/drivers/iwl/)
> + * of this device driver (i.e. a new file in /sys/class/net/wlan0/device/)
>   * used for controlling the debug level.
>   *
>   * See the level definitions in iwl for details.
> diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
> index e4c264b..56c13b4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-debug.h
> +++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
> @@ -96,28 +96,25 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
>  #endif				/* CONFIG_IWLWIFI_DEBUGFS */
>  
>  /*
> - * To use the debug system;
> + * To use the debug system:
>   *
>   * If you are defining a new debug classification, simply add it to the #define
> - * list here in the form of:
> + * list here in the form of
>   *
>   * #define IWL_DL_xxxx VALUE
>   *
> - * shifting value to the left one bit from the previous entry.  xxxx should be
> - * the name of the classification (for example, WEP)
> + * where xxxx should be the name of the classification (for example, WEP).
>   *
>   * You then need to either add a IWL_xxxx_DEBUG() macro definition for your
>   * classification, or use IWL_DEBUG(IWL_DL_xxxx, ...) whenever you want
>   * to send output to that classification.
>   *
> - * To add your debug level to the list of levels seen when you perform
> + * The active debug levels can be accessed via files
>   *
> - * % cat /sys/class/net/wlanX/device/debug_level
> + * 	/sys/module/iwlagn/parameters/debug{50}
> + * 	/sys/class/net/wlan0/device/debug_level
>   *
> - * you simply need to add your entry to the iwl_debug_levels array.
> - *
> - * If you do not see debug_level in  /sys/class/net/wlanX/device/debug_level
> - * then you do not have CONFIG_IWLWIFI_DEBUG defined in your kernel config file
> + * when CONFIG_IWLWIFI_DEBUG=y.
>   */

Hi Yi,

This was my prepared version:

 * The debug levels can be activated by the "debug" module parameter("debug50"
 * for 5000), and be runtime accessed via file
 *
 *     /sys/class/net/wlan0/device/debug_level
 *
 * when CONFIG_IWLWIFI_DEBUG=y.

It's not really an obviously better writing though, and can be safely ignored.

Thanks,
Fengguang

