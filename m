Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1329C335067
	for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 15:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790522431; cv=none; b=GgKu8HHpt91inOpYz2ZulTxF3lF8xc5fQ8Y9zS7cETW4VGZ8+j+/BUmm/4LeiLQDwaOzReMu3Cy7Boey7yqOrxNI67yeiUcjwlKHEg2FcTuTjLRHv7JmyEwifIhCdeZTW9Zek12ohZGOfOiEFcNiUp3ErgwN2kYJrDT3p/MszbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790522431; c=relaxed/simple;
	bh=GeiIu1Yqh7lpEKhjAIcHg3YuaBifRy+znuqW15vVmqc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=g86Nnr2UPMNOcrgI1xIG4Q3EVc4DWGhQ+8PYpTgg1Koz/KUX6AoC9KOB2lqR3F6m/HcB423ZM/OvhKZTY7Di+75RGbhNsjBPa+a2d0e4/XejC+bC1Gbp0D7aTiw4cvsi/3ROLBmXghZm0LnHOHQ6PUbQw4qSk2B1yp7nbFYI95k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DP/4UFe9; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DP/4UFe9"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e721b5503so21685875e9.0
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2026 08:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790522427; x=1791127227; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=I6Oh5NOkCSZ/PYd9yjxpFMmwfnk0bVhRF+OLfOHHDi8=;
        b=DP/4UFe9QznWQMJtSMROh1dkaYeyfacw1RPKdLSX3WI2VSvGOqB4iQC/gE2bdOzgvY
         Rencoh8+sOORs89tXZvHc4ynTdxsdoUnAdECdO5SqqL0oGoLz6f7wAs6rHIsQIsjFpQD
         B+6pH0sJaDVVZ3eBtpbNE+PWDQwcLcAWL9vplWjI2Xio2dq64W2DPMCIqhzpNSf8miS1
         DqzWZr8x/X1MxL3HZd2Uln4cYTFO6mib9n3G/ecd+KMenj3IOpD7OU96OUHYxSKgRgyQ
         cHyB07eff3915wpM1cfNlN7jpNlkB36GegaDUSofR79BKrsVULzUlv+g/mXbKlETWpWM
         TveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790522427; x=1791127227;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=I6Oh5NOkCSZ/PYd9yjxpFMmwfnk0bVhRF+OLfOHHDi8=;
        b=W+Qa6Z3qFkajMtWL47x3Y9wBEIIaTpyTpfQAyQ2hyp/kYmaKU/rU8aBkGTI+0x6h0I
         ydPThw40sqOoccDLJnTk9eeJw2S/6ihlKJxOr+yt8MH/Heyo7d88S4CAZtd9eL31etu1
         4YY1DqC404wp0hvh/NPUwTiob0YqiFuS+cRy7RYO2cA//CFsFmi8TWyboYOMQsuWyMj2
         DyNt7zIOx8d5+HiGyiGt35a3JZP9jOPC59zjlOgpolLIIo8ktK+Pa01N3z/j005wPC2/
         6Wi3kpJlRG2c8TYM2WK/OeGafX/r6TnEAL/llCOkQOUXU7OSgu0qVN23VUcor8tp2I//
         +RFQ==
X-Gm-Message-State: AFuF++me/KFdRcQMMOPsxC4aWburjktHgZpgxLhbeSISnIb9bSs4i25y
	t+0ufoccFoTaT9SygzYXbg3vfQtulo0cQf/QDPL/FLUs1Q/8hqnG0YEuqfmjpQ==
X-Gm-Gg: AYBFou01XXirctQCXgD5yxH6NzwjI5y0r1XM5GJDgkg+oT+gboS7lBxK/NN+QBxwf4Z
	/OYrIa87snjhJlT/dRmlIqaBKycJpT+iX2EkQQoF/7uMbWg3/B6pfx/k78PleSH+VvwiQ76Eg0+
	8x6WkaLCa4fzAzhzqHFzV02V5XfZJGP/QyetkEKrBajRabwSSa45xzHVN6BqGycvHi2yMTslsum
	n1jrseSxvh87yAFOBQPiEcaGOv5/UoPT9xypNebUOPtk7hlmMnGL/QD9pN1uQ38+FI8zCR0yro0
	b751gkz/20n8ESd0jJuqXJfjs75rBk1nQOTQgAMT+tG7X7k3no+tcxSwUC3PrsNmTLkgFobUK8G
	arKx+JL8w/l6MM6JaK7x82UpbagoMUTwG6C5+n+cSUIfPUlC2zcoxOTamNJ4uWWqpE3AOQKP6eF
	bgrcrF7KKyWgN512JJ4z2O8P2xOmWWpOR0WDpFSd8zAiqLSlpA93jtWJnMUAAHbdc/lGO4ETvhp
	L7Ipg==
X-Received: by 2002:a05:600c:45d5:b0:49d:28c4:b304 with SMTP id 5b1f17b1804b1-49fe6707ba7mr197864835e9.29.1790522427115;
        Sun, 27 Sep 2026 08:20:27 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a355c65sm21105179f8f.19.2026.09.27.08.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Sep 2026 08:20:24 -0700 (PDT)
