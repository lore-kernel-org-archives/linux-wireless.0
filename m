Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:38877 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754807Ab2LRNqX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2012 08:46:23 -0500
Date: Tue, 18 Dec 2012 14:46:11 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, rodrigue@qca.qualcomm.com,
	adrian@freebsd.org, nbd@openwrt.org, jonbither@gmail.com,
	kgiori@qca.qualcomm.com, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [RFCv2] Add spectral scan support for Atheros AR92xx/AR93xx
Message-ID: <20121218134611.GA7053@pandem0nium> (sfid-20121218_144627_679994_E58FA664)
References: <1354811768-4414-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <20121213140753.GA26868@pandem0nium>
 <50D04EC9.2040805@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HP7ph2BbKc20aGI"
In-Reply-To: <50D04EC9.2040805@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Zefir,=20

On Tue, Dec 18, 2012 at 12:08:57PM +0100, Zefir Kurtisi wrote:
> On 12/13/2012 03:07 PM, Simon Wunderlich wrote:
> > Hey there,
> >=20
> > just to bump the issue again - isn't there anyone here who can answer
> > some of these questions?
> >=20
> > [...]
> >=20
> > Thanks a lot!
> > 	Simon
> >=20
> Note: removed John, Johannes and Juoni from CC, since this is ath9k speci=
fic
>=20
>=20
> Hi Simon,
>=20
> I have a spectral scanning module up and running in an AR9590 based syste=
m and can
> provide you some relevant observations and experiences I made.

Cool, thanks a lot for adding more puzzle pieces to this one! This is very =
helpful!
>=20
>=20
> First off: forget about 40MHz for now. It is either not working at all or=
 way too
> unstable (tested with 9280, 9380, 9580).

Thanks for the warning, I won't waste time on that for now then and post a =
HT20
only version to begin with.

>=20
> In 20MHz mode, spectral data is provided in the following format:
>=20
> +#define SPECTRAL_HT20_NUM_BINS		56
> +#define SPECTRAL_HT20_DC_INDEX		(SPECTRAL_HT20_NUM_BINS / 2)
> +#define SPECTRAL_HT20_TOTAL_DATA_LEN	(sizeof(struct ht20_fft_packet) + 3)
> +
> +struct ht20_mag_data {
> +	u8 all_bins1;
> +	u8 max_mag_bits29;
> +	u8 all_bins2;
> +	u8 max_exp;
> +} __attribute__((packed));
> +
> +struct ht20_fft_packet {
> +	u8 bin[SPECTRAL_HT20_NUM_BINS];
> +	struct ht20_mag_data mag_data;
> +} __attribute__((packed));
> +
>=20
> When spectral data is ready, the length is sometimes reported incorrectly=
, valid
> values are between (SPECTRAL_HT20_TOTAL_DATA_LEN - 1) and
> (SPECTRAL_HT20_TOTAL_DATA_LEN + 2), my code snipped to check the validity=
 is:

