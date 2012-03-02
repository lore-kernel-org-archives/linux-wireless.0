Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37122 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965463Ab2CBXaP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 18:30:15 -0500
Received: by vbbff1 with SMTP id ff1so1980354vbb.19
        for <linux-wireless@vger.kernel.org>; Fri, 02 Mar 2012 15:30:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330730316.3865.0.camel@jlt3.sipsolutions.net>
References: <1330729524-1010-1-git-send-email-thomas@cozybit.com>
 <1330729524-1010-3-git-send-email-thomas@cozybit.com> <1330730316.3865.0.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 2 Mar 2012 15:29:54 -0800
Message-ID: <CAG6hwVNhs7Fk1VLbvpj0sa5C=HE7iy46xFBU0uoJ-YOj6YYoOg@mail.gmail.com> (sfid-20120303_003019_726394_8D7C0A4A)
Subject: Re: [PATCH 3/3] mac80211: fix mesh airtime link metric estimating
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 2, 2012 at 3:18 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-02 at 15:05 -0800, Thomas Pedersen wrote:
>> Airtime link metric estimation was broken in HT mesh, use
>> cfg80211_calculate_bitrate to get the right rate value.
>
>> -     if (sta->last_tx_rate.flags & IEEE80211_TX_RC_MCS)
>> +     sta_set_sinfo(sta, &sinfo);
>> +     rate = cfg80211_calculate_bitrate(&sinfo.txrate);
>> +     if (WARN_ON(!rate))
>>               return MAX_METRIC;
>
> Patch 1 should be rolled into this, but I don't like it -- you fill a
> lot of info you don't need, I think the rate should be factored out of
> sta_set_sinfo then
>

Yes that would be better.

Thanks,
Thomas
