Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1433BED58;
	Mon, 30 Mar 2026 10:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865908; cv=none; b=Gb663D3KgLwoz+ionJmpJkTm2w1yygN7RWIaswx4PZ0ltts3e3i3d7bmwJTDtQxDNvYPevGPLEAqwj1Qox+qktEtexDh/KgClyNAlJ2OcWc9mqmmQ8++Cfem7DJ8TcvvkES17ANZu+N+YD0F7EIftf3gMXaiugak2lTZkE0rKiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865908; c=relaxed/simple;
	bh=+C/m07xrnjqPCMatJ2aXNKiqXleyo1ulSGuLaHUMa18=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=NuTofwXw0hJiU4e3kHr5mZnx7kTyXndHfq5gPzVerZPiQSsmBBaL/GLBIyCKAysTtO+ATq/ivbWxKVTT5PeMC/ZVf/I9LqhkIWNTzxH1KSI8V8b5gn2j8ZRrAomtFiQwXTjIK/BSTFrnV47faVAnZ9gJJXLpA4vif6k4ticz/Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=BMYiAxLU; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="BMYiAxLU"
Message-ID: <44c0a75e-6e72-49e8-9b15-cb504a494feb@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774865896;
	bh=+C/m07xrnjqPCMatJ2aXNKiqXleyo1ulSGuLaHUMa18=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=BMYiAxLUiIGumw6RyS1KKt0wBhxLSX1O3Csb/1uoGMCYsItSebXTqRhbwuss2xqiY
	 Lf6zuLY+ynwlncarwYnDhywMDyJJsTUKBIUz5TQ2owsrsf9ss1z+R1pH6FkZKrAOKf
	 SJnRJqZ6RA+vHV/OsAAqhEKUQUhJmXJeRi+EqyPQ=
Date: Mon, 30 Mar 2026 12:18:15 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
Subject: Re: [PATCH v5 6/9] arm64: dts: amlogic: t7: khadas-vim4: Add power
 regulators
To: Neil Armstrong <neil.armstrong@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>,
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
 Johannes Berg <johannes@sipsolutions.net>, van Spriel <arend@broadcom.com>
References: <20260326-add-emmc-t7-vim4-v5-0-d3f182b48e9d@aliel.fr>
 <20260326-add-emmc-t7-vim4-v5-6-d3f182b48e9d@aliel.fr>
 <416d42a6-8d99-421c-91aa-e705f23576e2@linaro.org>
Content-Language: en-US
In-Reply-To: <416d42a6-8d99-421c-91aa-e705f23576e2@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/30/26 9:55 AM, Neil Armstrong wrote:
> On 3/26/26 10:59, Ronald Claveau wrote:
>> Add voltage regulator nodes describing the VIM4 power tree,
>> required by peripheral nodes such as the SD card controller.
>>
>> Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
>> Signed-off-by: Ronald Claveau <linux-kernel-dev@aliel.fr>
>> ---
>>   .../dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts  | 90 ++++++++++++
>> ++++++++++
>>   1 file changed, 90 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-
>> vim4.dts b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
>> index fffdab96b12eb..2450084d37642 100644
>> --- a/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
>> +++ b/arch/arm64/boot/dts/amlogic/amlogic-t7-a311d2-khadas-vim4.dts
>> @@ -6,6 +6,8 @@
>>   /dts-v1/;
>>     #include "amlogic-t7.dtsi"
>> +#include <dt-bindings/gpio/amlogic,t7-periphs-pinctrl.h>
>> +#include <dt-bindings/gpio/gpio.h>
>>     / {
>>       model = "Khadas vim4";
>> @@ -45,6 +47,94 @@ xtal: xtal-clk {
>>           #clock-cells = <0>;
>>       };
>>   +    dc_in: regulator-dc-in {
>> +        compatible = "regulator-fixed";
>> +        regulator-name = "DC_IN";
>> +        regulator-min-microvolt = <5000000>;
>> +        regulator-max-microvolt = <5000000>;
>> +        regulator-always-on;
>> +    };
>> +
>> +    sd_3v3: regulator-sdcard-3v3 {
>> +        compatible = "regulator-fixed";
>> +        regulator-name = "SD_3V3";
>> +        regulator-min-microvolt = <3300000>;
>> +        regulator-max-microvolt = <3300000>;
>> +        vin-supply = <&vddao_3v3>;
>> +        gpio = <&gpio GPIOD_11 GPIO_ACTIVE_LOW>;
>> +        regulator-boot-on;
> 
>> +        enable-active-low;
> 
> This properly is invalid, please send follow up patch removing this,
> 
> Thanks,
> Neil
> 
> <snip>

Sure. I am on it.

Thanks,
-- 
Best regards,
Ronald
