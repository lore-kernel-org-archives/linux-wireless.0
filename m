Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:30107 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbYDIGbq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 02:31:46 -0400
Subject: Re: [PATCH] Add Realtek 8187B support
From: Pavel Roskin <proski@gnu.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804081931.07638.herton@mandriva.com.br>
References: <200804081931.07638.herton@mandriva.com.br>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 02:31:40 -0400
Message-Id: <1207722700.8539.80.camel@rd> (sfid-20080409_073207_310208_C1A5367E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-08 at 19:31 -0300, Herton Ronaldo Krzesinski wrote:

P.S. More stuff as I'm going through the patch.  Sorry, I had to post
the first reply quickly to disavow my Signed-off-by.

> Also I fixed a bug of a missing "priv->vif = vif" in rtl8187_config_interface
> that makes kernel oops in transmit code in ieee80211_generic_frame_duration
> function.

This should be a separate patch.  In the kernel, it's very important to
be able to pinpoint which change broke things.  And git is well suited
for working with multiple patches (my personal preference is StGIT,
which is not just suited for that - it's the main thing StGIT does).

> diff --git a/drivers/net/wireless/rtl8180_rtl8225.c b/drivers/net/wireless/rtl8180_rtl8225.c
> index cd22781..b4c6ae0 100644
> --- a/drivers/net/wireless/rtl8180_rtl8225.c
> +++ b/drivers/net/wireless/rtl8180_rtl8225.c
> @@ -718,10 +718,7 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
>  	struct rtl8180_priv *priv = dev->priv;
>  	int chan = ieee80211_frequency_to_channel(conf->channel->center_freq);
>  
> -	if (priv->rf->init == rtl8225_rf_init)
> -		rtl8225_rf_set_tx_power(dev, chan);
> -	else
> -		rtl8225z2_rf_set_tx_power(dev, chan);
> +	priv->rf->set_txpwr(dev, chan);

It seems to me it's unrelated to rtl8187b support.  You are doing some
unrelated refactoring here, which could be done in a separate patch.

> -	.set_chan	= rtl8225_rf_set_channel
> +	.set_chan	= rtl8225_rf_set_channel,
> +	.set_txpwr	= rtl8225_rf_set_tx_power

Same thing here.  If you need extra infrastructure, add it in one patch
and leave hardware support for another.

> +struct rtl8187b_rx_hdr {
> +	__le32 flags;
> +	__le64 mac_time;
> +	u8 noise;
> +	u8 signal;
> +	u8 agc;
> +	u8 reserved;
> +	__le32 unused;
> +} __attribute__((packed));

I know, you are copying parts from the rtl8187 header.  But looking at
the vendor driver, "reserved" and "unused" are better described.  Nobody
would guess it by looking at this header.  It would be great if you at
least give a hint that the vendor driver describes the structure of
those fields.  That should be a separate patch, of course.

> +struct rtl8187b_tx_hdr {
> +	__le32 flags;
> +	__le16 rts_duration;
> +	__le16 len;
> +	__le32 unused_1;
> +	__le16 unused_2;
> +	__le16 tx_duration;
> +	__le32 unused_3;
> +	__le32 retry;
> +	__le32 unused_4[2];
> +} __attribute__((packed));

Those are indeed "unused in" the vendor driver.

> +#define DEVICE_RTL8187	0
> +#define DEVICE_RTL8187B	1

I prefer enums here, but I don't feel strongly about it.

>  struct rtl8187_priv {
>  	/* common between rtl818x drivers */
>  	struct rtl818x_csr *map;
> @@ -76,70 +103,100 @@ struct rtl8187_priv {
>  	u32 rx_conf;
>  	u16 txpwr_base;
>  	u8 asic_rev;
> +	u8 is_rtl8187b;
> +	enum {
> +		RTL8187BvB,
> +		RTL8187BvD,
> +		RTL8187BvE
> +	} hw_rev;

Or maybe we could have one enum here, and use (hw_rev > DEVICE_RTL8187)
instead of is_rtl8187b.  Maybe there will be future revisions that
change something else.  The standard approaches are flags that are ORed
or enums that are compared.  is_something doesn't scale well.
 
> -static inline u8 rtl818x_ioread8(struct rtl8187_priv *priv, u8 *addr)
> +static inline u8 rtl818x_ioread8_idx(struct rtl8187_priv *priv,
> +				     u8 *addr, u8 idx)
>  {
>  	u8 val;
>  
>  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
>  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
> -			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
> +			(unsigned long)addr, idx & 0x03, &val,
> +			sizeof(val), HZ / 2);

As I said, "addr" should not be a pointer.  In fact, the fifth argument
is __u16.  There is no way a valid pointer can even be passed to
usb_control_msg() without truncating it.  Make it __u16 and remove all
casts unless they are needed and you know why.

> -static inline u16 rtl818x_ioread16(struct rtl8187_priv *priv, __le16 *addr)
> +#define rtl818x_ioread8(priv, addr) rtl818x_ioread8_idx(priv, addr, 0)

Inline functions are preferred for that.

> +static inline u16 rtl818x_ioread16_idx(struct rtl8187_priv *priv,
> +				       __le16 *addr, u8 idx)
>  {
>  	__le16 val;
>  
>  	usb_control_msg(priv->udev, usb_rcvctrlpipe(priv->udev, 0),
>  			RTL8187_REQ_GET_REG, RTL8187_REQT_READ,
> -			(unsigned long)addr, 0, &val, sizeof(val), HZ / 2);
> +			(unsigned long)addr, idx & 0x03, &val,
> +			sizeof(val), HZ / 2);

More of the same stuff.
 
>  static struct usb_device_id rtl8187_table[] __devinitdata = {
> -	/* Realtek */
> -	{USB_DEVICE(0x0bda, 0x8187)},
> +	/* Realtek 8187 */
> +	{USB_DEVICE(0x0bda, 0x8187), .driver_info = DEVICE_RTL8187},

You are mixing to things in the comment.  DEVICE_RTL8187 already
indicates that it's 8187.  Better keep Realtek devices together, and
leave the details to the code.

> -	hdr = (struct rtl8187_tx_hdr *)skb_push(skb, sizeof(*hdr));
> -	hdr->flags = cpu_to_le32(flags);
> -	hdr->len = 0;
> -	hdr->rts_duration = rts_dur;
> -	hdr->retry = cpu_to_le32(control->retry_limit << 8);
> +	if (!priv->is_rtl8187b) {

I would explore the possibility of splitting the hardware specific parts
of rtl8187_tx() into two separate functions.

> @@ -240,11 +264,25 @@ static void rtl8187_rx_cb(struct urb *urb)

And the same on the rx side.  gcc is good at inlining static functions
that are used once.

> +		rx_status.mactime = le64_to_cpu(hdr_b->mac_time);

Careful here!  mac_time is not size-aligned in rtl8187b_rx_hdr.  I would
ask our alignment gurus it it's OK.

> -static int rtl8187_init_hw(struct ieee80211_hw *dev)
> +static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
>  {
>  	struct rtl8187_priv *priv = dev->priv;
>  	u8 reg;
>  	int i;

It seems to me that there is too much in common between those functions.
Please consider refactoring.  I would also suggest that you submit it
separately.

Skipping lots of stuff for a later review, as it's getting late, and the
end it far away.  I hope you got the idea.

>  	u8	reserved_19[3];
> +	__le16	INT_MIG;
> +#define RTL818X_R8187B_B	0
> +#define RTL818X_R8187B_D	1
> +#define RTL818X_R8187B_E	2

You are inconsistent here.  You were using an enum in another structure
essentially for the same thing.

-- 
Regards,
Pavel Roskin
