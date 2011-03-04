Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46246 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab1CDSwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 13:52:09 -0500
Received: by vxi39 with SMTP id 39so2273700vxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Mar 2011 10:52:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299238332.4348.3.camel@jlt3.sipsolutions.net>
References: <1299208307-9428-1-git-send-email-thomas@cozybit.com>
 <1299208307-9428-3-git-send-email-thomas@cozybit.com> <1299238332.4348.3.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 4 Mar 2011 10:51:47 -0800
Message-ID: <AANLkTinZvEprR31SK3Gy1r3Rb3MW1XEWQK+Dv27g8+m=@mail.gmail.com>
Subject: Re: [PATCH 2/7] mac80211: New constant definitions for SAE
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Thomas Pedersen <thomas@cozybit.com>,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 4, 2011 at 3:32 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2011-03-03 at 19:11 -0800, Thomas Pedersen wrote:
>
>> +++ b/include/linux/nl80211.h
>> @@ -1817,6 +1817,7 @@ enum nl80211_bss_status {
>>   * @NL80211_AUTHTYPE_SHARED_KEY: Shared Key authentication (WEP only)
>>   * @NL80211_AUTHTYPE_FT: Fast BSS Transition (IEEE 802.11r)
>>   * @NL80211_AUTHTYPE_NETWORK_EAP: Network EAP (some Cisco APs and mainly LEAP)
>> + * @NL80211_AUTHTYPE_SAE: Simultaneous Authentication of Equals
>>   * @__NL80211_AUTHTYPE_NUM: internal
>>   * @NL80211_AUTHTYPE_MAX: maximum valid auth algorithm
>>   * @NL80211_AUTHTYPE_AUTOMATIC: determine automatically (if necessary by
>
> I think some of the auth code in nl80211 or so needs to catch this.
> Maybe nl80211_valid_auth_type() wouldn't be the right place, but for now
> it doesn't look like we'd be able to support this in managed mode, yet
> it wouldn't get errors and at least in the cfg80211 SME fall back to
> using OPEN, which is no fun.

We'll withdraw this then, given that we are not using it for mesh either.

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
