Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f224.google.com ([209.85.217.224]:64288 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495Ab0BFAGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2010 19:06:08 -0500
Received: by gxk24 with SMTP id 24so5136527gxk.1
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2010 16:06:07 -0800 (PST)
Message-ID: <4B6CB26D.9040002@lwfinger.net>
Date: Fri, 05 Feb 2010 18:06:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [RFC][PATCH] b43: LP-PHY: always adjust gain table on channel
 	switch
References: <1265317065-2922-2-git-send-email-zajec5@gmail.com> 	<4B6B8F8B.6020908@lwfinger.net> <69e28c911002050827x63aa5d3cjda82d8c7a643fd82@mail.gmail.com>
In-Reply-To: <69e28c911002050827x63aa5d3cjda82d8c7a643fd82@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2010 10:27 AM, Gábor Stefanik wrote:
> On Fri, Feb 5, 2010 at 4:24 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> On 02/04/2010 02:57 PM, Rafał Miłecki wrote:
>>> ---
>>> GÃ¡bor: I think you missed specs here. Could you check whole routine just for
>>> sure, please? I don't understand whole radio and chanspec magic yet.
>>> ---
>>>  drivers/net/wireless/b43/phy_lp.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
>>> index 185219e..61009ee 100644
>>> --- a/drivers/net/wireless/b43/phy_lp.c
>>> +++ b/drivers/net/wireless/b43/phy_lp.c
>>> @@ -2655,8 +2655,8 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
>>>               if (err)
>>>                       return err;
>>>               lpphy_set_analog_filter(dev, new_channel);
>>> -             lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
>>>       }
>>> +     lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
>>>
>>>       lpphy->channel = new_channel;
>>>       b43_write16(dev, B43_MMIO_CHANNEL, new_channel);
>>
>> Both the lpphy_set_analog_filter() and lpphy_adjust_gain_table() calls should be
>> outside the if statement. I changed the spec a little. It used to test "radio
>> enabled", but I have found that is always true for our driver.
>>
>> Larry
>>
>>
> 
> Isn't set_analog_filter() rev0/1-specific?

The new routines are described in

http://bcm-v4.sipsolutions.net/802.11/PHY/LP/TxFilterInit

http://bcm-v4.sipsolutions.net/802.11/PHY/LP/TxDigFiltUcodeRev2

The revised routines are:

http://bcm-v4.sipsolutions.net/802.11/PHY/LP/SetChanSpecLPPHY

http://bcm-v4.sipsolutions.net/802.11/PHY/LP/PR41573

Larry

