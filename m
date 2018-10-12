Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD8AFC6783C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E93F20865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 14:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nOew3HmP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LgCfVAsj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5E93F20865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728644AbeJLVxe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 17:53:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728579AbeJLVxe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 17:53:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4A52360B7A; Fri, 12 Oct 2018 14:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539354054;
        bh=DdfdIKZ7xrMplhxANXikou8IxFthpHCZYgdy0ozQMEg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nOew3HmPpeUTvzTFObw44eD8YthxH7fBh3I02a22b2U/ZHLmjJqxTtg5XHDrp6Mld
         gZc2yXUFD65gC6xzjZ/61ut89NuuWqpu59hJQe/4FhtDwHRMyWYSCy/NMOksPsrxnm
         TpT7qEv28cCe8XQlGSnJsZILYkADk3BVjCOlgCe8=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 85F9A60116;
        Fri, 12 Oct 2018 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539354053;
        bh=DdfdIKZ7xrMplhxANXikou8IxFthpHCZYgdy0ozQMEg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LgCfVAsjk6vuB1n+0ZVgXsZy4+SUHQaRc8BvN6babOccXl5KGlZ2DP5tNCl7mFaEw
         UcvTPJYP/zALo9XFVu+HYxjbNlFWzeYxIDsbfs7etaG/1z4SS/bL6G3Lt10Ick4q27
         Sf4idZEJrzkFLnW/Mv93fm72iLmz6zu0drXOlwt8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 85F9A60116
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rakesh Pillai <pillair@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath10k: Handle bundled tx completion for managenent frames
References: <1538503421-17607-1-git-send-email-pillair@codeaurora.org>
        <1538503421-17607-2-git-send-email-pillair@codeaurora.org>
Date:   Fri, 12 Oct 2018 17:20:49 +0300
In-Reply-To: <1538503421-17607-2-git-send-email-pillair@codeaurora.org>
        (Rakesh Pillai's message of "Tue, 2 Oct 2018 23:33:40 +0530")
Message-ID: <87y3b3456m.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rakesh Pillai <pillair@codeaurora.org> writes:

> WCN3990 supports sending tx completion for multiple
> management frames bundled together in a single event.
>
> Add support to handle the bundled tx completion
> event for WCN3990.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
>
> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>

[...]

> +static int ath10k_wmi_tlv_op_pull_mgmt_tx_bundle_compl_ev(
> +				struct ath10k *ar, struct sk_buff *skb,
> +				struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg *arg)
> +{
> +	struct wmi_tlv_tx_bundle_compl_parse bundle_tx_compl = { };
> +	int ret;
> +
> +	ret = ath10k_wmi_tlv_iter(ar, skb->data, skb->len,
> +				  ath10k_wmi_tlv_mgmt_tx_bundle_compl_parse,
> +				  &bundle_tx_compl);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to parse tlv: %d\n", ret);
> +		return ret;
> +	}
> +
> +	if (!bundle_tx_compl.num_reports || !bundle_tx_compl.desc_ids ||
> +	    !bundle_tx_compl.status)
> +		return -EPROTO;
> +
> +	arg->num_reports = __le32_to_cpu(*bundle_tx_compl.num_reports);

This causes a new warning:

drivers/net/wireless/ath/ath10k/wmi-tlv.c:744:26: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath/ath10k/wmi-tlv.c:744:26:    expected restricted __le32 [usertype] num_reports
drivers/net/wireless/ath/ath10k/wmi-tlv.c:744:26:    got unsigned int [unsigned] [usertype] <noident>

> +	arg->desc_ids = (__le32 *)bundle_tx_compl.desc_ids;
> +	arg->status = (__le32 *)bundle_tx_compl.status;

And these casts look really fishy, casting away const? Avoid casts as
much as possible, only in very expectional cases they are ok to use.

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -2378,6 +2378,32 @@ int ath10k_wmi_event_mgmt_tx_compl(struct ath10k *ar, struct sk_buff *skb)
>  	return 0;
>  }
>  
> +int ath10k_wmi_event_mgmt_tx_bundle_compl(struct ath10k *ar, struct sk_buff *skb)
> +{
> +	struct wmi_tlv_mgmt_tx_bundle_compl_ev_arg arg;
> +	u32 *desc_ids, *status;
> +	u32 num_reports;
> +	int i, ret;
> +
> +	ret = ath10k_wmi_pull_mgmt_tx_bundle_compl(ar, skb, &arg);
> +	if (ret) {
> +		ath10k_warn(ar, "failed to parse bundle mgmt compl event: %d\n", ret);
> +		return ret;
> +	}
> +
> +	num_reports = __le32_to_cpu(arg.num_reports);
> +	desc_ids = (u32 *)arg.desc_ids;
> +	status = (u32 *)arg.status;

These casts look fishy as well.

> +	for (i = 0; i < num_reports; i++)
> +		wmi_process_mgmt_tx_comp(ar, __le32_to_cpu(desc_ids[i]),
> +					 __le32_to_cpu(status[i]));

This has a warning:

drivers/net/wireless/ath/ath10k/wmi.c:2399:46: warning: cast to restricted __le32
drivers/net/wireless/ath/ath10k/wmi.c:2400:42: warning: cast to restricted __le32

-- 
Kalle Valo
