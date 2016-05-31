Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35621 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932223AbcEaNKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:10:09 -0400
Received: by mail-oi0-f65.google.com with SMTP id h125so30389010oib.2
        for <linux-wireless@vger.kernel.org>; Tue, 31 May 2016 06:10:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464689804.3076.13.camel@sipsolutions.net>
References: <1463739223-19205-1-git-send-email-zajec5@gmail.com>
	<1464689804.3076.13.camel@sipsolutions.net>
Date: Tue, 31 May 2016 15:10:08 +0200
Message-ID: <CACna6rw--bPNdWcp1Bx1GOKv9cnOgfr5D_YU1RF7A8CS_Bt7Vg@mail.gmail.com> (sfid-20160531_151028_128699_C77D7723)
Subject: Re: [PATCH iw] add "channels" PHY command listing frequencies with
 more details
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31 May 2016 at 12:16, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2016-05-20 at 12:13 +0200, Rafał Miłecki wrote:
>> Channels (frequencies) are getting more details that users may want
>> to
>> know about. E.g. it's important to know which frequencies allow using
>> 40/80/160 MHz channels to setup AP properly.
>>
>> We list channels in "info" command output but it's already quite big
>> and
>> it was agreed to introduce new command rather than expand the old
>> one.
>>
>> This patch adds "channels" command printing what was already
>> available
>> in the "info" plus details about supported channel widths. It also
>> removes DFS info from the "info" output.
>
> Very nice.
>
> Unfortunately, I get compiler warnings about width_* being possibly
> used uninitialized. Can you address that please?

It's nice your compiled got this mistake, my didn't. There were
actually meant to be static. I'll fix that.


>> +TOPLEVEL(channels, NULL, NL80211_CMD_GET_WIPHY, 0, CIB_PHY,
>> handle_channels, "Show available channels.");
>
> Maybe that should be allowed for a CIB_DEV too?

Since this is PHY specific, I was thinking it should be CIB_PHY. I
didn't see reason to allow querying devices. Similarly we don't
support "iw dev wlan0 reg get".

Anyway, I can change that if you think it's better for some reason.
Any hint how to make command usable with both: phy and dev?

-- 
Rafał
