Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:49776 "EHLO
	na3sys009aog138.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934576Ab3E1Q0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 12:26:04 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: 'Johannes Berg' <johannes@sipsolutions.net>,
	Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Tue, 28 May 2013 09:24:57 -0700
Subject: RE: [PATCH v2 2/2] cfg80211/nl80211: Add packet coalesce support
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CA5@SC-VEXCH1.marvell.com> (sfid-20130528_182610_135112_EAD2F875)
In-Reply-To: <1369426955.8290.34.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> 
> Some smallish things.
> 
> > In most cases, host that receives IPv4 and IPv6 multicast/broadcast
> > packets does not do anything with these packets. Therefore the
> > reception of these unwanted packets causes unnecessary processing
> > and power consumption.
> 
> This is curious, you already discard those that you don't care about by
> way of multicast filtering, no? What's the added advantage here? Would
> you coalesce interrupts for those packets that pass the filter(s)?

Yes. we don't want to simply discard those packets, because few of them may be useful for the host.
The advantage here is instead of getting random per packet receive interrupts, host receives multiple buffered packets with a single receive interrupt.

> But
> those packets are packets that the host cares about, no?

The assumption is filters are designed in such a way that specified delay in packet processing is acceptable for those packets.

> 
> >  /**
> > + * struct cfg80211_coalesce_rules - Coalesce rule parameters
> > + *
> > + * This structure defines coalesce rule for the device.
> > + * @delay: maximum coalescing delay in msecs.
> > + * @condition: condition for packet coalescence.
> > + *	i.e. pattern 'match' or 'no match'
> > + * @patterns: array of packet patterns
> > + * @n_patterns: number of patterns
> > + */
> > +struct cfg80211_coalesce_rules {
> > +	int delay;
> > +	u8 condition;
> 
> seems like "condition" should be of some enum type? presumably an
> nl80211 enum type that userspace can use?

Sure. We will add an enum for "condition".

> 
> > +	struct cfg80211_pkt_pattern *patterns;
> 
> const?

This can not be a const. It points to an array of patterns. Runtime while adding new rule, buffer is allocated based on number of patterns configured by user and information is filled.

> 
> > +struct cfg80211_coalesce {
> > +	struct cfg80211_coalesce_rules **rules;
> > +	int n_rules;
> > +};
> 
> I think you can pass these as two function arguments rather than a
> separate struct.

This is our global structure for coalesce configuration. We just save it's pointer in rdev structure. It is allocated when user adds first coalesce rule. rdev->coalesce is NULL when user clears the setting.

> 
> > @@ -3027,7 +3063,6 @@ enum nl80211_cqm_rssi_threshold_event {
> >  	NL80211_CQM_RSSI_BEACON_LOSS_EVENT,
> >  };
> >
> > -
> >  /**
> >   * enum nl80211_tx_power_setting - TX power adjustment
> >   * @NL80211_TX_POWER_AUTOMATIC: automatically determine transmit power
> 
> seems spurious :)

Ok. We will revert the change.

> 
> >   * This struct is carried in %NL80211_WOWLAN_TRIG_PKT_PATTERN when
> > - * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED in the
> > - * capability information given by the kernel to userspace.
> > + * that is part of %NL80211_ATTR_WOWLAN_TRIGGERS_SUPPORTED or in
> > + * %NL80211_ATTR_COALESCE_RULE_PKT_PATTERN when that is part of
> > + * %NL80211_ATTR_COALESCE_RULE in the capability information given
> > + * by the kernel to userspace.
> 
> Ah, I think here you're updating what I asked about before.
> 
> > + * @NL80211_ATTR_COALESCE_RULE_CONDITION: condition for packet
> coalescence.
> > + *	i.e. pattern 'match' or 'no match'
> 
> I'm sure the condition attribute isn't a string, so this should say
> which enum to take the value from?

Sure. We will update the description using newly added enum for "condition".

> 
> > + * @NL80211_FEATURE_PACKET_COALESCE: This driver support packet
> coalescing
> > + *	feature. Packets are buffered in firmware based on configured rules
> > + *	to reduce unwanted packet or interrupt to host.
> 
> I don't think you need this, since you have this:
> 
> > +       struct wiphy_coalesce_support coalesce;

We will get rid of this flag.

> 
> Actually, you should probably make that a pointer, then it can be NULL
> for drivers not supporting it, and static const for those that do. Means
> you should make it a const pointer, of course.
> 
> Userspace can tell by checking if the support is advertised.

We will use following condition to check if driver is not supporting the feature. (wowlan code does the same thing)

"if (!dev->wiphy.coalesce.n_patterns || !dev->wiphy.coalesce.n_rules)"

> 
> 
> > +static inline void
> > +cfg80211_rdev_free_coalesce(struct cfg80211_registered_device *rdev)
> 
> That's fairly big, would prefer not to inline it.

Ack, thanks.

> 
> > +static int nl80211_set_coalesce(struct sk_buff *skb, struct genl_info
> *info)
> > +{
> > +	struct cfg80211_registered_device *rdev = info->user_ptr[0];
> > +	struct nlattr *tb[NUM_NL80211_ATTR_COALESCE_RULE];
> > +	struct wiphy_coalesce_support *coalesce = &rdev->wiphy.coalesce;
> > +	struct cfg80211_coalesce_rules new_rule = {};
> > +	struct cfg80211_coalesce_rules *nrule;
> > +	int err, i;
> > +
> > +	if (!(rdev->wiphy.features & NL80211_FEATURE_PACKET_COALESCE))
> > +		return -EOPNOTSUPP;
> 
> Then this should check the coalesce pointer of course, which can then be
> NULL.
> 
> > +	if (!rdev->coalesce) {
> > +		rdev->coalesce = kzalloc(sizeof(*rdev->coalesce), GFP_KERNEL);
> > +		rdev->coalesce->rules = kcalloc(coalesce->n_rules,
> > +						sizeof(void *), GFP_KERNEL);
> > +	}
> > +
> > +	if (rdev->coalesce->n_rules >= coalesce->n_rules)
> > +		return -EOPNOTSUPP;
> 
> This is bad. You leave rdev->coalesce assigned, but it's completely
> invalid data. IMHO you should use a temporary variable and only assign
> it when it's fully parsed, freeing it if not. That way, you also don't
> kill old values when new invalid values are parsed.

"iw coalesce add" command adds one coalesce rule at a time. "iw coalesce disable" command removes all configured rules.

"rdev->coalesce" will be created while adding first rule. "if (!rdev->coalesce)" condition will be false for further rules.

"if (rdev->coalesce->n_rules >= coalesce->n_rules)" condition becomes true when number of configured rules becomes equal to number of supported rules advertised by the driver. So we can't accommodate new rule in this case.

Therefore we don't leave rdev->coalesce assigned with invalid data.

We are already using 'new_rule' as a temporary variable for storing new rule information and freeing it in failure cases (similar to wowlan code).

> 
> > +	new_rule.delay = nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_DELAY]);
> > +	new_rule.condition =
> > +		nla_get_u8(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);
> 
> Needs sanity checking, what if userspace passes the value 17? Does that
> mean anything? :)

Ack. We will add sanity check to allow only valid enum values.

> 
> > +		nla_for_each_nested(pat,
> > +				    tb[NL80211_ATTR_COALESCE_RULE_PKT_PATTERN],
> > +				    rem) {
> > +			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
> > +				  nla_len(pat), NULL);
> > +			err = -EINVAL;
> > +			if (!pat_tb[NL80211_PKTPAT_MASK] ||
> > +			    !pat_tb[NL80211_PKTPAT_PATTERN])
> > +				goto error;
> > +			pat_len = nla_len(pat_tb[NL80211_PKTPAT_PATTERN]);
> > +			mask_len = DIV_ROUND_UP(pat_len, 8);
> > +			if (nla_len(pat_tb[NL80211_PKTPAT_MASK]) !=
> > +			    mask_len)
> > +				goto error;
> > +			if (pat_len > coalesce->pattern_max_len ||
> > +			    pat_len < coalesce->pattern_min_len)
> > +				goto error;
> 
> I wonder if any of this could be refactored with WoWLAN? Not really sure
> though, maybe not.

Refactoring is little difficult here. We need to define new structure for pattern specific support variables (n_patterns, pattern_max_len, pattern_min_len, max_pkt_offset) which can be passed to a common routine created after refactoring. This will affect readability at many other places due to following replacements.
wiphy.wowlan.pattern_min_len -> wiphy.wowlan.pattern.pattern_min_len
wiphy.coalesce.pattern_min_len -> wiphy.coalesce.pattern.pattern_min_len
and so on.

> 
> > +	err = rdev->ops->set_coalesce(&rdev->wiphy, nrule);
> > +	if (err)
> > +		goto error;
> > +
> > +	rdev->coalesce->rules[rdev->coalesce->n_rules++] = nrule;
> 
> Wait ... you can't delete old rules, only add new ones? I think I'm
> confused, I thought the SET command was going to overwrite all old
> rules?

SET command either adds new coalesce rule or removes all existing rules.
Corresponding iw commands are 'add' and 'disable'

Please let me know if you want any specific modifications in the code/logic.

Thanks,
Amitkumar Karwar

> 
> johannes

