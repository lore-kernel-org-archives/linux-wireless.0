Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0FCE175A85
	for <linux-wireless@vger.kernel.org>; Fri,  2 Oct 2026 17:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790960535; cv=none; b=sVvi0z9hPfg4DvSN2/Rm9yhT9UAm1m1KUC/fEWrZZlPeokY1wA+fNwcSmvldLeuzxBCkNVrWjcPnM1CDeclm1Vcdjd/ryARS6Qnyoa/T9tW2iyfLOwE8HRTKLB0JzkVZdXek7fOUP0wLkkQIFcOqba54PMuH1mte0m2ED9UOebU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790960535; c=relaxed/simple;
	bh=FE/PZv5JfuAwaqpVABOUabbsa29Yfo5y6YCeVvuNU9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=UbWdSKQsw5jBw5QhTR1sLY8drrYyrP7dKhLUF/y5ROlvGHc/jDouyDIoQHADpGUoFGSOFthcUyrS7DytoYy+NLTn245jw17QFcTR2htReNweYZhI2+z+zlUrHNBK+5ZJbyxsBjAMaVcRr1yMv+QQhKvEl/vxx5aQYFyygb9SI8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BB9bwhOA; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BB9bwhOA"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48870973bddso20904f8f.1
        for <linux-wireless@vger.kernel.org>; Fri, 02 Oct 2026 10:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790960532; x=1791565332; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aeb40aOeb6u3o0dJC11RO5hP4rQ2MaG7wkG0NhPfMOQ=;
        b=BB9bwhOA5HGshkrWUwnLjfapS0+7i9srem6iGFE9leO2mp4qf3IThTr796yrQyeRJ+
         l8BoWvpZAEMlpVHOtQw7ot8tdLOUsIZSEEt80KVdnelu0pgHD5GQ0Kz0YO1FJ73TBIJj
         FLQMnuCjdcO4eNemUZWkNQjUASFMF9l6aroD2OCJpWo9vwLoFOlEtSNCfXMnzQ7mbiLS
         8HPZ9/1g3BxgwKcRs0rrDs3tshp4WUVmQWy90GWUqEZAUsSmgdOPfeTFcMV2kGyroXcS
         csdUZiykejF7+hgErpq+ykxDd80PeusEax0TZaAfff6f8jina/LB0SGuGnkp7rNc40cr
         jEPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790960532; x=1791565332;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aeb40aOeb6u3o0dJC11RO5hP4rQ2MaG7wkG0NhPfMOQ=;
        b=o99f/9V0HcStJw35U+QJNXd49n4TGM2VdvWvVfAdkxn3rKxlia7whFjTgSjke9NWcj
         /fXaPtfHcjViOP0gDKNq2CHAPca4gstOY3nLelEWfzyW5aFjaC6GwG3CIuFAPjbfbXgr
         9L3ulo94O9yGUH5Hpy3Zg08WcBMfb2n401t5kINeWkexQhrIH/Z9qY5KpKdgN2OKamTZ
         myOIzgtpSPfoajpNnMawJXXb9u0KdP7s21kHVTC/vj/MiG7L1bmOx61FQSBbODc9WWP1
         FyA25dez/ETxhPQcBAWoS32i6hl2u99pE2Jso7KNGjIosJo7lMi+R7SKY/41Xd/L4Gkx
         lcNw==
X-Forwarded-Encrypted: i=1; AKwUvBwGNupHVZ4255bk/JChaivNwO6Vfo8NJZeO09h+BSufRyA2+XcFyEADCm0M526crzO6rDhM8xzlVpxNuO4Zqw==@vger.kernel.org
X-Gm-Message-State: AFq9FYIUpo3LyJNHD6RMhh0fMKzyznjyvnbehgoL5vNXBF7SSTqbm3xe
	u0zOKMNspJCx+T19W734eaAKD/Oq+G4X78vMRfnaTXHKkYvTfvC/QZj8
X-Gm-Gg: AYBFou1sR5OlQ5yruz63CJ76hufxJx708+NZ6u8P/IbuktdpJSQz2wWimum1PZLvpWG
	6S96Ta2ud5tCeY+ULCKbdj+RXYSq3qhlXcoWeVIKwLq7mzcvPueSCO+0GSN5bDu01Kf3JdkavSD
	DK1UMhoSyiYk5vr2xlct3YhSj32SBXvCVJJvepMm0SiM7NNjuCMLQo5RedXrOyiOoKuee+BAHJy
	jO71LG76vn71ppi9Nrom+JI6sDGTLREZkVC2DtzWoMn2cGUONBgr8fcDVxUApIcDgojsJkStsqK
	kvlFi2fnVOZDOWuhNvwMFOlPhepey/6V0SnNs0+AnXSAUtTQblHjouzmLIg0YHLdrTRCLRyvoyZ
	0byEiB74MjwCyGVVuccrPzpAuFz1ckxGOXCECigsdge9lW99/aOsaTs/36Cqkri1tgDzY5xxGz3
	FxGjzmWJ0Ku43UeWB2eOYNKF/bQ65GxLYf+loHmxIXrMgQE+Z0d9AsVPpk5lnrYoRnAoJDvtI+8
	pWDqA==
X-Received: by 2002:a05:6000:4112:b0:48b:1145:3a37 with SMTP id ffacd0b85a97d-48b11455218mr7797838f8f.13.1790960530911;
        Fri, 02 Oct 2026 10:02:10 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b380fab11sm6728331f8f.16.2026.10.02.10.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 10:02:10 -0700 (PDT)
