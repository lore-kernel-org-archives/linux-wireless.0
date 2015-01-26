Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:33385 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbbAZIhV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 03:37:21 -0500
Received: by mail-lb0-f176.google.com with SMTP id z12so6346854lbi.7
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 00:37:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422260772.1890.7.camel@sipsolutions.net>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
 <1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
 <CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com> <1422260772.1890.7.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 26 Jan 2015 10:37:04 +0200
Message-ID: <CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com> (sfid-20150126_093725_257863_6962C238)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 26, 2015 at 10:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Sun, 2015-01-25 at 12:30 +0200, Arik Nemtsov wrote:
>
>> > +       switch (chandef->width) {
>> > +       case NL80211_CHAN_WIDTH_80:
>> > +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
>> > +               break;
>> > +       case NL80211_CHAN_WIDTH_80P80:
>> > +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
>> > +               vht_oper->center_freq_seg2_idx =
>> > +                       ieee80211_frequency_to_channel(chandef->center_freq2);
>> > +               break;
>> > +       case NL80211_CHAN_WIDTH_160:
>> > +               vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
>> > +               break;
>> > +       default:
>> > +               return pos;
>> > +       }
>>
>> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
>> have no use for it in IBSS I can add it later.
>
> Why would you want to require VHT rates?

Are you sure it's required and no the other way around in this case?
As in specifying which rates are not supported.
Not sure it means the same thing as in the HT instance.

Arik
