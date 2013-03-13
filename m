Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:44525 "EHLO
	Linville-X1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932391Ab3CMP0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 11:26:35 -0400
Date: Wed, 13 Mar 2013 11:26:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Patrik, Kluba" <pkluba@dension.com>,
	linux-wireless@vger.kernel.org
Subject: Re: bug: deadlock in rtl8192cu
Message-ID: <20130313152623.GA10077@tuxdriver.com> (sfid-20130313_162642_989546_B5690E0E)
References: <20130312163020.67f9532b.pkluba@dension.com>
 <513F5931.6040509@lwfinger.net>
 <20130313152505.7dc3466c.pkluba@dension.com>
 <5140977D.2040403@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5140977D.2040403@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 13, 2013 at 10:13:01AM -0500, Larry Finger wrote:

> Yesterday, Jussi Kivilinna and I found a problem that prevented
> rtl8192cu from reconnecting once it disconnected. That patch is
> attached.
> 
> Larry

Is this your patch submission?  Or will you be posting separately
(and with a clearer subject/intent)? :-)

> The driver was failing to clear the BSSID when a disconnect happened. That
> prevented a reconnection. This problem is reported at
> https://bugzilla.redhat.com/show_bug.cgi?id=789605,
> https://bugzilla.redhat.com/show_bug.cgi?id=866786,
> https://bugzilla.redhat.com/show_bug.cgi?id=906734, and
> https://bugzilla.kernel.org/show_bug.cgi?id=46171.
> 
> Thanks to Jussi Kivilinna for making the critical observation
> that led to the solution.
> 
> Reported-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Tested-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Stable <stable@vger.kernel.org>
> ---
> 
> John,
> 
> As you can see by the number of bug reports, this patch should be
> pushed as soon as possible.
> 
> Thanks,
> 
> Larry
> ---
> 
>  base.h         |    3 +
>  pci.c          |    2 -
>  rtl8192cu/hw.c |   87 ++++++++++++++++++++++-----------------------------------
>  3 files changed, 39 insertions(+), 53 deletions(-)
> 
> Index: linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> +++ linux-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/hw.c
> @@ -1377,74 +1377,57 @@ void rtl92cu_card_disable(struct ieee802
>  
>  void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
>  {
> -	/* dummy routine needed for callback from rtl_op_configure_filter() */
> -}
> -
> -/*========================================================================== */
> -
> -static void _rtl92cu_set_check_bssid(struct ieee80211_hw *hw,
> -			      enum nl80211_iftype type)
> -{
>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
>  	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
> -	struct rtl_phy *rtlphy = &(rtlpriv->phy);
> -	u8 filterout_non_associated_bssid = false;
> +	u32 reg_rcr = rtl_read_dword(rtlpriv, REG_RCR);
>  
> -	switch (type) {
> -	case NL80211_IFTYPE_ADHOC:
> -	case NL80211_IFTYPE_STATION:
> -		filterout_non_associated_bssid = true;
> -		break;
> -	case NL80211_IFTYPE_UNSPECIFIED:
> -	case NL80211_IFTYPE_AP:
> -	default:
> -		break;
> -	}
> -	if (filterout_non_associated_bssid) {
> +	if (rtlpriv->psc.rfpwr_state != ERFON)
> +		return;
> +
> +	if (check_bssid) {
> +		u8 tmp;
>  		if (IS_NORMAL_CHIP(rtlhal->version)) {
> -			switch (rtlphy->current_io_type) {
> -			case IO_CMD_RESUME_DM_BY_SCAN:
> -				reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
> -				rtlpriv->cfg->ops->set_hw_reg(hw,
> -						 HW_VAR_RCR, (u8 *)(&reg_rcr));
> -				/* enable update TSF */
> -				_rtl92cu_set_bcn_ctrl_reg(hw, 0, BIT(4));
> -				break;
> -			case IO_CMD_PAUSE_DM_BY_SCAN:
> -				reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
> -				rtlpriv->cfg->ops->set_hw_reg(hw,
> -						 HW_VAR_RCR, (u8 *)(&reg_rcr));
> -				/* disable update TSF */
> -				_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
> -				break;
> -			}
> +			reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
> +			tmp = BIT(4);
>  		} else {
> -			reg_rcr |= (RCR_CBSSID);
> -			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
> -						      (u8 *)(&reg_rcr));
> -			_rtl92cu_set_bcn_ctrl_reg(hw, 0, (BIT(4)|BIT(5)));
> +			reg_rcr |= RCR_CBSSID;
> +			tmp = BIT(4) | BIT(5);
>  		}
> -	} else if (filterout_non_associated_bssid == false) {
> +		rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
> +					      (u8 *) (&reg_rcr));
> +		_rtl92cu_set_bcn_ctrl_reg(hw, 0, tmp);
> +	} else {
> +		u8 tmp;
>  		if (IS_NORMAL_CHIP(rtlhal->version)) {
> -			reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
> -			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
> -						      (u8 *)(&reg_rcr));
> -			_rtl92cu_set_bcn_ctrl_reg(hw, BIT(4), 0);
> +			reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
> +			tmp = BIT(4);
>  		} else {
> -			reg_rcr &= (~RCR_CBSSID);
> -			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_RCR,
> -						      (u8 *)(&reg_rcr));
> -			_rtl92cu_set_bcn_ctrl_reg(hw, (BIT(4)|BIT(5)), 0);
> +			reg_rcr &= ~RCR_CBSSID;
> +			tmp = BIT(4) | BIT(5);
>  		}
> +		reg_rcr &= (~(RCR_CBSSID_DATA | RCR_CBSSID_BCN));
> +		rtlpriv->cfg->ops->set_hw_reg(hw,
> +					      HW_VAR_RCR, (u8 *) (&reg_rcr));
> +		_rtl92cu_set_bcn_ctrl_reg(hw, tmp, 0);
>  	}
>  }
>  
> +/*========================================================================== */
> +
>  int rtl92cu_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
>  {
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +
>  	if (_rtl92cu_set_media_status(hw, type))
>  		return -EOPNOTSUPP;
> -	_rtl92cu_set_check_bssid(hw, type);
> +
> +	if (rtlpriv->mac80211.link_state == MAC80211_LINKED) {
> +		if (type != NL80211_IFTYPE_AP)
> +			rtl92cu_set_check_bssid(hw, true);
> +	} else {
> +		rtl92cu_set_check_bssid(hw, false);
> +	}
> +
>  	return 0;
>  }
>  
> Index: linux-2.6/drivers/net/wireless/rtlwifi/base.h
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/rtlwifi/base.h
> +++ linux-2.6/drivers/net/wireless/rtlwifi/base.h
> @@ -143,5 +143,8 @@ extern struct attribute_group rtl_attrib
>  int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
>  			 bool isht, u8 desc_rate, bool first_ampdu);
>  bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
> +struct sk_buff *rtl_make_del_ba(struct ieee80211_hw *hw,
> +				u8 *sa, u8 *bssid, u16 tid);
> +void rtl_lps_change_work_callback(struct work_struct *work);
>  
>  #endif
> Index: linux-2.6/drivers/net/wireless/rtlwifi/pci.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/rtlwifi/pci.c
> +++ linux-2.6/drivers/net/wireless/rtlwifi/pci.c
> @@ -939,7 +939,7 @@ static void _rtl_pci_prepare_bcn_tasklet
>  	return;
>  }
>  
> -static void rtl_lps_leave_work_callback(struct work_struct *work)
> +void rtl_lps_leave_work_callback(struct work_struct *work)
>  {
>  	struct rtl_works *rtlworks =
>  	    container_of(work, struct rtl_works, lps_leave_work);


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
