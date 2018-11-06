Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28292C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC81D20862
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 12:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JtSrnQlW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JtSrnQlW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DC81D20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387813AbeKFWFy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 17:05:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:44262 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387454AbeKFWFx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 17:05:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DFF7B60B7D; Tue,  6 Nov 2018 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541508050;
        bh=m3cOvyL7fZADAa6xGih7P1stUu+bk6oCjpk5n8aadKE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JtSrnQlWWc+1TzzVnEKB9AHbhzsyoUm6yBvCMv5Elcqns0FJH7Lr36nfeSvJYtybG
         UXABmIlG49Jcvxl/SU/EKoRQOJagHc3s07qUWBFE26ICttz/Vc4DPtB+uZcVtYG0D7
         EemsO1zUKrmLvKHip1fny4JPdzk8jtxWIEEbTxc4=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0578560C4B;
        Tue,  6 Nov 2018 12:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541508050;
        bh=m3cOvyL7fZADAa6xGih7P1stUu+bk6oCjpk5n8aadKE=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=JtSrnQlWWc+1TzzVnEKB9AHbhzsyoUm6yBvCMv5Elcqns0FJH7Lr36nfeSvJYtybG
         UXABmIlG49Jcvxl/SU/EKoRQOJagHc3s07qUWBFE26ICttz/Vc4DPtB+uZcVtYG0D7
         EemsO1zUKrmLvKHip1fny4JPdzk8jtxWIEEbTxc4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 0578560C4B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     merez@codeaurora.org
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 07/16] wil6210: refactor disconnect flow
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
        <1540975944-30576-8-git-send-email-merez@codeaurora.org>
        <871s7ybir0.fsf@purkki.adurom.net>
        <6852209b6e110737dc189ec89a49078f@codeaurora.org>
        <874lcue6ft.fsf@codeaurora.org>
        <98ff59749bbf386ba92faec2203ac3e9@codeaurora.org>
Date:   Tue, 06 Nov 2018 14:40:46 +0200
In-Reply-To: <98ff59749bbf386ba92faec2203ac3e9@codeaurora.org>
        (merez@codeaurora.org's message of "Tue, 06 Nov 2018 14:38:22 +0200")
Message-ID: <87va5acrap.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

merez@codeaurora.org writes:

> On 2018-11-06 14:28, Kalle Valo wrote:
>> merez@codeaurora.org writes:
>>
>>> On 2018-11-06 12:30, Kalle Valo wrote:
>>>> Maya Erez <merez@codeaurora.org> writes:
>>>>
>>>>> From: Ahmad Masri <amasri@codeaurora.org>
>>>>>
>>>>> Separate sending command to the fw from the event handling
>>>>> function to
>>>>> simplify the disconnect flow and track the from_event flag
>>>>> correctly.
>>>>>
>>>>> Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
>>>>> Signed-off-by: Maya Erez <merez@codeaurora.org>
>>>>
>>>> [...]
>>>>
>>>>> +static int wil_disconnect_cid(struct wil6210_vif *vif, int cid,
>>>>> +			      u16 reason_code)
>>>>> +__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
>>>>> +{
>>>>> +	struct wil6210_priv *wil = vif_to_wil(vif);
>>>>> +	struct wireless_dev *wdev = vif_to_wdev(vif);
>>>>> +	struct wil_sta_info *sta = &wil->sta[cid];
>>>>> +	bool del_sta = false;
>>>>> +
>>>>> +	might_sleep();
>>>>> +	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
>>>>> +		     cid, sta->mid, sta->status);
>>>>> +
>>>>> +	if (sta->status == wil_sta_unused)
>>>>> +		return 0;
>>>>> +
>>>>> +	if (vif->mid != sta->mid) {
>>>>> +		wil_err(wil, "STA MID mismatch with VIF MID(%d)\n", vif->mid);
>>>>> +		return -EINVAL;
>>>>> +	}
>>>>> +
>>>>> +	/* inform lower layers */
>>>>> +	if (wdev->iftype == NL80211_IFTYPE_AP && disable_ap_sme)
>>>>> +		del_sta = true;
>>>>> +
>>>>> +	/* disconnect by sending command disconnect/del_sta and wait
>>>>> +	 * synchronously for WMI_DISCONNECT_EVENTID event.
>>>>> +	 */
>>>>> +	return wmi_disconnect_sta(vif, sta->addr, reason_code, del_sta);
>>>>> +}
>>>>
>>>> I don't get use of __acquires() and __releases() in this function. I
>>>> see
>>>> similar pattern already in wil6210 but care to explain why this is
>>>> needed? I don't see the function even accessing tid_rx_lock so I'm
>>>> very
>>>> confused.
>>>
>>> I assume it is a copy / paste leftover that we missed in the code
>>> review. We will remove it.
>>
>> Actually I already removed the annotations from the pending branch and
>> no need to resend, it's faster that way. Please double check if you
>> can,
>> unfortunately I cannot provide a direct link cgit doesn't show the new
>> commit yet.
>
> In such a case you can go ahead and apply the patches without
> "wil6210: ignore HALP ICR if already handled". I'll upstream its fixed
> version
> in the next set of wil6210 patches.

Ok, I dropped "wil6210: ignore HALP ICR if already handled" and I'm
planning to apply the rest.

-- 
Kalle Valo
