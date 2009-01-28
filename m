Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbZA1K4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 05:56:20 -0500
Subject: Re: [PATCH] iw: add get regulatory domain support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1233111335-8317-1-git-send-email-lrodriguez@atheros.com>
References: <1233111335-8317-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oWovzjTX99Xv4r0NXCrz"
Date: Wed, 28 Jan 2009 11:18:50 +0100
Message-Id: <1233137930.3936.5.camel@johannes.local> (sfid-20090128_115622_714725_562CBC6C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oWovzjTX99Xv4r0NXCrz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 18:55 -0800, Luis R. Rodriguez wrote:

> +#define FLAG_BUF_LEN 200
> +#define PARSE_FLAG(nl_flag, string_value, len)  do { \
> +		if ((flags & nl_flag)) { \
> +			if (idx + len + 2 > FLAG_BUF_LEN) { \
> +				fprintf(stderr, "flags_buf size limit (%d) reached\n", FLAG_BUF_LEN)=
; \
> +				return NL_STOP; \
> +			} \
> +			sprintf(flags_buf + idx, ", "); \
> +			sprintf(flags_buf + idx + 2, string_value); \
> +			idx +=3D len + 2; \
> +		} \
> +	} while (0)
> +	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
> +	struct genlmsghdr *gnlh =3D nlmsg_data(nlmsg_hdr(msg));
> +	char *alpha2;
> +	struct nlattr *nl_rule;
> +	int rem_rule;
> +	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1=
] =3D {
> +		[NL80211_ATTR_REG_RULE_FLAGS]           =3D { .type =3D NLA_U32 },
> +		[NL80211_ATTR_FREQ_RANGE_START]         =3D { .type =3D NLA_U32 },
> +		[NL80211_ATTR_FREQ_RANGE_END]           =3D { .type =3D NLA_U32 },
> +		[NL80211_ATTR_FREQ_RANGE_MAX_BW]        =3D { .type =3D NLA_U32 },
> +		[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]  =3D { .type =3D NLA_U32 },
> +		[NL80211_ATTR_POWER_RULE_MAX_EIRP]      =3D { .type =3D NLA_U32 },
> +	};
> +
> +	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
> +		genlmsg_attrlen(gnlh, 0), NULL);
> +
> +	if (!tb_msg[NL80211_ATTR_REG_ALPHA2]) {
> +		printf("No alpha2\n");
> +		return NL_SKIP;
> +	}
> +
> +	if (!tb_msg[NL80211_ATTR_REG_RULES]) {
> +		printf("No reg rules\n");
> +		return NL_SKIP;
> +	}
> +
> +	alpha2 =3D nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
> +	printf("country %s:\n", alpha2);
> +
> +	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) =
{
> +		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
> +		__u32 flags, start_freq_khz, end_freq_khz, max_bw_khz, max_ant_gain_mb=
i, max_eirp_mbm;
> +		int idx =3D 0;
> +		char antenna_gain_buf[20];
> +		char flags_buf[200];
> +
> +		nla_parse(tb_rule, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_rule), nla_=
len(nl_rule), reg_rule_policy);
> +
> +		flags =3D nla_get_u32(tb_rule[NL80211_ATTR_REG_RULE_FLAGS]);
> +		start_freq_khz =3D nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_START])=
;
> +		end_freq_khz =3D nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_END]);
> +		max_bw_khz =3D nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
> +		max_ant_gain_mbi =3D nla_get_u32(tb_rule[NL80211_ATTR_POWER_RULE_MAX_A=
NT_GAIN]);
> +		max_eirp_mbm =3D nla_get_u32(tb_rule[NL80211_ATTR_POWER_RULE_MAX_EIRP]=
);
> +
> +		if (MBI_TO_DBI(max_ant_gain_mbi))
> +			sprintf(antenna_gain_buf, "%d", MBI_TO_DBI(max_ant_gain_mbi));
> +		else
> +			sprintf(antenna_gain_buf, "N/A");
> +
> +		/* Sync this output format to match that of dbparse.py from wireless-r=
egdb.git */
> +		PARSE_FLAG(NL80211_RRF_NO_OFDM, "NO-OFDM", 7);
> +		PARSE_FLAG(NL80211_RRF_NO_CCK, "NO-CCK", 6);
> +		PARSE_FLAG(NL80211_RRF_NO_INDOOR, "NO-INDOOR", 9);
> +		PARSE_FLAG(NL80211_RRF_NO_OUTDOOR, "NO-OUTDOOR", 10);
> +		PARSE_FLAG(NL80211_RRF_DFS, "DFS", 3);
> +		PARSE_FLAG(NL80211_RRF_PTP_ONLY, "PTP-ONLY", 8);
> +		PARSE_FLAG(NL80211_RRF_PASSIVE_SCAN, "PASSIVE-SCAN", 12);
> +		PARSE_FLAG(NL80211_RRF_NO_IBSS, "NO-IBSS", 7);
> +
> +		printf("\t(%d - %d @ %d), (%s, %d)%s\n",
> +			KHZ_TO_MHZ(start_freq_khz), KHZ_TO_MHZ(end_freq_khz), KHZ_TO_MHZ(max_=
bw_khz),
> +			antenna_gain_buf, MBM_TO_DBM(max_eirp_mbm), (!idx) ? "" : flags_buf);

All this looks really complicated, why do you need to sprintf everything
first into a buffer, can't you just print it out in the correct order?

johannes

--=-oWovzjTX99Xv4r0NXCrz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgDEHAAoJEKVg1VMiehFYoaoQAIOhZs7Bzx1H3SYO1fKYnRdM
ewt0QzLYJw6TLYbwJ/1jFLg8XHpWCX7qw7X7sMH85f8LxpdX4/M502W3cnPH3Mpy
+QmugzVxvGwQqI9WFNX4B8P2UiUG3OjAGmWdIOc/whaaDG4odd/P3TYHTOpSo5PK
+m/BBP87MXz1HQfKH3UVQOAPDZeDygWhN21KhJcOv8Q3HJTehPLplmMSeVx0ERc7
CCRJH7gAJjZnyYJuTCgYdX+/lLyuPWvF++iW39khj90mEu4UJufHhEdhe8MxHaSL
P8ZUahGG6ozCQi3UGU02BP1bxtlbuMcv/0AaBYqR8N5iCGlLpOpHe3uGT4HCPv62
WbeABO6PI9V7TzylPIHdy+Vvv0WpRePcsJm7kxGC1EaYirLmdRJ3wa4I4emoH9ho
xmHJ5ssVq19ChxtwoIcZt066QoLw42zbhdpILdfqSCywRT5l30H1TQMBipsQ8TGL
lhUYH6wwcx3N6r3L5y4k8Bsw/PK4qeicYTkRXxX4913a3tKheaNSVNpKhDDntqCs
8kI7t/GCJsLluDIGRnu0aDEZlrhUbJw+rKVZ2Cb0piB+tKlzVz80afS6nVUYX1bB
YpAJoXLplUfpBiysRc3mDLMKmCAnMZJs95/3DujvH7oZs16Do12v1xGbY7r66h4R
3d1CLekrd/WeMwInXpPc
=CF60
-----END PGP SIGNATURE-----

--=-oWovzjTX99Xv4r0NXCrz--

