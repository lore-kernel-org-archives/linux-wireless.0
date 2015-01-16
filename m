Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:62105 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611AbbAPMsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 07:48:53 -0500
Received: by mail-ig0-f181.google.com with SMTP id r2so3044776igi.2
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 04:48:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1421410704.9214.10.camel@sipsolutions.net>
References: <1421404724-32326-1-git-send-email-janusz.dziedzic@tieto.com>
	<1421404724-32326-6-git-send-email-janusz.dziedzic@tieto.com>
	<1421405703.9214.4.camel@sipsolutions.net>
	<CALhHN=pkvz9qiQNWvXF6xwfhpmmhbUaW0PVnOWDhgWYT0nVY=w@mail.gmail.com>
	<1421410704.9214.10.camel@sipsolutions.net>
Date: Fri, 16 Jan 2015 13:48:53 +0100
Message-ID: <CALhHN=ot=nZWt4buNAw=i-Be7apE8H9Xr1-do+VWr+LmjX6zng@mail.gmail.com> (sfid-20150116_134858_725386_D2BE9DE3)
Subject: Re: [RFCv2 6/6] mac80211: IBSS setup correctly BW for VHT
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 January 2015 at 13:18, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2015-01-16 at 13:08 +0100, Janusz Dziedzic wrote:
>> On 16 January 2015 at 11:55, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Fri, 2015-01-16 at 11:38 +0100, Janusz Dziedzic wrote:
>> >
>> >> +                             /* we both use VHT */
>> >> +                             struct ieee80211_vht_cap vhtcap_ie;
>> >> +                             struct ieee80211_sta_vht_cap vht_cap = sta->sta.vht_cap;
>> >> +
>> >> +                             ieee80211_vht_oper_to_chandef(channel,
>> >> +                                                           elems->vht_operation,
>> >> +                                                           &chandef);
>> >
>> > Ok maybe I'm missing something - but can't this erroneously configure
>> > the local HW to 160 MHz when it doesn't even support it, or so?
>> >
>> I will check this more. But seems chandef (sta chandef) is a local
>> variable here, not used by the way.
>> So, our chandef is form cfg80211 (sdata->u.ibss.chandef) and we don't
>> change this.
>> Orginaly this sta chandef was used to compare with ibss->chandef.
>>
>> -                       if (chandef.center_freq1 !=
>> -                           sdata->u.ibss.chandef.center_freq1)
>> -                               htcap_ie.cap_info &=
>> -
>> cpu_to_le16(~IEEE80211_HT_CAP_SUP_WIDTH_20_40);
>>
>> But for me this check seems as not needed, eg.
>> We support VHT80 and other ibss have only HT40 support - so we will
>> have different center_freq1 - but still could operate, while sta_add
>> and correct rates for sta configured.
>> One I think we could check here is, if our chandef and sta chandef overlap.
>>
>> Anyway, I am not sure I understand your question correctly, you mean eg.
>> we work in VHT80 mode and other ibss join in VHT160 mode? Does it
>> really matter while we will use sta_add for this new V160 "station"
>> and configure supported rates for this station?
>
> Well like I said - I might not understand this correctly. But the
> ieee80211_vht_oper_to_chandef() function doesn't - iirc - take into
> account local capabilities. As a consequence, if a VHT160 station joins
> the chandef might be 160 while we're only supporting 80?
>
> But anyway - I see that at least what I originally thought was wrong -
> this code isn't concerned with picking up the channel from the peer to
> join the networks together, I guess. That's what I was worried about.
> That code I haven't seen and checked though - so perhaps you can look
> there if it correctly handles trying to form a network when the peer has
> higher capabilities than the local hw.
>
I am testing different combinations and TP

HT20 <-> HT40
HT20 <-> VHT80
HT40 <-> VHT80
HT40 <-> VHT80
VHT80 <-> HT20
VHT80 <-> HT40

using ath9k and ath10k. What I see using iw wlan0 info, we always
using chandef we pass from cfg80211.
We also update nss/rates/bw correctly in sta_rc_update().
But anyway will do more tests.

BR
Janusz
