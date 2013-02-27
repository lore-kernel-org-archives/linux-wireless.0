Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:50228 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab3B0PG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 10:06:59 -0500
Received: by mail-ie0-f180.google.com with SMTP id bn7so725757ieb.11
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 07:06:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361968754.8172.6.camel@jlt4.sipsolutions.net>
References: <1361891395-59990-1-git-send-email-nbd@openwrt.org>
	<CAL1gcdO-SYTeXQhaGQgwE8=ZpK=S9YOnSuizR9WGCHA-X+7kyw@mail.gmail.com>
	<1361968754.8172.6.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Feb 2013 16:06:59 +0100
Message-ID: <CAL1gcdM2a_7u+M+LZrUA+q2fO2Xo=ZYmpgSQEhJ0LebiwmkiwQ@mail.gmail.com> (sfid-20130227_160702_771272_C324B3DE)
Subject: Re: [PATCH 3.9] rt2x00: error in configurations with mesh support disabled
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 27, 2013 at 1:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2013-02-27 at 13:37 +0100, Gertjan van Wingerde wrote:
>> Hi Felix,
>>
>> On Tue, Feb 26, 2013 at 4:09 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>> > If CONFIG_MAC80211_MESH is not set, cfg80211 will now allow advertising
>
> typo: "will not allow"
>
>> > interface combinations with NL80211_IFTYPE_MESH_POINT present.
>> > Add appropriate ifdefs to avoid running into errors.
>>
>> I'm not sure if rt2x00 is the proper place to fix this. To me it
>> doesn't look good to have to sprinkle these kind of ifdefs throughout
>> the drivers to check if mac80211 has mesh enabled.
>> I would prefer a solution where drivers are still able to indicate
>> that they support mesh interfaces, but where mac80211/cfg80211 prevent
>> these kind of interfaces from being created.
>>
>> @Johannes: What is your view on this?
>
> It would be nicer, but the data is const so mac80211 can't modify it,
> and I don't see that we should add a lot of code/handshaking to
> mac80211/cfg80211 just to avoid one ifdef here.
>

OK. No worries. Was just looking if there was an alternative.

I'll ack Felix' patch then

-- 
---
Gertjan
