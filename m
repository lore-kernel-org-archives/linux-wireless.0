Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32798 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbeC2HdA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 03:33:00 -0400
Subject: Re: [PATCH v2] wcn36xx: Disable 5GHz for wcn3610
To: Kalle Valo <kvalo@codeaurora.org>
Cc: loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20180329065818.9338-1-rfried@codeaurora.org>
 <874lkzmjxu.fsf@kamboji.qca.qualcomm.com>
From: Ramon Fried <rfried@codeaurora.org>
Message-ID: <2d978343-2057-8424-a249-83a0394da5a7@codeaurora.org> (sfid-20180329_093320_027667_B90DABDA)
Date: Thu, 29 Mar 2018 10:32:55 +0300
MIME-Version: 1.0
In-Reply-To: <874lkzmjxu.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding Bjorn Andersson)


On 3/29/2018 10:15 AM, Kalle Valo wrote:
> (adding devicetree list)
>
> Ramon Fried <rfried@codeaurora.org> writes:
>
>> wcn3610 can only operate on 2.4GHz band due to RF limitation.
>> If wcn36xx digital block is associated with an external IRIS
>> RF module, retrieve the id and disable 5GHz band in case of
>> wcn3610 id.
>>
>> Signed-off-by: Ramon Fried <rfried@codeaurora.org>
>> ---
>> v2: fixed wrong assignment, which is logically introduces the 
>> 	same behaviour, but for correctness.
>>
>>  drivers/net/wireless/ath/wcn36xx/main.c    | 4 +++-
>>  drivers/net/wireless/ath/wcn36xx/wcn36xx.h | 1 +
>>  2 files changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
>> index ab5be6d2c691..833531a68c95 100644
>> --- a/drivers/net/wireless/ath/wcn36xx/main.c
>> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
>> @@ -1146,7 +1146,7 @@ static int wcn36xx_init_ieee80211(struct wcn36xx *wcn)
>>  		BIT(NL80211_IFTYPE_MESH_POINT);
>>  
>>  	wcn->hw->wiphy->bands[NL80211_BAND_2GHZ] = &wcn_band_2ghz;
>> -	if (wcn->rf_id != RF_IRIS_WCN3620)
>> +	if (wcn->rf_id != RF_IRIS_WCN3610 && wcn->rf_id != RF_IRIS_WCN3620)
>>  		wcn->hw->wiphy->bands[NL80211_BAND_5GHZ] = &wcn_band_5ghz;
>>  
>>  	wcn->hw->wiphy->max_scan_ssids = WCN36XX_MAX_SCAN_SSIDS;
>> @@ -1248,6 +1248,8 @@ static int wcn36xx_platform_get_resources(struct wcn36xx *wcn,
>>  	if (iris_node) {
>>  		if (of_device_is_compatible(iris_node, "qcom,wcn3620"))
>>  			wcn->rf_id = RF_IRIS_WCN3620;
>> +		else if (of_device_is_compatible(iris_node, "qcom,wcn3610"))
>> +			wcn->rf_id = RF_IRIS_WCN3610;
>>  		of_node_put(iris_node);
>>  	}
> Should we document qcom,wcn3610 just like wcn3620 is:
>
> Documentation/devicetree/bindings/remoteproc/qcom,wcnss-pil.txt:                    "qcom,wcn3620",
IMHO the mentioned bindings is related to the PIL (peripheral image loaded) which is just the firmware part and has
nothing to do with wifi frontend(IRIS).