Message-ID: <dc900baa-a3c7-4962-a11e-9a949af92340@gmail.com>
Date: Fri, 2 Oct 2026 20:02:09 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Problems with rtw89 on 5Ghz wlans.
To: Ping-Ke Shih <pkshih@realtek.com>,
 PierluigiFrullani <pierluigi.frullani@frumar.it>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <10543730.tdPhlSkOF2@topolinux>
 <fab16229-8e70-41a8-83f3-5d04c6035a43@gmail.com>
 <980970f8b4934572aafbd6f5f6020436@realtek.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <980970f8b4934572aafbd6f5f6020436@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 02/10/2026 06:44, Ping-Ke Shih wrote:
> Hi Bitterblue,
> 
> I just quickly give some comments before you send patch.
> 
> Bitterblue Smith <rtl8821cerfe2@gmail.com> wrote:
>> On 30/09/2026 12:21, PierluigiFrullani wrote:
>>> Hello all,
>>>     I'm using Linux Mint 22.1 with kernel 7.0.0-34-generic and a
>>> 02:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8852BE PCIe 802.11ax Wireless
>> Network Controller [1T1R] [10ec:b85b]
>>> that has lot of issues with the 5Ghz wlan.
>>> The problem is that has a very low sensitivity and can detect, in linux, these wlans only when I'm
>> a few feet from access point.
>>>
>>>
>>> I've then swapped the driver with https://github.com/morrownr/rtw89 and found the same behaviour.
>>> I've then opened an issue there :
>>>  https://github.com/morrownr/rtw89/issues/128 and the peoples there managed to find the culprit and
>> patch his driver that now works perfectly.
>>> For my understanding the problem was that my card ( may card model ? ) ( rfe_type 41 ) has only one
>> antenna and is not correctly selected b y the driver.
>>>
>>> Looking into the https://github.com/pkshih/rtw/blob/rtw-next/drivers/net/wireless/realtek/rtw89
>> code I can see that is really similar so then patche applied in the morrownr could possibly apply  also
>> to the vanilla kernel driver.
>>>
>>>
>>> Patch is rather easy and with this patch allied and this driver loaded now the 5Ghz is perfectly working.
>>>
>>>
>>> Would you be interessed in pushing this patch also here ?
>>>
>>>
>>> In case, this is the patch ( also with the comments to verify that the driver loaded is the one that
>> is patched ) :
>>> diff --git a/drivers/net/wireless/realtek/rtw89/mac.c b/drivers/net/wireless/realtek/rtw89/mac.c
>>> index df396fbfca26..81a4be7a593d 100644
>>> --- a/drivers/net/wireless/realtek/rtw89/mac.c
>>> +++ b/drivers/net/wireless/realtek/rtw89/mac.c
>>> @@ -3244,6 +3244,14 @@ static int rtw89_mac_setup_phycap_part0(struct rtw89_dev *rtwdev)
>>>      tx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_TX_NUM);
>>>      rx_ant = u32_get_bits(phycap->w3, RTW89_C2HREG_PHYCAP_W3_ANT_RX_NUM);
>>>
>>> +    if (chip->chip_id == RTL8852B && efuse->rfe_type == 41 &&
> 
> Can we add a quirk instead of checking IC and its rfe type?
> I guess there might be more than one cases afterward. 
> 

I think that should work.

>>> +        tx_nss == 1 && tx_ant == 2 && rx_nss == 1 && rx_ant == 2) {
>>> +        tx_ant = 1;
>>> +        rx_ant = 1;
>>> +
>>> +        rtw89_warn(rtwdev, "fix more stuff for RFE 41\n");
> 
> I think you will change rtw89_warn() to debug level in formal patch, right?
> 

The messages will be gone completely. I only added them to be
sure that Pierluigi is testing the patched code.

>>> +    }
>>> +
>>>      hal->tx_nss = tx_nss ? min_t(u8, tx_nss, chip->tx_nss) : chip->tx_nss;
>>>      hal->rx_nss = rx_nss ? min_t(u8, rx_nss, chip->rx_nss) : chip->rx_nss;
>>>
>>> diff --git a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>> b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>> index 356623341f65..c9ee3c76cfc9 100644
>>> --- a/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>> +++ b/drivers/net/wireless/realtek/rtw89/rtw8852b.c
>>> @@ -771,6 +771,15 @@ static void rtw8852b_btc_set_rfe(struct rtw89_dev *rtwdev)
>>>      } else {
>>>          md->ant.type = BTC_ANT_SHARED;
>>>          md->bt0_pos = BTC_BT_BTG;
>>> +
>>> +        if (md->rfe_type == 41) {
> 
> Use the same quirk by the way. 
> 

This was the initial version of the patch. Since then I changed
it to check hal->tx_nss and hal->rx_nss, to mirror what the
vendor driver does. Is that okay?

>>> +            md->ant.num = 1;
>>> +            md->ant.single_pos = RF_PATH_B;
>>> +            md->ant.btg_pos = RF_PATH_B;
>>> +            md->ant.stream_cnt = 1;
>>> +
>>> +            rtw89_warn(rtwdev, "fix stuff for RFE 41\n");
>>> +        }
>>>      }
>>>      rtwdev->btc.btg_pos = md->ant.btg_pos;
>>>      rtwdev->btc.ant_type = md->ant.type;
>>>
>>>
>>>
>>> All credits must absolutelly go to  dubhater (   https://github.com/dubhater ) that did all
>> troubleshooting and wrote the patch.
>>>
>>> My interest in this is only to have a (vanilla) kernel version of this driver that works correctly
>> as lot of problems are reported by peoples using the same chip.
>>>
>>>
>>>
>>> Thanks
>>>
>>>
>>> Pierluigi
>>
>> Hi,
>>
>> Two other people reported the same problem recently. I decided to wait
>> for them to say if the patch helps or not. But I will send the patch
>> anyway next week.
> 

