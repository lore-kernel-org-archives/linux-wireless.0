Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:59864 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752736Ab2G3L3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 07:29:50 -0400
Message-ID: <5016702D.8000801@net.t-labs.tu-berlin.de> (sfid-20120730_133030_892593_B411BF3A)
Date: Mon, 30 Jul 2012 13:29:49 +0200
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org
Subject: Re: [PATCH 1/2] mac80211: Add support of transmit power control (TPC)
 per data packet
References: <1343404809-70329-1-git-send-email-thomas@net.t-labs.tu-berlin.de>  <1343404809-70329-2-git-send-email-thomas@net.t-labs.tu-berlin.de>  (sfid-20120727_180037_367100_88493A5C) <1343633674.4452.3.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343633674.4452.3.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes

Johannes Berg schrieb:

> On Fri, 2012-07-27 at 18:00 +0200, Thomas Huehn wrote:
> 
>>   * &struct ieee80211_tx_info contains an array of these structs
>> - * in the control information, and it will be filled by the rate
>> - * control algorithm according to what should be sent. For example,
>> - * if this array contains, in the format { <idx>, <count> } the
>> + * in the control information, and it will be filled by the joint rate-
>> + * power control algorithm according to what should be sent. For example,
>> + * if this array contains, in the format { <idx>, <count>, <tpc> } the
>>   * information
>> - *    { 3, 2 }, { 2, 2 }, { 1, 4 }, { -1, 0 }, { -1, 0 }
>> + *    { 3, 2, 16 }, { 2, 2, 10 }, { 1, 4, 5 }, { -1, 0, 0 }
>>   * then this means that the frame should be transmitted
>> - * up to twice at rate 3, up to twice at rate 2, and up to four
>> - * times at rate 1 if it doesn't get acknowledged. Say it gets
>> - * acknowledged by the peer after the fifth attempt, the status
>> + * up to twice at rate 3 with 16 dBm, up to twice at rate 2 with 10 dBm,
> 
> You might want to consider using 1/2 or 1/4 dBm granularity? A lot of
> hardware can do that.
> 


The choice of 1 dBm as step width was based on our experiments with
Atheros chips that do support up to 0,5dBm step width. We concluded that
1dBm is sufficient as it provides 20 steps from 1 till 100 mWatt as
dynamic range of control. But there is no problem for my tpc algorithm
to handle a granularity of 0.5 dBm as step size, or any other upcoming
tpc controller. Should we gather some feedback about todays hardware
specs in terms of tx_power abilities? Or should I just apply 0.5 dBm
steps in v2 ?


>>  struct ieee80211_tx_rate {
>>  	s8 idx;
>>  	u8 count;
>>  	u8 flags;
>> +	u8 tpc;
> 
> I'm not sure that should be named "tpc". Think about what that means --
> "transmit power control", but it's really the power value, so it should
> be "txpower" or so.
> 


I will change this to tx_power in v2, sounds reasonable.

Greetings Thomas