Message-ID: <5fcc0373-b1b5-4a21-8e24-09b23e0077fb@gmail.com>
Date: Sun, 27 Sep 2026 18:20:21 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: Re: [PATCH v4 1/6] wifi: rtw88: 8723b: add the RTL8723B register
 definitions
To: Luka Gejak <luka.gejak@linux.dev>, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 Michael Straube <straube.linux@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>
References: <20260923213557.186205-1-luka.gejak@linux.dev>
 <20260923213557.186205-2-luka.gejak@linux.dev>
Content-Language: en-US
In-Reply-To: <20260923213557.186205-2-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 24/09/2026 00:35, Luka Gejak wrote:
> Add the register offsets and bit definitions the RTL8723B driver uses:
> the power and system function bits, the BT antenna and efuse control
> registers, the packet lifetime and MAC ID drop registers, the FPGA0
> HSSI and RF switch control registers, and the RFE antenna path
> registers.
> 
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> ---
>  drivers/net/wireless/realtek/rtw88/reg.h | 35 ++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/reg.h b/drivers/net/wireless/realtek/rtw88/reg.h
> index 0b9ba6f37680..3bbcb1591e6f 100644
> --- a/drivers/net/wireless/realtek/rtw88/reg.h
> +++ b/drivers/net/wireless/realtek/rtw88/reg.h
> @@ -8,7 +8,9 @@
>  #define REG_SYS_FUNC_EN		0x0002
>  #define BIT_FEN_EN_25_1		BIT(13)
>  #define BIT_FEN_ELDR		BIT(12)
> +#define BIT_FEN_PPLL		BIT(7)
>  #define BIT_FEN_PCIEA		BIT(6)
> +#define BIT_FEN_DIO_PCIE	BIT(5)
>  #define BIT_FEN_CPUEN		BIT(2)
>  #define BIT_FEN_USBA		BIT(2)
>  #define BIT_FEN_BB_GLB_RST	BIT(1)
> @@ -19,6 +21,7 @@
>  #define BIT_PFM_WOWL		BIT(3)
>  #define BIT_APFM_OFFMAC		BIT(9)
>  #define REG_APS_FSMCO		0x0004
> +#define BIT_EN_PDN		BIT(4)
>  #define APS_FSMCO_MAC_ENABLE	BIT(8)
>  #define APS_FSMCO_MAC_OFF	BIT(9)
>  #define APS_FSMCO_HW_POWERDOWN	BIT(15)
> @@ -67,6 +70,9 @@
>  #define BIT_SHIFT_LDO25_VOLTAGE	4
>  #define BIT_LDO25_EN		BIT(7)
>  
> +#define REG_PWR_DATA		0x0038
> +#define BIT_EEPRPAD_RFE_CTRL_EN	BIT(11)
> +
>  #define REG_ACLK_MON		0x3e
>  
>  #define REG_GPIO_MUXCFG		0x0040
> @@ -105,6 +111,11 @@
>  #define BIT_BTGP_SPI_EN		BIT(20)
>  #define BIT_LED1DIS		BIT(15)
>  #define BIT_SW_DPDT_SEL_DATA	BIT(0)
> +#define REG_BT_ANT_SEL_8723B	0x0067

I think there is no need to add the _8723B suffix to these
names.

