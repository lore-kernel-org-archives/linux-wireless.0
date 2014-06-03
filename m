Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60254 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924AbaFCT6E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:58:04 -0400
Message-ID: <1401825462.4157.42.camel@jlt4.sipsolutions.net> (sfid-20140603_215809_175911_9B21898B)
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
Date: Tue, 03 Jun 2014 21:57:42 +0200
In-Reply-To: <CAN8YU5Mxxqs1H4caXQ_tS0Sq5YKwk9NatgSqWferCqBu_+jnyQ@mail.gmail.com> (sfid-20140531_205434_951215_79D9D36D)
References: <CAN8YU5Nh-FwrBWuCz-YArmHg9NSLqsS2aan_6edaVDg+i6018g@mail.gmail.com>
	 <1400509775.4273.8.camel@jlt4.sipsolutions.net>
	 <1400510950.4273.9.camel@jlt4.sipsolutions.net>
	 <CAN8YU5OdpxQ0F7RMEFeQWC6PNzppHu6bDEt7Tv6dKntEUMy-9A@mail.gmail.com>
	 <1400515344.4273.19.camel@jlt4.sipsolutions.net>
	 <CAN8YU5P5rFjjF9kjLBi0qXwZ1-Zphfi-fbY048wbO9oBmKoULQ@mail.gmail.com>
	 <CAN8YU5OgcuaLv3C=_Lg0E6p1kHqhYZ-PjSgqaTxjJ=EV7VhNaw@mail.gmail.com>
	 <1401285737.8146.21.camel@jlt4.sipsolutions.net>
	 <CAN8YU5Mxxqs1H4caXQ_tS0Sq5YKwk9NatgSqWferCqBu_+jnyQ@mail.gmail.com>
	 (sfid-20140531_205434_951215_79D9D36D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andrea,

On Sat, 2014-05-31 at 20:54 +0200, Andrea Merello wrote:
> Hello,
> I found some useful helper function in mac80211, and I used some of
> them, but unfortunately I finally parsed information element in
> beacon/probe-response by myself:
> I found the utility ieee802_11_parse_elems(), but it seems that it
> relies on structures that are declared in some .h file located locally
> to mac80211.. So I suppose it is not intended for use outside
> mac80211, is it?

Yeah, and it would do much more than what you want. You could use
cfg80211_find_ie() though to simplify the code.

> +/* This is a workaround to make scan working:
> + * currently mac80211 does not process frames with no frequency
> + * information.
> + * However during scan the HW performs a sweep by itself, and we
> + * are unable to know where the radio is actually tuned.
> + * This function tries to do its best to guess this information..
> + * If the current frame is a beacon or a probe response, the channel
> + * information is extracted from it.
> + * For other frames, or if it happen that for whatever reason we fail
> + * to parse beacons and probe responses, this function returns
> + * the priv->channel information, that should be valid at least
> + * when we are NOT scanning.
> + */
> +static int at76_parse_freq(struct at76_priv *priv)
> +{
> +       size_t el_off;
> +       u8 id;
> +       u8 *el;
> +       int el_len;
> +       int channel = priv->channel;
> +       int len = priv->rx_skb->len;
> +       struct ieee80211_hdr *hdr = (void *)priv->rx_skb->data;
> +
> +       if (len < 24)
> +               goto exit;
> +
> +       if (ieee80211_is_probe_resp(hdr->frame_control)) {
> +               el_off = offsetof(struct ieee80211_mgmt, u.probe_resp.variable);
> +               el = ((struct ieee80211_mgmt *)hdr)->u.probe_resp.variable;
> +       } else if (ieee80211_is_beacon(hdr->frame_control)) {
> +               el_off = offsetof(struct ieee80211_mgmt, u.beacon.variable);
> +               el = ((struct ieee80211_mgmt *)hdr)->u.beacon.variable;
> +       } else
> +               goto exit;
> +
> +       len -= el_off;
> +
> +       while (len >= 2) {
> +               id = *el++;
> +               el_len = *el++;
> +               len -= 2;
> +
> +               if (id == WLAN_EID_DS_PARAMS) {
> +                       if ((el_len > 0) && (len >= el_len))
> +                               channel = *el;
> +                       break;
> +               }
> +               len -= el_len;
> +               el += el_len;
> +       }

So the loop can be simplified to

	el = cfg80211_find_ie(WLAN_EID_DS_PARAMS, el, el_len);
	if (el && el[1] > 0)
		channel = el[2];

> @@ -1542,6 +1597,8 @@ static void at76_rx_tasklet(unsigned long param)
>         rx_status.signal = buf->rssi;
>         rx_status.flag |= RX_FLAG_DECRYPTED;
>         rx_status.flag |= RX_FLAG_IV_STRIPPED;
> +       rx_status.band = IEEE80211_BAND_2GHZ;
> +       rx_status.freq = at76_parse_freq(priv);

You might also invoke this only when you know you're scanning, to avoid
the overhead otherwise, but with this driver it probably doesn't matter
much.

johannes

