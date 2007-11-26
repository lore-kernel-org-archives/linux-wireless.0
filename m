Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038AbXKZQ2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:28:44 -0500
Subject: Re: [PATCH 03/15] mac80211: adding 802.11n HT framework definitions
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11960864902461-git-send-email-ron.rindjunsky@intel.com>
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
	 <11960864902461-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ccRXpYI1JQg6U0hWR33a"
Date: Mon, 26 Nov 2007 17:28:27 +0100
Message-Id: <1196094507.4149.295.camel@johannes.berg> (sfid-20071126_162903_577931_836A184D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ccRXpYI1JQg6U0hWR33a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-26 at 16:14 +0200, Ron Rindjunsky wrote:
> New structures:
>  - ieee80211_ht_info: describing STA's HT capabilities
>  - ieee80211_ht_bss_info: describing BSS's HT characteristics
> Changed structures:
>  - ieee80211_hw_mode: now also holds PHY HT capabilities for each HW mode
>  - ieee80211_conf: ht_conf holds current self HT configuration
>                    ht_bss_conf holds current BSS HT configuration
>  - flag IEEE80211_CONF_SUPPORT_HT_MODE added to indicate if HT use is
>    desired
>  - sta_info: now also holds Peer's HT capabilities
>=20
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>

Looks good, we'll do the bss parameter work on top of this.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  include/net/mac80211.h  |   55 +++++++++++++++++++++++++++++++++++++++++=
-----
>  net/mac80211/sta_info.h |    3 ++
>  2 files changed, 52 insertions(+), 6 deletions(-)
>=20
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 17b6039..862431a 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -139,17 +139,54 @@ enum ieee80211_phymode {
>  };
> =20
>  /**
> + * struct ieee80211_ht_info - describing STA's HT capabilities
> + *
> + * This structure describes most essential parameters needed
> + * to describe 802.11n HT capabilities for an STA.
> + *
> + * @ht_supported: is HT supported by STA, 0: no, 1: yes
> + * @cap: HT capabilities map as described in 802.11n spec
> + * @ampdu_factor: Maximum A-MPDU length factor
> + * @ampdu_density: Minimum A-MPDU spacing
> + * @supp_mcs_set: Supported MCS set as described in 802.11n spec
> + */
> +struct ieee80211_ht_info {
> +	u8 ht_supported;
> +	u16 cap; /* use IEEE80211_HT_CAP_ */
> +	u8 ampdu_factor;
> +	u8 ampdu_density;
> +	u8 supp_mcs_set[16];
> +};
> +
> +/**
> + * struct ieee80211_ht_bss_info - describing BSS's HT characteristics
> + *
> + * This structure describes most essential parameters needed
> + * to describe 802.11n HT characteristics in a BSS
> + *
> + * @primary_channel: channel number of primery channel
> + * @bss_cap: 802.11n's general BSS capabilities (e.g. channel width)
> + * @bss_op_mode: 802.11n's BSS operation modes (e.g. HT protection)
> + */
> +struct ieee80211_ht_bss_info {
> +	u8 primary_channel;
> +	u8 bss_cap;  /* use IEEE80211_HT_IE_CHA_ */
> +	u8 bss_op_mode; /* use IEEE80211_HT_IE_ */
> +};
> +
> +/**
>   * struct ieee80211_hw_mode - PHY mode definition
>   *
>   * This structure describes the capabilities supported by the device
>   * in a single PHY mode.
>   *
> + * @list: internal
> + * @channels: pointer to array of supported channels
> + * @rates: pointer to array of supported bitrates
>   * @mode: the PHY mode for this definition
>   * @num_channels: number of supported channels
> - * @channels: pointer to array of supported channels
>   * @num_rates: number of supported bitrates
> - * @rates: pointer to array of supported bitrates
> - * @list: internal
> + * @ht_info: PHY's 802.11n HT abilities for this mode
>   */
>  struct ieee80211_hw_mode {
>  	struct list_head list;
> @@ -158,6 +195,7 @@ struct ieee80211_hw_mode {
>  	enum ieee80211_phymode mode;
>  	int num_channels;
>  	int num_rates;
> +	struct ieee80211_ht_info ht_info;
>  };
> =20
>  /**
> @@ -406,11 +444,12 @@ struct ieee80211_tx_status {
>   *
>   * @IEEE80211_CONF_SHORT_SLOT_TIME: use 802.11g short slot time
>   * @IEEE80211_CONF_RADIOTAP: add radiotap header at receive time (if sup=
ported)
> - *
> + * @IEEE80211_CONF_SUPPORT_HT_MODE: use 802.11n HT capabilities (if supp=
orted)
>   */
>  enum ieee80211_conf_flags {
> -	IEEE80211_CONF_SHORT_SLOT_TIME	=3D 1<<0,
> -	IEEE80211_CONF_RADIOTAP		=3D 1<<1,
> +	IEEE80211_CONF_SHORT_SLOT_TIME	=3D (1<<0),
> +	IEEE80211_CONF_RADIOTAP		=3D (1<<1),
> +	IEEE80211_CONF_SUPPORT_HT_MODE	=3D (1<<2),
>  };
> =20
>  /**
> @@ -434,6 +473,8 @@ enum ieee80211_conf_flags {
>   * @antenna_sel_tx: transmit antenna selection, 0: default/diversity,
>   *	1/2: antenna 0/1
>   * @antenna_sel_rx: receive antenna selection, like @antenna_sel_tx
> + * @ht_conf: describes current self configuration of 802.11n HT capabili=
es
> + * @ht_bss_conf: describes current BSS configuration of 802.11n HT param=
eters
>   */
>  struct ieee80211_conf {
>  	int channel;			/* IEEE 802.11 channel number */
> @@ -452,6 +493,8 @@ struct ieee80211_conf {
>  	u8 antenna_max;
>  	u8 antenna_sel_tx;
>  	u8 antenna_sel_rx;
> +	struct ieee80211_ht_info ht_conf;
> +	struct ieee80211_ht_bss_info ht_bss_conf;
>  };
> =20
>  /**
> diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
> index 8f7ebe4..e1a4ac1 100644
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -99,6 +99,9 @@ struct sta_info {
> =20
>  	u16 listen_interval;
> =20
> +	struct ieee80211_ht_info ht_info; /* 802.11n HT capabilities
> +					     of this STA */
> +
>  #ifdef CONFIG_MAC80211_DEBUGFS
>  	struct sta_info_debugfsdentries {
>  		struct dentry *dir;

--=-ccRXpYI1JQg6U0hWR33a
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r0KqVg1VMiehFYAQLwFQ//ZfzCGzapUxSEIPO7nVEbKkwLEttW6PKW
Uan48H+XEgr7QS9FB0Ez+8M0kVwB3t1F91ePL/VZXHazCFXE11PyUC6CG4p1e/6n
9k2vTy4+5RUC+pugT1I0dnXDWliicPspjW+6Jg02WDVHyt5b2T5amQvQz4RPSU0K
vfwAIe18wHP1rO6hUrWdL1C58wmtL0ZzH+j+xj/4PkOTDNwKJiNEFDXXUEqSW++x
2Vxi3rmb+BRui5uE8ttIjJ40MFMI9QALeqFUgpeSwbj0r3QsGPHxZingXLr5s6I1
p0RUTAED1WgBz5pNdwaG6dqzxdLls4L/ait4OWlnpGw/viIAY1nA1ATJqVjlbXiL
BLN3udEkfGjflh1lxqomg5/ZT8DC4xP1NQnckBlCUtaoWtv0yBwyC+KbdshsmVCz
JFNuiOdGWKc8uX6kchWhVvIaWGer7WO0NuRW7/pV0RP2pHON9xE7Fy3Xp/LHXZLx
AK76Wxlohr8da5ctTP8IpwfueOOsrsM1mcMJUzhJ3cry05lDuh3kaVEGsNiHg/pM
Lyy6xGoNSdtDRbtAK6Q9ODssf8B2bQ/PqEPjpqgKp0jOPCzjtdzdQvSql70q4TT0
uSEihLVqurD+cvLbMCRgeR6WPZzi98duKTrGzW53l5AyyKvJuEpiEJgVcBQxjRuw
6qkEoWT7LOM=
=79CU
-----END PGP SIGNATURE-----

--=-ccRXpYI1JQg6U0hWR33a--

