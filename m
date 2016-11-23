Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933977AbcKWKUX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Nov 2016 05:20:23 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 23 Nov 2016 15:50:17 +0530
From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
To: Rob Herring <robh@kernel.org>
Cc: c_traja@qti.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCHv2 3/4] dt: bindings: add new dt entry for BTCOEX feature
 in qcom,ath10k.txt
In-Reply-To: <20161118144406.3se7gnckhcmwqytp@rob-hp-laptop>
References: <1479383064-25718-1-git-send-email-c_traja@qti.qualcomm.com>
 <1479383064-25718-4-git-send-email-c_traja@qti.qualcomm.com>
 <20161118144406.3se7gnckhcmwqytp@rob-hp-laptop>
Message-ID: <df0313af8ab0ed1e7bddcfeca8429632@codeaurora.org> (sfid-20161123_112106_288918_538B53EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the comments.

On 2016-11-18 20:14, Rob Herring wrote:
> On Thu, Nov 17, 2016 at 05:14:23PM +0530, c_traja@qti.qualcomm.com 
> wrote:
>> From: Tamizh chelvam <tamizhchelvam@codeaurora.org>
>> 
>> There two things done in this patch.
>> 
>> 1) 'btcoex_support' flag for BTCOEX feature support by the hardware.
>> 2) 'wlan_btcoex_gpio' is used to fill wlan priority pin number for
>>    BTCOEX priority feature support.
>> 
>> Signed-off-by: Tamizh chelvam <tamizhchelvam@codeaurora.org>
>> ---
>>  .../bindings/net/wireless/qcom,ath10k.txt          |    4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt 
>> b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> index 74d7f0a..08150e2d 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -46,6 +46,10 @@ Optional properties:
>>  				 hw versions.
>>  - qcom,ath10k-pre-calibration-data : pre calibration data as an 
>> array,
>>  				     the length can vary between hw versions.
>> +- btcoex_support  : should contain eithr "0" or "1" to indicate 
>> btcoex
>> +		    support by the hardware.
> 
> This is BT coexistence? Make this boolean and n

Yes, this is BT coexistence. And I didn't get what are you trying to say 
in this "Make this boolean and n"
> 
>> +- btcoex_gpio_pin :  btcoex gpio pin number for the device which
>> +		     supports BTCOEX.
> 
> This is a pin number on the chip, not any pin number Linux GPIO subsys
> cares about, right? Is there a connection to the host too, or this is
> internal between BT and WiFi?

This is internal between BT and wifi.
> 
> Do you really need 2 properties? Does supporting this feature require
> the GPIO? If so, then the first property is redundant.
> 
Target/driver can hard copy this gpio pin for some chipsets and there we 
will need btcoex_support flag to find the btcoex support.

> Needs vendor prefix and don't use '_'. Should be something like
> 'qcom,bt-coexist-gpio-pin'.
> 
Sure I'll update this and send in v3 patch
