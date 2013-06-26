Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:34366 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751658Ab3FZSzV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 14:55:21 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Bing Zhao <bzhao@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Wed, 26 Jun 2013 11:53:44 -0700
Subject: RE: [PATCH v4 2/2] cfg80211/nl80211: Add packet coalesce support
Message-ID: <5FF020A1CFFEEC49BD1E09530C4FF59510356238C8@SC-VEXCH1.marvell.com> (sfid-20130626_205525_778438_2E880BCF)
References: <1372212237-5687-1-git-send-email-bzhao@marvell.com>
	 <1372212237-5687-2-git-send-email-bzhao@marvell.com>,<1372259597.13529.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1372259597.13529.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi Johannes,

Thanks for your comments.

>> +struct cfg80211_coalesce {
>> +     struct cfg80211_coalesce_rules **rules;

>I don't really see why this should be a double pointer? The
>coalesce_rules struct is small enough that you could just allocate an
>array of that, no?

Actually it came from our previous design which used to add one rule per iw command by allocating an array of rule pointers.
You are right. We will use normal pointer and allocate an array of rules in updated version.

>>  /**
>> + * struct wiphy_coalesce_support - coalesce support data
>> + * @n_rules: maximum number of coalesce rules
>> + * @n_patterns: number of supported patterns
>> + *   (see nl80211.h for the pattern definition)
>> + * @pattern_max_len: maximum length of each pattern
>> + * @pattern_min_len: minimum length of each pattern
>> + * @max_pkt_offset: maximum Rx packet offset

>Should there be any limits on the timer? Will the firmware actually work
>if I set it to (useless) values like 2^32-1 msecs?

Makes sense. There should be a limit for colaescing delay. We will add new parameter 'max_delay'.

>Also -- is n_patterns per rule, or global? It seems global, but in the
>rules you can have multiple patterns per rule?

n_patterns is per rule. We will update description of 'n_patterns'.

>> + * @NL80211_CMD_GET_COALESCE: Get currently supported coalesce rules.
>> + *
>> + * @NL80211_CMD_SET_COALESCE: Configure coalesce rules or clear existing rules.

> I'd prefer no space between the two :)
Sure.

>> +struct nl80211_coalesce_rule_support {
>> +     __u32 max_rules;
>> +     struct nl80211_pattern_support pat;

>(timing stuff would also go here, I suppose)
Yes. The new parameter will be added here.


>> +     new_rule->delay = nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_DELAY]);
>no check that it actually exists?

>> +     new_rule->condition =
>> +             nla_get_u32(tb[NL80211_ATTR_COALESCE_RULE_CONDITION]);
>ditto. easy to crash, no?

Thanks. We will add checks to see if these attributes are present.

> +     if (!rdev->wiphy.coalesce)
> +             return -EOPNOTSUPP;
> +     if (!rdev->ops->set_coalesce)
> +             return -EOPNOTSUPP;

>could combine the conditions :)
Ack.

>> +     new_coalesce = kzalloc(sizeof(*new_coalesce), GFP_KERNEL);
>> +     new_coalesce->rules = kcalloc(coalesce->n_rules,
>> +                                     sizeof(void *), GFP_KERNEL);
>*kaboom*
>> +     cfg80211_rdev_free_coalesce(rdev->coalesce);
>> +     rdev->coalesce = new_coalesce;
>> +
>> +     err = rdev->ops->set_coalesce(&rdev->wiphy, rdev->coalesce);
>> +     if (err)
>> +             goto error;
>> +
>> +     return 0;
>> +error:
>> +     cfg80211_rdev_free_coalesce(new_coalesce);

>*kaboom* if it ever fails, and you then do get_coalesce -- should
>probably assign only after setting the new value successfully?

Thanks for pointing this out. We will take care of this error path.

Regards,
Amitkumar Karwar