OK, this matches with my data (55-58 byte of "spectral data") ...
>=20
> +static s8 fix_rssi_inv_only(u8 rssi_val)
> +{
> +	if (rssi_val =3D=3D 128)
> +		rssi_val =3D 0;
> +	return (s8) rssi_val;
> +}
> +
> +#define SPECTRAL_SCAN_BITMASK 0x10
> +
> +/*
> + * check PHY-error for spectral
> + */
> +bool process_spectral_phyerr(struct ath_softc *sc, void *data,
> +			     struct ath_rx_status *rs, u64 mactime)
> +{
> +	u16 datalen;
> +	char *vdata_end;
> +	struct ath_hw *ah =3D sc->sc_ah;
> +	struct ath_spectral_scanner *ass =3D ah->spectral_scanner;
> +	struct ath_spectral_data *sd =3D &ass->spectral_data;
> +	u8 pulse_bw_info;
> +	s8 rssi;
> +	struct spectral_ht20_msg *msg;
> +
> +	sd->stats.total_phy_errors++;
> +
> +	if (rs->rs_phyerr !=3D ATH9K_PHYERR_SPECTRAL) {
> +		sd->stats.drop_non_spectral++;
> +		return false;
> +	}
> +
> +	datalen =3D rs->rs_datalen;
> +	if (datalen > SPECTRAL_HT20_TOTAL_DATA_LEN + 2) {
> +		sd->stats.drop_len_overflow++;
> +		return false;
> +	}
> +	if (datalen < SPECTRAL_HT20_TOTAL_DATA_LEN - 1) {
> +		sd->stats.drop_len_underflow++;
> +		return false;
> +	}
> +
> +	vdata_end =3D (char *)data + datalen;
> +	pulse_bw_info =3D vdata_end[-1];
> +
> +	if (!(pulse_bw_info & SPECTRAL_SCAN_BITMASK)) {
> +		sd->stats.drop_non_spectral++;
> +		return false;
> +	}
> +
> +	rssi =3D fix_rssi_inv_only(rs->rs_rssi_ctl0);
> +
> +	sd->stats.descriptors_processed++;
> +
> +	ath_process_spectraldata_ht20(ah, data, datalen, rssi, mactime, msg);
> +
> +	sd->run_stats.last_tstamp =3D mactime;
> +	sd->run_stats.spectral_packets++;
> +
> +	return true;
> +}
>=20
> As for the incorrect data, there are 4 cases to consider:
> 1) data length is correct =3D> take the 56 bins as is
> 2) data length is 1 less =3D> duplicate the first bin
> 3) data length is 2 more =3D> remove bins 30 and 32
> 4) data length is 1 more =3D> combine 2) + 3)

=2E.. didn't see THAT coming. But that explains it very well how to
handle these varying data lengths. Although I wonder how this can happen.
I guess there are some chip-internal reasons ...

>=20
> The code snippet to handle this post-processing is:
>=20
> +static s8 fix_max_index(u8 max_index)
> +{
> +	s8 maxindex =3D max_index;
> +	if (max_index > 32)
> +		maxindex |=3D 0xe0;
> +	else
> +		maxindex &=3D ~0xe0;
> +	maxindex +=3D 29;
> +	return maxindex;
> +}
> +
> +static void ath_process_spectraldata_ht20(struct ath_hw *ah, u8 *vdata,
> +		u16 datalen, s8 rssi, u64 fulltsf,
> +		struct spectral_ht20_msg *nl_msg)
> +{
> +	struct ath_spectral_data *sd =3D &ah->spectral_scanner->spectral_data;
> +	u8 *vdata_end =3D (char*)vdata + datalen;
> +	u8 *msg_bin =3D nl_msg->bin;
> +	struct ht20_mag_data *mag =3D (struct ht20_mag_data *) (vdata_end - 7);
> +
> +	switch(datalen - SPECTRAL_HT20_TOTAL_DATA_LEN) {
> +	case 0:
> +		// correct length
> +		memcpy(msg_bin, vdata, SPECTRAL_HT20_NUM_BINS);
> +		sd->stats.datalen_ok++;
> +		break;
> +	case -1:
> +		// missing the first byte -> duplicate first as byte 0 and 1
> +		msg_bin[0] =3D vdata[0];
> +		memcpy(msg_bin + 1, vdata, SPECTRAL_HT20_NUM_BINS - 1);
> +		sd->stats.datalen_m1++;
> +		break;
> +	case 2:
> +		// MAC added 2 extra bytes at bin 30 and 32
> +		memcpy(msg_bin, vdata, 30);
> +		msg_bin[30] =3D vdata[31];
> +		memcpy(msg_bin + 31, vdata + 33, SPECTRAL_HT20_NUM_BINS - 31);
> +		sd->stats.datalen_p2++;
> +		break;
> +	case 1:
> +		// MAC added 2 extra bytes AND first byte missing
> +		msg_bin[0] =3D vdata[0];
> +		memcpy(msg_bin + 1, vdata, 30);
> +		msg_bin[31] =3D vdata[31];
> +		memcpy(msg_bin + 32, vdata + 33, SPECTRAL_HT20_NUM_BINS - 32);
> +		sd->stats.datalen_p2m1++;
> +		break;
> +	}
> +
> +	/* global data */
> +	nl_msg->freq =3D sd->center_freq;
> +	nl_msg->rssi =3D rssi;
> +	nl_msg->noise_floor =3D ah->noise; //ah->caldata->nfCalHist[0].privNF;
> +	nl_msg->tstamp =3D fulltsf;
> +
> +	/* extract magnitude scaling data */
> +	nl_msg->max_magnitude =3D (mag->max_mag_bits29 << 2) |
> +				((mag->all_bins1 & 0xc0) >> 6) |
> +				((mag->all_bins2 & 0x03) << 10);
> +	nl_msg->bitmap_weight =3D mag->all_bins1 & 0x3f;
> +	nl_msg->max_index =3D fix_max_index(mag->all_bins2 & 0x3f);
> +	nl_msg->max_exp =3D mag->max_exp & 0x0f;
> +}

