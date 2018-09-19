Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41252 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731956AbeISWXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 18:23:24 -0400
Subject: Re: [PATCH 5/7] netlink: prepare validate extack setting for
 recursion
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20180919120900.28708-1-johannes@sipsolutions.net>
 <20180919120900.28708-6-johannes@sipsolutions.net>
 <18ea5293-5a12-7aca-7373-12d1ab3a0821@gmail.com>
 <1537374995.10305.47.camel@sipsolutions.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <50773483-5732-8874-c5bf-99fa09d7e94a@gmail.com> (sfid-20180919_184446_707036_FC1344F3)
Date: Wed, 19 Sep 2018 09:44:37 -0700
MIME-Version: 1.0
In-Reply-To: <1537374995.10305.47.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/18 9:36 AM, Johannes Berg wrote:
> On Wed, 2018-09-19 at 09:28 -0700, David Ahern wrote:
>> On 9/19/18 5:08 AM, Johannes Berg wrote:
>>> diff --git a/lib/nlattr.c b/lib/nlattr.c
>>> index 966cd3dcf31b..2b015e43b725 100644
>>> --- a/lib/nlattr.c
>>> +++ b/lib/nlattr.c
>>> @@ -69,7 +69,7 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
>>>  
>>>  static int validate_nla(const struct nlattr *nla, int maxtype,
>>>  			const struct nla_policy *policy,
>>> -			const char **error_msg)
>>> +			struct netlink_ext_ack *extack, bool *extack_set)
>>
>> extack_set arg is not needed if you handle the "Attribute failed policy
>> validation" message and NL_SET_BAD_ATTR here as well.
> 
> I'm not sure that's true, but perhaps you have a better idea than me?
> 
> My thought would be to introduce an "error" label in validate_nla(),
> that sets up the extack data.
> 
> Then we could skip over that if we have a separate message to report,
> making the NLA_REJECT case easier.
> 
> However, if we do nested validation, I'm not sure it really is that much
> easier? We still need to figure out if the nested validation was setting
> the message (and bad attr), rather than it having been set before we
> even get into this function.
> 
> So let's say we have
> 
>         case NLA_NESTED:
>                 /* a nested attributes is allowed to be empty; if its not,
>                  * it must have a size of at least NLA_HDRLEN.
>                  */
>                 if (attrlen == 0)
>                         break;
>                 if (attrlen < NLA_HDRLEN)
>                         return -ERANGE;
>                 if (pt->validation_data) {
>                         int err;
> 
>                         err = nla_validate_parse(nla_data(nla), nla_len(nla),
>                                                  pt->len, pt->validation_data,
>                                                  extack, extack_set, NULL);
>                         if (err < 0)
>                                 return err;
>                 }
>                 break;
> 
> right now after all the patches.
> 
> The "return -ERANGE;" would become "{ err = -ERANGE; goto error; }", but
> I'm not really sure we can cleanly handle the other case?
> 
> Hmm. Maybe it works if we ensure that nla_validate_parse() has no other
> return points that can fail outside of validate_nla(), or we set up the
> extack data there as well, so that once we have a nested
> nla_validate_parse() we know that it's been set.
> 
> Actually, we need to do that anyway so that we can move the setting into
> validate_nla(), and then it should work.
> 
> Mechanics aside - I'll take a look later tonight or tomorrow - do you
> think the goal/external interface of this makes sense?

If it fails and returns (nested and all) on the first failure it should
be fine. I was thinking something like this (whitespace damaged on paste):

diff --git a/lib/nlattr.c b/lib/nlattr.c
index e335bcafa9e4..f18f0ed3f1cd 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -73,6 +73,7 @@ static int validate_nla(const struct nlattr *nla, int
maxtype,
 {
        const struct nla_policy *pt;
        int minlen = 0, attrlen = nla_len(nla), type = nla_type(nla);
+       int err = -ERANGE;

        if (type <= 0 || type > maxtype)
                return 0;
@@ -89,7 +90,7 @@ static int validate_nla(const struct nlattr *nla, int
maxtype,
        switch (pt->type) {
        case NLA_FLAG:
                if (attrlen > 0)
-                       return -ERANGE;
+                       goto out_err;
                break;

        case NLA_BITFIELD32:

...
(similar for other error places. the one EINVAL needs to set err first)
...

@@ -156,6 +157,10 @@ static int validate_nla(const struct nlattr *nla,
int maxtype,
        }

        return 0;
+out_err:
+       NL_SET_ERR_MSG_ATTR(extack, nla,
+                           "Attribute failed policy validation");
+       return err;
 }

 /**
