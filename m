Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA7FC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:17:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B66A2184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 09:17:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Vv8MySr3";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jDQoAnsu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfB1JR2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 04:17:28 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731994AbfB1JR2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 04:17:28 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F264A60CED; Thu, 28 Feb 2019 09:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551345447;
        bh=AL/CTvFjknhZ0CwQdK7PbYJvwhZhLl5KAJgEm3gzgy8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Vv8MySr3mgiv7KD8Mm6Ygx+HcLall65kIwtreP/e6GDIWeWihlUh3VJBdRCtVnjkL
         t8vnCVdxF1URBhCwy8gAQPBwR+HIn6f+WjNFQatuV7LJ19YxYA1xuN1AGogPX1bGnr
         T2OuqcpL0Usz+Me6N1WCVCb4s7T/inkNiVH6zAkI=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC2BF602FC;
        Thu, 28 Feb 2019 09:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1551345446;
        bh=AL/CTvFjknhZ0CwQdK7PbYJvwhZhLl5KAJgEm3gzgy8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jDQoAnsur7MV/SKAT2gobnxzgeRHrZw40WOoVKUPjkidHAkHFlLeX0+gejpnA1H21
         exjIxf5aoL2cMohed9/BgXH2OJ1porEbSY6wxtGZOZDGjf1Hw+t8zC8SXElDN7v1Rx
         Twu+jnGcP1ybNStmgiOlJ0nmfOo9O8739KneODcw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC2BF602FC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 03/21] wil6210: support up to 20 stations in AP mode
References: <1550845279-16103-1-git-send-email-merez@codeaurora.org>
        <1550845279-16103-4-git-send-email-merez@codeaurora.org>
Date:   Thu, 28 Feb 2019 11:17:23 +0200
In-Reply-To: <1550845279-16103-4-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Fri, 22 Feb 2019 16:21:01 +0200")
Message-ID: <87va14z2zg.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> writes:

> From: Ahmad Masri <amasri@codeaurora.org>
>
> New FW added support for upto 20 clients in AP mode. Change the driver
> to support this as well. FW reports it's max supported associations in
> WMI_READY_EVENT. Some WMI commands/events use cidxtid field which is
> limited to 16 cids. Use new cid/tid fields instead.
>
> For Rx packets cid from rx descriptor is limited to 3 bits (0..7),
> to find the real cid, compare transmitter address with the stored
> stations mac address in the driver sta array.
>
> EDMA FW still supports 8 stations. Extending the support to 20
> stations will come later.
>
> Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

[...]


> --- a/drivers/net/wireless/ath/wil6210/wmi.c
> +++ b/drivers/net/wireless/ath/wil6210/wmi.c
> @@ -24,8 +24,9 @@
>  #include "wmi.h"
>  #include "trace.h"
>  
> -static uint max_assoc_sta = WIL6210_MAX_CID;
> -module_param(max_assoc_sta, uint, 0644);
> +/* set the default max assoc sta to max supported by driver */
> +uint max_assoc_sta = WIL6210_MAX_CID;
> +module_param(max_assoc_sta, uint, 0444);
>  MODULE_PARM_DESC(max_assoc_sta, " Max number of stations associated to the AP");
>  
>  int agg_wsize; /* = 0; */
> @@ -770,6 +771,7 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
>  	struct wil6210_priv *wil = vif_to_wil(vif);
>  	struct wiphy *wiphy = wil_to_wiphy(wil);
>  	struct wmi_ready_event *evt = d;
> +	u8 fw_max_assoc_sta;
>  
>  	wil_info(wil, "FW ver. %s(SW %d); MAC %pM; %d MID's\n",
>  		 wil->fw_version, le32_to_cpu(evt->sw_version),
> @@ -787,6 +789,25 @@ static void wmi_evt_ready(struct wil6210_vif *vif, int id, void *d, int len)
>  			    evt->rfc_read_calib_result);
>  		wil->fw_calib_result = evt->rfc_read_calib_result;
>  	}
> +
> +	fw_max_assoc_sta = WIL6210_RX_DESC_MAX_CID;
> +	if (len > offsetof(struct wmi_ready_event, max_assoc_sta) &&
> +	    evt->max_assoc_sta > 0) {
> +		fw_max_assoc_sta = evt->max_assoc_sta;
> +		wil_dbg_wmi(wil, "fw reported max assoc sta %d\n",
> +			    fw_max_assoc_sta);
> +
> +		if (fw_max_assoc_sta > WIL6210_MAX_CID) {
> +			wil_dbg_wmi(wil,
> +				    "fw max assoc sta %d exceeds max driver supported %d\n",
> +				    fw_max_assoc_sta, WIL6210_MAX_CID);
> +			fw_max_assoc_sta = WIL6210_MAX_CID;
> +		}
> +	}
> +
> +	max_assoc_sta = min_t(uint, max_assoc_sta, fw_max_assoc_sta);

You shouldn't modify max_assoc_sta like this. If you have two wil6210
devices on the same host they will share that variable and there's a
race condition. Sure, I guess currently they will use the same firmware
so the values will be the same, but still this is a bug. I think you
should have wil->max_assoc_sta to make this device specific value.

I'll apply this anyway as it breaks all other patches if I remove this
patch. But please fix this in a follow up patch.

-- 
Kalle Valo
