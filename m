Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84BAC32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 881E120862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 10:30:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IDrZ9NCx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IDrZ9NCx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 881E120862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387817AbeKFTzT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 14:55:19 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:52918 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387491AbeKFTzT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 14:55:19 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DA2826049C; Tue,  6 Nov 2018 10:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541500246;
        bh=jEFlFONmjGjqpnbYSDrLrbtqVCdP3VBBGTqKnmRce5M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IDrZ9NCxb+7S5ItGAxPFBKz3cBZjS9XtWVy2f0Y+gnNhFSUDqevfH21GFNz8V7fMt
         XwNORyEkl1ZeSw7k/52BGs8kbt2XWaj4THdGShoU3zWU29DHWdr3FMOiVoQHEHCwWq
         1WgKJkYN7ySjjJBd2X0Mqaw45NxqX4XPUPJe/9+s=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C4E4A6053D;
        Tue,  6 Nov 2018 10:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541500246;
        bh=jEFlFONmjGjqpnbYSDrLrbtqVCdP3VBBGTqKnmRce5M=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IDrZ9NCxb+7S5ItGAxPFBKz3cBZjS9XtWVy2f0Y+gnNhFSUDqevfH21GFNz8V7fMt
         XwNORyEkl1ZeSw7k/52BGs8kbt2XWaj4THdGShoU3zWU29DHWdr3FMOiVoQHEHCwWq
         1WgKJkYN7ySjjJBd2X0Mqaw45NxqX4XPUPJe/9+s=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C4E4A6053D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 07/16] wil6210: refactor disconnect flow
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
        <1540975944-30576-8-git-send-email-merez@codeaurora.org>
Date:   Tue, 06 Nov 2018 12:30:43 +0200
In-Reply-To: <1540975944-30576-8-git-send-email-merez@codeaurora.org> (Maya
        Erez's message of "Wed, 31 Oct 2018 10:52:15 +0200")
Message-ID: <871s7ybir0.fsf@purkki.adurom.net>
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
> Separate sending command to the fw from the event handling function to
> simplify the disconnect flow and track the from_event flag correctly.
>
> Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
> Signed-off-by: Maya Erez <merez@codeaurora.org>

[...]

> +static int wil_disconnect_cid(struct wil6210_vif *vif, int cid,
> +			      u16 reason_code)
> +__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
> +{
> +	struct wil6210_priv *wil = vif_to_wil(vif);
> +	struct wireless_dev *wdev = vif_to_wdev(vif);
> +	struct wil_sta_info *sta = &wil->sta[cid];
> +	bool del_sta = false;
> +
> +	might_sleep();
> +	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
> +		     cid, sta->mid, sta->status);
> +
> +	if (sta->status == wil_sta_unused)
> +		return 0;
> +
> +	if (vif->mid != sta->mid) {
> +		wil_err(wil, "STA MID mismatch with VIF MID(%d)\n", vif->mid);
> +		return -EINVAL;
> +	}
> +
> +	/* inform lower layers */
> +	if (wdev->iftype == NL80211_IFTYPE_AP && disable_ap_sme)
> +		del_sta = true;
> +
> +	/* disconnect by sending command disconnect/del_sta and wait
> +	 * synchronously for WMI_DISCONNECT_EVENTID event.
> +	 */
> +	return wmi_disconnect_sta(vif, sta->addr, reason_code, del_sta);
> +}

I don't get use of __acquires() and __releases() in this function. I see
similar pattern already in wil6210 but care to explain why this is
needed? I don't see the function even accessing tid_rx_lock so I'm very
confused.

-- 
Kalle Valo
