Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D0D3E5588
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 09:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785144092; cv=none; b=Myjsrvra+wi6QSVZwpeXYn7nrE+fboLGNaa0zr9CaMaIOeV4SpbGnjcE4ElYU2xEtD36FxpJWdWuEb4e4YAQ5tGHnOc3XK0m/ysUgfAT659UQd6oI9f5sQHTOXe3t3SpS6VoxyuWXGhsyHXY3G25HAgRnpHi7ye9OqGB+wVt+E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785144092; c=relaxed/simple;
	bh=NW4VsbzwU9X5/oUYlvLYj3eRXkJBpK4UsneeQ+0JTi8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aK75QgZBo9rc8EON5qXKPW5Oo3BM7hEWwuROCR8EiRMY+K89L2k8tnb21UFvvPBBARwhi1pHjRxlVU6pNi3BZOQ+m/Qtom7kooVFP2omUDo9q3QjduypexbTBwMRrmuw5XDZp2ZMdUd1czXE30/rUlfbwhdNUxOx8x7hu/WCTsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=o6bmUTha; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=aYYIF0YD; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="o6bmUTha";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="aYYIF0YD"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R8g5KZ161560
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 09:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	9+7Rgtl2oaW722fZ/wqrP9SnB6sQw+4UHDJNsBWnnE4=; b=o6bmUThakxElRNt/
	EsqTCd5G01EWCIO1sERQmO5F7VwP2E3P6OMAktBDVE+ReUZz1yMDa+F+gBXnM3Sw
	sOZZrg1Gx1CO/rbkVHGj8bbbtMRom32eyF4eyvOmLe+6gWnW/oVF6Zzf4dvWRXEt
	dkiyHfcUdP6nvWojaOdJoFQ/m0KNjlAQHE9mehD3k7WrW+XoglegAMqfmRsFzila
	ekr77Kt11EX57XTqPkc0s7BVVAdrZmG+u8F0NVAquXx+Que3Kc5Rngc6QVz8Qu6R
	Xn3zbKlYJmao6fguBRe2ehU8yz117OvXVbe5oFv4jH/BL6XP8eGxr4A0BeraLcz+
	2vygNA==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fny9wh856-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 09:21:29 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c19493ac2so38041131cf.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 02:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785144088; x=1785748888; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=9+7Rgtl2oaW722fZ/wqrP9SnB6sQw+4UHDJNsBWnnE4=;
        b=aYYIF0YDUlOzTSgOcBpCvbb7NpJrt7doT4lJmzNghmi4xVa/JJetlAqccUAXuw5EsK
         Ej0XY78RhB912ZO5Fmpwa39qF9UZdliNW5cZC50oLsxC7tV5LXDzTVPhMRcZo+S/tb+3
         inm6i0j2NES+fH5HYkqT7DOg6w85zqHJnonSdcX8t78TNL5g2d5j2umE0FVFwhQPu97f
         hd2X90GivYSbKKGC2wnq4mr9Kkbi3HU/XVs9d2RkWy3wdbJEQyu7Tlz7jHwoD2z4EzWi
         0nBrOKtCT/o5Gbu2Q15gM72iujk4ISKniRMPSgLLiiXvEOj2Z7FvVM6KU2FnQFEVZi5i
         7b8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785144088; x=1785748888;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9+7Rgtl2oaW722fZ/wqrP9SnB6sQw+4UHDJNsBWnnE4=;
        b=lEaTcTtm6AUwP3+uv+bN9Mc64OVW/dlMEKlaZUI8RgF0OPuFs1Kq3u7Jut79KI0+SW
         SIDxi5FaWCH6TgUy1E6ubvuWEOlPAFUG2F1jN9Q9FfWOoe6pWRYU2Vc2FFhX480aYfU9
         6VmU7W9CFpQgd+DxJ5jMniHn2bAJOqcJ/Wv8Uoqftb/Xe87gMSd0JQQi56CCjZFe792y
         HJUJVvmqgUMkUL5pYvWtAW3qgZtxn9Apc8yFzQ33S8ouxByHdgHq+OdIyKSonOtKihCl
         QDBamtGKTfLgQ4Db4idYLXhMU0e/djYFEQrYjDtOcbpY0G2toBIzzC6IUYQJVJgm5eXz
         yVUg==
