Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:41079 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402AbaKTQrl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 11:47:41 -0500
Received: by mail-wg0-f53.google.com with SMTP id l18so4266631wgh.12
        for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2014 08:47:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416496922.8557.7.camel@sipsolutions.net>
References: <1415895219-19848-1-git-send-email-arik@wizery.com>
 <1415895219-19848-4-git-send-email-arik@wizery.com> <20141113231323.GG24486@wotan.suse.de>
 <CA+XVXfeqfHHDh6AcgkuBW9BwUo-s77+pnbDtP_y=e0dZQVBitg@mail.gmail.com> <1416496922.8557.7.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 20 Nov 2014 18:47:24 +0200
Message-ID: <CA+XVXffq5h-5=wvPQ1PY0CoSa5zgi9j-kNCw5RbWjd0zDLigfA@mail.gmail.com> (sfid-20141120_174801_454167_036C4F5F)
Subject: Re: [PATCH v2 4/4] cfg80211: Allow usermode to query wiphy specific
 regd info
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jonathan Doron <jond@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 5:22 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2014-11-16 at 13:06 +0200, Arik Nemtsov wrote:
>
>> We intend to add a patch to wpa_s to always add the wiphy_idx to
>> NL80211_CMD_GET_REG. With the current approach only drivers with
>> SELF_MANAGED_REG will get wiphy->regd back. This is ok since these are
>> new drivers, which are familiar with this API.
>>
>> But if we use your suggestion and always return wiphy->regd, then some
>> driver like ath9k that uses regulatory_hint() will now get it's
>> private regd returned to the wpa_s that manages it. I'm not saying
>> it's necessarily bad, but it's different than what was returned
>> before. The cfg80211 regdomain is intersected with wiphy->regd, so now
>> ath9k will start getting more permissive channels in usermode.
>>
>> So we thought it's best to enable the new behavior only if the driver
>> explicitly wants it, using a new regulatory flag.
>
> How does this work the other way around - i.e. a newer wpa_s requesting
> per-wiphy information but it not being present?

Then it gets the global one, and it knows it via a wiphy attribute:

      (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) &&
+                   (nla_put_flag(msg, NL80211_ATTR_WIPHY_SELF_MANAGED_REG)))
+                       goto nla_put_failure;

(we won't do this put_flag if it's global)

The supplicant patches are not up yet, but I think for now we will
just act according to the global one. Anyway it has the option to
change policy, since it knows.

>
> It seems to me that either way what the kernel should return is the
> information that will actually be applied when validated, which is of
> course not possible when there are wiphy-specific regdomains and a
> global one is requested (unless there's just one wiphy, which might be
> something to consider making work?)

Well the cfg80211 regdomain is always intersected with all wiphy->regd
in the system, so the global one is always less permissive.
This is of course true before REGULATORY_WIPHY_SELF_MANAGED - in this
case wiphy->regd will not affect the global regd.

With CUSTOM_REG we have a special case, since the regulatory code
doesn't set wiphy->regd, it just applies a user supplied regd to the
wiphy channels (which get validated).
If the user also happens to set  wiphy->regd himself with CUSTOM_REG,
then it makes sense to return the per-wiphy one. The global regd is
meaningless anyway for CUSTOM_REG, and the per-wiphy one might be too.
But I guess we can return it if it's there?

>
> I also don't actually see a driver regulatory flag in this patch, as
> expected, so not sure what exactly you're talking about above?

The regulatory flag is in the previous patch and is called
REGULATORY_WIPHY_SELF_MANAGED. The relevant code here is:

+               if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED)
+                       regdom = get_wiphy_regdom(wiphy);

Arik
