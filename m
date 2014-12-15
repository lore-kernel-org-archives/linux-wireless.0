Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:63199 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbaLORHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 12:07:20 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so15121301wgh.40
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 09:07:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418387875.2470.31.camel@sipsolutions.net>
References: <1417622897-30768-1-git-send-email-arik@wizery.com> <1418387875.2470.31.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 15 Dec 2014 19:07:03 +0200
Message-ID: <CA+XVXfcdxSBOAOXkDW+e86zxOaRiomD83=6KEj5qWro2w6Wgmg@mail.gmail.com> (sfid-20141215_180725_852426_F2B9EAE1)
Subject: Re: [PATCH v8 1/4] cfg80211: allow usermode to query wiphy specific regdom
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2014 at 2:37 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-12-03 at 18:08 +0200, Arik Nemtsov wrote:
>
>>   * @NL80211_CMD_GET_REG: ask the wireless core to send us its currently set
>> - *   regulatory domain.
>> + *   regulatory domain. If %NL80211_ATTR_WIPHY is specified and the device
>> + *   has a private regulatory domain, it will be returned. Otherwise, the
>> + *   global regdomain will be returned.
>> + *   A device will have a private regulatory domain if it uses the
>> + *   regulatory_hint() API. Even when a private regdomain is used the channel
>> + *   information will still be mended according to further hints from
>> + *   the regulatory core to help with compliance.
>
> I think you need to document the new availability of the dump version of
> this now.

Sure.

>
>> +     if (!regdom && !cfg80211_regdomain) {
>
> I'm not sure why sparse doesn't warn here, but I think that should
> probably use rcu_access_pointer(cfg80211_regdomain).
>
> More realistically, the regdomain can never be NULL I think, so is that
> even needed? OTOH, if it can be NULL, then you must make this check
> after the rcu_dereference, which would make this code easier to follow.

You're right. I'll remove the check. I don't see a way where it can be
set to NULL at any point.

Arik