X-Gm-Message-State: AOJu0YzJu3ZFymnQlSUnuBrvdZp4KN8TOh4retdnYCiOwhGhiyiThH9K
	HBmfb5eeUiiAv0bH53QSn8EAm+noRlNkdWG6Q2yjfifwXoSRRebFBM+Z9gUoNw4UoEX5oJNBPh9
	lqhmy4uZptUojmyMuVaw3k5N7qqAvylDdvZdwQu4cnDYuobtSuwcgMoLAtIgannZFjV3Y0A==
X-Gm-Gg: AR+sD13YSCMOkeaFaenj+KDSvlEqFhm/MZO6m9g2mGymmTTavT3971wLuLepNeXpjfn
	EU4MIQzs6k4H6LHx3hPB88PaL50eJFPuXsxY87zMui85eHM5CIPCEG7hFyaBy7wKT0nxwIo4y7b
	hYLVa0Zfu8Dm5zerdlDIUiT4mDyw/Em07fkbRAfx8xwkHM35uHo0e1TXZKbS7V4BB0LWgIN66x/
	OYBdQ4ynbCykXxYaOBS9b0MZfO/5ANxyYR6Qf1rovcIpCEA3JxTbTPf5Nb9/rcW6nvvQNukySfU
	59Z68akS4UmdyGgq1FfcgrUlLGOrm+16mT684ID1kGUVcdhtzxFmGMYK6VtOcg28nr2GXRlprdj
	lOD9gbbdXRtNaw8HwWyQ=
X-Received: by 2002:a05:622a:3c6:b0:51a:8e07:59d5 with SMTP id d75a77b69052e-529a8365042mr75011051cf.12.1785144088350;
        Mon, 27 Jul 2026 02:21:28 -0700 (PDT)
X-Received: by 2002:a05:622a:3c6:b0:51a:8e07:59d5 with SMTP id d75a77b69052e-529a8365042mr75010871cf.12.1785144087734;
        Mon, 27 Jul 2026 02:21:27 -0700 (PDT)
Received: from [10.40.99.10] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb51c9691sm2351279a12.7.2026.07.27.02.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 02:21:26 -0700 (PDT)
Message-ID: <c9f421f8-5c15-4a92-979c-af7fb86069a8@oss.qualcomm.com>
Date: Mon, 27 Jul 2026 11:21:24 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] wifi: rtw88: 8723bs: add the core handling
 required by RTL8723BS
To: luka.gejak@linux.dev, Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Straube <straube.linux@gmail.com>,
        Peter Robinson <pbrobinson@gmail.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>
References: <20260722200337.135150-1-luka.gejak@linux.dev>
 <20260722200337.135150-2-luka.gejak@linux.dev>
From: Hans de Goede <johannes.goede@oss.qualcomm.com>
Content-Language: en-US, nl
In-Reply-To: <20260722200337.135150-2-luka.gejak@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA5MSBTYWx0ZWRfX6UdIGOofGsog
 EIuFU91HXXo54kamMj2wx4kLTRILCNhG+70xymZ1BEQSDtTIHU2Z4wExMENq16a5c3I+g5f1Iku
 xCkzPehfHwgSbLI5ZgwUVY5baLaOZWMl/jY87XvuIS+gc8EsrW76JuaMqGL5/WLagr6L07pNjqa
 8uzfv7zkVfdbwNwCiTlOidZfGaztYBUaGCH4q0ES4pHvp5YLCAofm0Qmuw766gpeWIUS0pvD1Am
 /zlRA5GVNGf0n+QpDqSSOVv2f4JOvr7n2zH3fkk/MvpwhK55QbTbi610O9aNWgWNnqQR0ZMGb3T
 nDfgRdg66iiz92UUgGwNHelspMFs6PoECP63IQNjfYteGR0klmu4fnMZxUW0VKjaJEoBoFhGmzv
 dANACuBwkGV7P5OFLYB0Z7O8mVkATxLUTGmpi6mYZXmutlTCwo+NuFLsCAe7OsNfNBDiaSRlbK7
 F7jw34bfpcL27lwDL2Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA5MSBTYWx0ZWRfX5kYVO9BJ2dtv
 5TfEMhmqaWk7RdeZELGrnY7WYzDy4tCQRzJ8O3OGYvV6bT/4gmQcwo2rv1+Jm7TUPVjuCt/8LkD
 DycDqt8qbGTnE3zM7qB6BNODQ1ZvCIo=
