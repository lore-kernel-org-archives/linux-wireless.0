Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37986 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998AbaFEMdM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2014 08:33:12 -0400
Message-ID: <1401971576.4168.3.camel@jlt4.sipsolutions.net> (sfid-20140605_143317_893264_44102B74)
Subject: Re: [RFC] mac80211: at76x50x_usb driver broken by commit 3afc216..
 and RX path involved in scan
From: Johannes Berg <johannes@sipsolutions.net>
To: andrea.merello@gmail.com
Cc: emmanuel.grumbach@intel.com,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	joerg.albert@gmx.de, Alex Stewart <alex@foogod.com>,
	n0_5p4m_p13453@hotmail.com, Pavel Roskin <proski@gnu.org>,
	agx@sigxcpu.org, Kalle Valo <kalle.valo@iki.fi>, sesmo@gmx.net,
	John Linville <linville@tuxdriver.com>
Date: Thu, 05 Jun 2014 14:32:56 +0200
In-Reply-To: <CAN8YU5NVmAMQ06oJ2Urze7=m4XNUox4-QmYbE1ozoRTFOEY0=g@mail.gmail.com> (sfid-20140604_230243_516417_A2A8F6A0)
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
	 <1400509775.4273.8.camel@jlt4.sipsolutions.net>
	 <1400510950.4273.9.camel@jlt4.sipsolutions.net>
	 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
	 <1400515344.4273.19.camel@jlt4.sipsolutions.net>
	 <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
	 <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com>
	 <1401285737.8146.21.camel@jlt4.sipsolutions.net>
	 <CAN8YU5Mxxqs1H4caXQ_tS0Sq5YKwk9NatgSqWferCqBu_+jnyQ@mail.gmail.com>
	 <1401825462.4157.42.camel@jlt4.sipsolutions.net>
	 <CAN8YU5NVmAMQ06oJ2Urze7=m4XNUox4-QmYbE1ozoRTFOEY0=g@mail.gmail.com>
	 (sfid-20140604_230243_516417_A2A8F6A0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> So this is the updated patch.
> If you agree, we could push it for merge :)

Yeah, looks fine. Minor code style comments below:

> +static inline int at76_guess_freq(struct at76_priv *priv)
> +{
> +    size_t el_off;

should have tabs for indentation

> +    const u8 *el;
> +    int channel = priv->channel;
> +    int len = priv->rx_skb->len;
> +    struct ieee80211_hdr *hdr = (void *)priv->rx_skb->data;
> +
> +    if (!priv->scanning)
> +        goto exit;
> +
> +    if (len < 24)
> +        goto exit;
> +
> +    if (ieee80211_is_probe_resp(hdr->frame_control)) {
> +        el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
> +        el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
> +    } else if (ieee80211_is_beacon(hdr->frame_control)) {
> +        el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
> +        el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
> +    } else
> +        goto exit;

should have braces around all branches

johannes

