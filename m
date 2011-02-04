Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:46247 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1BDEPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Feb 2011 23:15:44 -0500
Received: by yib18 with SMTP id 18so780523yib.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 Feb 2011 20:15:44 -0800 (PST)
Message-ID: <4D4B7D92.7000402@lwfinger.net>
Date: Thu, 03 Feb 2011 22:16:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	'Zhaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 1/8] rtlwifi: Prepare core for addition of USB driver
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net> <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net> <20110203102552.GB3516@redhat.com>
In-Reply-To: <20110203102552.GB3516@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stanislaw,

Thank you for the thorough review. As noted below, I have some questions:

On 02/03/2011 04:25 AM, Stanislaw Gruszka wrote:

>> +static int _usbctrl_vendorreq_async_write(struct usb_device *udev, u8 request,
>> +					  u16 value, u16 index, void *pdata,
>> +					  u16 len, u8 requesttype)
>> +{
>> +	int rc;
>> +	unsigned int pipe;
>> +	u8 reqtype;
>> +	struct usb_ctrlrequest *dr;
>> +	struct urb *urb;
>> +	struct rtl819x_async_write_data {
>> +		u8 data[REALTEK_USB_VENQT_MAX_BUF_SIZE];
>> +		struct usb_ctrlrequest dr;
>> +	} *buf;
>> +
>> +	if (requesttype == VENDOR_READ) {
>> +		pipe = usb_rcvctrlpipe(udev, 0); /* read_in */
>> +		reqtype =  REALTEK_USB_VENQT_READ;
> This is not needed, or function should be named differently not _async_write.

This one I do not understand. The function does do an asynchronous write. Please
explain.

>> +	wvalue = (u16)(addr&0x0000ffff);
>> +	_usbctrl_vendorreq_sync(udev, request, wvalue, index, data, len,
>> +				requesttype);
>> +	ret = (le32_to_cpu(*data) & (0xffffffff >> ((4 - len) * 8)));
> Ok, BYTEMASK can be used, but what mean this magic? 

As the output of this routine is always cast with (u8) when len is 1 and (u16)
when len is 2, I think the magic can just disappear and ret can simply be

	ret = le32_to_cpu(*data);

I will test and have contacted the original author. There is similar magic in
_usb_write_async() that can also disappear.

>> +
>> +	 /* IBSS */
>> +	 mac->beacon_interval = 100;
>> +
>> +	 /* AMPDU */
>> +	 mac->min_space_cfg = 0;
>> +	 mac->max_mss_density = 0;
> Spaces.

Please explain what you mean by "spaces".

>> +static void _rtl_usb_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb,
>> +				bool brxagg)
> Hungarian notation is prohibited in coding style, for me is
> pretty ok for structure fields, but not for local variables.
> 
>> +{
>> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
>> +	u8 *rxdesc = skb->data;
>> +	struct ieee80211_hdr *hdr;
>> +	bool unicast = false;
>> +	u16 fc;
>> +	struct ieee80211_rx_status rx_status = {0};
>> +	struct rtl_stats stats = {
>> +		.signal = 0,
>> +		.noise = -98,
>> +		.rate = 0,
>> +	};
>> +
>> +	skb_pull(skb, RTL_RX_DESC_SIZE);
>> +	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
>> +	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
>> +	hdr = (struct ieee80211_hdr *)(skb->data);
>> +	fc = le16_to_cpu(hdr->frame_control);
>> +	if (!stats.b_crc) {
> Is caller with brxagg == false prepared for stats.b_crc != 0 ?

As far as I can tell, the answer is yes, but will keep your question in mind.

>> +		memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
>> +
>> +		if (is_broadcast_ether_addr(hdr->addr1)) {
>> +			/*TODO*/;
>> +		} else if (is_multicast_ether_addr(hdr->addr1)) {
>> +			/*TODO*/
>> +		} else {
>> +			unicast = true;
>> +			rtlpriv->stats.rxbytesunicast +=  skb->len;
>> +		}
>> +
>> +		rtl_is_special_data(hw, skb, false);
>> +
>> +		if (ieee80211_is_data(fc)) {
>> +			rtlpriv->cfg->ops->led_control(hw, LED_CTL_RX);
>> +
>> +			if (unicast)
>> +				rtlpriv->link_info.num_rx_inperiod++;
>> +		}
>> +		if (!brxagg) {
>> +			if (likely(rtl_action_proc(hw, skb, false))) {
>> +				struct sk_buff *uskb = NULL;
>> +				u8 *pdata;
>> +
>> +				uskb = dev_alloc_skb(skb->len + 128);
>> +				memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
>> +				       sizeof(rx_status));
>> +				pdata = (u8 *)skb_put(uskb, skb->len);
>> +				memcpy(pdata, skb->data, skb->len);
>> +				dev_kfree_skb_any(skb);
>> +				ieee80211_rx_irqsafe(hw, uskb);
>> +			} else {
>> +				dev_kfree_skb_any(skb);
>> +			}
> Instead of using rxagg argument, this probably should be done in separate
> function.

Good suggestion. I will do that.

>> +		}
>> +	}
>> +}
>> +
>> +static void _rtl_rx_pre_process(struct ieee80211_hw *hw, struct sk_buff *skb)
>> +{
>> +	struct sk_buff *_skb;
>> +	struct sk_buff_head rx_queue;
>> +	struct rtl_usb *rtlusb = rtl_usbdev(rtl_usbpriv(hw));
>> +
>> +	skb_queue_head_init(&rx_queue);
>> +	rtlusb->usb_rx_segregate_hdl(hw, skb, &rx_queue);
> usb_rx_segregate_hdl is NULL ...

A check has been added. A future USB-based driver may not impose that condition.
> 
>> +static void _rtl_rx_completed(struct urb *_urb)
>> +{
>> +	struct sk_buff *skb = (struct sk_buff *)_urb->context;
>> +	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
>> +	struct rtl_usb *rtlusb = (struct rtl_usb *)info->rate_driver_data[0];
>> +	struct ieee80211_hw *hw = usb_get_intfdata(rtlusb->intf);
>> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
>> +	int err = 0;
>> +
>> +	/* TODO: check */
>> +	if (unlikely(IS_USB_STOP(rtlusb)))
>> +		goto free;
>> +
>> +	if (likely(0 == _urb->status)) {
>> +		/* TODO: Move these code to work queue to improve CPU
>> +		 * utilization!  NOTE: We shall allocate another skb
>> +		 * and reuse the original one.
>> +		 */
>> +		skb_put(skb, _urb->actual_length);
>> +
>> +		if (likely(!rtlusb->usb_rx_segregate_hdl)) {
> ... and we check against that

All other suggestions have been adopted.

Thanks again,

Larry
