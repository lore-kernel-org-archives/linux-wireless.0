Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36037 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262AbbFKKAR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 06:00:17 -0400
Received: by iebps5 with SMTP id ps5so3031873ieb.3
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 03:00:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1434016002.1915.7.camel@sipsolutions.net>
References: <CACna6rwHXzGTZ+NS9PpZENJATVzRzm1Wkija0_CrveMoM05d5g@mail.gmail.com>
	<1434015922.1915.6.camel@sipsolutions.net>
	<1434016002.1915.7.camel@sipsolutions.net>
Date: Thu, 11 Jun 2015 12:00:16 +0200
Message-ID: <CACna6ry_VRbUbEQeVXC5j68VzPOkJ-qOsAGzKN8XswhHXnO+tw@mail.gmail.com> (sfid-20150611_120023_935861_D6DFF125)
Subject: Re: Exposing enum ieee80211_channel_flags to user
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 June 2015 at 11:46, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2015-06-11 at 11:45 +0200, Johannes Berg wrote:
>> On Thu, 2015-06-11 at 11:35 +0200, Rafał Miłecki wrote:
>>
>> > iw also wasn't helpful:
>> > Frequencies:
>> >         * 5180 MHz [36] (30.0 dBm)
>> >         * 5200 MHz [40] (30.0 dBm)
>> >         * 5220 MHz [44] (30.0 dBm)
>> >         * 5240 MHz [48] (30.0 dBm)
>> >
>> > After some in-kernel debugging (nl80211_set_wiphy,
>> > cfg80211_chandef_usable, cfg80211_secondary_chans_ok) I finally
>> > realized it was because of:
>> > IEEE80211_CHAN_NO_80MHZ
>> >
>> > Do you have any idea how we could handle such cases nicely? To let
>> > user find out what's going on (wrong)?
>> >
>> > Should "iw" be extended to print flag names? Or should hostapd check
>> > for channels in some smarter way? Any other ideas?
>>
>> We already have the flags exposed to iw, it's just not printing them.
>> There was a patch to print them, but it wasn't complete, and the
>> submitter kinda went away. You can see the discussion here:
>>
>> http://mid.gmane.org/1425452686-28196-1-git-send-email-arnagara@qti.qualcomm.com
>
> Upon rereading, I think my preference would be to remove much of the
> channel list information and add a separate iw command.

Do you mean removing channel list from "iw phy X info"? Can you
suggest the new command name?

-- 
Rafał