X-Proofpoint-ORIG-GUID: m7M40gYM94Az3ywkOrl4IHHvNNk9pZ7E
X-Authority-Analysis: v=2.4 cv=E4b9Y6dl c=1 sm=1 tr=0 ts=6a672319 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=rrvG0T/C2D967D07Ol03YQ==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=m9Y0QTPE2cQAiPVIt1QA:9 a=QEXdDO2ut3YA:10 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-GUID: m7M40gYM94Az3ywkOrl4IHHvNNk9pZ7E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_02,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 priorityscore=1501 impostorscore=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270091

Hi Luka,

First of all as the person responsible for adding the downstream rtl8723bs
driver to drivers/staging because it is used in a lot of budget x86
tablets, many thanks for doing this!

I do believe that this is the right path forward and that the drivers/staging
driver should be dropped as soon as this is merged.

I'll try to make some time to run some tests with this on my own hw.

On 22-Jul-26 10:03 PM, luka.gejak@linux.dev wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
> 
> The RTL8723BS predates rtw88 and runs the Realtek vendor firmware
> (version 41), whose H2C/C2H protocol and association behaviour differ
> from the firmware used by the existing rtw88 8723-family devices. It
> therefore needs a set of changes in the shared rtw88 code before the
> chip driver itself can work.

<snip>

