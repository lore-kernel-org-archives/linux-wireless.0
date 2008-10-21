Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.185]:58346 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYJUAoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 20:44:23 -0400
Received: by rn-out-0910.google.com with SMTP id k40so779231rnd.17
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2008 17:44:21 -0700 (PDT)
Message-ID: <314b98fa0810201744r4c5d1e9blade8353a0b480f63@mail.gmail.com> (sfid-20081021_024428_698428_D0FCECC1)
Date: Mon, 20 Oct 2008 17:44:21 -0700
From: "Colin McCabe" <colin@cozybit.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] Add nl80211 commands to get and set o11s mesh networking parameters
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224527130.27899.60.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48fcc3c2.38652c0a.297d.533e@mx.google.com>
	 <1224527130.27899.60.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 20, 2008 at 11:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-10-20 at 10:40 -0700, colin@cozybit.com wrote:
>> The two new commands are NL80211_CMD_GET_MESH_PARAMS and
>> NL80211_CMD_SET_MESH_PARAMS. There is a new attribute enum,
>> NL80211_ATTR_MESH_PARAMS, which enumerates the various mesh configuration
>> parameters.
>>
>> Moved struct mesh_config from mac80211/ieee80211_i.h to net/cfg80211.h.
>> nl80211_get_mesh_params and nl80211_set_mesh_params unpack the netlink messages
>> and ask the driver to get or set the configuration.  This is done via two new
>> function stubs, get_mesh_params and set_mesh_params, in struct cfg80211_ops.
>
>> +     /* Set the mask */
>> +     mask = 0;
>> +     for (i = 0; i < NL80211_MESHCONF_ATTR_MAX; ++i)
>> +             if (tb[i+1])
>> +                     mask |= (1 << i);
>
> Can you move that into the macro so it's set whenever you parse any of
> the values? I think you probably missed that in my earlier mail? Or was
> there a reason not to?

Sure.
I wasn't sure how strong your preference was, earlier.

>> +     /* Fill in the params struct */
>> +     FILL_IN_MESH_PARAM_IF_SET(tb, cfg, dot11MeshRetryTimeout,
>> +                     NL80211_MESHCONF_RETRY_TIMEOUT, nla_get_u16);
>
>
>> +             .cmd = NL80211_CMD_GET_MESH_PARAMS,
>> +             .doit = nl80211_get_mesh_params,
>> +             .policy = nl80211_policy,
>> +             .flags = GENL_ADMIN_PERM,
>
> Does this really need admin permission for getting the values?

Hmm, I guess not.

Colin

>
> johannes
>
