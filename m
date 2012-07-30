Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59883 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752329Ab2G3Lph (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 07:45:37 -0400
Message-ID: <501673E1.9010804@net.t-labs.tu-berlin.de> (sfid-20120730_134615_785932_64EEB057)
Date: Mon, 30 Jul 2012 13:45:37 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, linville@tuxdriver.com
Subject: Re: [ath5k-devel] [PATCH 3/4] ath5k: Preserve tx power level requested
 from above on phy_init
References: <1343485971-31360-1-git-send-email-mickflemm@gmail.com> <1343485971-31360-3-git-send-email-mickflemm@gmail.com> <501404BE.7040606@net.t-labs.tu-berlin.de> <5014065B.7070909@net.t-labs.tu-berlin.de> <CAFtRNNzPnh_C2JqC4WjKrChn=QPcC4UG-8PigyGp4WLXuCb5GQ@mail.gmail.com> <50151A71.9010306@net.t-labs.tu-berlin.de> <CAFtRNNyG1hhw1+petgJaDSnSPNbO-iMPAwA+Vr8xKOj5xGeD5w@mail.gmail.com>
In-Reply-To: <CAFtRNNyG1hhw1+petgJaDSnSPNbO-iMPAwA+Vr8xKOj5xGeD5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Nick

Nick Kossifidis schrieb:

> 2012/7/29 Thomas Huehn <thomas@net.t-labs.tu-berlin.de>:
>> Hi Nick,
>>
>>
>>> Anyway if readability is the issue we can just do something like
>>>
>>> int txpower_halfdb = 0;
>>>
>>> [...]
>>>
>>> if(ah->power_level) {
>>>  txpower_halfdb = ah->power_level * 2;
>>> } else {
>>>  txpower_halfdb = AR5K_TUNE_MAX_TXPOWER;
>>> }
>>>
>>> and then it'll look like this
>>>
>>> ret = ath5k_hw_txpower(ah, channel, txpower_halfdb);
>>

> How will we distinguish the case when a user asks for the max power
> from the case where we have initialized ah->ah_txpower.txp_requested
> to max ?

I do not sea any use-case where someone would need this distinction. But
if there is such a need, I would rather store this information in a
variable (e.g. user_set_power=true) explicitly rather than infer it from
fact that our power variable is not initialised. Probably to much of a
personal taste than to be considered further I guess.

Greetings Thomas
