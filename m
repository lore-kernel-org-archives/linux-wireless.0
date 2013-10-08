Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47766 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab3JHKeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Oct 2013 06:34:04 -0400
Received: by mail-vc0-f179.google.com with SMTP id ht10so3453627vcb.24
        for <linux-wireless@vger.kernel.org>; Tue, 08 Oct 2013 03:34:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1381222401-21999-1-git-send-email-johannes@sipsolutions.net>
References: <1381222401-21999-1-git-send-email-johannes@sipsolutions.net>
Date: Tue, 8 Oct 2013 12:34:03 +0200
Message-ID: <CAB3XZEe+vVezWHBkOt_M4pfqCu--c78EuyMEmGD2oqcpP9=c-w@mail.gmail.com> (sfid-20131008_123408_827750_14BC03F5)
Subject: Re: [PATCH] nl80211: vendor command support
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 8, 2013 at 11:53 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Add support for vendor-specific commands to nl80211. This is
> intended to be used for really vendor-specific functionality
> that can't be implemented in a generic fashion for any reason.
> It's *NOT* intended to be used for any normal/generic feature
> or any optimisations that could be implemented across drivers.
>
> Currently, only vendor commands (with replies) are supported,
> no dump operations or vendor-specific notifications.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
[...]

>
>  #ifdef CONFIG_NL80211_TESTMODE
>  static struct genl_multicast_group nl80211_testmode_mcgrp = {
> @@ -6633,11 +6686,11 @@ static int nl80211_testmode_do(struct sk_buff *skb, struct genl_info *info)
>         if (!info->attrs[NL80211_ATTR_TESTDATA])
>                 return -EINVAL;
>
> -       rdev->testmode_info = info;
> +       rdev->cur_cmd_info = info;
>         err = rdev_testmode_cmd(rdev, wdev,
>                                 nla_data(info->attrs[NL80211_ATTR_TESTDATA]),
>                                 nla_len(info->attrs[NL80211_ATTR_TESTDATA]));
> -       rdev->testmode_info = NULL;
> +       rdev->cur_cmd_info = NULL;
>
>         return err;
>  }

[...]

> +
> +int cfg80211_vendor_cmd_reply(struct sk_buff *skb)
> +{
> +       struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
> +       void *hdr = ((void **)skb->cb)[1];
> +       struct nlattr *data = ((void **)skb->cb)[2];
> +
> +       if (WARN_ON(!rdev->cur_cmd_info)) {
> +               kfree_skb(skb);
> +               return -EINVAL;
> +       }
> +
> +       nla_nest_end(skb, data);
> +       genlmsg_end(skb, hdr);
> +       return genlmsg_reply(skb, rdev->cur_cmd_info);
> +}
don't you miss the rdev->cur_cmd_info initialization in case of
vendor_cmd (like it's being done in testmode)?

Eliad.
