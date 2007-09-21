Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.235]:47877 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765718AbXIUVEZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 17:04:25 -0400
Received: by wx-out-0506.google.com with SMTP id h31so762315wxd
        for <linux-wireless@vger.kernel.org>; Fri, 21 Sep 2007 14:04:24 -0700 (PDT)
Date: Fri, 21 Sep 2007 17:04:37 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@gentoo.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/5] Wireless: add IEEE-802.11 regualtory domain module
Message-ID: <20070921210437.GG31768@pogo>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MIdTMoZhcV1D07fI"
In-Reply-To: <20070921204606.GD31768@pogo>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--MIdTMoZhcV1D07fI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This adds the regulatory domain module. It provides a way to
allocate and construct a regulatory domain based on the current
map. This module provides no enforcement, it just does the actual
building of the regdomain and returns it as defined in ieee80211_regdomains=
=2Eh

This module depends on the ISO3166-1 module.

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 include/net/ieee80211_regdomains.h |  196 ++++++++
 net/wireless/Kconfig               |   16 +
 net/wireless/Makefile              |    1 +
 net/wireless/reg_common.h          |  138 ++++++
 net/wireless/regdomains.c          |  751 ++++++++++++++++++++++++++++++
 net/wireless/regulatory_map.h      |  887 ++++++++++++++++++++++++++++++++=
++++
 6 files changed, 1989 insertions(+), 0 deletions(-)
 create mode 100644 include/net/ieee80211_regdomains.h
 create mode 100644 net/wireless/reg_common.h
 create mode 100644 net/wireless/regdomains.c
 create mode 100644 net/wireless/regulatory_map.h

diff --git a/include/net/ieee80211_regdomains.h b/include/net/ieee80211_reg=
domains.h
new file mode 100644
index 0000000..adf4de4
--- /dev/null
+++ b/include/net/ieee80211_regdomains.h
@@ -0,0 +1,196 @@
+#ifndef _IEEE80211_REGDOMAIN_H
+#define _IEEE80211_REGDOMAIN_H
+/*
+ * Copyright (C) 2006-2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ */
+
+#include <linux/kernel.h>
+#include <net/wireless_common.h>
+#include <net/iso3166-1.h>
+
+#define REGDOMAINS_VERSION "1.0"
+#define REGNAMSIZ		22
+#define REGSBNAMSIZ		30
+
+/* Changing this will change the default regulatory domain
+ * for countries we don't have a map for. Use World as default */
+#define DEFAULT_REG_ISO3166_1   "00"
+
+/* XXX: <net/ieee80211.h> has two band defs bellow */
+#ifndef IEEE80211_24GHZ_BAND
+#define IEEE80211_24GHZ_BAND     (1<<0)
+#define IEEE80211_52GHZ_BAND     (1<<1)
+#endif
+
+#define MAX_NUM_MODE_A_CHANS	220
+#define MAX_NUM_MODE_B_CHANS	26
+#define MAX_NUM_MODE_G_CHANS	26
+
+#define REG_NUM_SUBBANDS	7
+
+/**
+ * struct ieee80211_subband_restrictions - defines a regulatory domain
+ * 	subband restrictions list
+ *
+ * @band: which band we this subband belongs to, could be either IEEE80211=
_24GHZ_BAND
+ * 	or IEEE80211_52GHZ_BAND
+ * @name: name for this subband.
+ * @min_freq: minimum frequency for this subband, in MHz. This represents =
the=20
+ * 	center of frequency of a channel.
+ * @max_freq: maximum frequency for this subband, in MHz. This represents =
the=20
+ * 	center of frequency of a channel.
+ * @modulation_cap: modulations this subband is capable of handling. This =
can be
+ *	IEEE80211_RATE_OFDM, IEEE80211_RATE_CCK
+ * @environment_cap: defines indoor/outdoor capability for subband as defi=
ned by
+ * 	the 802.11d Country Information element char. This can be=20
+ * 	Indoor REG_CAP_INDOOR ('I'), REG_CAP_OUTDOOR ('O'), or both=20
+ * 	REG_CAP_INOUT (' ').
+ * @max_antenna_gain: defines the maximum antenna gain set by regulatory=
=20
+ * 	agencies for this subband. This is expressed in dBi, which is=20
+ * 	dB relative to isotropic, used to measure antenna gain compared to an
+ * 	isotropic antenna on which radiation is distributed uniformly on the
+ * 	surface of a sphere. This can be used to define mac80211's
+ * 	conf.antenna_max and channel.antenna_max for example.
+ * @max_ir_ptmp: maximum allowed Intentional Radiated power on the transmi=
tter
+ * 	for Point to Multi Points, given in dBm. This applies to stations,=20
+ * 	Access Points and PtMP bridges.
+ * @max_ir_ptmp: maximum allowed Intentional Radiated power on the transmi=
tter
+ *	for Point to Point links such as PtP Bridges, given in dBm.
+ * @max_eirp_ptmp: maximum allowed Equivalent Isotropically Radiated Power=
 on=20
+ *	the transmitter for Point to Point to Multi Points links, given in dBm
+ * @max_eirp_ptp: maximum allowed Equivalent Isotropically Radiated Power =
on=20
+ *	the transmitter for Point to Point links such as PtP Bridges, given in
+ *	dBm.
+ * @num_channels: number of channels in channel_list.
+ * @channel_list: linked list of all channels on this subband. These are of
+ * 	type @ieee80211_channel
+ *
+ * This structure contains the regualtory power restrictions on this subba=
nd=20
+ * and has a linked list of all possible channels. Wireless drivers can co=
mpute
+ * their maximum allowed TX power as follows:
+ *
+ * Max TX Power =3D Max EIRP - passive gain of antenna
+ *=20
+ * Keep in mind that the passive gain of the standard dipole antenna is ap=
prox
+ * 2.2 dBi. You can use this value for most wireless setups. Please note t=
hat=20
+ * some regulatory domains also have rules to which change the max IR if y=
ou=20
+ * change the antenna, such as the 1:1 and 3:1 rule for the FCC. For more=
=20
+ * information please refer to the Documentation/ieee80211_regdomains.txt
+ * documentation.
+ */
+struct ieee80211_subband_restrictions {
+	u8 band;
+	char name[REGSBNAMSIZ];
+	u16 min_freq;
+	u16 max_freq;
+	u32 modulation_cap;
+	u8 max_antenna_gain;
+	u8 max_ir_ptmp;
+	u8 max_ir_ptp;
+#define REG_DIPOLE_ANTENNA_GAIN 2
+	u8 max_eirp_ptmp;
+	u8 max_eirp_ptp;
+#define REG_CAP_INDOOR 	'I'
+#define REG_CAP_OUTDOOR	'O'
+#define REG_CAP_INOUT	' '
+	char environment_cap;
+	u8 num_channels;
+	struct list_head channel_list;
+};
+
+/**
+ * struct ieee80211_regdomain - defines a regulatory domain
+ *
+ * @regdomain_id: ID of this regulatory domain. Some come from
+ * 	http://standards.ieee.org/getieee802/download/802.11b-1999_Cor1-2001.p=
df
+ * @regdomain_name: name of this regulatory domain.
+ * @list: node, part of band_restrictions_list
+ *
+ * This structure defines a regulatory domain, which consists of channel a=
nd
+ * power restrictions. Some regulatory domains come from=20
+ * 802.11b-1999_Cor1-2001, the rest are based on Reyk Floeter's ar5k. If=
=20
+ * there is need to add more values here, please add one that is either=20
+ * defined in a standard or that many hardware devices have adopted. Also=
=20
+ * note that multiple countries can map to the same @regdomain_id
+ */
+struct ieee80211_regdomain {
+	u32 regdomain_id;
+	char regdomain_name[REGNAMSIZ];
+	struct ieee80211_subband_restrictions subbands[REG_NUM_SUBBANDS];
+};
+
+/**
+ * struct ieee80211_iso3166_reg_map - map of an ISO3166-1 country to a reg=
domain
+ *
+ * @alpha2: the ISO-3166-1 alpha2 country code string. Example: 'CR' for=
=20
+ * 	Costa Rica.
+ *
+ * @regdomain_id: a regualtory domain ID this country maps to.
+ *
+ * This structure holds the mapping of the country to a specific regulatory
+ * domain. Keep in mind more than one country can map to the same regulato=
ry
+ * domain. The ISO-3166-1 alpha2 country code also happens to be used in t=
he=20
+ * 802.11d Country Information Element on the string for the country. It=
=20
+ * should be noted, however, that in that the size of this string, is=20
+ * three octects while our string is only 2. The third octet is used to=20
+ * indicate Indoor/outdoor capabilities which we set in=20
+ * @ieee80211_subband_restrictions environment_cap.
+ */
+struct ieee80211_iso3166_reg_map {
+	char alpha2[ISOCOUNTRYSIZ2];
+	u32 regdomain_id; /* stack-aware value */
+	/* XXX: shall we just use an array? */
+	struct list_head list; /* node, part of iso3166_reg_map_list */
+};
+
+/**
+ * regdomain_mhz2ieee - convert a frequency to an IEEE-80211 channel number
+ * @freq: center of frequency in MHz. We support a range:
+ * 	2412 - 2732 MHz (Channel 1 - 26) in the 2GHz band and=20
+ * 	5005 - 6100 MHz (Channel 1 - 220) in the 5GHz band.
+ *
+ * Given a frequency in MHz returns the respective IEEE-80211 channel
+ * number. You are expected to provide the center of freqency in MHz.
+ */
+u16 regdomain_mhz2ieee(u16 freq);
+
+/**
+ * regdomain_ieee2mhz - convert an IEEE-80211 channel number to frequency
+ * @chan: An IEEE-802.11 channel number we support the range:
+ * 	Channel 1 - 26 in the 2GHz band and
+ * 	Channel 1 - 220 in the 5GHz band
+ *
+ * @band: Which band we want the frequency in, could be either=20
+ * 	IEEE80211_24GHZ_BAND or IEEE80211_52GHZ_BAND.
+ *
+ * Given an IEEE-802.11 channel number and band returns the respective cen=
ter
+ * of frequency in MHz.
+ */
+u16 regdomain_ieee2mhz(u16 chan, u8 band);
+
+void print_regdomain(struct ieee80211_regdomain *);
+void print_iso3166_reg_map(void);
+
+int get_ieee80211_regname(u32, char *);
+
+int iso3166_to_reg_exists(char *);
+int iso3166_to_reg(char *, u32 *);
+
+int regdomain_build(u32, struct ieee80211_regdomain **);
+void free_regdomain(struct ieee80211_regdomain *);
+u32 ieee80211_mode_modulation(u8 mode);
+
+#endif /* _IEEE80211_REGDOMAIN_H_ */=20
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index d03cd53..c60ee87 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -14,6 +14,22 @@ config NL80211
=20
          If unsure, say Y.
