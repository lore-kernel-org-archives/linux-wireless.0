Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:44809 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3FZPNX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 11:13:23 -0400
Message-ID: <1372259597.13529.11.camel@jlt4.sipsolutions.net> (sfid-20130626_171326_711500_FF331C93)
Subject: Re: [PATCH v4 2/2] cfg80211/nl80211: Add packet coalesce support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Wed, 26 Jun 2013 17:13:17 +0200
In-Reply-To: <1372212237-5687-2-git-send-email-bzhao@marvell.com>
References: <1372212237-5687-1-git-send-email-bzhao@marvell.com>
	 <1372212237-5687-2-git-send-email-bzhao@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-25 at 19:03 -0700, Bing Zhao wrote:

> +/**
> + * struct cfg80211_coalesce - Packet coalescing settings
> + *
> + * This structure defines coalescing settings.
> + * @rules: array of coalesce rules
> + * @n_rules: number of rules
> + */
> +struct cfg80211_coalesce {
> +	struct cfg80211_coalesce_rules **rules;

I don't really see why this should be a double pointer? The
coalesce_rules struct is small enough that you could just allocate an
array of that, no?

>  /**
> + * struct wiphy_coalesce_support - coalesce support data
> + * @n_rules: maximum number of coalesce rules
> + * @n_patterns: number of supported patterns
> + *	(see nl80211.h for the pattern definition)
> + * @pattern_max_len: maximum length of each pattern
> + * @pattern_min_len: minimum length of each pattern
> + * @max_pkt_offset: maximum Rx packet offset

Should there be any limits on the timer? Will the firmware actually work
if I set it to (useless) values like 2^32-1 msecs?

Also -- is n_patterns per rule, or global? It seems global, but in the
rules you can have multiple patterns per rule?

> +/**
>   * enum nl80211_commands - supported nl80211 commands
>   *
>   * @NL80211_CMD_UNSPEC: unspecified command to catch errors
> @@ -648,6 +673,10 @@
>   * @NL80211_CMD_CRIT_PROTOCOL_STOP: Indicates the connection reliability can
>   *	return back to normal.
>   *
> + * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
> + *
> + * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.

I'd prefer no space between the two :)

> +struct nl80211_coalesce_rule_support {
> +	__u32 max_rules;
> +	struct nl80211_pattern_support pat;

(timing stuff would also go here, I suppose)

> +static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
> +				       struct nlattr *rule,
> +				       struct cfg80211_coalesce_rules *new_rule)
> +{
> +	int err, i;
> +	const struct wiphy_coalesce_support *coalesce = rdev->wiphy.coalesce;
> +	struct nlattr *tb[NUM_NL80211_ATTR_COALESCE_RULE], *pat;
> +	int rem, pat_len, mask_len, pkt_offset, n_patterns = 0;
> +	struct nlattr *pat_tb[NUM_NL80211_PKTPAT];
> +
> +	err = nla_parse(tb, NL80211_ATTR_COALESCE_RULE_MAX, nla_data(rule),
> +			nla_len(rule), nl80211_coalesce_policy);
> +	if (err)
> +		return err;
> +
> +	memset(new_rule, 0, sizeof(*new_rule));
> +	new_rule->delay = nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_DELAY]);

no check that it actually exists?

> +	new_rule->condition =
> +		nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);

ditto. easy to crash, no?

> +static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> +	const struct wiphy_coalesce_support *coalesce = rdev->wiphy.coalesce;
> +	struct cfg80211_coalesce_rules new_rule = {};
> +	struct cfg80211_coalesce_rules *nrule;
> +	struct cfg80211_coalesce *new_coalesce;
> +	int err, rem_rule;
> +	struct nlattr *rule;
> +
> +	if (!rdev->wiphy.coalesce)
> +		return -EOPNOTSUPP;
> +	if (!rdev->ops->set_coalesce)
> +		return -EOPNOTSUPP;

could combine the conditions :)

> +	new_coalesce = kzalloc(sizeof(*new_coalesce), GFP_KERNEL);
> +	new_coalesce->rules = kcalloc(coalesce->n_rules,
> +					sizeof(void *), GFP_KERNEL);

*kaboom*

> +	cfg80211_rdev_free_coalesce(rdev->coalesce);
> +	rdev->coalesce = new_coalesce;
> +
> +	err = rdev->ops->set_coalesce(&rdev->wiphy, rdev->coalesce);
> +	if (err)
> +		goto error;
> +
> +	return 0;
> +error:
> +	cfg80211_rdev_free_coalesce(new_coalesce);

*kaboom* if it ever fails, and you then do get_coalesce -- should
probably assign only after setting the new value successfully?

johannes