Thanks a lot for sharing!

>=20
> In my system the post-processed FFT raw data is transferred via a netlink
> interface to a spectral_proxy, that forwards it to a connected host for r=
eal-time
> inspection and visualization.
>=20
> The interpretation of the data is as follows: the reported values are giv=
en as
> magnitudes, which need to be scaled and converted to absolute power value=
s based
> on the packet's noise floor and RSSI values as follows:
> bin_sum =3D 10*log(sum[i=3D1..56](b(i)^2)
> power(i) =3D noise_floor + RSSI + 10*log(b(i)^2) - bin_sum
>=20

Ah, very nice. My intepretation code actually looks similar, different fact=
ors
and different summing thou. With the fixes in the data (as above) and this,=
 the
visualization will hopefully become clearer. :)

I'll fix my visualization program [1] accordingly.

[1] https://github.com/simonwunderlich/FFT_eval/wiki

> The code fragment to convert magnitude to absolute power values looks lik=
e this
> (assuming you transferred the FFT and magnitude data to user space):
> bool convert_data(struct spectral_ht20_msg *msg)
> +{
> +	u_int8_t *bin_pwr =3D msg->bin;
> +	u_int8_t *dc_pwr =3D msg->bin + SPECTRAL_NUM_BINS / 2;
> +	int pwr_count =3D SPECTRAL_NUM_BINS;
> +	int8_t rssi =3D msg->rssi;
> +	int8_t max_scale =3D 1 << msg->max_exp;
> +	int16_t max_mag =3D msg->max_magnitude;
> +	int i;
> +	int nf0 =3D msg->noise_floor;
> +
> +	float bsum =3D 0.0;
> +
> +	// DC value is invalid -> interpolate
> +	*dc_pwr =3D (dc_pwr[-1] + dc_pwr[1]) / 2;
> +
> +	for (i =3D 0; i < pwr_count; i++)
> +		bsum +=3D (bin_pwr[i] * max_scale) * (bin_pwr[i] * max_scale);
> +	bsum =3D log10f(bsum) * 10;
> +
> +	for (i =3D 0; i < pwr_count; i++) {
> +		float pwr_val;
> +		int16_t val =3D bin_pwr[i];
> +
> +		if (val =3D=3D 0)
> +			val =3D 1;
> +
> +		pwr_val =3D 20 * log10f((float) val * max_scale);
> +		pwr_val +=3D nf0 + rssi - bsum;
> +
> +		val =3D pwr_val;
> +		bin_pwr[i] =3D val;
> +	}
> +	return true;
> +}
>=20
>=20
> That's it, now you should be able to feed the raw data to whatever visual=
ization,
> statistics and classification back-ends.
>=20
>=20
> Hope this helps somewhat. My implementation is quite application specific=
 (like
> operational only as monitor, dedicated netlink interface, proxy-forwardin=
g, etc.)
> and not usable for the generic user. That's why I am not posting it here =
and
> polluting the mailing list. If you (or anybody else out there) would like=
 to test
> it as proof-of-concept, I can provide you the complete OpenWRT integratio=
n.

Yes, that helped very much, especially the varying data part was something =
I had no
clue about. This might also fix the "weird high numbers in the middle of th=
e dump"
problem I was seeing.

I'll change the patch according to your explanations, so that only 56 byte =
data samples
are returned (at least for HT20).

Thank you very much!
	Simon

--+HP7ph2BbKc20aGI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDQc6MACgkQrzg/fFk7axZz1QCg5dG7vdCD9TXKtIzT3dFiSg2V
aUMAoNp6zTePlWyw5DHBiax8Ajnstjne
=Gfh2
-----END PGP SIGNATURE-----

--+HP7ph2BbKc20aGI--