> +/* 0x006b is the high byte of the 16 bit register at 0x006a. */
> +#define REG_BT_EFUSE_CTRL_8723B	0x006b
> +#define BIT_BT_PWR_CUT		BIT(6)
> +#define BIT_BT_OUT_ISO		BIT(7)
>  #define REG_WL_BT_PWR_CTRL	0x0068
>  #define BIT_BT_FUNC_EN		BIT(18)
>  #define BIT_BT_DIG_CLK_EN	BIT(8)
> @@ -301,6 +312,8 @@
>  #define REG_HMEBOX3		0x01DC
>  #define REG_LLT_INIT		0x01E0
>  #define BIT_LLT_WRITE_ACCESS	BIT(30)
> +#define REG_RFK_FW_ACK_8723B	0x01E7
> +#define BIT_RFK_FW_ACK_8723B	BIT(0)
>  #define REG_HMEBOX0_EX		0x01F0
>  #define REG_HMEBOX1_EX		0x01F4
>  #define REG_HMEBOX2_EX		0x01F8
> @@ -429,6 +442,8 @@
>  #define REG_ARFRH5		0x04A8
>  #define REG_SW_AMPDU_BURST_MODE_CTRL 0x04BC
>  #define BIT_PRE_TX_CMD		BIT(6)
> +#define REG_PKT_VO_VI_LIFE_TIME	0x04C0
> +#define REG_PKT_BE_BK_LIFE_TIME	0x04C2
>  #define REG_QUEUE_CTRL		0x04C6
>  #define BIT_PTA_WL_TX_EN	BIT(4)
>  #define BIT_PTA_EDCCA_EN	BIT(5)
> @@ -437,6 +452,8 @@
>  #define REG_PROT_MODE_CTRL	0x04C8
>  #define REG_MAX_AGGR_NUM	0x04CA
>  #define REG_BAR_MODE_CTRL	0x04CC
> +#define REG_MACID_PKT_DROP0	0x04D0
> +#define REG_MACID_PKT_SLEEP	0x04D4
>  #define REG_PRECNT_CTRL		0x04E5
>  #define BIT_BTCCA_CTRL		(BIT(0) | BIT(1))
>  #define BIT_EN_PRECNT		BIT(11)
> @@ -497,6 +514,8 @@
>  #define REG_TIMER0_SRC_SEL	0x05B4
>  #define BIT_TSFT_SEL_TIMER0	(BIT(4) | BIT(5) | BIT(6))
>  
> +#define REG_BWOPMODE		0x0603
> +#define BIT_BWOPMODE_20MHZ	BIT(2)
>  #define REG_TCR			0x0604
>  #define BIT_PWRMGT_HWDATA_EN	BIT(7)
>  #define BIT_TCR_UPDATE_TIMIE	BIT(5)
> @@ -520,6 +539,7 @@
>  #define BIT_UC_MD_EN		BIT(16)
>  #define BIT_RXSK_PERPKT		BIT(15)
>  #define BIT_HTC_LOC_CTRL	BIT(14)
> +#define BIT_AMF			BIT(13)
>  #define BIT_RPFM_CAM_ENABLE	BIT(12)
>  #define BIT_TA_BCN		BIT(11)
>  #define BIT_RCR_ADF		BIT(11)
> @@ -546,6 +566,7 @@
>  #define REG_ACKTO		0x0640
>  #define REG_EIFS		0x0642
>  #define REG_NAV_CTRL		0x0650
> +#define REG_NAV_UPPER		0x0652
>  #define REG_WMAC_TRXPTCL_CTL	0x0668
>  #define BIT_RFMOD		(BIT(7) | BIT(8))
>  #define BIT_RFMOD_80M		BIT(8)
> @@ -581,6 +602,7 @@
>  #define REG_BT_COEX_V2		0x0762
>  #define BIT_GNT_BT_POLARITY	BIT(12)
>  #define BIT_LTE_COEX_EN		BIT(7)
> +#define REG_BT_CONTROL_8723B	0x0764
>  #define REG_GNT_BT		0x0765
>  #define BIT_PTA_SW_CTL		GENMASK(4, 3)
>  #define REG_BT_COEX_ENH_INTR_CTRL	0x76E
> @@ -606,12 +628,20 @@
>  #define BIT_RX_PSEL_RST		(BIT(28) | BIT(29))
>  #define REG_TXPSEL		0x080C
>  #define REG_RX_GAIN_EN		0x081c
> +#define REG_FPGA0_XA_HSSI_PARM2	0x0824
> +#define HSSI_3WIRE_ADDR_LEN	0x400
> +#define HSSI_3WIRE_DATA_LEN	0x800
>  #define REG_CCASEL		0x082C
> +#define REG_FPGA0_XB_HSSI_PARM2	0x082C
>  #define REG_PDMFTH		0x0830
>  #define REG_BWINDICATION	0x0834
>  #define REG_CCA2ND		0x0838
>  #define REG_L1PKTH		0x0848
>  #define REG_CLKTRK		0x0860
> +#define REG_FPGA0_XA_RF_INT_OE	0x0860
> +#define REG_FPGA0_XB_RF_INT_OE	0x0864
> +#define REG_FPGA0_XA_RF_SW_CTRL	0x0870
> +#define RFSI_RFENV		0x10
>  #define REG_CSI_MASK_SETTING1	0x0874
>  #define REG_NBI_SETTING		0x087c
>  #define BIT_NBI_ENABLE		BIT(13)
> @@ -630,6 +660,10 @@
>  #define REG_PSD			0x0910
>  #define BIT_PSD_INI		GENMASK(23, 22)
>  #define REG_SINGLE_TONE_CONT_TX	0x0914
> +#define REG_RFE_CTRL_ANTA_SRC	0x0930
> +#define REG_RFE_CTRL_ANT_SW	0x0944
> +#define BIT_RFE_CTRL_ANT_SW_SEL	GENMASK(1, 0)
> +#define BIT_BT_SEL_BY_WIFI_8723B	BIT(5)

This bit belongs under REG_BT_ANT_SEL_8723B.

>  #define REG_AGC_TABLE		0x0958
>  #define REG_RFE_CTRL_E		0x0974
>  #define REG_2ND_CCA_CTRL	0x0976
> @@ -683,6 +717,7 @@
>  #define REG_RX_IQC_AB_A		0x0c10
>  #define REG_RX_IQC_CD_A		0x0c14
>  #define REG_TXSCALE_A		0x0c1c
> +#define REG_B_RXIQI		0x0c1c
>  #define BB_SWING_MASK		GENMASK(31, 21)
>  #define REG_TX_AGC_A_CCK_11_CCK_1		0xc20
>  #define REG_TX_AGC_A_OFDM18_OFDM6		0xc24

