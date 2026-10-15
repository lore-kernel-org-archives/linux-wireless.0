Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D262148122F;
	Thu, 15 Oct 2026 06:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045197; cv=none; b=TilvxmRrBKJdML4Y66hiTFwymF4txsnU+8ETwGBxcYLbPOcrBTltQ+3b5bR1FVq6AsgZxx4VBBnTOj5TowSF0ewr9XhwoPNyXrYD9W6wamxAUGBcjOArr+moNhLbYd9mXQeqXjlXGR85pNWogMXt+h/HSthYV+P3fjQwrgGcvyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045197; c=relaxed/simple;
	bh=uAzzCY3ndU+qqC/YhMsfqq4WI/d1uNiWBP52Yel97eg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sAQj/v1gtdxvoTX7GKh4/hoN2vcqGEIWdSmHgev32X8nZE7G4RqnjYGlAOGMawefsBuQ99oLBxFYeKwCMu7trOzf5/p4trFUS7KqAtrlQs4Wux9DVev0VloHU2viQ0usbYTzTuzIv/jgdBAuOpfGImfmnCh6Awimm0V8/kuDbwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; dkim=pass (2048-bit key) header.d=molgen.mpg.de header.i=@molgen.mpg.de header.b=gV4uD0HD; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=molgen.mpg.de header.i=@molgen.mpg.de header.b="gV4uD0HD"
Received: from [192.168.2.230] (p57bd9217.dip0.t-ipconnect.de [87.189.146.23])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9CADF4C442F96C;
	Thu, 15 Oct 2026 08:18:56 +0200 (CEST)
Message-ID: <f63f8f6d-54b8-4f0d-bc4a-fdb9cdefaba2@molgen.mpg.de>
Date: Thu, 15 Oct 2026 08:18:55 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 4/5] wifi: ath12k: Support MAC address from the
 firmware node
To: Abel Vesa <abel.vesa@oss.qualcomm.com>
Cc: Srinivas Kandagatla <srini@kernel.org>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Bartosz Golaszewski <brgl@kernel.org>,
 Marcel Holtmann <marcel@holtmann.org>,
 Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
 Jeff Johnson <jjohnson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>,
 Abel Vesa <abelvesa@kernel.org>, Bjorn Andersson <andersson@kernel.org>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath12k@lists.infradead.org
References: <20261014-b4-nvmem-efivar-v1-0-187c85f65018@oss.qualcomm.com>
 <20261014-b4-nvmem-efivar-v1-4-187c85f65018@oss.qualcomm.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20261014-b4-nvmem-efivar-v1-4-187c85f65018@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=molgen.mpg.de; s=20260906; 
	t=1792045139; 
	h=from:from:subject:date:message-id:mime-version:content-type:content-transfer-encoding; 
	bh=PV4vgUC8vzMQkMRZKRfTyHLU0bvgUrJ1JuVDgdBfKCM=; 
	b=gV4uD0HDXWf64WAe9SD47afIh0zwoLH3zySpaE8EGBTXxO5r67cW0t5HXEJB7K2/o6ySSrJmwu5U
	Xn9QJtnZ37RLPBJ4WrgVEkb//xYuhv3wilZCdKVWrFrmGFxDPzefPy1Z3jIbE6OSDdqRmFmQtgdQo9
	aA4eExXakMVrzNevSpL4dYNQjEZxiMtNs0PTH4TybvpSKIN/2zGVZt5gE4G9/4qJVFFPKDqFjltTo5
	QRwm8n2NteQ7liwaSp3btR30biUUWA9xQC3i5YqpIsg3gEZzURvphqki9eo9Zc5YD11LA0/40n8aIp
	+ywb8j5TTxo9cw3ZDlT7eND7g9fVuoGA==

Dear Abel,


Thank you for your patch.

Am 14.10.26 um 15:02 schrieb Abel Vesa:
> Read a MAC address from the device's firmware node (a DT "mac-address"/
> "local-mac-address" property, or an nvmem cell named "mac-address" via
> device_get_mac_address()), and use it in preference to the address from
> the firmware board data. This mirrors what ath10k and ath11k already do
> and lets the WLAN MAC be sourced from firmware-provisioned storage such
> as a UEFI variable exposed through nvmem.
> 
> A device tree / nvmem address takes precedence over the board-data MAC,
> so an explicitly provisioned address wins even when the firmware reports
> a valid per-pdev address. An all-zero (absent) address is ignored.
> 
> Note: the provisioned address must be a valid unicast MAC; a multicast
> address (odd first octet) is rejected by nvmem_get_mac_address().

Please add a paragraph how you tested this.

> Assisted-by: LLM
> Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath12k/mac.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath12k/mac.c b/drivers/net/wireless/ath/ath12k/mac.c
> index 01f8c6572f65..f4d2d0377c8e 100644
> --- a/drivers/net/wireless/ath/ath12k/mac.c
> +++ b/drivers/net/wireless/ath/ath12k/mac.c
> @@ -14878,15 +14878,27 @@ static int ath12k_mac_hw_register(struct ath12k_hw *ah)
>   	u32 ht_cap = U32_MAX, antennas_rx = 0, antennas_tx = 0;
>   	bool is_6ghz = false, is_raw_mode = false, is_monitor_disable = false;
>   	u8 *mac_addr = NULL;
> +	u8 mac_from_dt[ETH_ALEN] = {};
>   	u8 mbssid_max_interfaces = 0;
>   
>   	wiphy->max_ap_assoc_sta = 0;
>   
> +	/*
> +	 * Allow a MAC address provided through the device tree (directly or
> +	 * via an nvmem cell named "mac-address") to override the one from the
> +	 * firmware board data.
> +	 */
> +	device_get_mac_address(ab->dev, mac_from_dt);
> +
>   	for_each_ar(ah, ar, i) {
>   		u32 ht_cap_info = 0;
>   
>   		pdev = ar->pdev;
> -		if (ar->ab->pdevs_macaddr_valid) {
> +		if (!is_zero_ether_addr(mac_from_dt)) {
> +			/* A device tree / nvmem address takes precedence. */

The comment is redundant as the code ordering shows exactly this.

> +			ether_addr_copy(ar->mac_addr, mac_from_dt);
> +			ar->mac_addr[4] += ar->pdev_idx;
> +		} else if (ar->ab->pdevs_macaddr_valid) {
>   			ether_addr_copy(ar->mac_addr, pdev->mac_addr);
>   		} else {
>   			ether_addr_copy(ar->mac_addr, ar->ab->mac_addr);
> 

With the commit message extended, and the comment removed:

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
