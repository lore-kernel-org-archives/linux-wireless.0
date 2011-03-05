Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58310 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1CETfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 14:35:20 -0500
Received: by vws12 with SMTP id 12so2838021vws.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Mar 2011 11:35:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299333920.3826.5.camel@jlt3.sipsolutions.net>
References: <1299288252-28314-1-git-send-email-thomas@cozybit.com>
 <1299288252-28314-2-git-send-email-thomas@cozybit.com> <1299333920.3826.5.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Sat, 5 Mar 2011 11:34:59 -0800
Message-ID: <AANLkTikAR4v8T48q7eSoOU+R+foqTUT+6Kr4U6ZnWwu7@mail.gmail.com>
Subject: Re: [PATCH 1/4 v2] mac80211: Enable mesh security from userspace
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 6:05 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-03-04 at 17:24 -0800, Thomas Pedersen wrote:
>
>
>> +#define NL80211_MESH_SETUP_VENDOR_IE NL80211_MESH_SETUP_IE
>
>> -     NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE,
>> +     NL80211_MESH_SETUP_IE,
>> +     NL80211_MESH_SETUP_ENABLE_SECURITY,
>
> Clearly the intent was to be API compatible (ABI is guaranteed anyway),
> but that seems to not work this way since the names don't match.

Ouch, you are right.  Should have been
+#define NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE NL80211_MESH_SETUP_IE
We'll send a fixup.

>> +     if (tb[NL80211_MESH_SETUP_IE]) {
>>               struct nlattr *ieattr =
>> -                     tb[NL80211_MESH_SETUP_VENDOR_PATH_SEL_IE];
>> +                     tb[NL80211_MESH_SETUP_IE];
>>               if (!is_valid_ie_attr(ieattr))
>>                       return -EINVAL;
>> -             setup->vendor_ie = nla_data(ieattr);
>> -             setup->vendor_ie_len = nla_len(ieattr);
>> +             setup->ie = nla_data(ieattr);
>> +             setup->ie_len = nla_len(ieattr);
>> +             if (eid_in_ie_attr(ieattr, WLAN_EID_RSN))
>> +                     setup->is_secure =
>> +                     nla_get_flag(tb[NL80211_MESH_SETUP_ENABLE_SECURITY]);
>
> That last check seems a bit pointless -- I'd trust userspace (aka allow
> it to shoot itself in the foot) and not check that there's RSN
> information when it says it wants security -- maybe WAPI will come up
> with mesh security at some point ;-)

Enabling security without an RSN will result in mesh node that can't
communicate with anyone in the mesh, secured or not.   I prefer
keeping that check in place to avoid annoying misconfigurations.  You
still think it's pointless?  (In fact I was contemplating a more
strict check by returning EINVAL instead of ignoring the request when
userspace enables security and does not pass an RSN.)

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
