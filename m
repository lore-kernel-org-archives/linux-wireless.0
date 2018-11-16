Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CABCC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 09:46:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610B72086C
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 09:46:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IRvRYlpt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JPqt8ge7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 610B72086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389414AbeKPT57 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 14:57:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43192 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727398AbeKPT56 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 14:57:58 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 68823607DC; Fri, 16 Nov 2018 09:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542361584;
        bh=jFzDp15PO9VpNznQ9BITkVSQLTDGdp0MdD6nZgnDBJs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IRvRYlptNCtFyTOMX36Br70go9h5prdDOe11xRViIyoqe0GTartuRI7685BTV/XmA
         GclECt69MYmjOKn4sX3YUN8nJ1s0sog+LM2ssh4hMoroyE9wiQqO+3crlt0HJbWi6S
         d3ugmV+NngZ1IByekIEDRefZsbN2oqYXn5m/5UYE=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6EBB36035F;
        Fri, 16 Nov 2018 09:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542361583;
        bh=jFzDp15PO9VpNznQ9BITkVSQLTDGdp0MdD6nZgnDBJs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JPqt8ge7uinrpVMdB5aR21tKqzcBGRDxvmoL4huR2tGZw3bnPwyonpouimIQVwXNP
         xGbdFh7l5SgcxbpSG2jc6WPlzIp6hqzZoH4u8Bd9vp5ZmNBiRtC1YXO235djpW2m12
         QXDQxulr33g6JMm/Ds14y5oBHp7GFhmiWDf0ugj8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6EBB36035F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Peter Oh <peter.oh@bowerswilkins.com>
Cc:     Tamizh chelvam <tamizhr@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath: fix frequent flase radar detection
References: <1539580047-22512-1-git-send-email-tamizhr@codeaurora.org>
        <b0e823e3-275c-86ab-dce0-dd522ebd3711@bowerswilkins.com>
Date:   Fri, 16 Nov 2018 11:46:20 +0200
In-Reply-To: <b0e823e3-275c-86ab-dce0-dd522ebd3711@bowerswilkins.com> (Peter
        Oh's message of "Mon, 15 Oct 2018 17:47:36 +0000")
Message-ID: <87wopd73tf.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Peter Oh <peter.oh@bowerswilkins.com> writes:

> On 10/14/2018 10:07 PM, Tamizh chelvam wrote:
>> Many number of false radar detection occurred in a noisy
>> environment in QCA4019, QCA9888 devices. By reducing
>> PRI_TOLERANCE to 6 and flushing out pulse queue by dpd_reset
>> if timestamp between current and previous pulse is lesser than
>> 100ms helps to avoid/reduce this false radar detection
>> in the noisy environment.
>>
>> Tested ath10k hw and fw:
>> 	* QCA9888(10.4-3.5.1-00052)
>> 	* QCA4019(10.4-3.2.1.1-00017)
>> 	* QCA9984(10.4-3.6-00104)
>> 	* QCA988X(10.2.4-1.0-00041)
>>
>> Tested ath9k hw: AR9300
>
> Please post the radar detection rate results before and after this change.
> Especially for ETSI at 30% channel load.
>
>> Signed-off-by: Tamizh chelvam <tamizhr@codeaurora.org>
>> ---
>>   drivers/net/wireless/ath/ath.h                  | 2 ++
>>   drivers/net/wireless/ath/ath10k/mac.c           | 4 ++++
>>   drivers/net/wireless/ath/ath9k/init.c           | 1 +
>>   drivers/net/wireless/ath/dfs_pattern_detector.c | 4 +++-
>>   drivers/net/wireless/ath/dfs_pattern_detector.h | 2 +-
>>   5 files changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
>> index 7a364ec..2bf2d0c 100644
>> --- a/drivers/net/wireless/ath/ath.h
>> +++ b/drivers/net/wireless/ath/ath.h
>> @@ -184,6 +184,8 @@ struct ath_common {
>>   
>>   	int last_rssi;
>>   	struct ieee80211_supported_band sbands[NUM_NL80211_BANDS];
>> +
>> +	int dfs_pulse_valid_diff_ts;
>>   };
>>   
>>   static inline const struct ath_ps_ops *ath_ps_ops(struct ath_common *common)
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index a1c2801..c93b81c 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -8275,6 +8275,8 @@ struct ath10k_vif *ath10k_get_arvif(struct ath10k *ar, u32 vdev_id)
>>   #define WRD_METHOD "WRDD"
>>   #define WRDD_WIFI  (0x07)
>>   
>> +#define ATH10K_DFS_PULSE_VALID_DIFF_TS 100
>> +
>>   static u32 ath10k_mac_wrdd_get_mcc(struct ath10k *ar, union acpi_object *wrdd)
>>   {
>>   	union acpi_object *mcc_pkg;
>> @@ -8642,6 +8644,8 @@ int ath10k_mac_register(struct ath10k *ar)
>>   	if (IS_ENABLED(CONFIG_ATH10K_DFS_CERTIFIED)) {
>>   		/* Init ath dfs pattern detector */
>>   		ar->ath_common.debug_mask = ATH_DBG_DFS;
>> +		ar->ath_common.dfs_pulse_valid_diff_ts =
>> +					ATH10K_DFS_PULSE_VALID_DIFF_TS;
>>   		ar->dfs_detector = dfs_pattern_detector_init(&ar->ath_common,
>>   							     NL80211_DFS_UNSET);
>>   
>> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
>> index c070a9e..7ea4460 100644
>> --- a/drivers/net/wireless/ath/ath9k/init.c
>> +++ b/drivers/net/wireless/ath/ath9k/init.c
>> @@ -696,6 +696,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
>>   	common->debug_mask = ath9k_debug;
>>   	common->btcoex_enabled = ath9k_btcoex_enable == 1;
>>   	common->disable_ani = false;
>> +	common->dfs_pulse_valid_diff_ts = 0;
>
> Why it's 0 here while ath10k is using 100us?

Tamizh, please reply to Peter's comments. I'll drop this patch now,
please resubmit once you have reached a conclusion in the discussion.

-- 
Kalle Valo