=20
+config IEEE80211_REGDOMAINS
+	tristate "Central IEEE 802.11 regulatory domain agent"
+	select ISO3166_1
+	---help---
+	 This option enables the a regdomains part of the central
+	 regulatory domain agent for the kernel. If added as a module=20
+	 the module will be called regdomains.ko.
+	=20
+	 If unsure, you can safely say Y.
+
+config IEEE80211_REGDOMAINS_DBG
+	bool "Enables debugging output for the regulatory domain agent"
+	depends on IEEE80211_REGDOMAINS
+	---help---
+	 This option enables debug for the central regulatory domain agent
+
 config ISO3166_1
 	tristate "ISO 3166-1 support (for 802.11d and regulatory)"
 	---help---
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index f710044..74c1059 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -4,4 +4,5 @@ obj-$(CONFIG_CFG80211) +=3D cfg80211.o
 cfg80211-y +=3D core.o sysfs.o radiotap.o
 cfg80211-$(CONFIG_NL80211) +=3D nl80211.o
=20
+obj-$(CONFIG_IEEE80211_REGDOMAINS) +=3D regdomains.o
 obj-$(CONFIG_ISO3166_1) +=3D iso3166-1.o
diff --git a/net/wireless/reg_common.h b/net/wireless/reg_common.h
new file mode 100644
index 0000000..460761b
--- /dev/null
+++ b/net/wireless/reg_common.h
@@ -0,0 +1,138 @@
+#ifndef _REGULATORY_COMMON_H_
+
+#define REG_2GHZ_MIN	2412	/* 2GHz channel 1 */
+#define REG_2GHZ_MAX	2732	/* 2GHz channel 26 */
+#define REG_5GHZ_MIN	5005	/* 5GHz channel 1 */
+#define REG_5GHZ_MAX	6100	/* 5GHz channel 220 */
+
+#define DMN_NULL_WORLD	0x03 /* World default */
+#define DMN_NULL_ETSIB	0x07
+#define DMN_NULL_ETSIC	0x08
+#define DMN_FCC1_FCCA	0x10
+#define DMN_FCC1_WORLD	0x11
+#define DMN_FCC2_FCCA	0x20
+#define DMN_FCC2_WORLD	0x21
+#define DMN_FCC2_ETSIC	0x22
+#define DMN_FCC3_FCCA	0x3A
+#define DMN_ETSI1_WORLD	0x37
+#define DMN_ETSI3_ETSIA	0x32
+#define DMN_ETSI2_WORLD	0x35
+#define DMN_ETSI3_WORLD	0x36
+#define DMN_ETSI4_WORLD	0x30
+#define DMN_ETSI4_ETSIC	0x38
+#define DMN_ETSI5_WORLD	0x39
+#define DMN_ETSI6_WORLD	0x34
+#define DMN_MKK1_MKKA	0x40
+#define DMN_MKK1_MKKB	0x41
+#define DMN_APL4_WORLD	0x42
+#define DMN_MKK2_MKKA	0x43
+#define DMN_APL2_WORLD	0x45
+#define DMN_APL2_APLC	0x46
+#define DMN_APL3_WORLD	0x47
+#define DMN_MKK1_FCCA	0x48
+#define DMN_APL2_APLD	0x49
+#define DMN_MKK1_MKKA1	0x4A
+#define DMN_MKK1_MKKA2	0x4B
+#define DMN_APL1_WORLD	0x52
+#define DMN_APL1_FCCA	0x53
+#define DMN_APL1_APLA	0x54
+#define DMN_APL1_ETSIC	0x55
+#define DMN_APL2_ETSIC	0x56
+#define DMN_APL5_WORLD	0x58
+#define DMN_DEBUG_DEBUG	0xFF
+
+/* 2.4GHz and 5GHz common subbands */
+#define	DMN_APL1	(1<<0)
+#define DMN_APL2	(1<<1)
+#define DMN_APL3	(1<<2)
+#define DMN_APL4	(1<<3)
+#define DMN_APL5	(1<<4)
+#define DMN_ETSI1	(1<<5)
+#define DMN_ETSI2	(1<<6)
+#define DMN_ETSI3	(1<<7)
+#define DMN_ETSI4	(1<<8)
+#define DMN_ETSI5	(1<<9)
+#define DMN_ETSI6	(1<<10)
+#define DMN_ETSIA	(1<<11)
+#define DMN_ETSIB	(1<<12)
+#define DMN_ETSIC	(1<<13)
+#define DMN_FCC1	(1<<14)
+#define DMN_FCC2	(1<<15)
+#define DMN_FCC3	(1<<16)
+#define DMN_FCCA	(1<<17)
+#define DMN_APLD	(1<<18)
+#define DMN_MKK1	(1<<19)
+#define DMN_MKK2	(1<<20)
+#define DMN_MKKA	(1<<21)
+#define DMN_NULL	(1<<22)
+#define DMN_WORLD	(1<<23)
+#define DMN_DEBUG	(1<<31) /* Use on any map for debugging */
+
+/* Default max antenna gain, in dBi */
+#define REG_MAX_ANTENNA	6
+
+/* Subbands definitions. We break the IEEE-802.11 spectrum into 7=20
+ * logical subbands */
+#define DMN_SB_ISM24	0
+#define DMN_SB_TELEC	1
+#define DMN_SB_UNII_1	2
+#define DMN_SB_UNII_2	3
+#define DMN_SB_ETSI	4
+#define DMN_SB_UNII_3	5
+#define DMN_SB_AAD	6
+
+#define REG_ISM24_MIN		2412	/* 2GHz channel 1 */
+#define REG_ISM24_MAX		2732	/* 2GHz channel 26 */
+#define REG_TELEC_MIN 		5005 	/* 5GHz channel 1 */
+#define REG_TELEC_MAX 		5145 	/* 5GHz channel 29 */
+#define REG_UNII_1_MIN 		5150 	/* 5GHz channel 30 */
+#define REG_UNII_1_MAX 		5245	/* 5GHz channel 49 */
+#define REG_UNII_2_MIN 		5250	/* 5GHz channel 50 */
+#define REG_UNII_2_MAX 		5350	/* 5GHz channel 70 */
+#define REG_ETSI_MIN		5355	/* 5GHz channel 71 */
+#define REG_ETSI_MAX		5720	/* 5GHz channel 144 */
+#define REG_UNII_3_MIN 		5725	/* 5GHz channel 145 */
+#define REG_UNII_3_MAX 		5825	/* 5GHz channel 165 */
+#define REG_AAD_MIN		5830	/* 5GHz channel 166 */
+#define REG_AAD_MAX 		6100	/* 5GHz channel 220 */
+
+/* Just FYI for now, technically DSRC is Dedicated Short Range Communicati=
ons,=20
+ * for vehicles in North America (USA, Canada, and Mexico) */
+#define REG_DSRC_MIN		5850
+#define REG_DSRC_MAX		5925
+
+/* 2.4GHz power subband IDs, note the entire world enables the=20
+ * 2.4GHz subband */
+#define	DMN_P24_FCC	(2<<1)
+#define	DMN_P24_ETSI	(2<<2)
+#define DMN_P24_MKK	(2<<3)
+#define	DMN_P24_WORLD	(2<<4)
+
+/* Now for all 5GHz power subbands IDs, note that WORLD
+ * regdomain has no 5GHz subbands */
+
+/* TELEC subband */
+#define	DMN_PT_MKK	(2<<0)
+/* UNII-1 Used for indoor -- regulations require use of an integrated ante=
nna */
+#define	DMN_PU1_FCC	(2<<1)
+#define	DMN_PU1_ETSI	(2<<2)
+#define	DMN_PU1_MKK	(2<<3)
+#define	DMN_PU1_APL	(2<<4)
+/* UNII-2 Used for indoor -- regulations allow for a user-installable ante=
nna */
+#define	DMN_PU2_FCC	(2<<5)
+#define	DMN_PU2_ETSI	(2<<6)
+#define	DMN_PU2_APL	(2<<7)
+/* ETSI band */
+#define	DMN_PE_FCC	(2<<8)
+#define	DMN_PE_ETSI	(2<<9)
+/* UNII-3 Used for both outdoor and indoor use -- subject to=20
+ * Dynamic Frequency Selection (DFS, or radar avoidance */
+#define	DMN_PU3_FCC	(2<<10)
+#define	DMN_PU3_APL	(2<<11)
+/* Asia/Africa/DSRC */
+/* XXX: fill these power restrictions out, for now only
+ * debug makes use of it */
+//#define	DMN_PA_FCC	(2<<12)
+//#define	DMN_PA_MKK	(2<<13)
+
+#endif /*_REGULATORY_COMMON_H_ */
diff --git a/net/wireless/regdomains.c b/net/wireless/regdomains.c
new file mode 100644
index 0000000..b9f79fd
--- /dev/null
+++ b/net/wireless/regdomains.c
@@ -0,0 +1,751 @@
+/*
+ * Copyright (c) 2004, 2005 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2006, 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ */
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <net/ieee80211_regdomains.h>
+#include "regulatory_map.h"
+
+#define DRV_NAME	"ieee80211_regdomains"
+#define DRV_DESCRIPTION	"IEEE-802.11 Regulatory Domain wireless driver"
+#define DRV_VERSION	REGDOMAINS_VERSION
+
+MODULE_AUTHOR("Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>");
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_DESCRIPTION(DRV_DESCRIPTION);
+MODULE_VERSION(DRV_VERSION);
+
+LIST_HEAD(iso3166_reg_map_list);
+EXPORT_SYMBOL(iso3166_reg_map_list);
+
+rwlock_t iso3166_reg_rwlock	=3D RW_LOCK_UNLOCKED;
+EXPORT_SYMBOL(iso3166_reg_rwlock);
+
+/*=20
+ * Loads regulatory maps, used to build regualtory domains. We later
+ * can provide support to update maps via nl80211 or configfs. */
+struct reg_band		reg_band_map[] =3D	REG_MAP;
+struct reg_channel	reg_2ghz_channels[] =3D	REG_CHANNELS_2GHZ;
+struct reg_channel	reg_5ghz_channels[] =3D	REG_CHANNELS_5GHZ;
+struct reg_domainname	reg_domainname_map[] =3D	REG_NAMES;
+struct reg_country	reg_ctry_map[] =3D	REG_COUNTRY_NAMES;
+struct reg_subband	reg_subbands_map[] =3D	REG_SUBBANDS;
+struct reg_pw		reg_pw_2ghz_map[] =3D	REG_PW_24_MAP;
+struct reg_pw		reg_pw_t_map[] =3D	REG_PW_T_MAP;
+struct reg_pw		reg_pw_u1_map[] =3D	REG_PW_U1_MAP;
+struct reg_pw		reg_pw_u2_map[] =3D	REG_PW_U2_MAP;
+struct reg_pw		reg_pw_e_map[] =3D	REG_PW_E_MAP;
+struct reg_pw		reg_pw_u3_map[] =3D	REG_PW_U3_MAP;
+struct reg_pw		reg_pw_aad_map[] =3D	REG_PW_AAD_MAP;
+struct reg_pw_subbands	reg_pw_map[] =3D		REG_PW_MAP;
+
+/* Add any exceptions to the official ISO3166-1 alpha map here */
+static char *iso3166_1_exceptions[] =3D {=20
+	"00", /* World regulatory domain */
+	"F2",=20
+	"J1", "J2", "J3", "J4", "J5", /* Japan is complicated... */
+	"K2",=20
+	"UK", /* UK's alpha2 is actually GB ;) */
+	"99" /* Used for debugging */
+};
+
+static inline int is_iso3166_1_exception(char *alpha2)
+{
+	int i;
+	for (i=3D0; i<ARRAY_SIZE(iso3166_1_exceptions); i++)
+		if(strncmp(alpha2, iso3166_1_exceptions[i], 2)=3D=3D0)
+		return 1;
+	return 0;
+}
+
+static u32 ieee80211_regdomain2flag(u32 regdomain, u16 mhz)
+{
+	int i;
+	for (i =3D 0; i < ARRAY_SIZE(reg_band_map); i++) {
+		if (reg_band_map[i].rm_domain =3D=3D regdomain) {
+			if (mhz >=3D 2000 && mhz <=3D 3000)
+				return((u32)reg_band_map[i].rm_domain_2ghz);
+			if (mhz >=3D REG_5GHZ_MIN &&=20
+			    mhz <=3D REG_5GHZ_MAX)
+				return((u32)reg_band_map[i].rm_domain_5ghz);
+		}
+	}
+	return((u32)DMN_DEBUG);
+}
+
+static int ieee80211_regdomain2name(u32 regdomain, char *name)
+{
+	int i;
+	/* Linear search over the table */
+	for(i =3D 0; i < ARRAY_SIZE(reg_domainname_map); i++)
+		if(reg_domainname_map[i].rn_domain =3D=3D regdomain) {
+			memcpy(name, reg_domainname_map[i].rn_name, REGNAMSIZ);
+			return 0;
+		}
+	printk("No regdomain name matches regdomain: %0x\n", regdomain);
+	return -ENOENT;
+}
+
+int freq_to_subband(u16 freq, u32 *sb_id)
+{
+	int i;
+	struct reg_subband *sb;
+	for (i=3D0; i < ARRAY_SIZE(reg_subbands_map); i++) {
+		sb =3D &reg_subbands_map[i];
+		if (freq <=3D sb->sb_max_freq && freq >=3D sb->sb_min_freq) {
+			*sb_id =3D sb->sb_id;
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static void update_reg_subband_map()
+{
+	reg_subbands_map[DMN_SB_ISM24].sb_reg_pw =3D reg_pw_2ghz_map;
+	reg_subbands_map[DMN_SB_ISM24].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_2ghz_=
map);
+
+	reg_subbands_map[DMN_SB_TELEC].sb_reg_pw =3D reg_pw_t_map;
+	reg_subbands_map[DMN_SB_TELEC].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_t_map=
);
+
+	reg_subbands_map[DMN_SB_UNII_1].sb_reg_pw =3D reg_pw_u1_map;
+	reg_subbands_map[DMN_SB_UNII_1].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_u1_m=
ap);
+
+	reg_subbands_map[DMN_SB_UNII_2].sb_reg_pw =3D reg_pw_u2_map;
+	reg_subbands_map[DMN_SB_UNII_2].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_u2_m=
ap);
+
+	reg_subbands_map[DMN_SB_ETSI].sb_reg_pw =3D reg_pw_e_map;
+	reg_subbands_map[DMN_SB_ETSI].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_e_map);
+
+	reg_subbands_map[DMN_SB_UNII_3].sb_reg_pw =3D reg_pw_u3_map;
+	reg_subbands_map[DMN_SB_UNII_3].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_u3_m=
ap);
+
+	reg_subbands_map[DMN_SB_AAD].sb_reg_pw =3D reg_pw_aad_map;
+	reg_subbands_map[DMN_SB_AAD].sb_reg_pw_size =3D ARRAY_SIZE(reg_pw_aad_map=
);
+}
+
+static int get_subband_pw_id(u32 regdomain, u32 sb_id, u32 *pw_id)
+{
+	int i;
+	struct reg_pw_subbands *pw_sb;
+	for (i=3D0; i <=3D ARRAY_SIZE(reg_pw_map); i++) {
+		pw_sb =3D &reg_pw_map[i];
+		if (pw_sb->domain_id =3D=3D regdomain) {
+			switch(sb_id) {
+				case DMN_SB_ISM24:
+					*pw_id =3D pw_sb->p_domain_2ghz;
+					break;
+				case DMN_SB_TELEC:
+					*pw_id =3D pw_sb->p_domain_telec;
+					break;
+				case DMN_SB_UNII_1:
+					*pw_id =3D pw_sb->p_domain_unii1;
+					break;
+				case DMN_SB_UNII_2:
+					*pw_id =3D pw_sb->p_domain_unii2;
+					break;
+				case DMN_SB_ETSI:
+					*pw_id =3D pw_sb->p_domain_etsi;
+					break;
+				case DMN_SB_UNII_3:
+					*pw_id =3D pw_sb->p_domain_unii3;
+					break;
+				case DMN_SB_AAD:
+					*pw_id =3D pw_sb->p_domain_aad;
+					break;
+				default:=09
+					return -ENOENT;
+			}
+			return 0;
+		}
+	}
+	return -ENOENT;
+}
+
+
+/* XXX: change to return u8 when ieee80211_channel chan gets changed */
+u16 regdomain_mhz2ieee(u16 freq)
+{
+	if (freq >=3D REG_2GHZ_MIN &&  /* Channel 1 */
+		freq <=3D REG_2GHZ_MAX) { /* Channel 26 */
+		if (freq =3D=3D 2484) /* Japan */
+			return 14;
+		if ((freq >=3D 2412) && (freq < 2484))
+			return (freq - 2407) / 5;
+		if (freq < 2512) /* No new channel until 2512 */
+			return 0;
+		return ((freq - 2512)/20) + 15; /* 15-26 */
+	} else if (freq >=3D REG_5GHZ_MIN && /* Channel 1 */
+		freq <=3D REG_5GHZ_MAX) { /* Channel 220 */
+		return (freq - 5000) / 5;
+	} else
+	return 0;
+}
+EXPORT_SYMBOL(regdomain_mhz2ieee);
+
+/* XXX: change arg1 to u8 when ieee80211_channel chan gets changed */
+u16 regdomain_ieee2mhz(u16 chan, u8 band)
+{
+	switch (band) {
+	case IEEE80211_24GHZ_BAND:
+		if (chan > MAX_NUM_MODE_G_CHANS || chan =3D=3D 0) {
+			BUG();
+			return 0;
+		}
+		if (chan < 14)
+			return (2407 + (chan * 5));
+		else if (chan =3D=3D 14)
+			return 2484;
+		else if (chan =3D=3D 15)
+			return 2512;
+		else
+			return (2492 + (chan * 20));
+	case IEEE80211_52GHZ_BAND:
+		if (chan > MAX_NUM_MODE_A_CHANS || chan =3D=3D 0) {
+			BUG();
+			return 0;
+		}
+		return ((5000) + (chan * 5));
+	default:
+		BUG();
+		return 0;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(regdomain_ieee2mhz);
+
+static inline u8 freq_band_id(u16 freq)
+{
+	if (freq >=3D REG_2GHZ_MIN &&  /* Channel 1 */
+		freq <=3D REG_2GHZ_MAX) /* Channel 26 */
+		return IEEE80211_24GHZ_BAND;
+	else if (freq >=3D REG_5GHZ_MIN && /* Channel 1 */
+		freq <=3D REG_5GHZ_MAX) /* Channel 220 */
+		return IEEE80211_52GHZ_BAND;
+	else {
+		BUG();
+		return -EINVAL;
+	}
+=09
+}
+
+static inline int is_japan_regdomain_id(u32 regdomain_id)
+{
+	switch(regdomain_id) {
+	case DMN_MKK1_MKKB:
+	case DMN_MKK1_FCCA:
+	case DMN_MKK1_MKKA:
+	case DMN_MKK2_MKKA:
+	case DMN_MKK1_MKKA1:
+	case DMN_MKK1_MKKA2:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
+u32 ieee80211_mode_modulation(u8 mode)
+{
+	switch (mode) {
+	case MODE_IEEE80211A:
+		return IEEE80211_RATE_OFDM;
+	case MODE_IEEE80211B:
+		return IEEE80211_RATE_CCK;
+	case MODE_IEEE80211G:
+		return IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM;
+	}
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_mode_modulation);
+
+static inline void setup_regdomain(struct ieee80211_regdomain *r,
+		u8 regdomain_id, char *regdomain_name)
+{
+	strcpy(r->regdomain_name, regdomain_name);
+	r->regdomain_id =3D regdomain_id;
+}
+
+static inline void setup_subband_restrictions(
+		struct ieee80211_subband_restrictions *sb, char *name,
+		u16 min_freq, u16 max_freq, u8 max_antenna_gain,
+		u8 max_ir_ptmp, u8 max_ir_ptp,
+		u8 max_eirp_ptmp, u8 max_eirp_ptp,
+		char environment_cap)
+{
+	memcpy(sb->name, name, REGSBNAMSIZ);
+	sb->band =3D freq_band_id(min_freq);
+	sb->min_freq =3D min_freq;
+	sb->max_freq =3D max_freq;
+	sb->max_antenna_gain =3D max_antenna_gain;
+	sb->max_ir_ptmp =3D max_ir_ptmp;
+	sb->max_ir_ptp =3D max_ir_ptp;
+	sb->max_eirp_ptmp =3D max_eirp_ptmp;
+	sb->max_eirp_ptp =3D max_eirp_ptp;
+	sb->environment_cap =3D environment_cap;
+}
+
+static inline void setup_reg_channel(u32 regdomain_id,
+		struct ieee80211_channel *chan,
+		struct ieee80211_subband_restrictions *sb,
+		struct reg_channel *r_channel)
+{
+	chan->freq =3D r_channel->rc_freq;
+	chan->modulation_cap =3D r_channel->rc_modulation_cap;
+	/* We set chan->val with what is common, drivers can overwrite=20
+	 * that if they so wish to */
+	chan->chan =3D chan->val =3D regdomain_mhz2ieee(chan->freq);
+
+	chan->flag =3D IEEE80211_CHAN_W_SCAN |=20
+		IEEE80211_CHAN_W_ACTIVE_SCAN |
+		IEEE80211_CHAN_W_IBSS;
+
+	/* For now assume standard dipole antenna */
+	chan->power_level =3D sb->max_eirp_ptmp - REG_DIPOLE_ANTENNA_GAIN;
+
+	if (chan->freq > REG_5GHZ_MIN) {
+		/* New regulatory rules in japan don't allow scan in
+ 		 * these old channels (5.15-5.25 GHz). This is an
+ 		 * excemption to common regulatory rules so we add=20
+ 		 * it here */
+		if (is_japan_regdomain_id(regdomain_id) &&
+		  (chan->freq =3D=3D 5170 || chan->freq =3D=3D 5190 ||
+		  chan->freq =3D=3D 5210 || chan->freq =3D=3D 5230))
+			chan->flag &=3D ~IEEE80211_CHAN_W_ACTIVE_SCAN;
+	}
+}
+
+static void free_subband_channel_list(struct list_head *channel_list)
+{=09
+	struct ieee80211_channel *chan, *chan_tmp;
+	list_for_each_entry_safe(chan, chan_tmp, channel_list, list) {
+		list_del(&chan->list);
+		if (chan !=3D NULL)
+			kfree(chan);
+	}
+}
+
+void free_regdomain(struct ieee80211_regdomain *reg)
+{
+	struct ieee80211_subband_restrictions *sb;
+	int y;
+	for (y=3D0; y<REG_NUM_SUBBANDS; y++) {
+		sb =3D &reg->subbands[y];
+		if (! list_empty(&sb->channel_list)) {
+			free_subband_channel_list(&sb->channel_list);
+		}
+		list_del(&sb->channel_list);
+	}
+	kfree(reg);
+}
+EXPORT_SYMBOL(free_regdomain);
+
+static void free_iso3166_reg_map_list(void)
+{
+	struct ieee80211_iso3166_reg_map *map, *tmp;
+	list_for_each_entry_safe(map, tmp, &iso3166_reg_map_list, list) {
+		list_del(&map->list);
+		kfree(map);
+	}
+}
+
+static inline int check_reg_init(int r, char *reg_name)
+{
+	printk("%s: regulatory domain %s ", DRV_NAME, reg_name);
+	switch(r) {
+		case -ENOMEM:
+			printk("Unable to allocate memory\n");
+			break;
+		case -EINVAL:
+			printk("reg_name is invalid\n");
+			break;
+		case 0:
+			printk("created\n");
+			break;
+		default:
+			printk("Unexpected error detected\n");
+			r =3D -EINVAL;
+			break;
+	}
+	return r;
+}
+
+void print_regdomain(struct ieee80211_regdomain *reg)
+{
+	struct ieee80211_subband_restrictions *sb;
+	struct ieee80211_channel *chan;
+	int y;
+
+	u32 modulation_a =3D ieee80211_mode_modulation(MODE_IEEE80211A);
+	u32 modulation_b =3D ieee80211_mode_modulation(MODE_IEEE80211B);
+	u32 modulation_g =3D ieee80211_mode_modulation(MODE_IEEE80211G);
+
+	if (reg =3D=3D NULL) {
+		printk("Invalid regulatory domain encountered\n");
+		return;
+	}
+
+	printk("Regulatory Domain:\t%s\tRegulatory Domain ID:\t0x%02x\n",
+			reg->regdomain_name,
+			reg->regdomain_id);
+
+=09
+	for (y=3D0; y < REG_NUM_SUBBANDS; y++) {
+		sb =3D &reg->subbands[y];
+		if (sb->num_channels =3D=3D 0)
+			continue;
+		switch (sb->band) {
+		case IEEE80211_24GHZ_BAND:
+			if (sb->modulation_cap =3D=3D modulation_b)
+				printk("\tIEEE 802.11b\t2GHz\t%s subband", sb->name);
+			else if (sb->modulation_cap =3D=3D modulation_g)
+				printk("\tIEEE 802.11g\t2GHz\t%s subband", sb->name);
+			else=20
+				BUG();
+			break;
+		case IEEE80211_52GHZ_BAND:
+			if (sb->modulation_cap =3D=3D modulation_a) {
+				printk("\tIEEE 802.11a\t5GHz\t%s subband", sb->name);
+			}
+			else
+				BUG();
+			break;
+		default:
+			BUG();
+			break;
+		}
+
+		printk("\n\tmax_ir_ptmp:\t%d dBm\tmax_eirp_ptmp:\t%d dBm\n",=20
+			sb->max_ir_ptmp, sb->max_eirp_ptmp);
+		printk("\tmax_ir_ptp:\t%d dBm\tmax_eirp_ptp:\t%d dBm\n",=20
+			sb->max_ir_ptp, sb->max_eirp_ptp);
+		printk("\tmax_antenna_gain:\t%d dBi\n"
+			"\tEnvironment capability:\t", sb->max_antenna_gain);
+		if(sb->environment_cap =3D=3D REG_CAP_INDOOR)
+			printk("Indoor\n");
+		else if(sb->environment_cap =3D=3D REG_CAP_OUTDOOR)
+			printk("Outdoor\n");
+		else if(sb->environment_cap =3D=3D REG_CAP_INOUT)
+			printk("Indoor & Outdoor\n");
+		else
+			BUG();
+		printk("\t\tChannel\tFreq (MHz)\t\n");
+
+		list_for_each_entry(chan, &sb->channel_list, list){
+			printk("\t\t%d\t%d\t\n", chan->chan, chan->freq);
+		}
+	}
+	printk("\n");
+}
+EXPORT_SYMBOL(print_regdomain);
+
+#ifdef CONFIG_IEEE80211_REGDOMAINS_DBG
+void print_iso3166_reg_map(void)
+{
+	struct ieee80211_iso3166_reg_map *map;
+	char regdomain_name[REGNAMSIZ];
+	printk("ISO3166 <--> regulatory domain map:\n");
+	printk("CTRY\t-->\tRegdomain\n");
+	read_lock(&iso3166_reg_rwlock);
+	list_for_each_entry(map, &iso3166_reg_map_list, list) {
+		if (ieee80211_regdomain2name(map->regdomain_id, regdomain_name))
+			printk("%s\t-->\t0x%02x (reg_id not registered in "
+					"regulatory db)\n",=20
+					map->alpha2, map->regdomain_id);
+		else
+			printk("%s\t-->\t%s\n", map->alpha2, regdomain_name);
+	}
+	read_unlock(&iso3166_reg_rwlock);
+}
+#else
+
+void print_iso3166_reg_map(void)
+{
+	return;
+}
+#endif /* CONFIG_IEEE80211_REGDOMAINS_DBG */
+EXPORT_SYMBOL(print_iso3166_reg_map);
+
+static inline void setup_iso3166_reg_map(struct ieee80211_iso3166_reg_map =
*map,
+		char *alpha2, u32 regdomain_id)
+{
+	strcpy(map->alpha2, alpha2);
+	map->regdomain_id =3D regdomain_id;
+}
+
+int iso3166_to_reg_exists(char *alpha2)
+{
+	struct ieee80211_iso3166_reg_map *map;
+	read_lock(&iso3166_reg_rwlock);
+	list_for_each_entry(map, &iso3166_reg_map_list, list)
+		if(strncmp(map->alpha2, alpha2, ISOCOUNTRYSIZ2-1)=3D=3D0) {
+			read_unlock(&iso3166_reg_rwlock);
+			return 1;
+		}
+	read_unlock(&iso3166_reg_rwlock);
+	return 0;
+}
+EXPORT_SYMBOL(iso3166_to_reg_exists);
+
+int iso3166_to_reg(char *alpha2, u32 *regdomain_id)
+{
+	struct ieee80211_iso3166_reg_map *map;
+	read_lock(&iso3166_reg_rwlock);
+	list_for_each_entry(map, &iso3166_reg_map_list, list)
+		if(strncmp(map->alpha2, alpha2, ISOCOUNTRYSIZ2-1)=3D=3D0) {
+			*regdomain_id =3D map->regdomain_id;
+			read_unlock(&iso3166_reg_rwlock);
+			return 0;
+		}
+	read_unlock(&iso3166_reg_rwlock);
+	return -ENOENT;
+}
+EXPORT_SYMBOL(iso3166_to_reg);
+
+static int add_iso3166_reg_map(char *alpha2, u32 regdomain_id)
+{
+	int r =3D 0;
+	struct ieee80211_iso3166_reg_map *map;
+	/* If not valid or iso map does already already present */
+	if((!iso3166_1_exists(alpha2) && !is_iso3166_1_exception(alpha2))=20
+		|| iso3166_to_reg_exists(alpha2)){
+		r =3D -EPERM;
+		goto exit;
+	}
+	write_lock(&iso3166_reg_rwlock);
+	map =3D kzalloc(sizeof(struct ieee80211_iso3166_reg_map), GFP_KERNEL);
+	if(map =3D=3D NULL) {
+		r =3D -ENOMEM;
+		goto unlock_and_exit;
+	}
+	setup_iso3166_reg_map(map, alpha2, regdomain_id);
+	list_add_tail(&map->list, &iso3166_reg_map_list);
+unlock_and_exit:
+	write_unlock(&iso3166_reg_rwlock);
+exit:
+	return r;
+}
+
+static int __load_iso3166_reg_map_list(void)
+{
+	int i, r =3D 0;
+	struct reg_country *r_country;
+	INIT_LIST_HEAD(&iso3166_reg_map_list);
+	for (i =3D 0; i < ARRAY_SIZE(reg_ctry_map); i++) {
+		r_country =3D &reg_ctry_map[i];
+		r =3D add_iso3166_reg_map(r_country->cn_name,=20
+			r_country->cn_domain);
+		if(r && r!=3D-ENOMEM) {
+			printk("%s: Skipping country <-> regdomain map for "
+				"country %s\n", DRV_NAME, r_country->cn_name);
+			r =3D 0;
+		}
+	}
+	return r;
+}
+
+static int __alloc_band_channels(u32 regdomain_id,=20
+	struct ieee80211_regdomain *reg, u8 band,=20
+	u32 sb_chan_domain)
+{
+	struct reg_channel *band_channels =3D NULL;
+	int band_channel_size =3D 0;
+	int i;
+
+	switch (band) {
+		case IEEE80211_24GHZ_BAND:
+			band_channels =3D reg_2ghz_channels;
+			band_channel_size =3D ARRAY_SIZE(reg_2ghz_channels);
+			break;
+		case IEEE80211_52GHZ_BAND:
+			band_channels =3D reg_5ghz_channels;
+			band_channel_size =3D ARRAY_SIZE(reg_5ghz_channels);
+			break;
+	}
+
+	for (i =3D 0; i < band_channel_size; i++) {
+		u32 sb_id =3D -1;
+		struct ieee80211_subband_restrictions *sb;
+		struct ieee80211_channel *sb_chan; /* For subband */
+		struct reg_subband *reg_sb;
+		struct reg_channel *r_channel =3D &band_channels[i];
+
+		if (r_channel->rc_domain !=3D sb_chan_domain)
+			continue;
+
+		BUG_ON(freq_to_subband(r_channel->rc_freq, &sb_id));
+		BUG_ON(&reg_subbands_map[sb_id] =3D=3D NULL);
+
+		sb =3D &reg->subbands[sb_id];
+		reg_sb =3D &reg_subbands_map[sb_id];
+
+		sb->modulation_cap |=3D r_channel->rc_modulation_cap;
+
+		/* Add to subband linked list */
+		sb_chan =3D kzalloc(sizeof(struct ieee80211_channel),=20
+					GFP_KERNEL);
+		if (sb_chan =3D=3D NULL)
+			return -ENOMEM;
+		setup_reg_channel(regdomain_id, sb_chan,=20
+				sb, r_channel);
+		list_add_tail(&sb_chan->list, &sb->channel_list);
+		sb->num_channels++;
+	}
+	return 0;
+}
+
+static int setup_reg_pw_restrictions(u32 regdomain_id,=20
+	struct ieee80211_regdomain *reg)
+{
+	int i, r =3D 0;
+	/* Iterate over our subbands and set respective power restrictions */
+	for (i=3D0; i < REG_NUM_SUBBANDS; i++) {
+		struct reg_subband *reg_sb;
+		struct reg_pw *sb_reg_pw;
+		struct ieee80211_subband_restrictions *sb;
+		u32 pw_sb_id =3D -1;
+		int pw_idx;
+
+		reg_sb =3D &reg_subbands_map[i];
+		/* Note, bellow is an array, we're going to iterate=20
+		 * through it later */
+		sb_reg_pw =3D reg_sb->sb_reg_pw;
+		BUG_ON(sb_reg_pw =3D=3D NULL);
+		sb =3D &reg->subbands[i];
+		/* Initialize all lists */
+		INIT_LIST_HEAD(&sb->channel_list);
+
+		/* Iterate through this subbands possible power maps, and setup
+		 * the subband as corresponds to this regdomain */
+		r =3D get_subband_pw_id(regdomain_id, i, &pw_sb_id);
+		BUG_ON(r);
+		for (pw_idx =3D 0; pw_idx < reg_sb->sb_reg_pw_size; pw_idx++) {
+			if (sb_reg_pw->p_domain !=3D pw_sb_id) {
+				sb_reg_pw++;
+				continue;
+			}
+			/* We found a match */
+			setup_subband_restrictions(sb, reg_sb->sb_name,
+				reg_sb->sb_min_freq, reg_sb->sb_max_freq,
+				sb_reg_pw->max_antenna_gain,
+				sb_reg_pw->max_ir_ptmp, sb_reg_pw->max_ir_ptp,
+				sb_reg_pw->max_eirp_ptmp,=20
+				sb_reg_pw->max_eirp_ptp,
+				sb_reg_pw->environment_cap);
+			break; /* Start working on next subband */
+		}
+	}
+	return r;
+}
+
+/* Called by users of this module, cfg80211 at the moment */
+int regdomain_build(u32 regdomain_id, struct ieee80211_regdomain **reg_p)
+{
+	struct ieee80211_regdomain *reg =3D NULL;
+	struct ieee80211_subband_restrictions *subbands =3D NULL;
+	char reg_name[REGNAMSIZ];
+	u32 reg_2ghz_id;
+	u32 reg_5ghz_id;
+	int i;
+	int r =3D -ENOMEM;
+
+	reg_2ghz_id =3D ieee80211_regdomain2flag(regdomain_id, REG_2GHZ_MIN);
+	reg_5ghz_id =3D ieee80211_regdomain2flag(regdomain_id, REG_5GHZ_MIN);
+	r =3D ieee80211_regdomain2name(regdomain_id, reg_name);
+	BUG_ON(r);
+
+	/* Allocate regdomain */
+	*reg_p =3D kzalloc(sizeof(struct ieee80211_regdomain), GFP_KERNEL);
+	if (reg) {
+		r =3D -ENOMEM;
+		goto exit;
+	}
+
+	reg =3D *reg_p;
+	subbands =3D reg->subbands;
+
+	/* First update subband power maps */
+	update_reg_subband_map();
+
+	/* Now update power restrictions */
+	r =3D setup_reg_pw_restrictions(regdomain_id, reg);
+	BUG_ON(r);
+=09
+	/* Allocate 2GHz channels for regdomain */
+	if (reg_2ghz_id !=3D DMN_NULL) {
+		r =3D __alloc_band_channels(regdomain_id, reg,=20
+			IEEE80211_24GHZ_BAND, reg_2ghz_id);
+		if (r)
+			goto free_sb_channels;
+	}
+
+	/* Allocate 5GHz channels for regdomain */
+	if (reg_5ghz_id !=3D DMN_NULL) {
+		r =3D __alloc_band_channels(regdomain_id, reg,=20
+			IEEE80211_52GHZ_BAND, reg_2ghz_id);
+		if (r)
+			goto free_sb_channels;
+	}
+
+	/* Setup regdomain, bands and subbands */
+	setup_regdomain(reg, regdomain_id, reg_name);
+	check_reg_init(r, reg_name);
+	return 0;
+
+free_sb_channels:
+	for (i=3D0; i < REG_NUM_SUBBANDS; i++) {
+		struct ieee80211_subband_restrictions *sb;
+		sb =3D &subbands[i];
+		if (! list_empty(&sb->channel_list))
+			free_subband_channel_list(&sb->channel_list);
+		list_del(&sb->channel_list);
+	}
+exit:
+	check_reg_init(r, reg_name);
+	return r;
+}
+EXPORT_SYMBOL(regdomain_build);
+
+static int regdomains_init(void)
+{
+	int r;
+	printk("%s: %s v%s loaded\n", DRV_NAME, DRV_DESCRIPTION, DRV_VERSION);
+
+	/* Load iso->reg map */
+	r =3D __load_iso3166_reg_map_list();
+	if(r)
+		goto free_iso_reg_map_list;
+	print_iso3166_reg_map();
+
+	return r;
+free_iso_reg_map_list:
+	free_iso3166_reg_map_list();
+	return r;
+}
+
+void regdomains_exit(void)
+{
+	/* Iso->reg map */
+	write_lock(&iso3166_reg_rwlock);
+	free_iso3166_reg_map_list();
+	list_del(&iso3166_reg_map_list);
+	write_unlock(&iso3166_reg_rwlock);
+	printk("%s: unloaded\n", DRV_NAME);
+}
+
+module_init(regdomains_init);
+module_exit(regdomains_exit);
diff --git a/net/wireless/regulatory_map.h b/net/wireless/regulatory_map.h
new file mode 100644
index 0000000..35fa358
--- /dev/null
+++ b/net/wireless/regulatory_map.h
@@ -0,0 +1,887 @@
+#ifndef _REGULATORY_MAP_H_
+/*
+ * Copyright (c) 2004, 2005 Reyk Floeter <reyk@openbsd.org>
+ * Copyright (c) 2007 Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
+ *
+ * Permission to use, copy, modify, and distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ */
+
+#include "reg_common.h"
+
+static int ieee80211_regdomain2name(u32, char *);
+static u32 ieee80211_regdomain2flag(u32, u16);
+
+static void update_reg_subband_map(void);
+static int get_subband_pw_id(u32, u32, u32 *);
+
+struct reg_channel {
+	u16	rc_freq; /* Center of frequency */
+	u32	rc_domain;
+	/* Can be IEEE80211_RATE_OFDM, IEEE80211_RATE_CCK,=20
+ 	 * depending on he rc_freq (mhz), we'll
+ 	 * use the modulation cap to configure mode on the subband=20
+ 	 * (MODE_IEEE80211A, MODE_IEEE80211B, MODE_IEEE80211G ) */=20
+	u32	rc_modulation_cap;
+};
+
+struct reg_domainname {
+	u32		rn_domain;
+	const char	*rn_name;
+};
+
+struct reg_pw {
+	u32 p_domain;
+	char environment_cap;
+/* As like the last (3rd) octect of 802.11d Country=20
+ * Information Element string */
+#define REG_CAP_INDOOR  'I'
+#define REG_CAP_OUTDOOR 'O'
+#define REG_CAP_INOUT   ' '
+	u8 max_antenna_gain;
+	u8 max_ir_ptmp;
+	u8 max_ir_ptp;
+	u8 max_eirp_ptmp;
+	u8 max_eirp_ptp;
+};
+
+struct reg_pw_subbands {
+	u32	domain_id;
+	u32	p_domain_2ghz;
+	u32	p_domain_telec;
+	u32	p_domain_unii1;
+	u32	p_domain_unii2;
+	u32	p_domain_etsi;
+	u32	p_domain_unii3;
+	u32	p_domain_aad;
+};
+
+struct reg_band {
+	u16	rm_domain;
+	u32	rm_domain_5ghz;
+	u32	rm_domain_2ghz;
+};
+
+struct reg_country {
+	/* ISO-3166-1 alpha 2 */
+	char	cn_name[2];
+	u32	cn_domain;
+};
+
+struct reg_subband {
+	u32	sb_id;
+	char	sb_name[30];
+	u16	sb_min_freq;
+	u16	sb_max_freq;
+	struct reg_pw *sb_reg_pw;
+	u8	sb_reg_pw_size;
+};
+
+#define REG_SUBBANDS { \
+	{ DMN_SB_ISM24,		"ISM", \
+		REG_ISM24_MIN,	REG_ISM24_MAX, NULL, 0 }, \
+	{ DMN_SB_TELEC,		"TELEC", \
+		REG_TELEC_MIN,	REG_TELEC_MAX, NULL, 0 }, \
+	{ DMN_SB_UNII_1,	"UNII-1", \
+		REG_UNII_1_MIN, REG_UNII_1_MAX, NULL, 0 }, \
+	{ DMN_SB_UNII_2,	"UNII-2 / ETSI", \
+		REG_UNII_2_MIN,	REG_UNII_2_MAX, NULL, 0 }, \
+	{ DMN_SB_ETSI,		"ETSI", \
+		REG_ETSI_MIN,	REG_ETSI_MAX, NULL, 0 }, \
+	{ DMN_SB_UNII_3,	"UNII-3", \
+		REG_UNII_3_MIN,	REG_UNII_3_MAX, NULL, 0 }, \
+	{ DMN_SB_AAD,		"Asia/Africa/DSRC", \
+		REG_AAD_MIN,	REG_AAD_MAX, NULL, 0 } \
+}
+
+/*
+ * EIRP	- Equivalent Isotropically Radiated Power
+ * IR	- Intentional Radiator, transmitter
+ * dBm	- dB milliwatt (mW), the base says that 1mW =3D 0 dBm
+ * dBi	- dB relative to isotropic, used to measure antenna gain compared t=
o an
+ * 	  isotropic antenna on which radiation is distributed uniformly on the
+ * 	  surface of a sphere=20
+ *
+ * EIRP =3D IR - loss in transmission line + passive gain of the antenna
+ */
+
+#define DMN_P5_NULL	DMN_NULL,	DMN_NULL,	DMN_NULL, \
+			DMN_NULL, 	DMN_NULL,	DMN_NULL
+#define DMN_P5_DEBUG	DMN_DEBUG,	DMN_DEBUG,	DMN_DEBUG, \
+			DMN_DEBUG, 	DMN_DEBUG,	DMN_DEBUG
+
+#define DMN_P5_FCC1	DMN_NULL,	DMN_PU1_FCC,	DMN_PU2_FCC, \
+			DMN_NULL,	DMN_PU3_FCC,	DMN_NULL
+#define DMN_P5_FCC2	DMN_P5_FCC1
+#define DMN_P5_FCC3	DMN_NULL,	DMN_PU1_FCC,	DMN_PU2_FCC, \
+			DMN_PE_FCC,	DMN_PU3_FCC,	DMN_NULL
+
+#define DMN_P5_ETSI1	DMN_NULL,	DMN_PU1_ETSI,	DMN_PU2_ETSI, \
+			DMN_PE_ETSI, 	DMN_NULL,	DMN_NULL
+#define DMN_P5_ETSI2	DMN_NULL,	DMN_PU1_ETSI,	DMN_NULL, \
+			DMN_NULL,	DMN_NULL,	DMN_NULL
+#define DMN_P5_ETSI3	DMN_NULL,	DMN_PU1_ETSI,	DMN_PU2_ETSI, \
+			DMN_NULL,	DMN_NULL,	DMN_NULL
+#define DMN_P5_ETSI4	DMN_P5_ETSI3
+#define DMN_P5_ETSI5	DMN_P5_ETSI2
+#define DMN_P5_ETSI6	DMN_NULL,	DMN_PU1_ETSI,	DMN_PU2_ETSI, \
+			DMN_PE_ETSI,	DMN_NULL,	DMN_NULL
+
+#define DMN_P5_MKK1	DMN_NULL,	DMN_PU1_MKK,	DMN_NULL, \
+			DMN_NULL,	DMN_NULL,	DMN_NULL
+#define DMN_P5_MKK2	DMN_PT_MKK,	DMN_PU1_MKK,	DMN_NULL, \
+			DMN_NULL,	DMN_NULL,	DMN_NULL
+
+#define DMN_P5_APL1	DMN_NULL,	DMN_NULL,	DMN_NULL, \
+			DMN_NULL,	DMN_PU3_APL,	DMN_NULL
+#define DMN_P5_APL2	DMN_P5_APL
+#define DMN_P5_APL3	DMN_NULL,	DMN_NULL,	DMN_PU2_APL, \
+			DMN_NULL, 	DMN_PU3_APL,	DMN_NULL
+#define DMN_P5_APL4	DMN_NULL,	DMN_PU1_APL,	DMN_NULL, \
+			DMN_NULL,	DMN_PU3_APL,	DMN_NULL
+#define DMN_P5_APL5	DMN_P5_APL1
+
+#define REG_PW_24_MAP { \
+	{ DMN_P24_FCC,	REG_CAP_INOUT, REG_MAX_ANTENNA, 30, 30, 36, 0xff},\
+	{ DMN_P24_ETSI,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_P24_WORLD,REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_P24_MKK,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_T_MAP { \
+	{ DMN_PT_MKK,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_U1_MAP { \
+	{ DMN_PU1_FCC,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_PU1_ETSI,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_PU1_MKK,	REG_CAP_INOUT, REG_MAX_ANTENNA, 10, 0, 10, 0}, \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_U2_MAP { \
+	{ DMN_PU2_FCC,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_PU2_ETSI,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_E_MAP { \
+	{ DMN_PE_FCC,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_PE_ETSI,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_U3_MAP { \
+	{ DMN_PU3_FCC,	REG_CAP_INOUT, REG_MAX_ANTENNA, 20, 0, 20, 0}, \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_AAD_MAP { \
+	{ DMN_DEBUG,	REG_CAP_INOUT, 0xff, 0xff, 0xff, 0xff, 0xff} \
+}
+
+#define REG_PW_MAP { \
+	{ DMN_NULL_WORLD,	DMN_P24_ETSI,	DMN_P5_NULL }, \
+	{ DMN_NULL_ETSIB,	DMN_P24_ETSI,	DMN_P5_NULL }, \
+	{ DMN_NULL_ETSIC,	DMN_P24_ETSI,	DMN_P5_NULL }, \
+	{ DMN_FCC1_WORLD,	DMN_P24_FCC,	DMN_P5_FCC1 }, \
+	{ DMN_FCC1_FCCA,	DMN_P24_FCC,	DMN_P5_FCC1 }, \
+	{ DMN_FCC2_WORLD,	DMN_DEBUG,	DMN_P5_FCC2 }, \
+	{ DMN_FCC2_FCCA,	DMN_P24_FCC,	DMN_P5_FCC2 }, \
+	{ DMN_FCC2_ETSIC,	DMN_DEBUG,	DMN_P5_FCC2 }, \
+	{ DMN_FCC3_FCCA,	DMN_P24_FCC,	DMN_P5_FCC3 }, \
+	{ DMN_ETSI1_WORLD,	DMN_P24_ETSI,	DMN_P5_ETSI1},	\
+	{ DMN_ETSI2_WORLD,	DMN_P24_ETSI,	DMN_P5_ETSI2},	\
+	{ DMN_ETSI3_WORLD,	DMN_P24_ETSI,	DMN_P5_ETSI3},	\
+	{ DMN_ETSI3_ETSIA,	DMN_P24_ETSI,	DMN_P5_ETSI3},	\
+	{ DMN_ETSI4_WORLD,	DMN_P24_ETSI,	DMN_P5_ETSI4},	\
+	{ DMN_ETSI4_ETSIC,	DMN_P24_ETSI,	DMN_P5_ETSI4},	\
+	{ DMN_ETSI5_WORLD,	DMN_P24_ETSI,	DMN_P5_ETSI5},	\
+	{ DMN_ETSI6_WORLD,	DMN_P24_ETSI,	DMN_P5_ETSI5},	\
+	{ DMN_MKK1_MKKA,	DMN_P24_MKK,	DMN_P5_MKK1},	\
+	{ DMN_MKK1_MKKB,	DMN_P24_MKK,	DMN_P5_MKK1},	\
+	{ DMN_MKK1_MKKB,	DMN_P24_MKK,	DMN_P5_MKK1},	\
+	{ DMN_MKK1_FCCA,	DMN_P24_MKK,	DMN_P5_MKK1},	\
+	{ DMN_MKK1_MKKA1,	DMN_P24_MKK,	DMN_P5_MKK1},	\
+	{ DMN_MKK1_MKKA2,	DMN_P24_MKK,	DMN_P5_MKK1},	\
+	{ DMN_MKK2_MKKA,	DMN_P24_MKK,	DMN_P5_MKK2},	\
+	{ DMN_APL1_WORLD,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL1_APLA,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL1_ETSIC,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL1_FCCA,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL2_WORLD,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL2_ETSIC,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL2_APLC,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL2_APLD,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL3_WORLD,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL4_WORLD,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_APL5_WORLD,	DMN_DEBUG,	DMN_P5_DEBUG},	\
+	{ DMN_DEBUG_DEBUG, 	DMN_DEBUG,	DMN_P5_DEBUG} \
+}
+
+#define REG_CHANNELS_2GHZ { \
+	{ 2432, DMN_WORLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4 G=
Hz */	\
+	{ 2437, DMN_WORLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_WORLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+											\
+	{ 2412, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4 GH=
z */	\
+	{ 2417, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2422, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2427, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2432, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2437, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2447, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2452, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2457, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2462, DMN_FCCA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+											\
+	{ 2412, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4GHz=
 */	\
+	{ 2417, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2422, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2427, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2432, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2437, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2447, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2452, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2457, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2462, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2467, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2472, DMN_APLD, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+											\
+	{ 2432, DMN_ETSIB, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4GH=
z */	\
+	{ 2437, DMN_ETSIB, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_ETSIB, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+											\
+	{ 2412, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4 G=
Hz */	\
+	{ 2417, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2422, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2427, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2432, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2437, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2447, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2452, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2457, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2462, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2467, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2472, DMN_ETSIC, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+											\
+	{ 2412, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4 GH=
z */	\
+	{ 2417, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2422, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2427, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2432, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2437, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2447, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2452, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2457, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2462, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2467, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2472, DMN_MKKA, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2484, DMN_MKKA, IEEE80211_RATE_CCK },						\
+											\
+	{ 2412, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* ISM 2.4 G=
Hz */	\
+	{ 2417, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Every 5MH=
z */	\
+	{ 2422, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2427, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2432, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2437, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2442, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2447, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2452, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2457, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2462, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2467, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },			\
+	{ 2472, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },/* Ch 13 */		\
+	{ 2484, DMN_DEBUG, IEEE80211_RATE_CCK }, /* Japan 14, note we hopped 12 M=
Hz */	\
+	{ 2512, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM },/*Now every 2=
0mhz*/ \
+	{ 2532, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 16 */	\
+	{ 2552, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 17 */	\
+	{ 2572, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 18 */	\
+	{ 2592, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 19 */	\
+	{ 2612, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 20 */	\
+	{ 2632, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 21 */	\
+	{ 2652, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 22 */	\
+	{ 2672, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 23 */	\
+	{ 2692, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 24 */	\
+	{ 2712, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }, /* Ch 25 */	\
+	{ 2732, DMN_DEBUG, IEEE80211_RATE_CCK|IEEE80211_RATE_OFDM }  /* Ch 26 */	\
+}
+
+#define REG_CHANNELS_5GHZ { \
+	{ 5745, DMN_APL1, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5765, DMN_APL1, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_APL1, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_APL1, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_APL1, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5745, DMN_APL2, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5765, DMN_APL2, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_APL2, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_APL2, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5280, DMN_APL3, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5300, DMN_APL3, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_APL3, IEEE80211_RATE_OFDM },		\
+	{ 5745, DMN_APL3, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5765, DMN_APL3, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_APL3, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_APL3, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_APL4, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_APL4, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_APL4, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_APL4, IEEE80211_RATE_OFDM },		\
+	{ 5745, DMN_APL4, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5765, DMN_APL4, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_APL4, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_APL4, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_APL4, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5745, DMN_APL5, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5765, DMN_APL5, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_APL5, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_APL5, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_APL5, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_ETSI1, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_ETSI1, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5500, DMN_ETSI1, IEEE80211_RATE_OFDM }, /* ETSI  */	\
+	{ 5520, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5540, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5560, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5580, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5600, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5620, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5640, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5660, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5680, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+	{ 5700, DMN_ETSI1, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_ETSI2, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_ETSI2, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_ETSI2, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_ETSI2, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_ETSI3, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_ETSI3, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_ETSI3, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_ETSI3, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_ETSI3, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_ETSI3, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_ETSI3, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_ETSI3, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_ETSI4, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_ETSI4, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_ETSI4, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_ETSI4, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_ETSI4, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_ETSI4, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_ETSI4, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_ETSI4, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_ETSI5, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_ETSI5, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_ETSI5, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_ETSI5, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_ETSI6, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_ETSI6, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5500, DMN_ETSI6, IEEE80211_RATE_OFDM }, /* ETSI */	\
+	{ 5520, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5540, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5560, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5580, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5600, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5620, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5640, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5660, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5680, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+	{ 5700, DMN_ETSI6, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_FCC1, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5210, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5250, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_FCC1, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5290, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5745, DMN_FCC1, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5760, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5765, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5800, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_FCC1, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_FCC2, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_FCC2, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5745, DMN_FCC2, IEEE80211_RATE_OFDM }, /* UNII-3*/	\
+	{ 5765, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_FCC2, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_FCC3, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5210, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5250, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_FCC3, IEEE80211_RATE_OFDM }, /* UNII-2 */	\
+	{ 5280, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5290, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5500, DMN_FCC3, IEEE80211_RATE_OFDM }, /* ETSI  */	\
+	{ 5520, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5540, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5560, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5580, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5600, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5620, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5640, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5660, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5680, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5700, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5745, DMN_FCC3, IEEE80211_RATE_OFDM }, /* UNII-3 */	\
+	{ 5760, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5765, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5800, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_FCC3, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5170, DMN_MKK1, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5190, DMN_MKK1, IEEE80211_RATE_OFDM },		\
+	{ 5210, DMN_MKK1, IEEE80211_RATE_OFDM },		\
+	{ 5230, DMN_MKK1, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5040, DMN_MKK2, IEEE80211_RATE_OFDM }, /* TELEC */	\
+	{ 5060, DMN_MKK2, IEEE80211_RATE_OFDM },		\
+	{ 5080, DMN_MKK2, IEEE80211_RATE_OFDM },		\
+	{ 5170, DMN_MKK2, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5190, DMN_MKK2, IEEE80211_RATE_OFDM },		\
+	{ 5210, DMN_MKK2, IEEE80211_RATE_OFDM },		\
+	{ 5230, DMN_MKK2, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5180, DMN_WORLD, IEEE80211_RATE_OFDM }, /* UNII-1 */	\
+	{ 5200, DMN_WORLD, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_WORLD, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_WORLD, IEEE80211_RATE_OFDM },		\
+								\
+	{ 5005, DMN_DEBUG, IEEE80211_RATE_OFDM }, /* Ch 1 */	\
+	{ 5010, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5015, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5020, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5025, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5030, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5035, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5040, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5045, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5050, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5055, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5060, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5065, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5070, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5075, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5080, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5085, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5090, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5095, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5100, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5105, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5110, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5115, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5120, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5125, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5130, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5135, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5140, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5145, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5150, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5155, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5160, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5165, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5170, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5175, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5180, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5185, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5190, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5195, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5200, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5205, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5210, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5215, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5220, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5225, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5230, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5235, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5240, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5245, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5250, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5255, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5260, DMN_DEBUG, IEEE80211_RATE_OFDM }, 		\
+	{ 5265, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5270, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5275, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5280, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5285, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5290, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5295, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5300, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5305, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5310, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5315, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5320, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5325, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5330, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5335, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5340, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5345, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5350, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5355, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5360, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5365, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5370, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5375, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5380, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5385, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5390, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5395, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5400, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5405, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5410, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5415, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5420, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5425, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5430, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5435, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5440, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5445, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5450, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5455, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5460, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5465, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5470, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5475, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5480, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5485, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5490, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5495, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5500, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5505, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5510, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5515, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5520, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5525, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5530, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5535, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5540, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5545, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5550, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5555, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5560, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5565, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5570, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5575, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5580, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5585, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5590, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5595, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5600, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5605, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5610, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5615, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5620, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5625, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5630, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5635, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5640, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5645, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5650, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5655, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5660, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5665, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5670, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5675, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5680, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5685, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5690, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5695, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5700, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5705, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5710, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5715, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5720, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5725, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5730, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5735, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5740, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5745, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5750, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5755, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5760, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5765, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5770, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5775, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5780, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5785, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5790, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5795, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5800, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5805, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5810, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5815, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5820, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5825, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5830, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5835, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5840, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5845, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5850, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5855, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5860, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5865, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5870, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5875, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5880, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5885, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5890, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5895, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5900, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5905, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5910, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5915, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5920, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5925, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5930, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5935, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5940, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5945, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5950, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5955, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5960, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5965, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5970, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5975, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5980, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5985, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5990, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 5995, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6000, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6005, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6010, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6015, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6020, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6025, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6030, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6035, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6040, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6045, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6050, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6055, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6060, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6065, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6070, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6075, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6080, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6085, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6090, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6095, DMN_DEBUG, IEEE80211_RATE_OFDM },		\
+	{ 6100, DMN_DEBUG, IEEE80211_RATE_OFDM } /* Ch 220 */	\
+}
+
+#define REG_NAMES { \
+	{ DMN_APL1_APLA,	    "APL1A" },		\
+	{ DMN_APL1_ETSIC,	    "APL1_ETSIC" },	\
+	{ DMN_APL1_FCCA,	    "APL1_FCCA" },	\
+	{ DMN_APL1_WORLD,	    "APL1W" },		\
+	{ DMN_APL2_APLC,	    "APL2C" },		\
+	{ DMN_APL2_APLD,	    "APL2D" },		\
+	{ DMN_APL2_ETSIC,	    "APL2_ETSIC" },	\
+	{ DMN_APL2_WORLD,	    "APL2W" },		\
+	{ DMN_APL3_WORLD,	    "APL3W" },		\
+	{ DMN_APL4_WORLD,	    "APL4W" },		\
+	{ DMN_APL5_WORLD,	    "APL5W" },		\
+	{ DMN_ETSI1_WORLD,	    "ETSI1W" },		\
+	{ DMN_ETSI2_WORLD,	    "ETSI2W" },		\
+	{ DMN_ETSI3_ETSIA,	    "ETSI3A" },		\
+	{ DMN_ETSI3_WORLD,	    "ETSI3W" },		\
+	{ DMN_ETSI4_ETSIC,	    "ETSI4C" },		\
+	{ DMN_ETSI4_WORLD,	    "ETSI4W" },		\
+	{ DMN_ETSI5_WORLD,	    "ETSI5W" },		\
+	{ DMN_ETSI6_WORLD,	    "ETSI6W" },		\
+	{ DMN_FCC1_FCCA,	    "FCC1A" },		\
+	{ DMN_FCC1_WORLD,	    "FCC1W" },		\
+	{ DMN_FCC2_ETSIC,	    "FCC2C" },		\
+	{ DMN_FCC2_FCCA,	    "FCC2A" },		\
+	{ DMN_FCC2_WORLD,	    "FCC2W" },		\
+	{ DMN_FCC3_FCCA,	    "FCC3A" },		\
+	{ DMN_MKK1_FCCA,	    "MKK1_FCCA" },	\
+	{ DMN_MKK1_MKKA,	    "MKK1A" },		\
+	{ DMN_MKK1_MKKA1,	    "MKK1A1" },		\
+	{ DMN_MKK1_MKKA2,	    "MKK1A2" },		\
+	{ DMN_MKK1_MKKB,	    "MKK1B" },		\
+	{ DMN_MKK2_MKKA,	    "MKK2A" },		\
+	{ DMN_NULL_ETSIB,	    "ETSIB" },		\
+	{ DMN_NULL_ETSIC,	    "ETSIC" },		\
+	{ DMN_NULL_WORLD,	    "WORLD" },		\
+	{ DMN_DEBUG_DEBUG,	    "DEBUG_DEBUG" }	\
+}
+
+#define REG_MAP {	\
+	{ DMN_NULL_WORLD,	DMN_NULL,	DMN_WORLD },	\
+	{ DMN_NULL_ETSIB,	DMN_NULL,	DMN_ETSIB },	\
+	{ DMN_NULL_ETSIC,	DMN_NULL,	DMN_ETSIC },	\
+	{ DMN_FCC1_WORLD,	DMN_FCC1,	DMN_WORLD },	\
+	{ DMN_FCC1_FCCA,	DMN_FCC1,	DMN_FCCA },	\
+	{ DMN_FCC2_WORLD,	DMN_FCC2,	DMN_WORLD },	\
+	{ DMN_FCC2_FCCA,	DMN_FCC2,	DMN_FCCA },	\
+	{ DMN_FCC2_ETSIC,	DMN_FCC2,	DMN_ETSIC },	\
+	{ DMN_FCC3_FCCA,	DMN_FCC3,	DMN_WORLD },	\
+	{ DMN_ETSI1_WORLD,	DMN_ETSI1,	DMN_WORLD },	\
+	{ DMN_ETSI2_WORLD,	DMN_ETSI2,	DMN_WORLD },	\
+	{ DMN_ETSI3_WORLD,	DMN_ETSI3,	DMN_WORLD },	\
+	{ DMN_ETSI3_ETSIA,	DMN_ETSI3,	DMN_WORLD },	\
+	{ DMN_ETSI4_WORLD,	DMN_ETSI4,	DMN_WORLD },	\
+	{ DMN_ETSI4_ETSIC,	DMN_ETSI4,	DMN_ETSIC },	\
+	{ DMN_ETSI5_WORLD,	DMN_ETSI5,	DMN_WORLD },	\
+	{ DMN_ETSI6_WORLD,	DMN_ETSI6,	DMN_WORLD },	\
+	{ DMN_MKK1_MKKA,	DMN_MKK1,	DMN_MKKA },	\
+	{ DMN_MKK1_MKKB,	DMN_MKK1,	DMN_MKKA },	\
+	{ DMN_MKK1_FCCA,	DMN_MKK1,	DMN_FCCA },	\
+	{ DMN_MKK1_MKKA1,	DMN_MKK1,	DMN_MKKA },	\
+	{ DMN_MKK1_MKKA2,	DMN_MKK1,	DMN_MKKA },	\
+	{ DMN_MKK2_MKKA,	DMN_MKK2,	DMN_MKKA },	\
+	{ DMN_APL1_WORLD,	DMN_APL1,	DMN_WORLD },	\
+	{ DMN_APL1_APLA,	DMN_APL1,	DMN_WORLD },	\
+	{ DMN_APL1_ETSIC,	DMN_APL1,	DMN_ETSIC },	\
+	{ DMN_APL1_FCCA,	DMN_APL1,	DMN_FCCA },	\
+	{ DMN_APL2_WORLD,	DMN_APL2,	DMN_WORLD },	\
+	{ DMN_APL2_ETSIC,	DMN_APL2,	DMN_ETSIC },	\
+	{ DMN_APL2_APLC,	DMN_APL2,	DMN_WORLD },	\
+	{ DMN_APL2_APLD,	DMN_APL2,	DMN_APLD },	\
+	{ DMN_APL3_WORLD,	DMN_APL3,	DMN_WORLD },	\
+	{ DMN_APL4_WORLD,	DMN_APL4,	DMN_WORLD },	\
+	{ DMN_APL5_WORLD,	DMN_APL5,	DMN_WORLD },	\
+	{ DMN_DEBUG_DEBUG,	DMN_DEBUG,	DMN_DEBUG }	\
+}
+
+/* Anything not here gets DMN_NULL_WORLD regdomain */
+#define REG_COUNTRY_NAMES { \
+	{ "00", DMN_NULL_WORLD},	\
+	{ "AM", DMN_ETSI4_WORLD },	\
+	{ "AR", DMN_APL3_WORLD },	\
+	{ "AT", DMN_ETSI5_WORLD },	\
+	{ "AU", DMN_FCC2_WORLD },	\
+	{ "AZ", DMN_ETSI4_WORLD },	\
+	{ "BE", DMN_ETSI4_WORLD },	\
+	{ "BG", DMN_ETSI6_WORLD },	\
+	{ "BN", DMN_APL1_WORLD },	\
+	{ "BO", DMN_APL1_ETSIC },	\
+	{ "BR", DMN_NULL_ETSIC },	\
+	{ "BZ", DMN_NULL_ETSIC },	\
+	{ "CA", DMN_FCC2_FCCA },	\
+	{ "CH", DMN_ETSI2_WORLD },	\
+	{ "CL", DMN_APL5_WORLD },	\
+	{ "CN", DMN_APL1_WORLD },	\
+	{ "CO", DMN_FCC1_FCCA },	\
+	{ "CY", DMN_ETSI1_WORLD },	\
+	{ "CZ", DMN_ETSI3_WORLD },	\
+	{ "DE", DMN_ETSI1_WORLD },	\
+	{ "DK", DMN_ETSI1_WORLD },	\
+	{ "DO", DMN_FCC1_FCCA },	\
+	{ "EE", DMN_ETSI1_WORLD },	\
+	{ "ES", DMN_ETSI1_WORLD },	\
+	{ "F2", DMN_ETSI3_WORLD },	\
+	{ "FI", DMN_ETSI1_WORLD },	\
+	{ "FR", DMN_ETSI3_WORLD },	\
+	{ "GB", DMN_ETSI1_WORLD },	\
+	{ "GE", DMN_ETSI4_WORLD },	\
+	{ "GT", DMN_FCC1_FCCA },	\
+	{ "HK", DMN_FCC2_WORLD },	\
+	{ "HR", DMN_ETSI3_WORLD },	\
+	{ "HU", DMN_ETSI2_WORLD },	\
+	{ "IE", DMN_ETSI1_WORLD },	\
+	{ "IR", DMN_APL1_WORLD },	\
+	{ "IS", DMN_ETSI1_WORLD },	\
+	{ "IT", DMN_ETSI1_WORLD },	\
+	{ "J1", DMN_MKK1_MKKB },	\
+	{ "J2", DMN_MKK1_FCCA },	\
+	{ "J3", DMN_MKK2_MKKA },	\
+	{ "J4", DMN_MKK1_MKKA1 },	\
+	{ "J5", DMN_MKK1_MKKA2 },	\
+	{ "JP", DMN_MKK1_MKKA },	\
+	{ "K2", DMN_APL2_APLD },	\
+	{ "KP", DMN_APL2_WORLD },	\
+	{ "KR", DMN_APL2_WORLD },	\
+	{ "LI", DMN_ETSI2_WORLD },	\
+	{ "LT", DMN_ETSI1_WORLD },	\
+	{ "LU", DMN_ETSI1_WORLD },	\
+	{ "MC", DMN_ETSI4_WORLD },	\
+	{ "MO", DMN_FCC2_WORLD },	\
+	{ "MX", DMN_FCC1_FCCA },	\
+	{ "NL", DMN_ETSI1_WORLD },	\
+	{ "NO", DMN_ETSI1_WORLD },	\
+	{ "NZ", DMN_FCC2_ETSIC },	\
+	{ "PA", DMN_FCC1_FCCA },	\
+	{ "PH", DMN_FCC1_WORLD },	\
+	{ "PL", DMN_ETSI1_WORLD },	\
+	{ "PR", DMN_FCC1_FCCA },	\
+	{ "PT", DMN_ETSI1_WORLD },	\
+	{ "SE", DMN_ETSI1_WORLD },	\
+	{ "SG", DMN_APL4_WORLD },	\
+	{ "SI", DMN_ETSI1_WORLD },	\
+	{ "SK", DMN_ETSI3_WORLD },	\
+	{ "TH", DMN_APL2_WORLD },	\
+	{ "TN", DMN_ETSI3_WORLD },	\
+	{ "TR", DMN_ETSI3_WORLD },	\
+	{ "TT", DMN_ETSI4_WORLD },	\
+	{ "TW", DMN_APL3_WORLD },	\
+	{ "UK", DMN_ETSI1_WORLD },	\
+	{ "US", DMN_FCC1_FCCA },	\
+	{ "UY", DMN_APL2_WORLD },	\
+	{ "UZ", DMN_FCC3_FCCA },	\
+	{ "VE", DMN_APL2_ETSIC },	\
+	{ "ZA", DMN_ETSI1_WORLD },	\
+	{ "99", DMN_DEBUG_DEBUG}	\
+}
+
+#endif /* _REGULATORY_MAP_H_ */
--=20
1.5.2.4


--MIdTMoZhcV1D07fI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG9DHlat1JN+IKUl4RAjzcAJ9MSD0kuNDOx5jJQ0KQkxsCGBKgwwCfQQO2
RBci+ZGVuxBh+4gHKrNnzH4=
=LJy2
-----END PGP SIGNATURE-----

--MIdTMoZhcV1D07fI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
