Return-Path: <SRS0=HoYG=RC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCA4EC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 06:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F19218E2
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Feb 2019 06:03:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CUk0+f4A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="CUk0+f4A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727187AbfB0GDu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 27 Feb 2019 01:03:50 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:47018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfB0GDu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 27 Feb 2019 01:03:50 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C541760E57; Wed, 27 Feb 2019 06:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551247428;
        bh=bg1q055ZSA5DXeDXp+Zobx9ZK154XcXpJSDpE4TFPCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CUk0+f4A1OlXtMR7hVeOL/kpVGinf2rTQdU9+WyRzIUMMTr82riy0qCYUw5WPa3+P
         7EcwSoLWhquR1BRYaJLxtPS+5lydlQVt6L/8H2HJco9DQqIzCri2Qkz+w2a0NbReuL
         sDR9HvZU7vmm0u8LeH6XJtIq6zypJ+xCfsB3ikMs=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id E43E460CED;
        Wed, 27 Feb 2019 06:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551247428;
        bh=bg1q055ZSA5DXeDXp+Zobx9ZK154XcXpJSDpE4TFPCo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CUk0+f4A1OlXtMR7hVeOL/kpVGinf2rTQdU9+WyRzIUMMTr82riy0qCYUw5WPa3+P
         7EcwSoLWhquR1BRYaJLxtPS+5lydlQVt6L/8H2HJco9DQqIzCri2Qkz+w2a0NbReuL
         sDR9HvZU7vmm0u8LeH6XJtIq6zypJ+xCfsB3ikMs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 27 Feb 2019 11:33:47 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCHv2 1/9] nl80211: New netlink command for TID specific
 configuration
In-Reply-To: <20190226122901.focow4odsbkmv7jn@bars>
References: <1550813554-11581-1-git-send-email-tamizhr@codeaurora.org>
 <1550813554-11581-2-git-send-email-tamizhr@codeaurora.org>
 <20190226122901.focow4odsbkmv7jn@bars>
