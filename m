Return-Path: <SRS0=UTNx=Z7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DB39C43603
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Dec 2019 04:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8976206D3
	for <linux-wireless@archiver.kernel.org>; Mon,  9 Dec 2019 04:35:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="D+GtL6Ba";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="CYvKOs93"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLIEfG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 8 Dec 2019 23:35:06 -0500
Received: from a27-11.smtp-out.us-west-2.amazonses.com ([54.240.27.11]:36608
        "EHLO a27-11.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726960AbfLIEfF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 8 Dec 2019 23:35:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575866105;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=GSyqXBSBISNmRJ2sqBaBH1oECvAKyPYDnFJSVrqRzTU=;
        b=D+GtL6BaMmzG79KHqqCgFrE6A/Y6DeO+jp5RhXgiWEa4vM9ohygBhIFu6zBrAToV
        a/SpqNeCE8B2AGLtUZR0hduFTMsOIbKjvfMcvTlM9KJTQwMd0rIyk1lubS3uMwiThUw
        fZ2hYS4laKXVarogdCemKduM3oM9IaqOep5vSYfk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575866105;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=GSyqXBSBISNmRJ2sqBaBH1oECvAKyPYDnFJSVrqRzTU=;
        b=CYvKOs93hml4hFcdv2iola7KEXnwb59aJLlyphcYpnwM/vsWGnM0qjyf78nIqQIf
        m8oy5eXedUwYSB4ckNmilWsefJ6zCpPJMTcFYpSykRS8oO0hvNFz6rWoT5pOby0pZdy
        MFVRWvJFzwUNXcrFCrbZZB9yWypO9zZmC//eLdVk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 9 Dec 2019 04:35:05 +0000
From:   vthiagar@codeaurora.org
To:     John Crispin <john@phrozen.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 7/7] ath11k: add handling for BSS color
In-Reply-To: <20191206143401.4080-7-john@phrozen.org>
References: <20191206143401.4080-1-john@phrozen.org>
 <20191206143401.4080-7-john@phrozen.org>
Message-ID: <0101016ee8f07cd1-50bd69b1-8bc0-49ef-a9a3-3e4f0d8dc9d1-000000@us-west-2.amazonses.com>
X-Sender: vthiagar@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.09-54.240.27.11
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-12-06 20:04, John Crispin wrote:
> This patch adds code to handle the BSS_CHANGED_BSS_COLOR flag. IT will
> trigger the propagation of BSS color settings into the FW. Handling is
> slightly different between AP and STA interfaces.
> 
> Signed-off-by: John Crispin <john@phrozen.org>
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c
> b/drivers/net/wireless/ath/ath11k/mac.c
> index 6a8c1c3b8da2..c692922513b2 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -1928,6 +1928,19 @@ static void
> ath11k_mac_op_bss_info_changed(struct ieee80211_hw *hw,
>  		ath11k_wmi_send_obss_spr_cmd(ar, arvif->vdev_id,
>  					     &info->he_obss_pd);
> 
> +	if (changed & BSS_CHANGED_HE_BSS_COLOR) {
> +		if (vif->type == NL80211_IFTYPE_AP) {
> +			ath11k_wmi_send_obss_color_collision_cfg_cmd(
> +				ar, arvif->vdev_id, info->he_bss_color.color,
> +				ATH11K_BSS_COLOR_COLLISION_DETECTION_AP_PERIOD_MS,
> +				!info->he_bss_color.disabled);

No error code check required, why?

> +		} else if (vif->type == NL80211_IFTYPE_STATION) {
> +			ath11k_wmi_send_bss_color_change_enable_cmd(ar, arvif->vdev_id, 1);
> +			ath11k_wmi_send_obss_color_collision_cfg_cmd(ar, arvif->vdev_id, 0,
> +				ATH11K_BSS_COLOR_COLLISION_DETECTION_STA_PERIOD_MS, 1);

Same here.


Vasanth
