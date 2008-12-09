Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:48472 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYLITGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 14:06:07 -0500
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] rtl8187: Use usb anchor facilities to manage urbs
Date: Tue, 9 Dec 2008 17:06:18 -0200
Cc: John W Linville <linville@tuxdriver.com>,
	"Hin-Tak Leung" <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
References: <493e9dd9.dZux2YPGwepU1RUb%Larry.Finger@lwfinger.net>
In-Reply-To: <493e9dd9.dZux2YPGwepU1RUb%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200812091706.19994.herton@mandriva.com.br> (sfid-20081209_200612_691293_68AAA1F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Ter=E7a 09 Dezembro 2008, =E0s 14:33:29, Larry Finger escreveu:
> When SLUB debugging is enabled in the kernel, and the boot command in=
cludes
> the option "slub_debug=3DP", rtl8187 encounters a GPF due to a
> read-after-free of a urb.
>
> Following the example of changes in p54usb to fix the same problem, t=
he
> code has been modified to use the usb_anchor_urb() method. With this
> change, the USB core handles the freeing of urb's.
>
> This patch fixes the problem reported in Kernel Bugzilla #12185
> (http://bugzilla.kernel.org/show_bug.cgi?id=3D12185).
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>
> ---
>
> John,
>
> This problem has been in rtl8187 since its inclusion in mainline. As =
such,
> it probably doesn't matter when if gets included - 2.6.29 would be be=
st,
> but if you would prefer more testing, then 2.6.30 is OK. It does take
> special settings to trigger it.
>
> The relocation of the files for this driver to the
> drivers/net/wireless/rtl818x directory means that backporting this fi=
x to
> stable would require a different patch and is probably not worth the
> effort, but I'll leave that call to you.
>
> Larry
> ---

Hi, I looked at the patch and also the discussion on LKML about the p54=
usb,=20
just reading the patch now spotted some minor things, see below. Otherw=
ise=20
everything else looks fine.

>
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187.h
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187.h
> @@ -99,6 +99,7 @@ struct rtl8187_priv {
>  	struct ieee80211_supported_band band;
>  	struct usb_device *udev;
>  	u32 rx_conf;
> +	struct usb_anchor anchored;
>  	u16 txpwr_base;
>  	u8 asic_rev;
>  	u8 is_rtl8187b;
> @@ -115,7 +116,6 @@ struct rtl8187_priv {
>  	u8 aifsn[4];
>  	struct {
>  		__le64 buf;
> -		struct urb *urb;
>  		struct sk_buff_head queue;
>  	} b_tx_status;
>  };
> Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187_dev.c
> +++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187_dev.c
> @@ -99,7 +99,6 @@ static const struct ieee80211_channel rt
>  static void rtl8187_iowrite_async_cb(struct urb *urb)
>  {
>  	kfree(urb->context);
> -	usb_free_urb(urb);
>  }
>
>  static void rtl8187_iowrite_async(struct rtl8187_priv *priv, __le16 =
addr,
> @@ -136,11 +135,13 @@ static void rtl8187_iowrite_async(struct
>  	usb_fill_control_urb(urb, priv->udev, usb_sndctrlpipe(priv->udev, 0=
),
>  			     (unsigned char *)dr, buf, len,
>  			     rtl8187_iowrite_async_cb, buf);
> +	usb_anchor_urb(urb, &priv->anchored);
>  	rc =3D usb_submit_urb(urb, GFP_ATOMIC);
>  	if (rc < 0) {
>  		kfree(buf);
> -		usb_free_urb(urb);
> +		usb_unanchor_urb(urb);
>  	}
> +	usb_free_urb(urb);
>  }
>
>  static inline void rtl818x_iowrite32_async(struct rtl8187_priv *priv=
,
> @@ -172,7 +173,6 @@ static void rtl8187_tx_cb(struct urb *ur
>  	struct ieee80211_hw *hw =3D info->rate_driver_data[0];
>  	struct rtl8187_priv *priv =3D hw->priv;
>
> -	usb_free_urb(info->rate_driver_data[1]);
>  	skb_pull(skb, priv->is_rtl8187b ? sizeof(struct rtl8187b_tx_hdr) :
>  					  sizeof(struct rtl8187_tx_hdr));
>  	ieee80211_tx_info_clear_status(info);
> @@ -273,11 +273,13 @@ static int rtl8187_tx(struct ieee80211_h
>
>  	usb_fill_bulk_urb(urb, priv->udev, usb_sndbulkpipe(priv->udev, ep),
>  			  buf, skb->len, rtl8187_tx_cb, skb);
> +	usb_anchor_urb(urb, &priv->anchored);
>  	rc =3D usb_submit_urb(urb, GFP_ATOMIC);
>  	if (rc < 0) {
> -		usb_free_urb(urb);
> +		usb_unanchor_urb(urb);
>  		kfree_skb(skb);
>  	}
> +	usb_free_urb(urb);
>
>  	return 0;
>  }
> @@ -301,14 +303,13 @@ static void rtl8187_rx_cb(struct urb *ur
>  		return;
>  	}
>  	spin_unlock(&priv->rx_queue.lock);
> +	skb_put(skb, urb->actual_length);
>
>  	if (unlikely(urb->status)) {
> -		usb_free_urb(urb);
>  		dev_kfree_skb_irq(skb);
>  		return;
>  	}
>
> -	skb_put(skb, urb->actual_length);
>  	if (!priv->is_rtl8187b) {
>  		struct rtl8187_rx_hdr *hdr =3D
>  			(typeof(hdr))(skb_tail_pointer(skb) - sizeof(*hdr));
> @@ -361,7 +362,6 @@ static void rtl8187_rx_cb(struct urb *ur
>
>  	skb =3D dev_alloc_skb(RTL8187_MAX_RX);
>  	if (unlikely(!skb)) {
> -		usb_free_urb(urb);
>  		/* TODO check rx queue length and refill *somewhere* */
>  		return;
>  	}

May be remove { } ? Probably checkpatch.pl didn't spot this because of =
the=20
comment using one line, but if it's allowed to keep {} in this case bec=
ause of=20
the comment no problem.

> @@ -373,24 +373,30 @@ static void rtl8187_rx_cb(struct urb *ur
>  	urb->context =3D skb;
>  	skb_queue_tail(&priv->rx_queue, skb);
>
> -	usb_submit_urb(urb, GFP_ATOMIC);
> +	usb_anchor_urb(urb, &priv->anchored);
> +	if (usb_submit_urb(urb, GFP_ATOMIC))
> +		usb_unanchor_urb(urb);

may be we should also skb_unlink and dev_kfree_skb_irq skb here like on=
=20
p54usb? although it should be freed anyway later on rtl8187_stop

>  }
>
>  static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>  {
>  	struct rtl8187_priv *priv =3D dev->priv;
> -	struct urb *entry;
> +	struct urb *entry =3D NULL;
>  	struct sk_buff *skb;
>  	struct rtl8187_rx_info *info;
> +	int ret =3D 0;
>
>  	while (skb_queue_len(&priv->rx_queue) < 8) {
>  		skb =3D __dev_alloc_skb(RTL8187_MAX_RX, GFP_KERNEL);
> -		if (!skb)
> -			break;
> +		if (!skb) {
> +			ret =3D -ENOMEM;
> +			goto err;
> +		}
>  		entry =3D usb_alloc_urb(0, GFP_KERNEL);
>  		if (!entry) {
>  			kfree_skb(skb);

kfree_skb is also called after err: too now.

> -			break;
> +			ret =3D -ENOMEM;
> +			goto err;
>  		}
>  		usb_fill_bulk_urb(entry, priv->udev,
>  				  usb_rcvbulkpipe(priv->udev,
> @@ -401,10 +407,22 @@ static int rtl8187_init_urbs(struct ieee
>  		info->urb =3D entry;
>  		info->dev =3D dev;
>  		skb_queue_tail(&priv->rx_queue, skb);
> -		usb_submit_urb(entry, GFP_KERNEL);
> +		usb_anchor_urb(entry, &priv->anchored);
> +		ret =3D usb_submit_urb(entry, GFP_KERNEL);
> +		if (ret) {
> +			skb_unlink(skb, &priv->rx_queue);
> +			usb_unanchor_urb(entry);
> +			goto err;
> +		}
> +		usb_free_urb(entry);
>  	}
> +	return ret;
>
> -	return 0;
> +err:
> +	usb_free_urb(entry);
> +	kfree_skb(skb);
> +	usb_kill_anchored_urbs(&priv->anchored);
> +	return ret;
>  }
>
>  static void rtl8187b_status_cb(struct urb *urb)
> @@ -415,7 +433,6 @@ static void rtl8187b_status_cb(struct ur
>  	unsigned int cmd_type;
>
>  	if (unlikely(urb->status)) {
> -		usb_free_urb(urb);
>  		return;
>  	}

remove { }

>
> @@ -488,26 +505,32 @@ static void rtl8187b_status_cb(struct ur
>  		spin_unlock_irqrestore(&priv->b_tx_status.queue.lock, flags);
>  	}
>
> -	usb_submit_urb(urb, GFP_ATOMIC);
> +	usb_anchor_urb(urb, &priv->anchored);
> +	if (usb_submit_urb(urb, GFP_ATOMIC))
> +		usb_unanchor_urb(urb);
>  }
>
>  static int rtl8187b_init_status_urb(struct ieee80211_hw *dev)
>  {
>  	struct rtl8187_priv *priv =3D dev->priv;
>  	struct urb *entry;
> +	int ret =3D 0;
>
>  	entry =3D usb_alloc_urb(0, GFP_KERNEL);
>  	if (!entry)
>  		return -ENOMEM;
> -	priv->b_tx_status.urb =3D entry;
>
>  	usb_fill_bulk_urb(entry, priv->udev, usb_rcvbulkpipe(priv->udev, 9)=
,
>  			  &priv->b_tx_status.buf, sizeof(priv->b_tx_status.buf),
>  			  rtl8187b_status_cb, dev);
>
> -	usb_submit_urb(entry, GFP_KERNEL);
> +	usb_anchor_urb(entry, &priv->anchored);
> +	ret =3D usb_submit_urb(entry, GFP_KERNEL);
> +	if (ret)
> +		usb_unanchor_urb(entry);
> +	usb_free_urb(entry);
>
> -	return 0;
> +	return ret;
>  }
>
>  static int rtl8187_cmd_reset(struct ieee80211_hw *dev)
> @@ -841,6 +864,9 @@ static int rtl8187_start(struct ieee8021
>  		return ret;
>
>  	mutex_lock(&priv->conf_mutex);
> +
> +	init_usb_anchor(&priv->anchored);
> +
>  	if (priv->is_rtl8187b) {
>  		reg =3D RTL818X_RX_CONF_MGMT |
>  		      RTL818X_RX_CONF_DATA |
> @@ -936,12 +962,12 @@ static void rtl8187_stop(struct ieee8021
>
>  	while ((skb =3D skb_dequeue(&priv->rx_queue))) {
>  		info =3D (struct rtl8187_rx_info *)skb->cb;
> -		usb_kill_urb(info->urb);
>  		kfree_skb(skb);
>  	}
>  	while ((skb =3D skb_dequeue(&priv->b_tx_status.queue)))
>  		dev_kfree_skb_any(skb);
> -	usb_kill_urb(priv->b_tx_status.urb);
> +
> +	usb_kill_anchored_urbs(&priv->anchored);
>  	mutex_unlock(&priv->conf_mutex);
>  }

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
