Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:62741 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbaAOOLV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 09:11:21 -0500
Received: by mail-bk0-f47.google.com with SMTP id mx12so714869bkb.20
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 06:11:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389792568.4338.12.camel@jlt4.sipsolutions.net>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	<1389787494-7361-7-git-send-email-michal.kazior@tieto.com>
	<1389791963.4338.4.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=ppr=npj_f58Ckv4LGpMb+PSTRkzFtLh5jt1PYQCXLhg@mail.gmail.com>
	<1389792568.4338.12.camel@jlt4.sipsolutions.net>
Date: Wed, 15 Jan 2014 15:11:19 +0100
Message-ID: <CA+BoTQkbd8UtGz3DwiL8aKDHAuVob3KZ_MYjEVmy1TeGKYB-oQ@mail.gmail.com> (sfid-20140115_151124_192756_EC5BA030)
Subject: Re: [RFC 6/9] mac80211: track CSA globally
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15 January 2014 14:29, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-01-15 at 14:28 +0100, Michal Kazior wrote:
>> On 15 January 2014 14:19, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > On Wed, 2014-01-15 at 13:04 +0100, Michal Kazior wrote:
>> >> For CSA to be safe it needs to be treated the same
>> >> way as radar detection, scanning and remain on
>> >> channel - all of those (including CSA) must be
>> >> mutually exclusive.
>> >
>> > This I don't understand. Why couldn't you do a remain-on(some
>> > other)-channel or scan while counting down the beacons?
>>
>> My concern is software offchannel (be it scan or roc) involves channel
>> context switches. I wanted to avoid any channel context mangling while
>> CSA is in progress. Does that make sense to you?
>
> No, I don't really get it. Why?

Hmm. Perhaps I was a little overcautious. Offchannel stuff doesn't use
channel contexts at all, right? It recalculates channel in hw_config()
and doesn't touch channel contexts so it should be safe.

Also, I just noticed the patch contains some code that doesn't belong
here (vif_use_channel is protected with the csa_is_active() -- this
should be in the final commit). And this is probably the only part
that is necessary - to prevent anything new from binding to a channel
context that is being used for CSA.


Michał
