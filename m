Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:58538 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaBUKJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 05:09:10 -0500
Received: by mail-la0-f42.google.com with SMTP id hr17so347242lab.15
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 02:09:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392976535.4346.46.camel@jlt4.sipsolutions.net>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	<1392972748.4346.37.camel@jlt4.sipsolutions.net>
	<CALhHN=ovcEvFsYSjc_dZSS0j0Zmiq-y6y2Kwo5RK1Qpb456MbQ@mail.gmail.com>
	<1392976535.4346.46.camel@jlt4.sipsolutions.net>
Date: Fri, 21 Feb 2014 11:09:08 +0100
Message-ID: <CALhHN=ommG9hB7HmMecJPb1UHdn1OqHRnSbS16b-BxowwP61FQ@mail.gmail.com> (sfid-20140221_110916_329132_3AE04D43)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 February 2014 10:55, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2014-02-21 at 10:47 +0100, Janusz Dziedzic wrote:
>> On 21 February 2014 09:52, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:
>> >
>> >> +++ b/include/net/regulatory.h
>> >> @@ -155,6 +155,7 @@ struct ieee80211_reg_rule {
>> >>       struct ieee80211_freq_range freq_range;
>> >>       struct ieee80211_power_rule power_rule;
>> >>       u32 flags;
>> >> +     u32 dfs_cac_ms;
>> >>  };
>> >
>> > Does that really have to be per channel? That's a significant investment
>> > into bss size since we have a lot of channel structs.
>> >
>> This seems easiest way to handle ETSI VHT80/40 case for channels with
>> different CAC time (eg):
>> VHT80:
>> - 116 (60s)
>> - 120 (600s)
>> - 124 (600s)
>> - 128 (600s)
>>
>> VHT40/HT40:
>> - 132 (600s)
>> - 136 (60s)
>
> Huh, but you don't distinguish between channel widths in this whole
> patchset?
>
In patch  cfg80211: DFS get CAC time from regulatory I check whole
chandef and get max channel cac value.

BR
Janusz
