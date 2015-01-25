Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:36248 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbbAYKZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 05:25:36 -0500
Received: by mail-lb0-f176.google.com with SMTP id z12so3723536lbi.7
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 02:25:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422007493.2728.26.camel@sipsolutions.net>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com> <1422007493.2728.26.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 25 Jan 2015 12:25:19 +0200
Message-ID: <CA+XVXfdXv5s_hs+jdpshGjo7RdS7fCW52F82Ojf4wQ90fVoCiw@mail.gmail.com> (sfid-20150125_112542_684116_143494FC)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2015 at 12:04 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> +++ b/net/mac80211/util.c
>> @@ -2317,6 +2317,41 @@ u8 *ieee80211_ie_build_ht_oper(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
>>       return pos + sizeof(struct ieee80211_ht_operation);
>>  }
>>
>> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
>> +                             const struct cfg80211_chan_def *chandef)
>
> I still think you should keep this a static function in ibss.c since
> nobody else is going to use it soon - the only possible user is mesh
> anyway I think.

Actually TDLS needs to use it pretty soon as well :)

Arik
