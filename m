Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:46767 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1AIPrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Jan 2011 10:47:03 -0500
Message-ID: <20110109174656.86162gssuhct8hog@hayate.sektori.org>
Date: Sun, 09 Jan 2011 17:46:56 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org, Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
Subject: Re: [RFC PATCH 10/17] zd1211rw: implement beacon fetching and
 handling ieee80211_get_buffered_bc()
References: <20110104234745.25309.72030.stgit@fate.lan>
 <20110104234910.25309.19235.stgit@fate.lan>
 <201101062246.38932.chunkeey@googlemail.com>
In-Reply-To: <201101062246.38932.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Christian Lamparter <chunkeey@googlemail.com>:

> On Wednesday 05 January 2011 00:49:10 Jussi Kivilinna wrote:
>> diff --git a/drivers/net/wireless/zd1211rw/zd_mac.c  
>> b/drivers/net/wireless/zd1211rw/zd_mac.c
>> index aace010..a3c7e8f 100644
>> --- a/drivers/net/wireless/zd1211rw/zd_mac.c
>> +++ b/drivers/net/wireless/zd1211rw/zd_mac.c
>> @@ -958,16 +958,46 @@ static int zd_op_config(struct ieee80211_hw  
>> *hw, u32 changed)
>>  	return zd_chip_set_channel(&mac->chip, conf->channel->hw_value);
>>  }
>>
>> +static void zd_beacon_done(struct zd_mac *mac)
>> +{
>
> this is an interesting one...
>
> Since zd_beacon_done also uploads the next beacon so long in advance,
> there could be an equally long race between the outdated state of the
> next beacon's DTIM broadcast traffic indicator (802.11-2007 7.3.2.6)
> which -in your case- was uploaded almost a beacon interval ago and
> the xmit of ieee80211_get_buffered_bc *now*.
>
> The dtim bc/mc bit might be not set, when a mc/bc arrived after the
> beacon was uploaded, but before the "beacon done event" from the
> hardware. So, dozing stations don't expect the broadcast traffic
> and of course, they might miss it completely.
>
> It's probably better to fix this in mac80211 (see the attached hack).

Ok, should I add this to my patchset?

>
> In fact, you could just as well drop "[09/17] zd1211rw: implement
> seq_num for IEEE80211_TX_CTL_ASSIGN_SEQ"... unless of course, I'm
> an idiot and there is a really clever way around these issues.

Oh well, I should have checked this more closely before doing that  
patch. HW is assigning seq-numbers already and that patch is not needed.

-Jussi


