Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gw90.de ([188.40.100.199]:48793 "EHLO mail.gw90.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401Ab3FQVjl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 17:39:41 -0400
Message-ID: <1371505124.8902.72.camel@mattotaupa> (sfid-20130617_233944_699361_9DFEC2A0)
Subject: Re: Connection not established with Realtek RTL8188CUS based USB
 device (EDIMAX)
From: Paul Menzel <paulepanter@users.sourceforge.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <51BCD7BA.1040900@lwfinger.net>
References: <1371326265.9845.54.camel@mattotaupa>
	 <51BCD7BA.1040900@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Rp4zWXjVMGqsUbwkYJIA"
Date: Mon, 17 Jun 2013 23:38:45 +0200
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Rp4zWXjVMGqsUbwkYJIA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Am Samstag, den 15.06.2013, 16:08 -0500 schrieb Larry Finger:
> On 06/15/2013 02:57 PM, Paul Menzel wrote:

> > hopefully I am contacting the correct list. I am not able to use the
> > Realtek RTL8188CUS based USB WLAN device Edimax EW-7811Un.
> >
> >          Bus 002 Device 005: ID 7392:7811 Edimax Technology Co., Ltd EW=
-7811Un 802.11n Wireless Adapter [Realtek RTL8188CUS]
> >
> > The device did not work with Debian Wheezy with Linux 3.2.x, Debian
> > Sid/unstable with Linux 3.9.x, Ubuntu 12.04 with Linux 3.2.12 to 3.5 an=
d
> > Ubuntu 13.04 with Linux 3.8. The person, from whom the device is from,
> > claims the device once worked with Ubuntu, but I do not know which
> > version and what WLAN type(?) this was with.
> >
> > The behavior is always the same. The device is detected and the
> > NetworkManager applet `nm-applet` is also able to detect the available
> > networks. But wanting to connect to one and entering the correct
> > password, the connection cannot be established and I am asked for the
> > password again. I tested this with different systems and different
> > networks and also with wpa_supplicant. A Ralink based WLAN USB device
> > works just fine.
> >
> > The Realtek RTL8188CUS WLAN device works also fine under Microsoft
> > Windows, so the device is functional.
>=20
> Use a compat-wireless package from 3.10-rc1 or later.

I only found 3.10-rc1 [1].

Unfortunately I was not able to load the modules. With the help from
#linux-wireless I did `make menuconfig` and then `make`.

        $ find net -name *ko
        net/mac80211/mac80211.ko
        net/wireless/cfg80211.ko
        $ find -name rtl*ko
        ./drivers/net/wireless/rtlwifi/rtl8192c/rtl8192c-common.ko
        ./drivers/net/wireless/rtlwifi/rtlwifi.ko
        ./drivers/net/wireless/rtlwifi/rtl8192cu/rtl8192cu.ko
        $ sudo insmod -f net/mac80211/mac80211.ko
        Error: could not insert module net/mac80211/mac80211.ko: Unknown sy=
mbol in module
        $ file net/mac80211/mac80211.ko
        net/mac80211/mac80211.ko: ELF 32-bit LSB  relocatable, Intel 80386,=
 version 1 (SYSV), BuildID[sha1]=3Dc3fcda409c09dcd98997f7a0a43a7eb8401b83cb=
, not stripped
        $ more /var/log/syslog
        [=E2=80=A6]
        Jun 17 23:26:18 myhostname kernel: [ 6853.383013] mac80211: Unknown=
 symbol cfg80211_send_assoc_timeout (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383049] mac80211: Unknown=
 symbol cfg80211_sched_scan_results (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383099] mac80211: Unknown=
 symbol cfg80211_rx_unexpected_4addr_frame (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383186] mac80211: Unknown=
 symbol cfg80211_scan_done (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383220] mac80211: Unknown=
 symbol cfg80211_sched_scan_stopped (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383272] mac80211: Unknown=
 symbol cfg80211_send_auth_timeout (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383307] mac80211: Unknown=
 symbol cfg80211_remain_on_channel_expired (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383340] mac80211: Unknown=
 symbol cfg80211_cac_event (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383395] mac80211: Unknown=
 symbol ieee80211_amsdu_to_8023s (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383423] mac80211: Unknown=
 symbol cfg80211_send_deauth (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383460] mac80211: Unknown=
 symbol cfg80211_ref_bss (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383531] mac80211: Unknown=
 symbol __cfg80211_send_deauth (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383574] mac80211: Unknown=
 symbol cfg80211_chandef_valid (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383601] mac80211: Unknown=
 symbol cfg80211_new_sta (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383639] mac80211: Unknown=
 symbol cfg80211_send_unprot_deauth (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383686] mac80211: Unknown=
 symbol cfg80211_calculate_bitrate (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383738] mac80211: Unknown=
 symbol cfg80211_ready_on_channel (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383773] mac80211: Unknown=
 symbol cfg80211_classify8021d (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383811] mac80211: Unknown=
 symbol cfg80211_send_unprot_disassoc (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383843] mac80211: Unknown=
 symbol wiphy_register (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383874] mac80211: Unknown=
 symbol wiphy_new (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383905] mac80211: Unknown=
 symbol cfg80211_put_bss (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383945] mac80211: Unknown=
 symbol cfg80211_gtk_rekey_notify (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.383991] mac80211: Unknown=
 symbol ieee80211_bss_get_ie (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384034] mac80211: Unknown=
 symbol cfg80211_rx_spurious_frame (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384061] mac80211: Unknown=
 symbol cfg80211_ibss_joined (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384090] mac80211: Unknown=
 symbol __cfg80211_send_disassoc (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384118] mac80211: Unknown=
 symbol cfg80211_chandef_compatible (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384155] mac80211: Unknown=
 symbol cfg80211_report_obss_beacon (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384196] mac80211: Unknown=
 symbol cfg80211_michael_mic_failure (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384223] mac80211: Unknown=
 symbol cfg80211_cqm_pktloss_notify (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384254] mac80211: Unknown=
 symbol cfg80211_send_rx_auth (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384295] mac80211: Unknown=
 symbol ieee80211_operating_class_to_band (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384442] mac80211: Unknown=
 symbol wiphy_unregister (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384493] mac80211: Unknown=
 symbol cfg80211_send_disassoc (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384532] mac80211: Unknown=
 symbol ieee80211_radiotap_iterator_init (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384574] mac80211: Unknown=
 symbol cfg80211_get_bss (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384609] mac80211: Unknown=
 symbol __ieee80211_get_channel (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384648] mac80211: Unknown=
 symbol cfg80211_chandef_usable (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384682] mac80211: Unknown=
 symbol rfc1042_header (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384724] mac80211: Unknown=
 symbol cfg80211_mgmt_tx_status (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384757] mac80211: Unknown=
 symbol cfg80211_check_station_change (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384792] mac80211: Unknown=
 symbol cfg80211_reg_can_beacon (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384834] mac80211: Unknown=
 symbol cfg80211_find_ie (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384865] mac80211: Unknown=
 symbol cfg80211_unregister_wdev (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384892] mac80211: Unknown=
 symbol cfg80211_del_sta (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384920] mac80211: Unknown=
 symbol cfg80211_probe_status (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384949] mac80211: Unknown=
 symbol ieee80211_data_to_8023 (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.384976] mac80211: Unknown=
 symbol cfg80211_send_rx_assoc (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385003] mac80211: Unknown=
 symbol ieee80211_radiotap_iterator_next (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385041] mac80211: Unknown=
 symbol ieee80211_channel_to_frequency (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385069] mac80211: Unknown=
 symbol cfg80211_rx_mgmt (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385117] mac80211: Unknown=
 symbol ieee80211_hdrlen (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385153] mac80211: Unknown=
 symbol cfg80211_chandef_create (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385181] mac80211: Unknown=
 symbol cfg80211_report_wowlan_wakeup (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385210] mac80211: Unknown=
 symbol cfg80211_inform_bss_frame (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385245] mac80211: Unknown=
 symbol cfg80211_get_p2p_attr (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385277] mac80211: Unknown=
 symbol ieee80211_frequency_to_channel (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385313] mac80211: Unknown=
 symbol cfg80211_radar_event (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385341] mac80211: Unknown=
 symbol bridge_tunnel_header (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385375] mac80211: Unknown=
 symbol backport_dependency_symbol (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385402] mac80211: Unknown=
 symbol cfg80211_unlink_bss (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385430] mac80211: Unknown=
 symbol wiphy_free (err 0)
        Jun 17 23:26:18 myhostname kernel: [ 6853.385462] mac80211: Unknown=
 symbol cfg80211_cqm_rssi_notify (err 0)

What am I doing wrong?

> If that fails, then I will give you a debug sequence to run.


Thanks,

Paul


[1] https://www.kernel.org/pub/linux/kernel/projects/backports/stable/

--=-Rp4zWXjVMGqsUbwkYJIA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEABECAAYFAlG/geQACgkQPX1aK2wOHVh0RACfaxybGoNNjhTa7cGzhDCp5D4M
um4AmweXlmGQcMdGOviRUQG4oWOB4A0X
=XQ/R
-----END PGP SIGNATURE-----

--=-Rp4zWXjVMGqsUbwkYJIA--

