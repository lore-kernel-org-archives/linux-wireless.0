Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4953 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713AbYBPPjM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2008 10:39:12 -0500
Date: Sat, 16 Feb 2008 10:25:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5polish@gmail.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: iwlist shows one AP few times
Message-ID: <20080216152520.GB3005@tuxdriver.com> (sfid-20080216_153923_112610_6D043CCD)
References: <14b026160802160301s3afa1b76sa4bf4dc22db5a8c7@mail.gmail.com> <200802161210.00795.mb@bu3sch.de> <14b026160802160333l45e1727ay4a62603590be4730@mail.gmail.com> <200802161240.03251.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <200802161240.03251.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 16, 2008 at 12:40:03PM +0100, Michael Buesch wrote:
> On Saturday 16 February 2008 12:33:57 Rafa=C5=82 Mi=C5=82ecki wrote:
> > 2008/2/16, Michael Buesch <mb@bu3sch.de>:
> > > On Saturday 16 February 2008 12:01:34 Rafa=C5=82 Mi=C5=82ecki wro=
te:
> > > > I use 4318/02 and 2.6.24 kernel. Usually everything works fine =
but in
> > > > some moments iwlist shows my AP a few time in the output. The p=
roblem
> > > > is that as long as iwlist do that, KNetworkManager doesn't disp=
lay my
> > > > AP. I wonder if this can be b43 bug?
> > >
> > > This seems to be channel interference.
> > > KNetworkManager should be fixed in any case.
> >=20
> > But as far as I know channels 6 and 11should be out of  interferenc=
e,
> > or am I wrong? I'm not a genius in this sphere, everying I can do i=
s
> > just to comapre that 2426-2448 (ch6) and 2451-2473 (ch1) have anoth=
er
> > values.
>=20
> If there is an AP on channel 6, you can also get most of its beacons =
on channel 7
> and 5. So if the AP sends a beacon while you scan channel 7 you might=
 get the
> AP from channel 6. Note that the TSF timers are different for the two=
 APs.
> The Channel:X value from iwlist is most likely from the beacon-embedd=
ed channel
> identifier IE. So you'll also get Channel:6, if the packet was actual=
ly received
> on channel 7 or 5 or whatever.

Here is a pertinent fragment of the code in question from
ieee80211_rx_bss_info (called for both beacons and probe responses):

	if (elems.ds_params && elems.ds_params_len =3D=3D 1)
		freq =3D ieee80211_channel_to_frequency(elems.ds_params[0]);
	else
		freq =3D rx_status->freq;

	bss =3D ieee80211_rx_bss_get(dev, mgmt->bssid, freq,
				   elems.ssid, elems.ssid_len);
	if (!bss) {
		bss =3D ieee80211_rx_bss_add(dev, mgmt->bssid, freq,
					   elems.ssid, elems.ssid_len);
		if (!bss)
			return;
	} else {
	.
	.
	.

So the frequency info can come from either the beacon or from the
Rx status.  But in either case, the info that comes from iwlist is
taken from the same linked list used by ieee80211_rx_bss_get and
ieee80211_rx_bss_add.  Since the frequency (i.e. channel) information
is the same for both instances of the BSSID, that implies that the
same freq value was passed to ieee80211_rx_bss_add for each entry.

The ieee80211_rx_bss_get compares BSSID, SSID, and frequency when
matching a BSS.  This accounts for some strange AP implementations
that use the same BSSID either on different frequencies or in
different SSIDs.  Anyway, the BSSID and SSID information also
matches in both BSSID instances from the posted iwlist output.
To me this implies that we have some linked list management problem.
Since ieee80211_rx_bss_add only gets called after a failed match in
ieee80211_rx_bss_get, I have to guess that there is a hole in our
matching algorithm?

Here is the ieee80211_rx_bss_get implementation, in case someone else
sees the problem:

static struct ieee80211_sta_bss *
ieee80211_rx_bss_get(struct net_device *dev, u8 *bssid, int freq,
		     u8 *ssid, u8 ssid_len)
{
	struct ieee80211_local *local =3D wdev_priv(dev->ieee80211_ptr);
	struct ieee80211_sta_bss *bss;

	spin_lock_bh(&local->sta_bss_lock);
	bss =3D local->sta_bss_hash[STA_HASH(bssid)];
	while (bss) {
		if (!memcmp(bss->bssid, bssid, ETH_ALEN) &&
		    bss->freq =3D=3D freq &&
		    bss->ssid_len =3D=3D ssid_len &&
		    (ssid_len =3D=3D 0 || !memcmp(bss->ssid, ssid, ssid_len))) {
			atomic_inc(&bss->users);
			break;
		}
		bss =3D bss->hnext;
	}
	spin_unlock_bh(&local->sta_bss_lock);
	return bss;
}

Any ideas on what might be happening?  It seems like it would have
to be linked to matching the SSID...?

John

P.S.  Here is the iwlist info in question, for those just joining the t=
hread:

wlan0     Scan completed :
          Cell 01 - Address: 00:18:39:DD:EE:78
                    ESSID:"zajec_linksys"
                    Mode:Master
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=3D63/100  Signal level=3D-51 dBm  Noise lev=
el=3D-72 dBm
                    Encryption key:on
                    IE: Unknown: 300130
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/=
s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=3D00000014481e851a
          Cell 02 - Address: 00:14:78:EB:FF:6C
                    ESSID:"NTC_03"
                    Mode:Master
                    Channel:11
                    Frequency:2.462 GHz (Channel 11)
                    Quality=3D31/100  Signal level=3D-86 dBm  Noise lev=
el=3D-72 dBm
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s
                    Extra:tsf=3D000000c4357e0181
          Cell 03 - Address: 00:18:39:DD:EE:78
                    ESSID:""
                    Mode:Master
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=3D65/100  Signal level=3D-50 dBm  Noise lev=
el=3D-72 dBm
                    Encryption key:on
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                       Preauthentication Supported
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/=
s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=3D0000001447c32e34
          Cell 04 - Address: 00:18:39:DD:EE:78
                    ESSID:""
                    Mode:Master
                    Channel:6
                    Frequency:2.437 GHz (Channel 6)
                    Quality=3D65/100  Signal level=3D-50 dBm  Noise lev=
el=3D-72 dBm
                    Encryption key:on
                    IE: IEEE 802.11i/WPA2 Version 1
                        Group Cipher : CCMP
                        Pairwise Ciphers (1) : CCMP
                        Authentication Suites (1) : PSK
                       Preauthentication Supported
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 11 Mb/s; 6 Mb/s
                              12 Mb/s; 24 Mb/s; 36 Mb/s; 9 Mb/s; 18 Mb/=
s
                              48 Mb/s; 54 Mb/s
                    Extra:tsf=3D0000001447c239ef
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
