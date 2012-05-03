Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754357Ab2ECUXV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:23:21 -0400
Received: by obbtb18 with SMTP id tb18so2923537obb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 13:23:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336074010.5167.19.camel@jlt3.sipsolutions.net>
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
 <1335820832-18887-3-git-send-email-ashok@cozybit.com> <1336074010.5167.19.camel@jlt3.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 3 May 2012 13:23:00 -0700
Message-ID: <CACcxo+rNUbiitNUvZewaNpXnT8BJTtSvJLsgDnZ44+MYAzbVuA@mail.gmail.com> (sfid-20120503_222325_079456_4E810050)
Subject: Re: [PATCH v2 3/4] mac80211: Allow nonHT/HT peering in mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 3, 2012 at 12:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:
>
>> -         (local->_oper_channel_type !=
>> -          ieee80211_ht_oper_to_channel_type(ie->ht_operation)))
>> +         local->_oper_channel_type > NL80211_CHAN_HT20 &&
>> +         sta_channel_type > NL80211_CHAN_HT20 &&
>> +         local->_oper_channel_type != sta_channel_type)
>
> I don't think you should use > operators since we may later have to add
> other channel types like 5 and 10 MHz.
>
Sure. I will send a fix patch reflecting this change.

> johannes
>

Thanks,
Ashok
