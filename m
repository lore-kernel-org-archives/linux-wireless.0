Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbYISKMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 06:12:37 -0400
Subject: Re: stlc45xx: mac80211 driver for N800 and N810
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <877i98iw4h.fsf@nokia.com> (sfid-20080919_064357_959180_9A8473C3)
References: <877i98iw4h.fsf@nokia.com>
	 (sfid-20080919_064357_959180_9A8473C3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/ytyM/7v1326CQEBEsaY"
Date: Fri, 19 Sep 2008 12:11:59 +0200
Message-Id: <1221819119.10419.75.camel@johannes.berg> (sfid-20080919_121242_359770_3F271068)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/ytyM/7v1326CQEBEsaY
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-19 at 07:43 +0300, Kalle Valo wrote:
> Hello all,
>=20
> Nokia yesterday published stlc45xx, which is a mac80211 driver for
> N800 and N810. Webpage here:
>=20
> http://stlc45xx.garage.maemo.org/

quick look at the code

> static ssize_t stlc45xx_sysfs_show_cal_rssi(struct device *dev,
> 					    struct device_attribute *attr,
> 					    char *buf)
> {
> 	struct stlc45xx *stlc =3D dev_get_drvdata(dev);
> 	ssize_t len;
> =09
> 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
>=20
> 	/* FIXME: what's the maximum length of buf? page size?*/
> 	len =3D 500;
>=20
> 	if (mutex_lock_interruptible(&stlc->mutex) < 0) {
> 		len =3D 0;
> 		goto out;
> 	}

The interruptible seems fairly useless, I don't see the mutex being held
for very long periods of time anywhere?

> 		stlc45xx_error("invalid cal_rssi lenght: %d", count);

typo. I love reviewing in a program with spell checking ;)
=09
> 	stlc->cal_rssi_ready =3D 1;

that variable is unneeded

> 	if (count !=3D CHANNEL_CAL_ARRAY_LEN) {

I'd suspect that is not a constant, in the US you have 11 channels? Or
are they in there but disabled?
=09
> 	stlc->cal_channels_ready =3D 1;

another pointless variable

> 	ssize_t len;
> =09

trailing whitespace in a number of places, run sed 's/\s*$//' or
something like that :)

> 	/* FIXME: what's the maximum length of buf? page size? */
> 	len =3D 500;

Oh, yes, as far as I know.

> 	len =3D snprintf(buf, len, "%i\n", stlc->psm);

but really, there's little use for snprintf for something that can at
most get like 13 characters.

> static ssize_t stlc45xx_sysfs_store_psm(struct device *dev,
> 					struct device_attribute *attr,=20
> 					const char *buf, size_t count)
> {
> 	struct stlc45xx *stlc =3D dev_get_drvdata(dev);
> 	int val, ret;
>=20
> 	ret =3D sscanf(buf, "%d", &val);

I think you may want strict_strtoul.

> static u16 stlc45xx_read16(struct stlc45xx *stlc, unsigned long addr)

> static u32 stlc45xx_read32(struct stlc45xx *stlc, unsigned long addr)

> static void stlc45xx_write16(struct stlc45xx *stlc, unsigned long addr, u=
16 val)

> static void stlc45xx_write32(struct stlc45xx *stlc, unsigned long addr, u=
32 val)

I'd almost think those should be declared inline, although the compiler
might?

> static void stlc45xx_dump_registers(struct stlc45xx *stlc)

Do we need this? It looks unused.

> 	list_for_each_entry(txbuffer, &stlc->txbuffer, buffer_list) {
> 		if (pos + len < txbuffer->start) {
> 			found =3D 1;
> 			break;
> 		}
>                 pos =3D ALIGN(txbuffer->end + 1, 4);
> 	}
>=20
> 	if (!found && (pos + len > FIRMWARE_TXBUFFER_END))
> 		/* not enough room */
> 		pos =3D -1;

Afaict the found variable can be removed since the txbuffer->start will
be < FIRMWARE_TXBUFFER_END of course.

This code is actually rather subtle, comments would be good since the
list must always contain the entries in the order that they're in in the
firmware buffer too.

> static int stlc45xx_txbuffer_add(struct stlc45xx *stlc,
> 				 struct txbuffer *txbuffer)=20
> {
> 	struct txbuffer *r, *prev =3D NULL;
> 	int ret =3D -1;
> =09
> 	stlc45xx_debug(DEBUG_FUNC, "%s()", __func__);
>=20
> 	if (list_empty(&stlc->txbuffer)) {
> 		list_add(&txbuffer->buffer_list, &stlc->txbuffer);
> 		ret =3D 0;
> 		goto out;

you can just return since there is no cleanup :)

> 	r =3D list_first_entry(&stlc->txbuffer, struct txbuffer, buffer_list);
> =09
> 	if (txbuffer->start < r->start) {
> 		list_add_tail(&txbuffer->buffer_list, &r->buffer_list);
> 		ret =3D 0;
> 		goto out;
> 	}

list_add_tail? This seems like it should be list_add() since it's before
the first item.

> 	prev =3D NULL;
> 	list_for_each_entry(r, &stlc->txbuffer, buffer_list) {
> 		WARN_ON_ONCE(txbuffer->start >=3D r->start
> 			     && txbuffer->start <=3D r->end);
> 		WARN_ON_ONCE(txbuffer->end >=3D r->start
> 			     && txbuffer->end <=3D r->end);
> 		if (prev && prev->end < txbuffer->start &&
> 		    txbuffer->start < r->start) {                <---****** txbuffer->e=
nd??
> 			list_add_tail(&txbuffer->buffer_list, &r->buffer_list);
> 			ret =3D 0;
> 			goto out;
> 		}
> 		prev =3D r;
> 	}

This looks complicated and buggy, how about this instead:

	prev =3D NULL;
	list_for_each_entry(r, &stlc->txbuffer, buffer_list) {
		/* skip first entry, we checked for that above */
		if (!prev)
			continue;

		/* double-check overlaps */
		WARN_ON_ONCE(txbuffer->start >=3D r->start &&
			     txbuffer->start <=3D r->end);
		WARN_ON_ONCE(txbuffer->end >=3D r->start &&
			     txbuffer->end <=3D r->end);

		if (prev->end < txbuffer->start &&
		    txbuffer->end < r->start) {
			/* insert at this spot */
			list_add_tail(&txbuffer->buffer_list, &r->buffer_list);
			return 0;
		}
		prev =3D r;
	}

	/* not found */
> 	list_add_tail(&txbuffer->buffer_list, &stlc->txbuffer);
> 	ret =3D 0;
>=20
> out:
> 	return ret;


> /* caller must hold tx_lock */
> static struct txbuffer *stlc45xx_txbuffer_alloc(struct stlc45xx *stlc,
> 						 size_t frame_len)
> {
> 	struct txbuffer *entry =3D NULL;
> 	size_t len;
> 	int pos;
>=20
> 	stlc45xx_debug(DEBUG_FUNC, "%s()", __func__);
> =09
> 	len =3D FIRMWARE_TXBUFFER_HEADER + frame_len + FIRMWARE_TXBUFFER_TRAILER=
;
>         pos =3D stlc45xx_txbuffer_find(stlc, len);
>=20
>         if (pos < 0) {
> 		return NULL;
>         }

useless braces

> 	WARN_ON_ONCE(pos + len > FIRMWARE_TXBUFFER_END);
> 	WARN_ON_ONCE(pos < FIRMWARE_TXBUFFER_START);
>=20
> 	entry =3D kmalloc(sizeof(*entry), GFP_ATOMIC);
> 	entry->start =3D pos;
> 	entry->frame_start =3D pos + FIRMWARE_TXBUFFER_HEADER;
> 	entry->end =3D entry->start + len;

I think this can be
	entry->end =3D entry->start + len - 1
since you treat it as such in all the other code afaict. Might pack the
buffers a bit better and require less padding.

> /* caller must hold tx_lock */
> static void stlc45xx_check_txsent(struct stlc45xx *stlc)=20
> {
> 	struct txbuffer *entry, *n;
>=20
> 	/* FIXME: notify mac80211? */

Yeah, you'd probably want to.

> static void stlc45xx_power_on(struct stlc45xx *stlc)
> {
> 	omap_set_gpio_dataout(stlc->config->power_gpio, 1);
> 	enable_irq(OMAP_GPIO_IRQ(stlc->config->irq_gpio));
>=20
> 	/*
> 	 * need to wait a while before device can be accessed, the lenght

another typo

> /* caller must hold tx_lock */
> static void stlc45xx_flush_queues(struct stlc45xx *stlc)=20
> {
> 	struct txbuffer *entry;
>=20
> 	/* FIXME: notify mac80211? */

given that reset shouldn't happen and on stop mac80211 doesn't care, I
wouldn't bother.

> static void stlc45xx_work_reset(struct work_struct *work)
> {
> 	struct stlc45xx *stlc =3D container_of(work, struct stlc45xx,
> 					     work_reset);

If reset _does_ happen you could use the mac80211 notification callback
to tell it to associate again.

> static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
> {


> 	stlc45xx_check_txsent(stlc);
> 	if (list_empty(&stlc->tx_sent))
> 		/* there are pending frames, we can stop the tx timeout
> 		 * timer */
> 		cancel_delayed_work(&stlc->work_tx_timeout);

there are _no_ pending frames [...]

> 	memset(&status, 0, sizeof(status));
>=20
> 	status.freq =3D data->frequency;
> 	status.signal =3D data->rcpi / 2 - 110;
>=20
> 	/* let's assume that maximum rcpi value is 140 (=3D 35 dBm) */
> 	status.qual =3D data->rcpi * 100 / 140;
>=20
> 	status.band =3D IEEE80211_BAND_2GHZ;
>=20
> 	/*
> 	 * FIXME: this gives warning from __ieee80211_rx()
> 	 *
> 	 * status.rate_idx =3D data->rate;
> 	 */

That's strange, you should print out the index and see why it warns, it
shouldn't afaict. Unless the docs are wrong...

> 	__ieee80211_rx(stlc->hw, skb, &status);

Use ieee80211_rx() without the underscores, the __ is just a hack to
make the symbol clash go away... Jiri never should have let it escape
the header file.

> 	setup->antenna =3D 2;
> 	setup->rx_align =3D 0;
> 	setup->rx_buffer =3D FIRMWARE_RXBUFFER_START;
> 	setup->rx_mtu =3D FIRMWARE_MTU;
> 	setup->frontend =3D 5;

There are #defines in the header file for some of these

> static int stlc45xx_op_add_interface(struct ieee80211_hw *hw,
> 				     struct ieee80211_if_init_conf *conf)
> {
> 	struct stlc45xx *stlc =3D hw->priv;
>=20
> 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
> =09
> 	switch (conf->type) {
> 	case IEEE80211_IF_TYPE_STA:
> 		break;
> 	default:
> 		return -EOPNOTSUPP;
> 	}

You need to keep track whether you're already up or not, right now
you're allowing multiple STA interfaces.
=09
> static void stlc45xx_op_remove_interface(struct ieee80211_hw *hw,
> 					 struct ieee80211_if_init_conf *conf)
> {
> 	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
> }

That's why you need _remove_interface in any case and it isn't
optional :) Also you really should clear the MAC address or go into the
no-ack mode so pure monitoring works.

> static void stlc45xx_op_configure_filter(struct ieee80211_hw *hw,
> 				      unsigned int changed_flags,
> 				      unsigned int *total_flags,
> 				      int mc_count,
> 				      struct dev_addr_list *mc_list)=20
> {
> 	*total_flags =3D 0;
> }

If I understand the documentation correctly you can actually support a
few things here.

> /* can't be const, mac80211 writes to this */
> static struct ieee80211_supported_band stlc45xx_band_2ghz =3D {

I don't think that's true for this one? Not that it matters. const is a
pure compiler thing anyway.

> static int stlc45xx_register_mac80211(struct stlc45xx *stlc)
> {
> 	/* FIXME: SET_IEEE80211_PERM_ADDR() requires default_mac_addr
> 	   to be non-const for some strange reason */

Bug I guess :)

> 	stlc =3D hw->priv;
> 	memset(stlc, 0, sizeof(*stlc));

should already be cleared, but you can do it again of course :)


Overall looks pretty good, I'm concerned that the binary helper is
_required_, we had this with ipw3945 and it wasn't accepted. Any way to
make it not required?

johannes

--=-/ytyM/7v1326CQEBEsaY
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI03rrAAoJEKVg1VMiehFYbqEP/0yTlnIemenyDJ7IdN8E6IEH
yQdmDCiOx+B47QTWLJi6k2Gx2dodLI39dr5jTYlGQDczK65KBPmXyn62cuA7//vj
LeKzVAHQP7pLjXMFfRPyNNLyvmfugJIiZfgDIFK52kc026Hc3p2GsXAP86AVScBS
ufsvdDXnta7bCJRoO0gYuMvuWPbcvxm0r0yAEvGgv4vlXryLNzNVZbSNYDB7wZ0c
INrUfgP4zTtL/jRhVhoSTxIowGFxkxKW1raW8OyhuUwrMvTcCiOLNQvDdCci9qyi
MFSfMhr1vQXmWbx5TPgSeEciNrMIDrGBjXIswWy5PSPwMZlLWTQRgrmFWqw7DLas
GiVADgmmcwpO5tCFykMGS2R8wE6Cnludb8jpF5OKgca0ZR1ghJIgXL96Ne0wsxPA
dsJ/jkm3tE0cdG+bItdTGs9MENNOpwSvNm6J+Jdg7cRN/1dPrRst2dwEEHLUxwTE
n5V2ToGFd3mwE6yqXYK/3T70PrX8kn1RG5OlB6acWegYXyf57ftTAiG8a1Mt+sMR
zV4gjAVpceSKTZ1w94LnuZTMdHXfto50PAF97ACFk67RZuhXF3UIUlwW/n6nczIv
UbbUi+5oHZ6eVuhJGw4BFJk2sb1aDzo86DRJOGSLQhftUBAO19GSIreEhpNa0lEA
COmeujY2jDDKRIrV89r9
=/FSr
-----END PGP SIGNATURE-----

--=-/ytyM/7v1326CQEBEsaY--

