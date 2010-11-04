Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:34104 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089Ab0KDLlX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 07:41:23 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 04:41:11 -0700
From: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>
To: Bruno Randolf <br1@einfach.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Thu, 4 Nov 2010 17:11:18 +0530
Subject: RE: [PATCH v2] ath9k_htc: Fix beacon distribution in IBSS mode
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAB4D6CB@CHEXMB-01.global.atheros.com>
References: <1285054089-6707-1-git-send-email-rmanoharan@atheros.com>
 <201009271018.42232.br1@einfach.org>,<201011041905.26464.br1@einfach.org>
In-Reply-To: <201011041905.26464.br1@einfach.org>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > -   qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
>> > +   /* For WIFI Beacon Distribution
>> > +    * Long slot time  : 2x cwmin
>> > +    * Short slot time : 4x cwmin
>> > +    */
>> > +   if (ah->slottime == ATH9K_SLOT_TIME_20)
>> > +           qi.tqi_cwmin = 2*qi_be.tqi_cwmin;
>> > +   else
>> > +           qi.tqi_cwmin = 4*qi_be.tqi_cwmin;
>> >
>> >     qi.tqi_cwmax = qi_be.tqi_cwmax;
>> >
>> >     if (!ath9k_hw_set_txq_props(ah, priv->beaconq, &qi)) {
>>
>> i am wondering - how does this relate to what i read in IEEE802.11-2007:
>>
>>    11.1.2.2 Beacon generation in an IBSS
>>
>>    b) Calculate a random delay uniformly distributed in the range between
>> zero and twice aCWmin × aSlotTime,
>>
>> wouldn't that mean that cwmin for the beacon queue should be 0 and cwmax
>> should be 2x cwmin * slot time?
>>
>> if the beacon queue cwmin is higher than the best effort queue, it would
>> mean that the best effort queue gets precedence over beacon transmissions.
>> but we want beacons to get sent out in any case.
>>
> also, what is the rationale behind using the best effort queue as a
> reference for cwmin/cwmax?
>
>I'm following up my own message since I just stumbled across that paragraph,
>which IMHO would imply that the beacon queue should be based on AC_VO instead
>of AC_BE, if anything.
>
>[9.2.4.2 HCF contention-based channel access (EDCA):
>Management frames shall be sent using the access category AC_VO
>without being restricted by admission control procedures. A QoS STA shall also
>send management frames using the access category AC_VO before associating with
>any BSS, even if there is no QoS facility available in that BSS.]
>
>Also I still doubt that 4*qi_be.tqi_cwmin is correct concerning the standard
>paragraph which i quoted before. Did I miss something?

Hi Bruno,

Sorry for long gap. somehow I missed your mail. During our Interop Testing, we
observed that ath9k based cards utilized the channel more frequently that others.
To ensure fair beacon distribution, BE queue parameters were set to beacon queue.

But still I couldn't find specific WMM parameters for beacon queue except
hostap.conf which stats that

tx_queue_beacon_aifs=2
tx_queue_beacon_cwmin=3
tx_queue_beacon_cwmax=7
tx_queue_beacon_burst=1.5

With these parameter we need to test again :) Any comments are welcome.

- Rajkumar