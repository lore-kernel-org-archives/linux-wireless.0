Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:35038 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933779AbXCZXnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 19:43:47 -0400
Date: Mon, 26 Mar 2007 16:43:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [patch 5/5] IEEE 802.11n management action frame handling
Message-Id: <20070326164321.6f4cd9b2.randy.dunlap@oracle.com>
In-Reply-To: <1174909425.1364.63.camel@dell-4965.jf.intel.com>
References: <1174909425.1364.63.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Mar 2007 04:43:45 -0700 mohamed wrote:

> add draft IEEE 802.11n management action frame handling
> 
> Several Action frame format are defined to support IEEE 802.11n
> features. 
> This patch adds support to parse Block Ack action frame, then call 
> low level driver with the frame's body.
> 
> Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
> 
> diff -Nupr wireless-dev/net/mac80211/ieee80211_sta.c
> wireless-dev-new/net/mac80211/ieee80211_sta.c
> --- wireless-dev/net/mac80211/ieee80211_sta.c	2007-03-27
> 01:34:54.000000000 -0700
> +++ wireless-dev-new/net/mac80211/ieee80211_sta.c	2007-03-27
> 02:02:58.000000000 -0700
> @@ -1818,6 +1818,92 @@ static void ieee80211_rx_mgmt_probe_req(
>  	ieee80211_sta_tx(dev, skb, 0);
>  }
>  
> +static void ieee80211_send_addba_resp(struct net_device *dev,
> +				      struct ieee80211_mgmt *mgmt_src,
> +				      size_t len,
> +				      u16 status)
> +{
> +	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
> +        struct ieee80211_if_sta *ifsta = &sdata->u.sta;

Use tab above for indent.

> +	struct sk_buff *skb;
> +	struct ieee80211_mgmt *mgmt;
> +
> +	skb = dev_alloc_skb(sizeof(*mgmt) + 50 );

No space between 50 and ')'.

> +	if (!skb) {
> +		printk(KERN_DEBUG "%s: failed to allocate buffer "
> +					"for addts frame\n", dev->name);
> +		return;
> +	}
> +
> +	mgmt = (struct ieee80211_mgmt *) skb_put(skb, 24);
> +	memset(mgmt, 0, 24);
> +	memcpy(mgmt->da, ifsta->bssid, ETH_ALEN);
> +	memcpy(mgmt->sa, dev->dev_addr, ETH_ALEN);
> +	memcpy(mgmt->bssid, ifsta->bssid, ETH_ALEN);
> +	mgmt->frame_control = IEEE80211_FC(IEEE80211_FTYPE_MGMT,
> +					IEEE80211_STYPE_ACTION);
> +
> +	skb_put(skb, 1 + sizeof(mgmt->u.action.u.addba_resp));
> +	mgmt->u.action.category = WLAN_CATEGORY_BACK;
> +	mgmt->u.action.u.addba_resp.action_code = WLAN_ACTION_ADDBA_RESP;
> +	mgmt->u.action.u.addba_resp.dialog_token =
> +		mgmt_src->u.action.u.addba_req.dialog_token;
> +	mgmt->u.action.u.addba_resp.capab =
> +		mgmt_src->u.action.u.addba_req.capab;
> +	mgmt->u.action.u.addba_resp.timeout =
> +		mgmt_src->u.action.u.addba_req.timeout;
> +	mgmt->u.action.u.addba_resp.status = cpu_to_le16(status);
> +
> +	ieee80211_sta_tx(dev, skb, 0);
> +	
> +	return;
> +}
> +static void ieee80211_rx_mgmt_action(struct net_device *dev,
> +				     struct ieee80211_if_sta *ifsta,
> +				     struct ieee80211_mgmt *mgmt,
> +				     size_t len)
> +{
> +	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
> +
> +	if (len < 24 + 1) {
> +		printk(KERN_DEBUG "%s: too short (%zd) action frame "
> +			"received from " MAC_FMT " - ignored\n",
> +			dev->name, len, MAC_ARG(mgmt->sa));
> +		return;
> +	}
> +
> +	switch (mgmt->u.action.category) {
> +	case WLAN_CATEGORY_BACK:
> +		switch (mgmt->u.action.u.addba_req.action_code) {
> +		case WLAN_ACTION_ADDBA_REQ:
> +			if (!local->ops->handle_ba_action || 
> +			    (local->ops->handle_ba_action(local_to_hw(local),
> +						      mgmt)))
> +				ieee80211_send_addba_resp(dev, mgmt, len,
> +						WLAN_STATUS_REQUEST_DECLINED);
> +			else
> +				ieee80211_send_addba_resp(dev, mgmt, len,
> +							WLAN_STATUS_SUCCESS);
> +			break;
> +		case WLAN_ACTION_ADDBA_RESP:
> +		case WLAN_ACTION_DELBA:
> +			 if (local->ops->handle_ba_action)
> +				local->ops->handle_ba_action(
> +						local_to_hw(local), mgmt);
> +			break;
> +		default:
> +			printk(KERN_ERR "%s: recieved back unsupported \n",

                                             received
				and maybe s/back/BACK/ ?

			I think that "back" there will be meaningless
			to lots of people.

> +								dev->name);
> +			break;
> +		}
> +		break;
> +
> +	default:
> +		printk(KERN_ERR "%s: unsupported action category %d\n",
> +			dev->name, mgmt->u.action.category);
> +		break;
> +	}
> +}
>  
>  void ieee80211_sta_rx_mgmt(struct net_device *dev, struct sk_buff *skb,
>  			   struct ieee80211_rx_status *rx_status)


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
