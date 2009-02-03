Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:49330 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759383AbZBCAFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 19:05:31 -0500
Received: by gxk14 with SMTP id 14so1419041gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 16:05:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <498788F3.5040502@erley.org>
References: <1233617946-25094-1-git-send-email-lrodriguez@atheros.com>
	 <498788F3.5040502@erley.org>
Date: Mon, 2 Feb 2009 16:05:29 -0800
Message-ID: <43e72e890902021605o34daf1f3k762d9d3d23484ae7@mail.gmail.com> (sfid-20090203_010548_817942_88DE22AA)
Subject: Re: [PATCH v2] iw: add MCS set parsing
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pat-lkml <pat-lkml@erley.org>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2009 at 3:59 PM, pat-lkml <pat-lkml@erley.org> wrote:
> Luis R. Rodriguez wrote:
>> This adds MCS set parsing to iw. When you can 'iw list' you can
>> now see the MCS set actually parsed, this can tell you information
>> such as all the RX/TX MCS indexes supported, max TX spatial streams,
>> if TX unequal modulation is supported and your max supported HT
>> RX data rate.
>>
>> This is as per 802.11n Draft 7 on section 7.3.2.57.4 Supported MCS Set field.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>
> Worked for me with ath9k (Supports mcs rates) and rtl8187 (doesn't
> support mcs rates) devices in the same system.
>
> Tested-by: Pat Erley <pat-lkml@erley.org>

Thanks, BTW I should mention a place to lookup the MCS index to rate maps:

http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n#MCSRates

So ath9k for example should only show up to MCS index 15 right now as
that is the max for two spatial streams.

Someone with ilw5000 though or those shiny new iwl6000 may be able to
get more because IIRC they have 3 spatial streams, someone correct me
if I'm wrong.

  Luis
