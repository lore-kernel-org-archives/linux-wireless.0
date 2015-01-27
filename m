Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:38791 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbA0Ljt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 06:39:49 -0500
Received: by mail-ie0-f180.google.com with SMTP id rl12so14549157iec.11
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2015 03:39:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422354271.1890.62.camel@sipsolutions.net>
References: <1422348243-4928-1-git-send-email-janusz.dziedzic@tieto.com>
	<1422348243-4928-3-git-send-email-janusz.dziedzic@tieto.com>
	<1422354271.1890.62.camel@sipsolutions.net>
Date: Tue, 27 Jan 2015 12:39:49 +0100
Message-ID: <CALhHN=oGGR=6bq90DB3wEN4Sq7rCCXEZLFR8x0sxot2+3JE=Aw@mail.gmail.com> (sfid-20150127_123953_214609_50B5F96B)
Subject: Re: [RFCv4 3/3] mac80211: add VHT support for IBSS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27 January 2015 at 11:24, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-01-27 at 09:44 +0100, Janusz Dziedzic wrote:
>
>> +u8 *ieee80211_ie_build_vht_oper(u8 *pos, struct ieee80211_sta_vht_cap *vht_cap,
>> +                             const struct cfg80211_chan_def *chandef)
>
>> +     /* 1 stream, MCS0-7 as a min Basic VHT MCS rates */
>> +     vht_oper->basic_mcs_set = cpu_to_le16(0xfffc);
>
> Unless I'm mistaken in my reading of the spec, this will make any
> well-behaved client (i.e. not mac80211) not join this network since it
> supports VHT MCSes.
>
> We seem to do the same for HT:
>
>         /* It seems that Basic MCS set and Supported MCS set
>            are identical for the first 10 bytes */
>         memset(&ht_oper->basic_set, 0, 16);
>         memcpy(&ht_oper->basic_set, &ht_cap->mcs, 10);
>
> but I'm not convinced it's right. It probably only works because nobody
> ever tested against a well-behaved non-HT client? Or perhaps there isn't
> even one?
>
for HT (spec, 20.3.5) - MCS0 .. MSC7 are mandatory - but this is for
all stations (not sure about ibss)
for VHT (22.5, table 22-30) - MCS0...MCS7 are mandatory for nss=1 (20,40,80)
Seems such set is secure?

If I understand correctly case you describe with non-HT client:
non-HT client should not understand HT ies, and HT-only client should
not understand VHT ies?

> I for one am not really comfortable with this restriction - there's very
> little point in making such a restriction in IBSS since if you have it
> then the other node will just form its own network on the same channel
> and you've won nothing - only lost interoperability.
>
> johannes
>
