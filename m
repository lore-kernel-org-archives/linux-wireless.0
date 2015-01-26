Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:64698 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbbAZJTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 04:19:06 -0500
Received: by mail-ie0-f179.google.com with SMTP id x19so7548056ier.10
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 01:19:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422262812.1890.12.camel@sipsolutions.net>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	<1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	<CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com>
	<1422260772.1890.7.camel@sipsolutions.net>
	<CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com>
	<1422262812.1890.12.camel@sipsolutions.net>
Date: Mon, 26 Jan 2015 10:19:04 +0100
Message-ID: <CALhHN=r=Bzh=EyzurEGWWHo3ozYuCf-X6qdKv0tgas_MtvtA4Q@mail.gmail.com> (sfid-20150126_101910_460114_30907443)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 January 2015 at 10:00, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-01-26 at 10:37 +0200, Arik Nemtsov wrote:
>
>> >> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
>> >> have no use for it in IBSS I can add it later.
>> >
>> > Why would you want to require VHT rates?
>>
>> Are you sure it's required and no the other way around in this case?
>> As in specifying which rates are not supported.
>> Not sure it means the same thing as in the HT instance.
>
> Well, it does mean the same thing ("these rates are required") but it's
> encoded in a way that you have to set it to all-ones (rather than
> all-zeroes) to mean "no requirements", so in that sense you're right.
>

I already set this in the patch:
+       vht_oper->basic_mcs_set = vht_cap->vht_mcs.rx_mcs_map;

BR
Janusz
