Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60519 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbbAZJt2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 04:49:28 -0500
Received: by mail-ie0-f181.google.com with SMTP id rp18so7629621iec.12
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 01:49:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422264304.1890.17.camel@sipsolutions.net>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	<1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	<CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com>
	<1422260772.1890.7.camel@sipsolutions.net>
	<CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com>
	<1422262812.1890.12.camel@sipsolutions.net>
	<CALhHN=r=Bzh=EyzurEGWWHo3ozYuCf-X6qdKv0tgas_MtvtA4Q@mail.gmail.com>
	<1422264304.1890.17.camel@sipsolutions.net>
Date: Mon, 26 Jan 2015 10:49:27 +0100
Message-ID: <CALhHN=prfa0KoQYeN5+ZsUOH6y4=a73xZTY+O+xbu2OeGTO5Hg@mail.gmail.com> (sfid-20150126_104932_708567_0E686D17)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 January 2015 at 10:25, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-01-26 at 10:19 +0100, Janusz Dziedzic wrote:
>> On 26 January 2015 at 10:00, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Mon, 2015-01-26 at 10:37 +0200, Arik Nemtsov wrote:
>> >
>> >> >> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
>> >> >> have no use for it in IBSS I can add it later.
>> >> >
>> >> > Why would you want to require VHT rates?
>> >>
>> >> Are you sure it's required and no the other way around in this case?
>> >> As in specifying which rates are not supported.
>> >> Not sure it means the same thing as in the HT instance.
>> >
>> > Well, it does mean the same thing ("these rates are required") but it's
>> > encoded in a way that you have to set it to all-ones (rather than
>> > all-zeroes) to mean "no requirements", so in that sense you're right.
>> >
>>
>> I already set this in the patch:
>> +       vht_oper->basic_mcs_set = vht_cap->vht_mcs.rx_mcs_map;
>
> But do you really want to require the local capabilities as basic MCSes?
>
I am not sure. Will check spec and how we do that for an AP.

BR
Janusz
