Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:60352 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbbAZKBE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 05:01:04 -0500
Received: by mail-ie0-f172.google.com with SMTP id rd18so7697746iec.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jan 2015 02:01:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=prfa0KoQYeN5+ZsUOH6y4=a73xZTY+O+xbu2OeGTO5Hg@mail.gmail.com>
References: <1421757318-8343-1-git-send-email-janusz.dziedzic@tieto.com>
	<1421757318-8343-4-git-send-email-janusz.dziedzic@tieto.com>
	<CA+XVXfd=dh4_n30y8JzAdo1jNB9eO=qk8mwpzB6vGbSnsk59zg@mail.gmail.com>
	<1422260772.1890.7.camel@sipsolutions.net>
	<CA+XVXfdCobu73WOdCDPLuW1XBHQ7otsJG235zwD=DJccaKN2=w@mail.gmail.com>
	<1422262812.1890.12.camel@sipsolutions.net>
	<CALhHN=r=Bzh=EyzurEGWWHo3ozYuCf-X6qdKv0tgas_MtvtA4Q@mail.gmail.com>
	<1422264304.1890.17.camel@sipsolutions.net>
	<CALhHN=prfa0KoQYeN5+ZsUOH6y4=a73xZTY+O+xbu2OeGTO5Hg@mail.gmail.com>
Date: Mon, 26 Jan 2015 11:01:03 +0100
Message-ID: <CALhHN=rEmCGLPQT7pasLBuExQCWVSqx0Ka1FuQua8UFYjp4tCA@mail.gmail.com> (sfid-20150126_110107_975631_E8D20825)
Subject: Re: [RFCv3 4/4] mac80211: add VHT support for IBSS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 January 2015 at 10:49, Janusz Dziedzic <janusz.dziedzic@tieto.com> wrote:
> On 26 January 2015 at 10:25, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Mon, 2015-01-26 at 10:19 +0100, Janusz Dziedzic wrote:
>>> On 26 January 2015 at 10:00, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> > On Mon, 2015-01-26 at 10:37 +0200, Arik Nemtsov wrote:
>>> >
>>> >> >> Shouldn't you also set vht_oper->basic_mcs_set here? Of course if you
>>> >> >> have no use for it in IBSS I can add it later.
>>> >> >
>>> >> > Why would you want to require VHT rates?
>>> >>
>>> >> Are you sure it's required and no the other way around in this case?
>>> >> As in specifying which rates are not supported.
>>> >> Not sure it means the same thing as in the HT instance.
>>> >
>>> > Well, it does mean the same thing ("these rates are required") but it's
>>> > encoded in a way that you have to set it to all-ones (rather than
>>> > all-zeroes) to mean "no requirements", so in that sense you're right.
>>> >
>>>
>>> I already set this in the patch:
>>> +       vht_oper->basic_mcs_set = vht_cap->vht_mcs.rx_mcs_map;
>>
>> But do you really want to require the local capabilities as basic MCSes?
>>
> I am not sure. Will check spec and how we do that for an AP.
>
The Basic VHT-MCS and NSS Set field indicates the VHT-MCSs for each
number of spatial streams in VHT
PPDUs that are supported by all VHT STAs in the BSS (including IBSS and MBSS).

hostapd set this as: 0xfffc - 1 stream, MCS0-7 as a min Basic VHT MCS
rates - this seems to be secure.

BR
Janusz
