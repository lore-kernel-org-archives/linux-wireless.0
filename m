Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36914 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1H0XxA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 19:53:00 -0400
Message-ID: <4E598358.9090209@openwrt.org> (sfid-20110828_015306_498285_6AB0A219)
Date: Sun, 28 Aug 2011 01:52:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k_hw: Update IFS parameters properly
References: <1314436569-6855-1-git-send-email-rmanohar@qca.qualcomm.com> <4E597D8F.4050506@openwrt.org>
In-Reply-To: <4E597D8F.4050506@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-08-28 1:28 AM, Felix Fietkau wrote:
> On 2011-08-27 11:16 AM, Rajkumar Manoharan wrote:
>>  Configure IFS parameters read from chip in case of
>>  full rate channel and non-AR9287 v1.3+. And also
>>  read the ack and cts timeouts from chip and increase the
>>  timeout when coverage class is defined. For half/Quarter
>>  rate channel, IFS values needs to be reconfigured.
>>  This patch removes the 2GHz workaround done for
>>  acktimeout(64 us) because of reading acktime from chip.
>>  The mentioned IFS parameters for AR9287 v1.3+ was
>>  verified in HT40 2-chanin mode.
>>
>>  @@ -1018,23 +1018,27 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
>>    			sifstime = 10;
>>    	}
>>
>>  -	/* As defined by IEEE 802.11-2007 17.3.8.6 */
>>  -	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
>>  +	if (AR_SREV_9287(ah)&&   AR_SREV_9287_13_OR_LATER(ah)) {
>>  +		/* Verified values (us) in 2chanin HT40 mode */
>>  +		acktimeout = 64;
>>  +		ctstimeout = 48;
>>  +	} else {
>>  +		acktimeout = MS(REG_READ(ah, AR_TIME_OUT), AR_TIME_OUT_ACK)/
>>  +				common->clockrate;
>>  +		ctstimeout = MS(REG_READ(ah, AR_TIME_OUT), AR_TIME_OUT_CTS)/
>>  +				common->clockrate;
>>  +	}
> Why this mess of partially reused values from initvals? I think it's
> much better to just override these based on the standard 802.11 values,
> and selectively add the 64-usec-minimum workaround for 2.4 ghz as needed.
Just sent a smaller, less intrusive patch to replace this one.

- Felix
