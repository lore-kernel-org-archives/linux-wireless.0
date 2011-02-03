Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1BCK1M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 05:27:12 -0500
Date: Thu, 3 Feb 2011 11:25:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	"'Zhaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 1/8] rtlwifi: Prepare core for addition of USB driver
Message-ID: <20110203102552.GB3516@redhat.com>
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net>
 <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 30, 2011 at 12:11:33PM -0600, Larry.Finger@lwfinger.net wrote:
> +#define	BYTEMASK(len)	(0xffffffff >> ((4 - len) * 8))
Not used.

> +static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
> +					  u16 value, u16 index, void *pdata,
> +					  u16 len, u8 requesttype)
> +{
> +	int rc;
> +	unsigned int pipe;
> +	u8 reqtype;
> +	struct usb_ctrlrequest *dr;
> +	struct urb *urb;
> +	struct rtl819x_async_write_data {
> +		u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
> +		struct usb_ctrlrequest dr;
> +	} *buf;
> +
> +	if (requesttype == VENDOR_READ) {
> +		pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
> +		reqtype =  REALTEK_USB_VENQT_READ;
This is not needed, or function should be named differently not _async_write.

> +	wvalue = (u16)(addr&0x0000ffff);
> +	_usbctrl_vendorreq_sync(udev, request, wvalue, index, data, len,
> +				requesttype);
> +	ret = (le32_to_cpu(*data) & (0xffffffff >> ((4 - len) * 8)));
Ok, BYTEMASK can be used, but what mean this magic? 

> +	ppsc->b_reg_fwctrl_lps = 3;
> +	ppsc->reg_max_lps_awakeintvl = 5;
> +	if (ppsc->b_reg_fwctrl_lps == 1)
> +		ppsc->fwctrl_psmode = FW_PS_MIN_MODE;
> +	else if (ppsc->b_reg_fwctrl_lps == 2)
> +		ppsc->fwctrl_psmode = FW_PS_MAX_MODE;
> +	else if (ppsc->b_reg_fwctrl_lps == 3)
> +		ppsc->fwctrl_psmode = FW_PS_DTIM_MODE;
Need clean up.

> +
> +	 /* IBSS */
> +	 mac->beacon_interval = 100;
> +
> +	 /* AMPDU */
> +	 mac->min_space_cfg = 0;
> +	 mac->max_mss_density = 0;
Spaces.

> +	skb = __dev_alloc_skb((rtlusb->rx_max_size + __RADIO_TAP_SIZE_RSV),
> +			       gfp_mask);
> +	if (!skb) {
> +		RT_TRACE(rtlpriv, COMP_USB, DBG_EMERG,
> +			 ("Failed to __dev_alloc_skb!!\n"))
> +		return (struct sk_buff *)(-ENOMEM);
Use ERR_PTR().

> +static void _rtl_usb_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb,
> +				bool brxagg)
Hungarian notation is prohibited in coding style, for me is
pretty ok for structure fields, but not for local variables.

> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	u8 *rxdesc = skb->data;
> +	struct ieee80211_hdr *hdr;
> +	bool unicast = false;
> +	u16 fc;
> +	struct ieee80211_rx_status rx_status = {0};
> +	struct rtl_stats stats = {
> +		.signal = 0,
> +		.noise = -98,
> +		.rate = 0,
> +	};
> +
> +	skb_pull(skb, RTL_RX_DESC_SIZE);
> +	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
> +	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
> +	hdr = (struct ieee80211_hdr *)(skb->data);
> +	fc = le16_to_cpu(hdr->frame_control);
> +	if (!stats.b_crc) {
Is caller with brxagg == false prepared for stats.b_crc != 0 ?

> +		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
> +
> +		if (is_broadcast_ether_addr(hdr->addr1)) {
> +			/*TODO*/;
> +		} else if (is_multicast_ether_addr(hdr->addr1)) {
> +			/*TODO*/
> +		} else {
> +			unicast = true;
> +			rtlpriv->stats.rxbytesunicast +=  skb->len;
> +		}
> +
> +		rtl_is_special_data(hw, skb, false);
> +
> +		if (ieee80211_is_data(fc)) {
> +			rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
> +
> +			if (unicast)
> +				rtlpriv->link_info.num_rx_inperiod++;
> +		}
> +		if (!brxagg) {
> +			if (likely(rtl_action_proc(hw, skb, false))) {
> +				struct sk_buff *uskb = NULL;
> +				u8 *pdata;
> +
> +				uskb = dev_alloc_skb(skb->len + 128);
> +				memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
> +				       sizeof(rx_status));
> +				pdata = (u8 *)skb_put(uskb, skb->len);
> +				memcpy(pdata, skb->data, skb->len);
> +				dev_kfree_skb_any(skb);
> +				ieee80211_rx_irqsafe(hw, uskb);
> +			} else {
> +				dev_kfree_skb_any(skb);
> +			}
Instead of using rxagg argument, this probably should be done in separate
function.

> +		}
> +	}
> +}
> +
> +static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
> +{
> +	struct sk_buff *_skb;
> +	struct sk_buff_head rx_queue;
> +	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
> +
> +	skb_queue_head_init(&rx_queue);
> +	rtlusb->usb_rx_segregate_hdl(hw, skb, &rx_queue);
usb_rx_segregate_hdl is NULL ...

> +static void _rtl_rx_completed(struct urb *_urb)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)_urb->context;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct rtl_usb *rtlusb = (struct rtl_usb *)info->rate_driver_data[0];
> +	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	int err = 0;
> +
> +	/* TODO: check */
> +	if (unlikely(IS_USB_STOP(rtlusb)))
> +		goto free;
> +
> +	if (likely(0 == _urb->status)) {
> +		/* TODO: Move these code to work queue to improve CPU
> +		 * utilization!  NOTE: We shall allocate another skb
> +		 * and reuse the original one.
> +		 */
> +		skb_put(skb, _urb->actual_length);
> +
> +		if (likely(!rtlusb->usb_rx_segregate_hdl)) {
... and we check against that

> +			/* TO DO */
> +			_rtl_rx_pre_process(hw, skb);
> +			printk(KERN_ERR "====>rx agg not supported yet\n");
"====>" does help someone to understand where is error cause?

> +static int _rtl_usb_receive(struct ieee80211_hw *hw)
> +{
[snip]
> +
> +		usb_anchor_urb(urb, &rtlusb->rx_submitted);
> +		err = usb_submit_urb(urb, GFP_KERNEL);
> +		if (err) {
> +			usb_unanchor_urb(urb);
> +			dev_kfree_skb_any((void *) urb->transfer_buffer);
Unanhor and kfree unneeded ...
> +			goto err_out;
> +		}
> +		usb_free_urb(urb);
> +	}
> +	return 0;
> +
> +err_out:
> +	usb_free_urb(urb);
... as well as this ...
> +
> +	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
... since we will free all resources here.

> +static void _rtl_submit_tx_urb(struct ieee80211_hw *hw, struct urb *_urb)
> +{
> +	int err;
> +	unsigned long flags;
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
> +
> +	usb_anchor_urb(_urb, &rtlusb->tx_submitted);
> +	spin_lock_irqsave(&rtlpriv->locks.tx_urb_lock, flags);
> +	rtlusb->tx_submitted_urbs++;
> +	spin_unlock_irqrestore(&rtlpriv->locks.tx_urb_lock, flags);
Are you using spinlock only to protect tx_submitted_urbs counter?
Use atomic variable instead. Beside this counter seems to be unneeded
at all.

> +static void _rtl_tx_complete(struct urb *urb)
> +{
> +	struct sk_buff *skb = (struct sk_buff *)urb->context;
> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
> +	struct rtl_usb *rtlusb = (struct rtl_usb *)info->rate_driver_data[0];
> +	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);	int err;
Do not hide variables :-)

> +			     IEEE80211_SCTL_SEQ) >> 4;
> +		seq_number += 1;
> +		seq_number = seq_number<<4;
seq_number <<= 4;

> +int __devinit rtl_usb_probe(struct usb_interface *intf,
> +			const struct usb_device_id *id)
> +{
> +	int err;
> +	struct ieee80211_hw *hw = NULL;
> +	struct rtl_priv *rtlpriv = NULL;
> +	struct usb_device	*udev;
> +	struct rtl_usb_priv *usb_priv;
> +
> +	hw = ieee80211_alloc_hw(sizeof(struct rtl_priv) +
> +				sizeof(struct rtl_usb_priv), &rtl_ops);
> +	if (!hw) {
> +		RT_ASSERT(false, ("%s : ieee80211 alloc failed\n", __func__));
> +		return -ENOMEM;
> +	}
> +	rtlpriv = hw->priv;
> +	memset(rtlpriv, 0, sizeof(*rtlpriv));
We use kzalloc for allocate, memset is not needed.
