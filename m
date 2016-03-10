Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57601 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbcCJOw3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 09:52:29 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 042/113] rtl8xxxu: Initial implementation of rtl8723bu_config_channel()
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
	<1456783551-28315-43-git-send-email-Jes.Sorensen@redhat.com>
	<87y49qjtoc.fsf@purkki.adurom.net>
Date: Thu, 10 Mar 2016 09:52:28 -0500
In-Reply-To: <87y49qjtoc.fsf@purkki.adurom.net> (Kalle Valo's message of "Thu,
	10 Mar 2016 16:26:11 +0200")
Message-ID: <wrfjk2la2xn7.fsf@redhat.com> (sfid-20160310_155231_970522_CC625C07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> This is a first stab of implementing rtl8723bu_config_channel(). For
>> now this will only do 20MHz channels.
>>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> [...]
>
>> +static void rtl8723bu_config_channel(struct ieee80211_hw *hw)
>> +{
>> +	struct rtl8xxxu_priv *priv = hw->priv;
>> +	u32 val32, rsr;
>> +	u8 val8, opmode, subchannel;
>> +	u16 rf_mode_bw;
>> +	bool ht = true;
>> +	int sec_ch_above, channel;
>> +	int i;
>> +
>> +	rf_mode_bw = rtl8xxxu_read16(priv, REG_WMAC_TRXPTCL_CTL);
>> +	rf_mode_bw &= ~WMAC_TRXPTCL_CTL_BW_MASK;
>> +	rsr = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);
>> +	channel = hw->conf.chandef.chan->hw_value;
>> +
>> +/* Hack */
>
> Indentation.

I can send you a v2 of this with it indented.

Jes