Message-ID: <1be400e2f95b87ca0f9e7144177a9b3e@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sergey,
> 
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>  include/net/cfg80211.h       |  35 +++++++++++++++
>>  include/uapi/linux/nl80211.h |  51 ++++++++++++++++++++++
>>  net/wireless/nl80211.c       | 102 
>> +++++++++++++++++++++++++++++++++++++++++++
>>  net/wireless/rdev-ops.h      |  11 +++++
>>  net/wireless/trace.h         |  18 ++++++++
>>  5 files changed, 217 insertions(+)
> 
> ...
> 
>> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
>> index 82d5e1e..352eb4a2 100644
>> --- a/net/wireless/nl80211.c
>> +++ b/net/wireless/nl80211.c
>> @@ -280,6 +280,13 @@ static int validate_ie_attr(const struct nlattr 
>> *attr,
>>                 
>> NLA_POLICY_NESTED_ARRAY(nl80211_psmr_peer_attr_policy),
>>  };
>> 
>> +static const struct nla_policy
>> +nl80211_attr_tid_config_policy[NL80211_ATTR_TID_CONFIG_MAX + 1] = {
>> +       [NL80211_ATTR_TID_CONFIG_TID] = NLA_POLICY_MAX(NLA_U8, 7),
> 
> Such a policy permits configuration of per-TID settings, either
> for per-STA or for all the STAs. However it is not possible to
> perform configuration for all TIDs at once, e.g. passing -1 value
> to driver.
> 
> Maybe simplify policy and use .type = NLA_U8 ?
> 
> Sanity check, if needed, can be performed by driver or even by 
> firmware.
> 
Sure, we can have like that. And do you feel driver should advertise 
support to perform configuration for all TIDs(like accepting tid -1) ?

>> +       [NL80211_ATTR_TID_CONFIG_NOACK] =
>> +                       NLA_POLICY_MAX(NLA_U8, 
>> NL80211_TID_CONFIG_DISABLE),
>> +};
>> +
>>  const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
>>         [NL80211_ATTR_WIPHY] = { .type = NLA_U32 },
>>         [NL80211_ATTR_WIPHY_NAME] = { .type = NLA_NUL_STRING,
>> @@ -541,6 +548,8 @@ static int validate_ie_attr(const struct nlattr 
>> *attr,
>>         [NL80211_ATTR_PEER_MEASUREMENTS] =
>>                 NLA_POLICY_NESTED(nl80211_pmsr_attr_policy),
>>         [NL80211_ATTR_AIRTIME_WEIGHT] = NLA_POLICY_MIN(NLA_U16, 1),
>> +       [NL80211_ATTR_TID_CONFIG] =
>> +                       
>> NLA_POLICY_NESTED(nl80211_attr_tid_config_policy),
>>  };
> 
> ...
> 
>> +static int nl80211_set_tid_config(struct sk_buff *skb,
>> +                                 struct genl_info *info)
>> +{
>> +       struct cfg80211_registered_device *rdev = info->user_ptr[0];
>> +       struct nlattr *attrs[NL80211_ATTR_TID_CONFIG_MAX + 1];
>> +       struct net_device *dev = info->user_ptr[1];
>> +       struct ieee80211_tid_config *tid_conf;
>> +       struct nlattr *tid;
>> +       int conf_idx = 0, rem_conf;
>> +       u32 num_conf = 0, size_of_conf;
>> +       int ret = -EINVAL;
>> +
>> +       if (!info->attrs[NL80211_ATTR_TID_CONFIG])
>> +               return -EINVAL;
>> +
>> +       if (!rdev->ops->set_tid_config)
>> +               return -EOPNOTSUPP;
>> +
>> +       nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
>> +                           rem_conf)
>> +               num_conf++;
>> +
>> +       size_of_conf = sizeof(struct ieee80211_tid_config) +
>> +               num_conf * sizeof(struct ieee80211_tid_cfg);
>> +
>> +       tid_conf = kzalloc(size_of_conf, GFP_KERNEL);
>> +       if (!tid_conf)
>> +               return -ENOMEM;
>> +
>> +       tid_conf->n_tid_conf = num_conf;
>> +
>> +       if (info->attrs[NL80211_ATTR_MAC])
>> +               tid_conf->peer = 
>> nla_data(info->attrs[NL80211_ATTR_MAC]);
>> +       else
>> +               tid_conf->peer = NULL;
>> +
>> +       nla_for_each_nested(tid, info->attrs[NL80211_ATTR_TID_CONFIG],
>> +                           rem_conf) {
>> +               ret = nla_parse_nested(attrs, 
>> NL80211_ATTR_TID_CONFIG_MAX, tid,
>> +                                      NULL, NULL);
>> +
>> +               if (ret)
>> +                       return ret;
>> +
>> +               if (!attrs[NL80211_ATTR_TID_CONFIG_TID])
>> +                       return -EINVAL;
>> +
>> +               ret = parse_tid_conf(rdev, attrs, 
>> &tid_conf->tid_conf[conf_idx],
>> +                                    tid_conf->peer);
>> +               if (ret)
>> +                       goto bad_tid_conf;
>> +
>> +               conf_idx++;
>> +       }
>> +
>> +       return rdev_set_tid_config(rdev, dev, tid_conf);
> 
> What is the ownership rule for tid_conf ? In other words, who is
> responsible for freeing this structure ?
> 
> Unless I am missing something, in the suggested patches there is no
> kfree for this structure and all the nested structures (see Tx bitrate
> patch), neither in cfg80211/mac80211 nor in ath10k.
> 
> As far as I understand, we have two options here. One option is to
> explicitly specify that ownership is passed to the caller, similar
> to nl80211_set_reg. Another option is to release memory in this
> function after driver makes copies of all necessary fields,
> e.g. see nl80211_set_mac_acl.
> 
Thanks for pointing out, will free it in this function(cfg80211) itself. 
I will make the change and send next patchset.
>> +
>> +bad_tid_conf:
>> +       kfree(tid_conf);
>> +       return ret;
>> +}

Thanks,
Tamizh.
