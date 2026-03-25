Received: from courrier.aliel.fr (pouet.aliel.fr [65.21.61.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A27E32AAAB;
	Wed, 25 Mar 2026 08:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.61.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774428120; cv=none; b=CxRIR2COEzSCTrFlmMC6EVBeCzCfUQOmQ0J58GiTA8k1h7IVuRJwGmji7aFujEOUP2KfxbJRTVnyrhhyo1cByhb7ltDb+qEMn5tO7VZfJFrdx//Ib4izwYl0uBTwCaeOajPmuqfmKF5P057pIY1RCxADjelsqL9avZ7STon00sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774428120; c=relaxed/simple;
	bh=lbXbfx2LEXlqwLddF+1Yul7XCpRx3LTNVV2LAxE+NF8=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Q+MG0xhjJbPfRoXM8VcFWKNyFIpQ6pv0ZOZYLnmzUSvd769upxUzwrExoTy/bvkAb/jki5gIv4wvsJWysbFWVmVFRpvdVTxxbG04BRWeNHM4qGVJLl6Vqko8RLRFXDixNPzxUtC5cct0Xt/IUXur1dr2j82V1Jeu04bqk1qOZzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr; spf=pass smtp.mailfrom=aliel.fr; dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b=RP6wkINc; arc=none smtp.client-ip=65.21.61.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=aliel.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliel.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliel.fr header.i=@aliel.fr header.b="RP6wkINc"
Message-ID: <1be18bd2-f1a3-4d27-b64a-49a8f66ab95a@aliel.fr>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aliel.fr;
	s=courrier-s1; t=1774428108;
	bh=lbXbfx2LEXlqwLddF+1Yul7XCpRx3LTNVV2LAxE+NF8=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=RP6wkINc7X/bMDlfIHaSZLY0h+yk4VJ04Nn1xy7QeG7oD3/eglJDe3cg+DWVwU/dd
	 PJUqhKdd8XYuJZbhCwgR823gDg1BN5+OSr5XBUxQZZ61uiOl6lgQFVwBgTeupYuviA
	 kehDe7HG1zOTIYmiYN+KqJ44lqp3U7FOi6Y+bI2o=
Date: Wed, 25 Mar 2026 09:40:52 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
From: Ronald Claveau <linux-kernel-dev@aliel.fr>
Subject: Re: [PATCH v3 1/9] arm64: dts: amlogic: t7: Add eMMC, SD card and
 SDIO pinctrl nodes
To: Xianwei Zhao <xianwei.zhao@amlogic.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-amlogic@lists.infradead.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Kevin Hilman <khilman@baylibre.com>, Jerome Brunet <jbrunet@baylibre.com>,
 Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
 Conor Dooley <conor+dt@kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>,
 Johannes Berg <johannes@sipsolutions.net>, van Spriel <arend@broadcom.com>
References: <20260323-add-emmc-t7-vim4-v3-0-5159d90a984c@aliel.fr>
 <20260323-add-emmc-t7-vim4-v3-1-5159d90a984c@aliel.fr>
 <316efeff-477d-4d8d-9c60-ac7c4e5b9b33@amlogic.com>
Content-Language: en-US
In-Reply-To: <316efeff-477d-4d8d-9c60-ac7c4e5b9b33@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 3/25/26 3:48 AM, Xianwei Zhao wrote:
> Hi Ronald,
> 
> On 2026/3/23 17:55, Ronald Claveau wrote:
>> These pinctrl nodes are required by the eMMC, SD card and SDIO drivers
>> to configure pin muxing at runtime.
>>
>> - eMMC: control, 4-bit/8-bit data, data strobe and clock gate pins
>> - SD card: data, clock, command and clock gate pins
>> - SDIO: data, clock, command and clock gate pins
>>
>> Signed-off-by: Ronald Claveau<linux-kernel-dev@aliel.fr>
>> ---
>>   arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi | 98 +++++++++++++++++++
>> ++++++++++
>>   1 file changed, 98 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi b/arch/arm64/
>> boot/dts/amlogic/amlogic-t7.dtsi
>> index 6510068bcff92..ac8de8e9b8010 100644
>> --- a/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
>> +++ b/arch/arm64/boot/dts/amlogic/amlogic-t7.dtsi
>> @@ -250,6 +250,104 @@ gpio: bank@4000 {
>>                                          #gpio-cells = <2>;
>>                                          gpio-ranges =
>> <&periphs_pinctrl 0 0 157>;
>>                                  };
>> +
>> +                               emmc_ctrl_pins: emmc-ctrl {
>> +                                       mux-0 {
>> +                                               groups = "emmc_cmd";
>> +                                               function = "emmc";
>> +                                               bias-pull-up;
>> +                                       };
>> +
>> +                                       mux-1 {
>> +                                               groups = "emmc_clk";
>> +                                               function = "emmc";
>> +                                               bias-disable;
>> +                                       };
>> +                               };
>> +
>> +                               emmc_data_4b_pins: emmc-data-4b {
>> +                                       mux-0 {
>> +                                               groups = "emmc_nand_d0",
>> +                                                        "emmc_nand_d1",
>> +                                                        "emmc_nand_d2",
>> +                                                        "emmc_nand_d3";
>> +                                               function = "emmc";
>> +                                               bias-pull-up;
>> +                                       };
>> +                               };
>> +
>> +                               emmc_data_8b_pins: emmc-data-8b {
>> +                                       mux-0 {
>> +                                               groups = "emmc_nand_d0",
>> +                                                        "emmc_nand_d1",
>> +                                                        "emmc_nand_d2",
>> +                                                        "emmc_nand_d3",
>> +                                                        "emmc_nand_d4",
>> +                                                        "emmc_nand_d5",
>> +                                                        "emmc_nand_d6",
>> +                                                        "emmc_nand_d7";
>> +                                               function = "emmc";
>> +                                               bias-pull-up;
>> +                                       };
>> +                               };
>> +
>> +                               emmc_ds_pins: emmc-ds {
>> +                                       mux {
>> +                                               groups = "emmc_nand_ds";
>> +                                               function = "emmc";
>> +                                               bias-pull-down;
>> +                                       };
>> +                               };
>> +
>> +                               emmc_clk_gate_pins: emmc_clk_gate {
> 
> Node names should use hyphens ('-') instead of underscores ('_'),
> consistent with the following nodes.
> 

Thanks for your feedback Xianwei.
I will change that.

>> +                                       mux {
>> +                                               groups = "GPIOB_8";
>> +                                               function =
>> "gpio_periphs";
>> +                                               bias-pull-down;
>> +                                       };
>> +                               };
>> +
>> +                               sdcard_pins: sdcard {
>> +                                       mux {
>> +                                               groups = "sdcard_d0",
>> +                                                        "sdcard_d1",
>> +                                                        "sdcard_d2",
>> +                                                        "sdcard_d3",
>> +                                                        "sdcard_clk",
>> +                                                        "sdcard_cmd";
>> +                                               function = "sdcard";
>> +                                               bias-pull-up;
>> +                                       };
>> +                               };
>> +
>> +                               sdcard_clk_gate_pins: sdcard_clk_gate {
>> +                                       mux {
>> +                                               groups = "GPIOC_4";
>> +                                               function =
>> "gpio_periphs";
>> +                                               bias-pull-down;
>> +                                       };
>> +                               };
>> +
>> +                               sdio_pins: sdio {
>> +                                       mux-0 {
>> +                                               groups = "sdio_d0",
>> +                                                        "sdio_d1",
>> +                                                        "sdio_d2",
>> +                                                        "sdio_d3",
>> +                                                        "sdio_clk",
>> +                                                        "sdio_cmd";
>> +                                               function = "sdio";
>> +                                               bias-pull-up;
>> +                                       };
>> +                               };
>> +
>> +                               sdio_clk_gate_pins: sdio_clk_gate {
>> +                                       mux {
>> +                                               groups = "GPIOX_4";
>> +                                               function =
>> "gpio_periphs";
>> +                                               bias-pull-up;
>> +                                       };
>> +                               };
>>                          };
>>
>>                          gpio_intc: interrupt-controller@4080 {


-- 
Best regards,
Ronald
