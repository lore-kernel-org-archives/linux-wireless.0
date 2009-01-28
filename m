Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59945 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbZA1Q4Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 11:56:25 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 08:56:25 -0800
Date: Wed, 28 Jan 2009 08:55:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] iw: add get regulatory domain support
Message-ID: <20090128165542.GA26656@tesla> (sfid-20090128_175638_760316_1992A3CE)
References: <1233111335-8317-1-git-send-email-lrodriguez@atheros.com> <1233137930.3936.5.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1233137930.3936.5.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 28, 2009 at 02:18:50AM -0800, Johannes Berg wrote:
> On Tue, 2009-01-27 at 18:55 -0800, Luis R. Rodriguez wrote:
> 
> > +#define FLAG_BUF_LEN 200
> > +#define PARSE_FLAG(nl_flag, string_value, len)  do { \
> > +		if ((flags & nl_flag)) { \
> > +			if (idx + len + 2 > FLAG_BUF_LEN) { \
> > +				fprintf(stderr, "flags_buf size limit (%d) reached\n", FLAG_BUF_LEN); \
> > +				return NL_STOP; \
> > +			} \
> > +			sprintf(flags_buf + idx, ", "); \
> > +			sprintf(flags_buf + idx + 2, string_value); \
> > +			idx += len + 2; \
> > +		} \
> > +	} while (0)
> > +	struct nlattr *tb_msg[NL80211_ATTR_MAX + 1];
> > +	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
> > +	char *alpha2;
> > +	struct nlattr *nl_rule;
> > +	int rem_rule;
> > +	static struct nla_policy reg_rule_policy[NL80211_FREQUENCY_ATTR_MAX + 1] = {
> > +		[NL80211_ATTR_REG_RULE_FLAGS]           = { .type = NLA_U32 },
> > +		[NL80211_ATTR_FREQ_RANGE_START]         = { .type = NLA_U32 },
> > +		[NL80211_ATTR_FREQ_RANGE_END]           = { .type = NLA_U32 },
> > +		[NL80211_ATTR_FREQ_RANGE_MAX_BW]        = { .type = NLA_U32 },
> > +		[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]  = { .type = NLA_U32 },
> > +		[NL80211_ATTR_POWER_RULE_MAX_EIRP]      = { .type = NLA_U32 },
> > +	};
> > +
> > +	nla_parse(tb_msg, NL80211_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
> > +		genlmsg_attrlen(gnlh, 0), NULL);
> > +
> > +	if (!tb_msg[NL80211_ATTR_REG_ALPHA2]) {
> > +		printf("No alpha2\n");
> > +		return NL_SKIP;
> > +	}
> > +
> > +	if (!tb_msg[NL80211_ATTR_REG_RULES]) {
> > +		printf("No reg rules\n");
> > +		return NL_SKIP;
> > +	}
> > +
> > +	alpha2 = nla_data(tb_msg[NL80211_ATTR_REG_ALPHA2]);
> > +	printf("country %s:\n", alpha2);
> > +
> > +	nla_for_each_nested(nl_rule, tb_msg[NL80211_ATTR_REG_RULES], rem_rule) {
> > +		struct nlattr *tb_rule[NL80211_FREQUENCY_ATTR_MAX + 1];
> > +		__u32 flags, start_freq_khz, end_freq_khz, max_bw_khz, max_ant_gain_mbi, max_eirp_mbm;
> > +		int idx = 0;
> > +		char antenna_gain_buf[20];
> > +		char flags_buf[200];
> > +
> > +		nla_parse(tb_rule, NL80211_FREQUENCY_ATTR_MAX, nla_data(nl_rule), nla_len(nl_rule), reg_rule_policy);
> > +
> > +		flags = nla_get_u32(tb_rule[NL80211_ATTR_REG_RULE_FLAGS]);
> > +		start_freq_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_START]);
> > +		end_freq_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_END]);
> > +		max_bw_khz = nla_get_u32(tb_rule[NL80211_ATTR_FREQ_RANGE_MAX_BW]);
> > +		max_ant_gain_mbi = nla_get_u32(tb_rule[NL80211_ATTR_POWER_RULE_MAX_ANT_GAIN]);
> > +		max_eirp_mbm = nla_get_u32(tb_rule[NL80211_ATTR_POWER_RULE_MAX_EIRP]);
> > +
> > +		if (MBI_TO_DBI(max_ant_gain_mbi))
> > +			sprintf(antenna_gain_buf, "%d", MBI_TO_DBI(max_ant_gain_mbi));
> > +		else
> > +			sprintf(antenna_gain_buf, "N/A");
> > +
> > +		/* Sync this output format to match that of dbparse.py from wireless-regdb.git */
> > +		PARSE_FLAG(NL80211_RRF_NO_OFDM, "NO-OFDM", 7);
> > +		PARSE_FLAG(NL80211_RRF_NO_CCK, "NO-CCK", 6);
> > +		PARSE_FLAG(NL80211_RRF_NO_INDOOR, "NO-INDOOR", 9);
> > +		PARSE_FLAG(NL80211_RRF_NO_OUTDOOR, "NO-OUTDOOR", 10);
> > +		PARSE_FLAG(NL80211_RRF_DFS, "DFS", 3);
> > +		PARSE_FLAG(NL80211_RRF_PTP_ONLY, "PTP-ONLY", 8);
> > +		PARSE_FLAG(NL80211_RRF_PASSIVE_SCAN, "PASSIVE-SCAN", 12);
> > +		PARSE_FLAG(NL80211_RRF_NO_IBSS, "NO-IBSS", 7);
> > +
> > +		printf("\t(%d - %d @ %d), (%s, %d)%s\n",
> > +			KHZ_TO_MHZ(start_freq_khz), KHZ_TO_MHZ(end_freq_khz), KHZ_TO_MHZ(max_bw_khz),
> > +			antenna_gain_buf, MBM_TO_DBM(max_eirp_mbm), (!idx) ? "" : flags_buf);
> 
> All this looks really complicated, why do you need to sprintf everything
> first into a buffer, can't you just print it out in the correct order?

Heh yeah, will resend, thanks.

  Luis