> diff --git a/drivers/net/wireless/realtek/rtw88/coex.c b/drivers/net/wireless/realtek/rtw88/coex.c
> index 37c336def419..641cfa1181b2 100644
> --- a/drivers/net/wireless/realtek/rtw88/coex.c
> +++ b/drivers/net/wireless/realtek/rtw88/coex.c
> @@ -1443,6 +1443,205 @@ static void rtw_coex_set_ant_path(struct rtw_dev *rtwdev, bool force, u8 phase)
>  #define case_ALGO(src) \
>  	case COEX_ALGO_##src: return #src
>  
> +/* 8723BS SDIO WiFi/BT coexistence antenna handling. On BT-disabled boards the
> + * scan/auth window still routes through the PTA mux; these helpers force the
> + * vendor-shaped WiFi-owned antenna path so directed management TX reaches air.
> + */
> +#define REG_8723BS_BT_COEX_CTRL		0x0039
> +#define REG_8723BS_BB_ANT_CFG		0x0930
> +#define REG_8723BS_BB_ANT_CFG1		0x0944
> +#define REG_8723BS_BB_ANT_BUF		0x0974
> +#define RTW8723BS_COEX_H_WLAN_ACTIVE	0x1800101b
> +
> +static bool rtw_coex_8723bs_ant_is_aux(struct rtw_dev *rtwdev)
> +{
> +	return !!(rtwdev->efuse.bt_setting & BIT(6));
> +}
> +
> +static bool rtw_coex_8723bs_bt_disabled(struct rtw_dev *rtwdev)
> +{
> +	return rtw_is_8723bs(rtwdev) && rtwdev->coex.stat.bt_disabled;
> +}
> +
> +static u32 rtw_coex_8723bs_pta_ant_path(struct rtw_dev *rtwdev)
> +{
> +	return rtw_coex_8723bs_ant_is_aux(rtwdev) ? 0x80 : 0x200;
> +}
> +
> +/* Write BB_SEL_BTG (0x948), retrying once with SYS_FUNC BB reset if the first
> + * write does not stick (RF/BB clock may have been gated).
> + */
> +static u32 rtw_coex_8723bs_write_bb_sel_btg(struct rtw_dev *rtwdev, u32 value)
> +{
> +	u8 sys_func_before;
> +	u32 readback;
> +
> +	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
> +	if ((sys_func_before & (BIT(0) | BIT(1))) != (BIT(0) | BIT(1))) {
> +		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
> +		usleep_range(10, 11);
> +	}
> +
> +	rtw_write32(rtwdev, 0x948, value);
> +	readback = rtw_read32(rtwdev, 0x948);
> +	if (readback == value)
> +		return readback;
> +
> +	usleep_range(10, 11);
> +	rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
> +	rtw_write32(rtwdev, 0x948, value);
> +
> +	return rtw_read32(rtwdev, 0x948);
> +}
> +
> +static u32 rtw_coex_8723bs_reassert_pta_ant(struct rtw_dev *rtwdev)
> +{
> +	return rtw_coex_8723bs_write_bb_sel_btg(rtwdev,
> +						rtw_coex_8723bs_pta_ant_path(rtwdev));
> +}
> +
> +static void rtw_coex_8723bs_set_cck_pri(struct rtw_dev *rtwdev, bool high)
> +{
> +	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> +		return;
> +
> +	if (high) {
> +		rtw_write32(rtwdev, REG_BT_COEX_TABLE_H,
> +			    RTW8723BS_COEX_H_WLAN_ACTIVE);
> +	} else {
> +		rtw_coex_set_wl_pri_mask(rtwdev, COEX_WLPRI_TX_CCK, false);
> +		rtw_coex_set_wl_pri_mask(rtwdev, COEX_WLPRI_RX_CCK, false);
> +	}
> +}
> +
> +static void rtw_coex_8723bs_restore_pad_ctrl(struct rtw_dev *rtwdev,
> +					     bool keep_pta_owner)
> +{
> +	u32 before, after;
> +
> +	before = rtw_read32(rtwdev, REG_PAD_CTRL1);
> +	after = before & ~(BIT_LNAON_WLBT_SEL | BIT_SW_DPDT_SEL_DATA);
> +	if (keep_pta_owner)
> +		after |= BIT_PAPE_WLBT_SEL;
> +	else
> +		after &= ~BIT_PAPE_WLBT_SEL;
> +	if (after != before)
> +		rtw_write32(rtwdev, REG_PAD_CTRL1, after);
> +}
> +
> +static void rtw_coex_8723bs_fw_gnt_bt_low(struct rtw_dev *rtwdev)
> +{
> +	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> +		return;
> +
> +	if (rtw_read8(rtwdev, 0x765) == 0x00 &&
> +	    rtw_read8(rtwdev, 0x76e) == 0x0c)
> +		return;
> +
> +	rtw_fw_set_gnt_bt(rtwdev, 0);
> +}
> +
> +static void rtw_coex_8723bs_force_assoc_pta_ant(struct rtw_dev *rtwdev)
> +{
> +	u32 ant_target;
> +
> +	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> +		return;
> +
> +	ant_target = rtw_coex_8723bs_pta_ant_path(rtwdev);
> +
> +	rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
> +	rtw_coex_set_ant_switch(rtwdev, COEX_SWITCH_CTRL_BY_PTA,
> +				COEX_SWITCH_TO_NOCARE);
> +	rtw_coex_8723bs_set_cck_pri(rtwdev, true);
> +	rtw_coex_8723bs_write_bb_sel_btg(rtwdev, ant_target);
> +	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, true);
> +}
> +
> +static void rtw_coex_8723bs_reassert_ant_buffer(struct rtw_dev *rtwdev)
> +{
> +	u8 sys_func_before;
> +
> +	sys_func_before = rtw_read8(rtwdev, REG_SYS_FUNC_EN);
> +	if ((sys_func_before & (BIT(0) | BIT(1))) != (BIT(0) | BIT(1))) {
> +		rtw_write8_set(rtwdev, REG_SYS_FUNC_EN, BIT(0) | BIT(1));
> +		usleep_range(10, 11);
> +	}
> +
> +	rtw_write8_mask(rtwdev, REG_8723BS_BT_COEX_CTRL, BIT(3), 0x1);
> +	rtw_write8(rtwdev, REG_8723BS_BB_ANT_BUF, 0xff);
> +	rtw_write8_mask(rtwdev, REG_8723BS_BB_ANT_CFG1, 0x3, 0x3);
> +	rtw_write8(rtwdev, REG_8723BS_BB_ANT_CFG, 0x77);
> +}
> +
> +static void rtw_coex_8723bs_apply_scan_table(struct rtw_dev *rtwdev)
> +{
> +	rtwdev->coex.dm.cur_table = 2;
> +	rtw_coex_set_table(rtwdev, true, 0x5a5a5a5a, 0x5a5a5a5a);
> +}
> +
> +/* Non-connected scan/auth workaround: PS-TDMA type 8 off, PTA antenna path,
> + * coex table type 2 (matches the vendor non-connected arbitration).
> + */
> +void rtw_coex_8723bs_scan_workaround(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_coex_dm *coex_dm = &rtwdev->coex.dm;
> +	struct rtw_coex_stat *coex_stat = &rtwdev->coex.stat;
> +
> +	if (!rtw_is_8723bs(rtwdev))
> +		return;
> +
> +	coex_dm->cur_ps_tdma_on = false;
> +	coex_dm->cur_ps_tdma = 8;
> +	coex_dm->ps_tdma_para[0] = 0x08;
> +	coex_dm->ps_tdma_para[1] = 0x00;
> +	coex_dm->ps_tdma_para[2] = 0x00;
> +	coex_dm->ps_tdma_para[3] = 0x00;
> +	coex_dm->ps_tdma_para[4] = 0x00;
> +
> +	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +	rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
> +	rtw_coex_set_ant_path(rtwdev, true, COEX_SET_ANT_2G);
> +	rtw_coex_8723bs_reassert_ant_buffer(rtwdev);
> +	rtw_coex_8723bs_apply_scan_table(rtwdev);
> +	if (coex_stat->bt_disabled)
> +		rtw_coex_8723bs_set_cck_pri(rtwdev, true);
> +	rtw_coex_8723bs_reassert_pta_ant(rtwdev);
> +	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, true);
> +}
> +
> +/* Replayed immediately before start_clnt_join()/auth: BT_INFO + PS-TDMA type 8
> + * then the forced WiFi PTA antenna path, so the auth window is clean.
> + */
> +void rtw_coex_8723bs_pre_auth_h2c(struct rtw_dev *rtwdev)
> +{
> +	lockdep_assert_held(&rtwdev->mutex);
> +
> +	if (!rtw_coex_8723bs_bt_disabled(rtwdev))
> +		return;
> +
> +	rtw_fw_query_bt_info(rtwdev);
> +	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +	rtw_fw_coex_tdma_type(rtwdev, 0x08, 0x00, 0x00, 0x00, 0x00);
> +	rtw_coex_8723bs_fw_gnt_bt_low(rtwdev);
> +	rtw_coex_8723bs_force_assoc_pta_ant(rtwdev);
> +}
> +
> +/* Minimal PTA antenna path so RF register writes reach the chip after IPS
> + * leave / power-on (before rtw_set_channel()).
> + */
> +void rtw_coex_8723bs_ensure_pta_path(struct rtw_dev *rtwdev)
> +{
> +	if (!rtw_is_8723bs(rtwdev))
> +		return;
> +
> +	rtw_coex_8723bs_reassert_ant_buffer(rtwdev);
> +	rtw_coex_8723bs_write_bb_sel_btg(rtwdev,
> +					 rtw_coex_8723bs_pta_ant_path(rtwdev));
> +	rtw_coex_8723bs_restore_pad_ctrl(rtwdev, false);
> +}
> +
>  static const char *rtw_coex_get_algo_string(u8 algo)
>  {
>  	switch (algo) {


You add a lot of rtl8723bs specific code here. I wonder if it wouldn't be better
to move all this to rtl8723b[s].c ?

> @@ -2877,6 +3076,33 @@ void rtw_coex_scan_notify(struct rtw_dev *rtwdev, u8 type)
>  	coex->freeze = false;
>  	rtw_coex_write_scbd(rtwdev, COEX_SCBD_ACTIVE | COEX_SCBD_ONOFF, true);
>  
> +	/* 8723BS SDIO BT-disabled: keep the scan/auth PTA antenna state the
> +	 * vendor uses and skip the generic coex run. At scan start (firmware
> +	 * has been up long enough for stable RX DMA) replay the vendor BT_MP /
> +	 * BT_INFO queries, then re-establish the scan-path PTA setup.
> +	 */
> +	if (rtw_coex_8723bs_bt_disabled(rtwdev)) {
> +		if (type == COEX_SCAN_START_2G || type == COEX_SCAN_START) {
> +			struct rtw_coex_info_req req = {};
> +
> +			coex_stat->cnt_wl[COEX_CNT_WL_SCANAP] = 0;
> +			coex_stat->wl_hi_pri_task2 = true;
> +
> +			req.seq = 0x0e;
> +			req.op_code = BT_MP_INFO_OP_SUPP_VER;
> +			rtw_fw_query_bt_mp_info(rtwdev, &req);
> +			req.seq = 0x0f;
> +			req.op_code = BT_MP_INFO_OP_PATCH_VER;
> +			rtw_fw_query_bt_mp_info(rtwdev, &req);
> +			rtw_fw_query_bt_info(rtwdev);
> +
> +			rtw_coex_8723bs_scan_workaround(rtwdev);
> +		} else {
> +			coex_stat->wl_hi_pri_task2 = false;
> +		}
> +		return;
> +	}
> +

If you move all the rtl8723bs specific handling to rtl8723bs.c then you
could maybe have a single call into a rtl8723bs helper here:

	if (rtw_is_8723bs(rtwdev) && rtw_coex_scan_notify_rtl8723bs(rtwdev, type))
		return;

And basically the same for all the other changes in this patch.

Move all the rtl8723bs specific handling into rtl8723bs.c and only export
helpers and call those from the necessary points where you need to hook
the main code.

Note I'm not a maintainer of the rtw88 code, so maybe wait to see
what Ping-Ke has to say about this?

Ping-Ke ?

>  	if (type == COEX_SCAN_START_5G) {
>  		rtw_dbg(rtwdev, RTW_DBG_COEX,
>  			"[BTCoex], SCAN START notify (5G)\n");
> @@ -2938,6 +3164,17 @@ void rtw_coex_connect_notify(struct rtw_dev *rtwdev, u8 type)
>  	if (coex->manual_control || coex->stop_dm)
>  		return;
>  
> +	/* 8723BS SDIO BT-disabled: the vendor ConnectNotify() early-returns
> +	 * without sending H2Cs; scan_workaround already established the PTA
> +	 * path / coex table / PS-TDMA. Keep only the register-level PTA
> +	 * reassertion at associate-start.
> +	 */
> +	if (rtw_coex_8723bs_bt_disabled(rtwdev)) {
> +		if (type == COEX_ASSOCIATE_START)
> +			rtw_coex_8723bs_force_assoc_pta_ant(rtwdev);
> +		return;
> +	}
> +
>  	rtw_coex_write_scbd(rtwdev, COEX_SCBD_ACTIVE | COEX_SCBD_ONOFF, true);
>  
>  	if (type == COEX_ASSOCIATE_5G_START) {

So same here, replace the new code with:

	if (rtw_is_8723bs(rtwdev) && rtw_coex_connect_notify_rtl8723bs(rtwdev, type))
		return;

and the same for all other changes in this patch.

Again not a rtw88 maintaner but this is how I would handle this myself to avoid
adding too much rtl8723bs specific code to the main generic code paths.

Regards,

Hans

