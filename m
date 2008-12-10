Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:50762 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754575AbYLJDGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 22:06:37 -0500
Message-ID: <493F323A.2000609@lwfinger.net> (sfid-20081210_040642_350102_CF3AA768)
Date: Tue, 09 Dec 2008 21:06:34 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: John W Linville <linville@tuxdriver.com>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Use usb anchor facilities to manage urbs
References: <493e9dd9.dZux2YPGwepU1RUb%Larry.Finger@lwfinger.net> <200812091706.19994.herton@mandriva.com.br>
In-Reply-To: <200812091706.19994.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Ter=E7a 09 Dezembro 2008, =E0s 14:33:29, Larry Finger escreveu:
>=20
> Hi, I looked at the patch and also the discussion on LKML about the p=
54usb,=20
> just reading the patch now spotted some minor things, see below. Othe=
rwise=20
> everything else looks fine.

--snip--

>>  	if (unlikely(!skb)) {
>> -		usb_free_urb(urb);
>>  		/* TODO check rx queue length and refill *somewhere* */
>>  		return;
>>  	}
>=20
> May be remove { } ? Probably checkpatch.pl didn't spot this because o=
f the=20
> comment using one line, but if it's allowed to keep {} in this case b=
ecause of=20
> the comment no problem.

I don't know what policy is for this, but I removed the {} even though
checkpatch didn't flag it.

>> @@ -373,24 +373,30 @@ static void rtl8187_rx_cb(struct urb *ur
>>  	urb->context =3D skb;
>>  	skb_queue_tail(&priv->rx_queue, skb);
>>
>> -	usb_submit_urb(urb, GFP_ATOMIC);
>> +	usb_anchor_urb(urb, &priv->anchored);
>> +	if (usb_submit_urb(urb, GFP_ATOMIC))
>> +		usb_unanchor_urb(urb);
>=20
> may be we should also skb_unlink and dev_kfree_skb_irq skb here like =
on=20
> p54usb? although it should be freed anyway later on rtl8187_stop

Done. I think the whole error return philosophy in rtl8187 needs some c=
hecking.
There are a number of routines, such as this one, that detect an error =
but never
report it anywhere. That seems wrong.

>>  }
>>
>>  static int rtl8187_init_urbs(struct ieee80211_hw *dev)
>>  {
>>  	struct rtl8187_priv *priv =3D dev->priv;
>> -	struct urb *entry;
>> +	struct urb *entry =3D NULL;
>>  	struct sk_buff *skb;
>>  	struct rtl8187_rx_info *info;
>> +	int ret =3D 0;
>>
>>  	while (skb_queue_len(&priv->rx_queue) < 8) {
>>  		skb =3D __dev_alloc_skb(RTL8187_MAX_RX, GFP_KERNEL);
>> -		if (!skb)
>> -			break;
>> +		if (!skb) {
>> +			ret =3D -ENOMEM;
>> +			goto err;
>> +		}
>>  		entry =3D usb_alloc_urb(0, GFP_KERNEL);
>>  		if (!entry) {
>>  			kfree_skb(skb);
>=20
> kfree_skb is also called after err: too now.

=46ixed.

>> -			break;
>> +			ret =3D -ENOMEM;
>> +			goto err;
>>  		}

--snip--

>> @@ -415,7 +433,6 @@ static void rtl8187b_status_cb(struct ur
>>  	unsigned int cmd_type;
>>
>>  	if (unlikely(urb->status)) {
>> -		usb_free_urb(urb);
>>  		return;
>>  	}
>=20
> remove { }

Done. I wonder why checkpatch didn't complain here. I guess it doesn't =
handle
the case where the patch changes a 2-line if clause into a one-liner.

Thanks for the review.

Larry

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
