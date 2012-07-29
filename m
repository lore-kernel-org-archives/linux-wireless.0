Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48141 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2G2Uvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jul 2012 16:51:43 -0400
Received: by obbuo13 with SMTP id uo13so7882160obb.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2012 13:51:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50151A71.9010306@net.t-labs.tu-berlin.de>
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com>
	<1343485971-31360-3-git-send-email-mickflemm@gmail.com>
	<501404BE.7040606@net.t-labs.tu-berlin.de>
	<5014065B.7070909@net.t-labs.tu-berlin.de>
	<CAFtRNNzPnh_C2JqC4WjKrChn=QPcC4UG-8PigyGp4WLXuCb5GQ@mail.gmail.com>
	<50151A71.9010306@net.t-labs.tu-berlin.de>
Date: Sun, 29 Jul 2012 23:51:43 +0300
Message-ID: <CAFtRNNyG1hhw1+petgJaDSnSPNbO-iMPAwA+Vr8xKOj5xGeD5w@mail.gmail.com> (sfid-20120729_225147_436614_61CBBED3)
Subject: Re: [ath5k-devel] [PATCH 3/4] ath5k: Preserve tx power level
 requested from above on phy_init
From: Nick Kossifidis <mickflemm@gmail.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: jirislaby@gmail.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/7/29 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
> Hi Nick,
>
>
>> Anyway if readability is the issue we can just do something like
>>
>> int txpower_halfdb = 0;
>>
>> [...]
>>
>> if(ah->power_level) {
>>  txpower_halfdb = ah->power_level * 2;
>> } else {
>>  txpower_halfdb = AR5K_TUNE_MAX_TXPOWER;
>> }
>>
>> and then it'll look like this
>>
>> ret = ath5k_hw_txpower(ah, channel, txpower_halfdb);
>
>
> I like this way you proposed here. But it is quite personal and compact
> wise the other version is in lead.
>

The thing is it doesn't initialize ah->ah_txpower.txp_requested, read below.

>> >
>> (wouldn't it be weird if someone from above asked us
>> what tx power was requested and we reply with max tx power ?).
>
> you mean in case someone from above did never requested something but
> ask us what was requested and we tell him that nothing was requested
> thats why we use max tx_power ... makes more sense ? :)
>

I mean that ah->ah_txpower.txp_requested or
ah->ah_txpower.txp_user_pwr in your case, both implicate that they are
initialized by the user. We shouldn't initialize them ourselves. Think
of it like this: we don't have permission to write this variable, we
only read it.

If you didn't like my example and you think it doesn't make sense,
here is another one:
How will we distinguish the case when a user asks for the max power
from the case where we have initialized ah->ah_txpower.txp_requested
to max ?



-- 
GPG ID: 0xEE878588
As you read this post global entropy rises. Have Fun ;-)
Nick
