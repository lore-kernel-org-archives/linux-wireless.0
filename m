Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52375 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727846AbeIRTr1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Sep 2018 15:47:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id y139-v6so2684317wmc.2
        for <linux-wireless@vger.kernel.org>; Tue, 18 Sep 2018 07:14:38 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: sgruszka@redhat.com
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
Date: Tue, 18 Sep 2018 16:14:33 +0200
Message-Id: <1537280073-9873-1-git-send-email-pozega.tomislav@gmail.com> (sfid-20180918_161442_230269_89A288CC)
In-Reply-To: <20180918122015.GB15481@redhat.com>
References: <20180918122015.GB15481@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 18 Sep 2018 14:20:16 +0200, Stanislaw Gruszka wrote:

>On Mon, Sep 17, 2018 at 06:32:51PM +0200, Tomislav Požega wrote:
>> Use curr_band instead of rf->channel among various subroutines -
>> mostly for 2.4GHz band but in some circumstances for 5GHz band too.
>
>What is the reason for that change ?

Operating band should be fetched from device capabilities, not from userspace
variables. More changes will needed to be made to accomplish that.

>
>> @@ -9265,8 +9278,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>>  	if (WARN_ON_ONCE(!spec->channels))
>>  		return -ENODEV;
>>  
>> -	spec->supported_bands = SUPPORT_BAND_2GHZ;
>> -	if (spec->num_channels > 14)
>> +	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
>> +		spec->supported_bands = SUPPORT_BAND_2GHZ;
>> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
>>  		spec->supported_bands |= SUPPORT_BAND_5GHZ;
>>  
>>  	/*
>> @@ -9336,7 +9350,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>>  			info[i].default_power3 = default_power3[i];
>>  	}
>>  
>> -	if (spec->num_channels > 14) {
>> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
>>  		default_power1 = rt2800_eeprom_addr(rt2x00dev,
>>  						    EEPROM_TXPOWER_A1);
>>  		default_power2 = rt2800_eeprom_addr(rt2x00dev,
>
>Above looks wrong.
>
>Thanks
>Stanislaw

Worked fine when I tried run two USB cards (RT3070-RF0005, RT5390-RF5370).
Why do you think it's wrong? Is there a dual-band card that operates on
both bands at the same time?
