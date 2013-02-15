Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22-vm6.bullet.mail.ird.yahoo.com ([212.82.109.225]:37473 "HELO
	nm22-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751038Ab3BOXp2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 18:45:28 -0500
Message-ID: <1360971925.60249.YahooMailClassic@web172301.mail.ir2.yahoo.com> (sfid-20130216_004533_218523_5DF12BD1)
Date: Fri, 15 Feb 2013 23:45:25 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [PATCH 2/4] mac80211: Indicate hardware support for doze state rather than powersave
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@canonical.com>
In-Reply-To: <1360184478-31481-3-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Wed, 6/2/13, Seth Forshee <seth.forshee@canonical.com> wrote:

> When the off-channel powersave mode
> is added to mac80211, even drivers
> which do not support a doze powersave state will be informed
> of changes
> in the powersave state. To prepare for this, change the
> hardware
> powersave support flag to IEEE80211_HW_SUPPORTS_PS_DOZE to
> indicate only
> support for the doze state rather than powersave support in
> general.
> Most drivers which do not support the doze state can
> continue to ignore
> powersave state changes.
> 
> It will also become necessary for all drivers to accurately
> set the
> IEEE80211_HW_PS_NULLFUNC_STACK flag. Set this flag for all
> drivers which
> do not support the doze state.
> 
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>

Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>

The rtl8187 part & some of the revisions of comments in the mac80211 header.

Hin-Tak  

> ---
>  drivers/net/wireless/adm8211.c       
>              | 
>   3 +-
>  drivers/net/wireless/at76c50x-usb.c     
>           |    3 +-
>  drivers/net/wireless/ath/ar5523/ar5523.c   
>        |    3 +-
>  drivers/net/wireless/ath/ath5k/base.c     
>         |    3 +-
>  drivers/net/wireless/ath/ath9k/htc_drv_init.c   
>   |    2 +-
>  drivers/net/wireless/ath/ath9k/init.c     
>         |    2 +-
>  drivers/net/wireless/ath/carl9170/fw.c     
>        |    2 +-
>  drivers/net/wireless/ath/carl9170/main.c   
>        |    2 +-
>  drivers/net/wireless/b43/main.c       
>             |    3
> +-
>  drivers/net/wireless/b43legacy/main.c     
>         |    3 +-
>  .../net/wireless/brcm80211/brcmsmac/mac80211_if.c 
> |    3 +-
>  drivers/net/wireless/iwlegacy/3945-mac.c   
>        |    3 +-
>  drivers/net/wireless/iwlegacy/4965-mac.c   
>        |    2 +-
>  drivers/net/wireless/iwlwifi/dvm/mac80211.c   
>     |    2 +-
>  drivers/net/wireless/iwlwifi/mvm/mac80211.c   
>     |    2 +-
>  drivers/net/wireless/libertas_tf/main.c     
>       |    3 +-
>  drivers/net/wireless/mac80211_hwsim.c     
>         |    3 +-
>  drivers/net/wireless/mwl8k.c       
>            
>    |    3 +-
>  drivers/net/wireless/p54/main.c       
>             |    2
> +-
>  drivers/net/wireless/rt2x00/rt2400pci.c     
>       |    2 +-
>  drivers/net/wireless/rt2x00/rt2500pci.c     
>       |    2 +-
>  drivers/net/wireless/rt2x00/rt2500usb.c     
>       |    2 +-
>  drivers/net/wireless/rt2x00/rt2800lib.c     
>       |    2 +-
>  drivers/net/wireless/rt2x00/rt61pci.c     
>         |    2 +-
>  drivers/net/wireless/rt2x00/rt73usb.c     
>         |    2 +-
>  drivers/net/wireless/rtl818x/rtl8180/dev.c   
>      |    3 +-
>  drivers/net/wireless/rtl818x/rtl8187/dev.c   
>      |    3 +-
>  drivers/net/wireless/rtlwifi/base.c     
>           |    2 +-
>  drivers/net/wireless/ti/wl1251/main.c     
>         |    2 +-
>  drivers/net/wireless/ti/wlcore/main.c     
>         |    2 +-
>  drivers/net/wireless/zd1211rw/zd_mac.c     
>        |    3 +-
>  include/net/mac80211.h         
>                
>    |   61
> +++++++++++---------
>  net/mac80211/cfg.c           
>                
>      |    2 +-
>  net/mac80211/debugfs.c         
>                
>    |    2 +-
>  net/mac80211/mlme.c         
>                
>       |    6 +-
>  net/mac80211/tx.c           
>                
>       |    2 +-
>  36 files changed, 86 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/net/wireless/adm8211.c
> b/drivers/net/wireless/adm8211.c
> index 3d339e0..802b70c 100644
> --- a/drivers/net/wireless/adm8211.c
> +++ b/drivers/net/wireless/adm8211.c
> @@ -1862,7 +1862,8 @@ static int adm8211_probe(struct
> pci_dev *pdev,
>  
>      dev->extra_tx_headroom =
> sizeof(struct adm8211_tx_hdr);
>      /* dev->flags =
> IEEE80211_HW_RX_INCLUDES_FCS in promisc mode */
> -    dev->flags =
> IEEE80211_HW_SIGNAL_UNSPEC;
> +    dev->flags =
> IEEE80211_HW_SIGNAL_UNSPEC |
> +       
> IEEE80211_HW_PS_NULLFUNC_STACK;
>      dev->wiphy->interface_modes =
> BIT(NL80211_IFTYPE_STATION);
>  
>      dev->channel_change_time = 1000;
> diff --git a/drivers/net/wireless/at76c50x-usb.c
> b/drivers/net/wireless/at76c50x-usb.c
> index 77fa428..3d79d5b 100644
> --- a/drivers/net/wireless/at76c50x-usb.c
> +++ b/drivers/net/wireless/at76c50x-usb.c
> @@ -2253,7 +2253,8 @@ static int at76_init_new_device(struct
> at76_priv *priv,
>     
> priv->hw->wiphy->interface_modes =
> BIT(NL80211_IFTYPE_STATION);
>     
> priv->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
> &at76_supported_band;
>      priv->hw->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
> -           
>   IEEE80211_HW_SIGNAL_UNSPEC;
> +           
>   IEEE80211_HW_SIGNAL_UNSPEC |
> +           
>   IEEE80211_HW_PS_NULLFUNC_STACK;
>      priv->hw->max_signal = 100;
>  
>      SET_IEEE80211_DEV(priv->hw,
> &interface->dev);
> diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c
> b/drivers/net/wireless/ath/ar5523/ar5523.c
> index 7157f7d..6b2b5c1 100644
> --- a/drivers/net/wireless/ath/ar5523/ar5523.c
> +++ b/drivers/net/wireless/ath/ar5523/ar5523.c
> @@ -1684,7 +1684,8 @@ static int ar5523_probe(struct
> usb_interface *intf,
>      ar->vif = NULL;
>      hw->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
>             
> IEEE80211_HW_SIGNAL_DBM |
> -           
> IEEE80211_HW_HAS_RATE_CONTROL;
> +           
> IEEE80211_HW_HAS_RATE_CONTROL |
> +           
> IEEE80211_HW_PS_NULLFUNC_STACK;
>      hw->extra_tx_headroom = sizeof(struct
> ar5523_tx_desc) +
>             
>     sizeof(struct ar5523_chunk);
>      hw->wiphy->interface_modes =
> BIT(NL80211_IFTYPE_STATION);
> diff --git a/drivers/net/wireless/ath/ath5k/base.c
> b/drivers/net/wireless/ath/ath5k/base.c
> index 1d264c0..4122a15 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -2439,7 +2439,8 @@ ath5k_init_ah(struct ath5k_hw *ah,
> const struct ath_bus_ops *bus_ops)
>             
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>             
> IEEE80211_HW_SIGNAL_DBM |
>             
> IEEE80211_HW_MFP_CAPABLE |
> -           
> IEEE80211_HW_REPORTS_TX_ACK_STATUS;
> +           
> IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> +           
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      hw->wiphy->interface_modes =
>         
> BIT(NL80211_IFTYPE_AP) |
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> index e5d7958..847cf6d 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
> @@ -718,7 +718,7 @@ static void ath9k_set_hw_capab(struct
> ath9k_htc_priv *priv,
>         
> IEEE80211_HW_SPECTRUM_MGMT |
>         
> IEEE80211_HW_HAS_RATE_CONTROL |
>         
> IEEE80211_HW_RX_INCLUDES_FCS |
> -       
> IEEE80211_HW_SUPPORTS_PS |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_PS_NULLFUNC_STACK |
>         
> IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>         
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
> diff --git a/drivers/net/wireless/ath/ath9k/init.c
> b/drivers/net/wireless/ath/ath9k/init.c
> index af932c9..9880af8 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -743,7 +743,7 @@ void ath9k_set_hw_capab(struct ath_softc
> *sc, struct ieee80211_hw *hw)
>      hw->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
>         
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>         
> IEEE80211_HW_SIGNAL_DBM |
> -       
> IEEE80211_HW_SUPPORTS_PS |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_PS_NULLFUNC_STACK |
>         
> IEEE80211_HW_SPECTRUM_MGMT |
>         
> IEEE80211_HW_REPORTS_TX_ACK_STATUS;
> diff --git a/drivers/net/wireless/ath/carl9170/fw.c
> b/drivers/net/wireless/ath/carl9170/fw.c
> index 47d5c2e..bfd6c8e 100644
> --- a/drivers/net/wireless/ath/carl9170/fw.c
> +++ b/drivers/net/wireless/ath/carl9170/fw.c
> @@ -286,7 +286,7 @@ static int carl9170_fw(struct ar9170
> *ar, const __u8 *data, size_t len)
>      }
>  
>      if (SUPP(CARL9170FW_PSM) &&
> SUPP(CARL9170FW_FIXED_5GHZ_PSM))
> -        ar->hw->flags
> |= IEEE80211_HW_SUPPORTS_PS;
> +        ar->hw->flags
> |= IEEE80211_HW_SUPPORTS_PS_DOZE;
>  
>      if (!SUPP(CARL9170FW_USB_INIT_FIRMWARE))
> {
>         
> dev_err(&ar->udev->dev, "firmware does not provide
> "
> diff --git a/drivers/net/wireless/ath/carl9170/main.c
> b/drivers/net/wireless/ath/carl9170/main.c
> index 4af4a66..edab945 100644
> --- a/drivers/net/wireless/ath/carl9170/main.c
> +++ b/drivers/net/wireless/ath/carl9170/main.c
> @@ -1852,7 +1852,7 @@ void *carl9170_alloc(size_t
> priv_size)
>      hw->flags |=
> IEEE80211_HW_RX_INCLUDES_FCS |
>           
>    IEEE80211_HW_MFP_CAPABLE |
>           
>    IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> -         
>    IEEE80211_HW_SUPPORTS_PS |
> +         
>    IEEE80211_HW_SUPPORTS_PS_DOZE |
>           
>    IEEE80211_HW_PS_NULLFUNC_STACK |
>           
>    IEEE80211_HW_NEED_DTIM_PERIOD |
>           
>    IEEE80211_HW_SIGNAL_DBM;
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index 806e34c..0f4ddc7 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -5352,7 +5352,8 @@ static struct b43_wl
> *b43_wireless_init(struct b43_bus_dev *dev)
>  
>      /* fill hw info */
>      hw->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
> -           
> IEEE80211_HW_SIGNAL_DBM;
> +           
> IEEE80211_HW_SIGNAL_DBM |
> +           
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      hw->wiphy->interface_modes =
>         
> BIT(NL80211_IFTYPE_AP) |
> diff --git a/drivers/net/wireless/b43legacy/main.c
> b/drivers/net/wireless/b43legacy/main.c
> index 8c3f70e..3b0b7e8 100644
> --- a/drivers/net/wireless/b43legacy/main.c
> +++ b/drivers/net/wireless/b43legacy/main.c
> @@ -3836,7 +3836,8 @@ static int
> b43legacy_wireless_init(struct ssb_device *dev)
>  
>      /* fill hw info */
>      hw->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
> -           
> IEEE80211_HW_SIGNAL_DBM;
> +           
> IEEE80211_HW_SIGNAL_DBM |
> +           
> IEEE80211_HW_PS_NULLFUNC_STACK;
>      hw->wiphy->interface_modes =
>         
> BIT(NL80211_IFTYPE_AP) |
>         
> BIT(NL80211_IFTYPE_STATION) |
> diff --git
> a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> index 5f49326..e36df33 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
> @@ -987,7 +987,8 @@ static int ieee_hw_init(struct
> ieee80211_hw *hw)
>      hw->flags = IEEE80211_HW_SIGNAL_DBM
>          /* |
> IEEE80211_HW_CONNECTION_MONITOR  What is this? */
>          |
> IEEE80211_HW_REPORTS_TX_ACK_STATUS
> -        |
> IEEE80211_HW_AMPDU_AGGREGATION;
> +        |
> IEEE80211_HW_AMPDU_AGGREGATION
> +        |
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      hw->extra_tx_headroom =
> brcms_c_get_header_len();
>      hw->queues = N_TX_QUEUES;
> diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c
> b/drivers/net/wireless/iwlegacy/3945-mac.c
> index 83856d1..b6b2f30 100644
> --- a/drivers/net/wireless/iwlegacy/3945-mac.c
> +++ b/drivers/net/wireless/iwlegacy/3945-mac.c
> @@ -3565,7 +3565,8 @@ il3945_setup_mac(struct il_priv *il)
>  
>      /* Tell mac80211 our characteristics */
>      hw->flags = IEEE80211_HW_SIGNAL_DBM |
> IEEE80211_HW_SPECTRUM_MGMT |
> -           
> IEEE80211_HW_SUPPORTS_PS |
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
> +           
> IEEE80211_HW_SUPPORTS_PS_DOZE |
> +           
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
>  
>      hw->wiphy->interface_modes =
>         
> BIT(NL80211_IFTYPE_STATION) | BIT(NL80211_IFTYPE_ADHOC);
> diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c
> b/drivers/net/wireless/iwlegacy/4965-mac.c
> index 9741ac1..7b63ace 100644
> --- a/drivers/net/wireless/iwlegacy/4965-mac.c
> +++ b/drivers/net/wireless/iwlegacy/4965-mac.c
> @@ -5734,7 +5734,7 @@ il4965_mac_setup_register(struct
> il_priv *il, u32 max_probe_length)
>      hw->flags =
>          IEEE80211_HW_SIGNAL_DBM |
> IEEE80211_HW_AMPDU_AGGREGATION |
>         
> IEEE80211_HW_NEED_DTIM_PERIOD | IEEE80211_HW_SPECTRUM_MGMT
> |
> -       
> IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> IEEE80211_HW_SUPPORTS_PS |
> +       
> IEEE80211_HW_REPORTS_TX_ACK_STATUS |
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
>      if (il->cfg->sku & IL_SKU_N)
>          hw->flags |=
> diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> index c2f03ec..c235216 100644
> --- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> +++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
> @@ -149,7 +149,7 @@ int iwlagn_mac_setup_register(struct
> iwl_priv *priv,
>             
> IEEE80211_HW_SPECTRUM_MGMT |
>             
> IEEE80211_HW_REPORTS_TX_ACK_STATUS |
>             
> IEEE80211_HW_QUEUE_CONTROL |
> -           
> IEEE80211_HW_SUPPORTS_PS |
> +           
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>             
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
>             
> IEEE80211_HW_WANT_MONITOR_VIF |
>             
> IEEE80211_HW_SCAN_WHILE_IDLE;
> diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
> b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
> index a6b05a0..ac2f788 100644
> --- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
> +++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
> @@ -115,7 +115,7 @@ int iwl_mvm_mac_setup_register(struct
> iwl_mvm *mvm)
>             
> IEEE80211_HW_WANT_MONITOR_VIF |
>             
> IEEE80211_HW_SCAN_WHILE_IDLE |
>             
> IEEE80211_HW_NEED_DTIM_PERIOD |
> -           
> IEEE80211_HW_SUPPORTS_PS |
> +           
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>             
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
>             
> IEEE80211_HW_AMPDU_AGGREGATION;
>  
> diff --git a/drivers/net/wireless/libertas_tf/main.c
> b/drivers/net/wireless/libertas_tf/main.c
> index 7001856..c3e8fc6 100644
> --- a/drivers/net/wireless/libertas_tf/main.c
> +++ b/drivers/net/wireless/libertas_tf/main.c
> @@ -637,7 +637,8 @@ struct lbtf_private *lbtf_add_card(void
> *card, struct device *dmdev)
>      priv->tx_skb = NULL;
>  
>      hw->queues = 1;
> -    hw->flags =
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING;
> +    hw->flags =
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> +           
> IEEE80211_HW_PS_NULLFUNC_STACK;
>      hw->extra_tx_headroom = sizeof(struct
> txpd);
>      memcpy(priv->channels, lbtf_channels,
> sizeof(lbtf_channels));
>      memcpy(priv->rates, lbtf_rates,
> sizeof(lbtf_rates));
> diff --git a/drivers/net/wireless/mac80211_hwsim.c
> b/drivers/net/wireless/mac80211_hwsim.c
> index 3e4123e..f45c8ef 100644
> --- a/drivers/net/wireless/mac80211_hwsim.c
> +++ b/drivers/net/wireless/mac80211_hwsim.c
> @@ -2239,7 +2239,8 @@ static int __init
> init_mac80211_hwsim(void)
>             
>     IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
>             
>     IEEE80211_HW_AMPDU_AGGREGATION |
>             
>     IEEE80211_HW_WANT_MONITOR_VIF |
> -           
>     IEEE80211_HW_QUEUE_CONTROL;
> +           
>     IEEE80211_HW_QUEUE_CONTROL |
> +           
>     IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>         
> hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
>             
>        
> WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
> diff --git a/drivers/net/wireless/mwl8k.c
> b/drivers/net/wireless/mwl8k.c
> index 2031130..89a0bff 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -5864,7 +5864,8 @@ static int
> mwl8k_firmware_load_success(struct mwl8k_priv *priv)
>      hw->queues = MWL8K_TX_WMM_QUEUES;
>  
>      /* Set rssi values to dBm */
> -    hw->flags |= IEEE80211_HW_SIGNAL_DBM
> | IEEE80211_HW_HAS_RATE_CONTROL;
> +    hw->flags |= IEEE80211_HW_SIGNAL_DBM
> | IEEE80211_HW_HAS_RATE_CONTROL |
> +         
>    IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      /*
>       * Ask mac80211 to not to
> trigger PS mode
> diff --git a/drivers/net/wireless/p54/main.c
> b/drivers/net/wireless/p54/main.c
> index aadda99..88b8d09 100644
> --- a/drivers/net/wireless/p54/main.c
> +++ b/drivers/net/wireless/p54/main.c
> @@ -747,7 +747,7 @@ struct ieee80211_hw
> *p54_init_common(size_t priv_data_len)
>     
> skb_queue_head_init(&priv->tx_pending);
>      dev->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
>           
>    IEEE80211_HW_SIGNAL_DBM |
> -         
>    IEEE80211_HW_SUPPORTS_PS |
> +         
>    IEEE80211_HW_SUPPORTS_PS_DOZE |
>           
>    IEEE80211_HW_PS_NULLFUNC_STACK |
>           
>    IEEE80211_HW_MFP_CAPABLE |
>           
>    IEEE80211_HW_REPORTS_TX_ACK_STATUS;
> diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c
> b/drivers/net/wireless/rt2x00/rt2400pci.c
> index 203a217..2c501cc 100644
> --- a/drivers/net/wireless/rt2x00/rt2400pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2400pci.c
> @@ -1573,7 +1573,7 @@ static int
> rt2400pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>       */
>      rt2x00dev->hw->flags =
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>             
>        IEEE80211_HW_SIGNAL_DBM |
> -           
>        IEEE80211_HW_SUPPORTS_PS |
> +           
>    
>    IEEE80211_HW_SUPPORTS_PS_DOZE |
>             
>    
>    IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      SET_IEEE80211_DEV(rt2x00dev->hw,
> rt2x00dev->dev);
> diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c
> b/drivers/net/wireless/rt2x00/rt2500pci.c
> index e4a7e12..71546a8 100644
> --- a/drivers/net/wireless/rt2x00/rt2500pci.c
> +++ b/drivers/net/wireless/rt2x00/rt2500pci.c
> @@ -1866,7 +1866,7 @@ static int
> rt2500pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>       */
>      rt2x00dev->hw->flags =
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>             
>        IEEE80211_HW_SIGNAL_DBM |
> -           
>        IEEE80211_HW_SUPPORTS_PS |
> +           
>    
>    IEEE80211_HW_SUPPORTS_PS_DOZE |
>             
>    
>    IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      SET_IEEE80211_DEV(rt2x00dev->hw,
> rt2x00dev->dev);
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c
> b/drivers/net/wireless/rt2x00/rt2500usb.c
> index a411f4e..a68593d 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -1705,7 +1705,7 @@ static int
> rt2500usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>      rt2x00dev->hw->flags =
>         
> IEEE80211_HW_RX_INCLUDES_FCS |
>          IEEE80211_HW_SIGNAL_DBM |
> -        IEEE80211_HW_SUPPORTS_PS
> |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      SET_IEEE80211_DEV(rt2x00dev->hw,
> rt2x00dev->dev);
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
> b/drivers/net/wireless/rt2x00/rt2800lib.c
> index acfb0a1..a60756c 100644
> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -5142,7 +5142,7 @@ static int rt2800_probe_hw_mode(struct
> rt2x00_dev *rt2x00dev)
>       */
>      rt2x00dev->hw->flags =
>          IEEE80211_HW_SIGNAL_DBM |
> -        IEEE80211_HW_SUPPORTS_PS
> |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_PS_NULLFUNC_STACK |
>         
> IEEE80211_HW_AMPDU_AGGREGATION |
>         
> IEEE80211_HW_REPORTS_TX_ACK_STATUS;
> diff --git a/drivers/net/wireless/rt2x00/rt61pci.c
> b/drivers/net/wireless/rt2x00/rt61pci.c
> index c9d3e37..ca84cc5 100644
> --- a/drivers/net/wireless/rt2x00/rt61pci.c
> +++ b/drivers/net/wireless/rt2x00/rt61pci.c
> @@ -2763,7 +2763,7 @@ static int
> rt61pci_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>      rt2x00dev->hw->flags =
>         
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>          IEEE80211_HW_SIGNAL_DBM |
> -        IEEE80211_HW_SUPPORTS_PS
> |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      SET_IEEE80211_DEV(rt2x00dev->hw,
> rt2x00dev->dev);
> diff --git a/drivers/net/wireless/rt2x00/rt73usb.c
> b/drivers/net/wireless/rt2x00/rt73usb.c
> index 719e781..70aa736 100644
> --- a/drivers/net/wireless/rt2x00/rt73usb.c
> +++ b/drivers/net/wireless/rt2x00/rt73usb.c
> @@ -2118,7 +2118,7 @@ static int
> rt73usb_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>       */
>      rt2x00dev->hw->flags =
>          IEEE80211_HW_SIGNAL_DBM |
> -        IEEE80211_HW_SUPPORTS_PS
> |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      SET_IEEE80211_DEV(rt2x00dev->hw,
> rt2x00dev->dev);
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c
> b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> index 1b3c284..4f7a737 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> @@ -991,7 +991,8 @@ static int rtl8180_probe(struct pci_dev
> *pdev,
>  
>      dev->flags =
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>           
>    IEEE80211_HW_RX_INCLUDES_FCS |
> -         
>    IEEE80211_HW_SIGNAL_UNSPEC;
> +         
>    IEEE80211_HW_SIGNAL_UNSPEC |
> +         
>    IEEE80211_HW_PS_NULLFUNC_STACK;
>      dev->vif_data_size = sizeof(struct
> rtl8180_vif);
>      dev->wiphy->interface_modes =
> BIT(NL80211_IFTYPE_STATION) |
>             
>        
> BIT(NL80211_IFTYPE_ADHOC);
> diff --git a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> index 4574bd2..4a4e917 100644
> --- a/drivers/net/wireless/rtl818x/rtl8187/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8187/dev.c
> @@ -1467,7 +1467,8 @@ static int rtl8187_probe(struct
> usb_interface *intf,
>  
>      dev->flags =
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
>           
>    IEEE80211_HW_SIGNAL_DBM |
> -         
>    IEEE80211_HW_RX_INCLUDES_FCS;
> +         
>    IEEE80211_HW_RX_INCLUDES_FCS |
> +         
>    IEEE80211_HW_PS_NULLFUNC_STACK;
>      /* Initialize rate-control variables */
>      dev->max_rates = 1;
>      dev->max_rate_tries = RETRY_COUNT;
> diff --git a/drivers/net/wireless/rtlwifi/base.c
> b/drivers/net/wireless/rtlwifi/base.c
> index 0f8b051..195424c 100644
> --- a/drivers/net/wireless/rtlwifi/base.c
> +++ b/drivers/net/wireless/rtlwifi/base.c
> @@ -315,7 +315,7 @@ static void _rtl_init_mac80211(struct
> ieee80211_hw *hw)
>  
>      /* swlps or hwlps has been set in diff
> chip in init_sw_vars */
>      if (rtlpriv->psc.swctrl_lps)
> -        hw->flags |=
> IEEE80211_HW_SUPPORTS_PS |
> +        hw->flags |=
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>             
> IEEE80211_HW_PS_NULLFUNC_STACK |
>              /*
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS | */
>             
> 0;
> diff --git a/drivers/net/wireless/ti/wl1251/main.c
> b/drivers/net/wireless/ti/wl1251/main.c
> index 57bea2f..83b0789 100644
> --- a/drivers/net/wireless/ti/wl1251/main.c
> +++ b/drivers/net/wireless/ti/wl1251/main.c
> @@ -1337,7 +1337,7 @@ int wl1251_init_ieee80211(struct
> wl1251 *wl)
>      wl->hw->channel_change_time =
> 10000;
>  
>      wl->hw->flags =
> IEEE80211_HW_SIGNAL_DBM |
> -       
> IEEE80211_HW_SUPPORTS_PS |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_SUPPORTS_UAPSD;
>  
>      wl->hw->wiphy->interface_modes
> = BIT(NL80211_IFTYPE_STATION) |
> diff --git a/drivers/net/wireless/ti/wlcore/main.c
> b/drivers/net/wireless/ti/wlcore/main.c
> index c67005f..9a33877 100644
> --- a/drivers/net/wireless/ti/wlcore/main.c
> +++ b/drivers/net/wireless/ti/wlcore/main.c
> @@ -5630,7 +5630,7 @@ static int
> wl1271_init_ieee80211(struct wl1271 *wl)
>      wl->hw->max_listen_interval =
> wl->conf.conn.max_listen_interval;
>  
>      wl->hw->flags =
> IEEE80211_HW_SIGNAL_DBM |
> -       
> IEEE80211_HW_SUPPORTS_PS |
> +       
> IEEE80211_HW_SUPPORTS_PS_DOZE |
>         
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS |
>         
> IEEE80211_HW_SUPPORTS_UAPSD |
>         
> IEEE80211_HW_HAS_RATE_CONTROL |
> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c
> b/drivers/net/wireless/zd1211rw/zd_mac.c
> index 114364b..0c39718 100644
> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
> @@ -1402,7 +1402,8 @@ struct ieee80211_hw
> *zd_mac_alloc_hw(struct usb_interface *intf)
>      hw->flags =
> IEEE80211_HW_RX_INCLUDES_FCS |
>             
> IEEE80211_HW_SIGNAL_UNSPEC |
>             
> IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
> -           
> IEEE80211_HW_MFP_CAPABLE;
> +           
> IEEE80211_HW_MFP_CAPABLE |
> +           
> IEEE80211_HW_PS_NULLFUNC_STACK;
>  
>      hw->wiphy->interface_modes =
>         
> BIT(NL80211_IFTYPE_MESH_POINT) |
> diff --git a/include/net/mac80211.h
> b/include/net/mac80211.h
> index 024c495..c5ca5ab 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1307,7 +1307,7 @@ struct ieee80211_tx_control {
>   * @IEEE80211_HW_AMPDU_AGGREGATION:
>   *    Hardware supports 11n A-MPDU
> aggregation.
>   *
> - * @IEEE80211_HW_SUPPORTS_PS:
> + * @IEEE80211_HW_SUPPORTS_PS_DOZE:
>   *    Hardware has power save support
> (i.e. can go to sleep).
>   *
>   * @IEEE80211_HW_PS_NULLFUNC_STACK:
> @@ -1399,7 +1399,7 @@ enum ieee80211_hw_flags {
>     
> IEEE80211_HW_NEED_DTIM_PERIOD   
>         = 1<<7,
>     
> IEEE80211_HW_SPECTRUM_MGMT   
>         = 1<<8,
>     
> IEEE80211_HW_AMPDU_AGGREGATION   
>         = 1<<9,
> -   
> IEEE80211_HW_SUPPORTS_PS   
>         = 1<<10,
> +   
> IEEE80211_HW_SUPPORTS_PS_DOZE   
>         = 1<<10,
>     
> IEEE80211_HW_PS_NULLFUNC_STACK   
>         = 1<<11,
>     
> IEEE80211_HW_SUPPORTS_DYNAMIC_PS   
>     = 1<<12,
>     
> IEEE80211_HW_MFP_CAPABLE   
>         = 1<<13,
> @@ -1655,28 +1655,37 @@ void ieee80211_free_txskb(struct
> ieee80211_hw *hw, struct sk_buff *skb);
>   *
>   * mac80211 has support for various powersave
> implementations.
>   *
> - * First, it can support hardware that handles all
> powersaving by itself,
> - * such hardware should simply set the
> %IEEE80211_HW_SUPPORTS_PS hardware
> - * flag. In that case, it will be told about the desired
> powersave mode
> - * with ieee80211_conf_ps_mode() depending on the
> association status.
> - * The hardware must take care of sending nullfunc frames
> when necessary,
> - * i.e. when entering and leaving powersave mode. The
> hardware is required
> - * to look at the AID in beacons and signal to the AP that
> it woke up when
> - * it finds traffic directed to it.
> - *
> - * The %IEEE80211_PS_DOZE mode means that the powersave
> mode defined in
> - * IEEE 802.11-2007 section 11.2 is enabled. This is not to
> be confused
> - * with hardware wakeup and sleep states. Driver is
> responsible for waking
> - * up the hardware before issuing commands to the hardware
> and putting it
> - * back to sleep at appropriate times.
> - *
> - * When PS is enabled, hardware needs to wakeup for beacons
> and receive the
> - * buffered multicast/broadcast frames after the beacon.
> Also it must be
> - * possible to send frames and receive the acknowledment
> frame.
> + * Drivers are informed about changes to the powersave
> state with the
> + * %IEEE80211_CONF_PS_MASK bits in the configuration flags.
> The current
> + * mode can be read by calling ieee80211_conf_ps_mode().
> Hardware which
> + * does not support a low-power state should leave
> + * %IEEE80211_HW_SUPPORTS_PS_DOZE clear to avoid being
> placed into a low-
> + * power state. %IEEE80211_HW_PS_NULLFUNC_STACK should be
> set if the
> + * hardware requires that mac80211 generate nullfunc frames
> when
> + * transitioning between powersave modes.
> + *
> + * Hardware which supports a low-power "doze" state should
> set the
> + * %IEEE80211_HW_SUPPORTS_PS_DOZE hardware flag. This will
> make it possible
> + * to put the hardware into the %IEEE80211_PS_DOZE mode.
> When in the doze
> + * state the powersave mode defined in IEEE 802.11-2007
> section 11.2 is
> + * enabled. This is not to be confused with hardware wakeup
> and sleep
> + * states. While in the doze state, the driver is
> responsible for waking up
> + * the hardware before issuing commands to the hardware and
> putting it back
> + * to sleep at appropriate times. The hardware needs to
> wakeup for beacons
> + * and receive the buffered multicast/broadcast frames
> after the beacon.
> + * Also it must be possible to send frames and receive the
> acknowledment
> + * frame.
> + *
> + * For hardware that handles all powersaving by itself,
> setting
> + * %IEEE80211_HW_SUPPORTS_PS_DOZE is all that is needed.
> The hardware must
> + * take care of sending nullfunc frames when necessary,
> i.e. when entering
> + * and leaving powersave mode. The hardware is required to
> look at the AID
> + * in beacons and signal to the AP that it woke up when it
> finds traffic
> + * directed to it.
>   *
>   * Other hardware designs cannot send nullfunc frames
> by themselves and also
>   * need software support for parsing the TIM bitmap.
> This is also supported
> - * by mac80211 by combining the %IEEE80211_HW_SUPPORTS_PS
> and
> + * by mac80211 by combining the
> %IEEE80211_HW_SUPPORTS_PS_DOZE and
>   * %IEEE80211_HW_PS_NULLFUNC_STACK flags. The hardware
> is of course still
>   * required to pass up beacons. The hardware is still
> required to handle
>   * waking up for multicast traffic; if it cannot the
> driver must handle that
> @@ -1690,11 +1699,11 @@ void ieee80211_free_txskb(struct
> ieee80211_hw *hw, struct sk_buff *skb);
>   * periods.
>   *
>   * Dynamic powersave is simply supported by mac80211
> enabling and disabling
> - * PS based on traffic. Driver needs to only set
> %IEEE80211_HW_SUPPORTS_PS
> - * flag and mac80211 will handle everything automatically.
> Additionally,
> - * hardware having support for the dynamic PS feature may
> set the
> - * %IEEE80211_HW_SUPPORTS_DYNAMIC_PS flag to indicate that
> it can support
> - * dynamic PS mode itself. The driver needs to look at the
> + * PS based on traffic. Driver needs to only set
> + * %IEEE80211_HW_SUPPORTS_PS_DOZE flag and mac80211 will
> handle everything
> + * automatically. Additionally, hardware having support for
> the dynamic PS
> + * feature may set the %IEEE80211_HW_SUPPORTS_DYNAMIC_PS
> flag to indicate
> + * that it can support dynamic PS mode itself. The driver
> needs to look at the
>   * @dynamic_ps_timeout hardware configuration value
> and use it that value
>   * whenever the mode is %IEEE80211_PS_DOZE. In this
> case mac80211 will disable
>   * dynamic PS feature in stack and will just set
> %IEEE80211_PS_DOZE whenever
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index fd38c37..fac5ef8 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2265,7 +2265,7 @@ static int
> ieee80211_set_power_mgmt(struct wiphy *wiphy, struct
> net_device *dev,
>          sdata->vif.type !=
> NL80211_IFTYPE_MESH_POINT)
>          return -EOPNOTSUPP;
>  
> -    if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS))
> +    if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS_DOZE))
>          return -EOPNOTSUPP;
>  
>      if (enabled == sdata->u.mgd.powersave
> &&
> diff --git a/net/mac80211/debugfs.c
> b/net/mac80211/debugfs.c
> index 466f4b4..21ad1f5 100644
> --- a/net/mac80211/debugfs.c
> +++ b/net/mac80211/debugfs.c
> @@ -127,7 +127,7 @@ static ssize_t hwflags_read(struct file
> *file, char __user *user_buf,
>          sf += snprintf(buf +
> sf, mxln - sf, "SPECTRUM_MGMT\n");
>      if (local->hw.flags &
> IEEE80211_HW_AMPDU_AGGREGATION)
>          sf += snprintf(buf +
> sf, mxln - sf, "AMPDU_AGGREGATION\n");
> -    if (local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS)
> +    if (local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS_DOZE)
>          sf += snprintf(buf +
> sf, mxln - sf, "SUPPORTS_PS\n");
>      if (local->hw.flags &
> IEEE80211_HW_PS_NULLFUNC_STACK)
>          sf += snprintf(buf +
> sf, mxln - sf, "PS_NULLFUNC_STACK\n");
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index 7afcc73..d13d885 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -953,7 +953,7 @@ void ieee80211_enable_dyn_ps(struct
> ieee80211_vif *vif)
>      struct ieee80211_conf *conf =
> &local->hw.conf;
>  
>      WARN_ON(sdata->vif.type !=
> NL80211_IFTYPE_STATION ||
> -        !(local->hw.flags
> & IEEE80211_HW_SUPPORTS_PS) ||
> +        !(local->hw.flags
> & IEEE80211_HW_SUPPORTS_PS_DOZE) ||
>          (local->hw.flags
> & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
>  
>      local->disable_dynamic_ps = false;
> @@ -968,7 +968,7 @@ void ieee80211_disable_dyn_ps(struct
> ieee80211_vif *vif)
>      struct ieee80211_conf *conf =
> &local->hw.conf;
>  
>      WARN_ON(sdata->vif.type !=
> NL80211_IFTYPE_STATION ||
> -        !(local->hw.flags
> & IEEE80211_HW_SUPPORTS_PS) ||
> +        !(local->hw.flags
> & IEEE80211_HW_SUPPORTS_PS_DOZE) ||
>          (local->hw.flags
> & IEEE80211_HW_SUPPORTS_DYNAMIC_PS));
>  
>      local->disable_dynamic_ps = true;
> @@ -1058,7 +1058,7 @@ void ieee80211_recalc_ps(struct
> ieee80211_local *local, s32 latency)
>      int count = 0;
>      int timeout;
>  
> -    if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS)) {
> +    if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS_DOZE)) {
>          local->ps_sdata =
> NULL;
>          return;
>      }
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index 2572647..e96994e 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -185,7 +185,7 @@ ieee80211_tx_h_dynamic_ps(struct
> ieee80211_tx_data *tx)
>      struct ieee80211_if_managed *ifmgd;
>  
>      /* driver doesn't support power save */
> -    if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS))
> +    if (!(local->hw.flags &
> IEEE80211_HW_SUPPORTS_PS_DOZE))
>          return TX_CONTINUE;
>  
>      /* hardware does dynamic power save */
> -- 
> 1.7.9.5
> 
> 
