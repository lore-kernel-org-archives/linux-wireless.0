Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40003 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731362AbeISV7A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 17:59:00 -0400
Subject: Re: [PATCH 3/7] netlink: set extack error message in nla_validate()
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
 <20180919120900.28708-4-johannes@sipsolutions.net>
From: David Ahern <dsahern@gmail.com>
Message-ID: <3e7aadff-5228-660a-537a-9b54c11fa5cc@gmail.com> (sfid-20180919_182028_241875_01ED3F17)
Date: Wed, 19 Sep 2018 09:20:19 -0700
MIME-Version: 1.0
In-Reply-To: <20180919120900.28708-4-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/19/18 5:08 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In nla_parse() we already set this, but it makes sense to
> also do it in nla_validate() which already also sets the
> bad attribute pointer.
> 
> CC: David Ahern <dsahern@gmail.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  lib/nlattr.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index e2e5b38394d5..33404745bec4 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -180,9 +180,13 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
>  	int rem;
>  
>  	nla_for_each_attr(nla, head, len, rem) {
> -		int err = validate_nla(nla, maxtype, policy, NULL);
> +		static const char _msg[] = "Attribute failed policy validation";
> +		const char *msg = _msg;
> +		int err = validate_nla(nla, maxtype, policy, &msg);
>  
>  		if (err < 0) {
> +			if (extack)
> +				extack->_msg = msg;
>  			NL_SET_BAD_ATTR(extack, nla);

msg, NL_SET_BAD_ATTR and extack handling all can be done in validate_nla
removing the need for the same message ("Attribute failed policy
validation") to be declared twice and simplifying the extack setting.

>  			return err;
>  		}
> 
