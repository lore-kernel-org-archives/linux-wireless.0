Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44285 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151Ab2BBOWd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Feb 2012 09:22:33 -0500
Message-ID: <4F2A9C26.5070201@openwrt.org> (sfid-20120202_152236_276666_414C673A)
Date: Thu, 02 Feb 2012 15:22:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?UTF-8?B?TWFydGluIEh1bmRlYsO4bGw=?= <m.hundeboll@gmail.com>
CC: Seth Forshee <seth.forshee@canonical.com>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: Re: CTS timeout issue with AR9285
References: <20120202042521.GA20635@ubuntu-macmini> <4F2A830A.8000905@openwrt.org> <4F2A9A9D.4000108@gmail.com>
In-Reply-To: <4F2A9A9D.4000108@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-02 3:15 PM, Martin Hundebøll wrote:
> Hi Felix,
> 
> On 2012-02-02 13:35, Felix Fietkau wrote:
>> Please try this patch:
>>
>> --- a/drivers/net/wireless/ath/ath9k/hw.c
>> +++ b/drivers/net/wireless/ath/ath9k/hw.c
>> @@ -1061,13 +1061,16 @@ void ath9k_hw_init_global_settings(struc
>>
>>   	/*
>>   	 * Workaround for early ACK timeouts, add an offset to match the
>> -	 * initval's 64us ack timeout value.
>> +	 * initval's 64us ack timeout value. Use 48us for the CTS timeout.
>>   	 * This was initially only meant to work around an issue with delayed
>>   	 * BA frames in some implementations, but it has been found to fix ACK
>>   	 * timeout issues in other cases as well.
>>   	 */
>> -	if (conf->channel&&  conf->channel->band == IEEE80211_BAND_2GHZ)
>> +	if (conf->channel&&  conf->channel->band == IEEE80211_BAND_2GHZ) {
>>   		acktimeout += 64 - sifstime - ah->slottime;
>> +		ctstimeout += 48 - sifstime - ah->slottime;
>> +	}
>> +
>>
>>   	ath9k_hw_set_sifs_time(ah, sifstime);
>>   	ath9k_hw_setslottime(ah, slottime);
> 
> I have been seeing the same issues with the Atheros 9170 USB chipset
> using the carl9170 driver and firmware, where RST are transmitted
> repeatidly, even though a CTS-reply is seen on the air. I suspect the
> issue to be related to this one, but I am unable to locate any
> calculation or setting of CTS timeout in the driver or firmware.
> 
> Can anyone point me in the right direction to tune the CTS timeout
> with the 9170 chip?
I think your carl9170 CTS issue is likely to be something else, since
AR9170 is using a completely different 802.11 MAC (Zydas design instead
of Atheros).

- Felix
