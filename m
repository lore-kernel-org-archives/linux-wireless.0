Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C43E2C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 11:52:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A62620869
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 11:52:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WmnGB3SW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IJ+s+2KZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8A62620869
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730645AbeKFVRl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 16:17:41 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:38830 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730368AbeKFVRl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 16:17:41 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 800DF60795; Tue,  6 Nov 2018 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541505170;
        bh=gWcSSXYnE3LredWSZWd3en+2tRTwJZM/56orLVI8/Ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WmnGB3SWgPczQS5VnjsNHVhVXfzuYnjTlt8Xqp5KwFVthxvdYMU8+RA+fA5u0R7MO
         kvZnBcJoSGyPvpodXKJcSjABItD9J2AJT1qFz+gPOcC6aaLM4ODNMcLs3JaU+0fixG
         dp+zASgoYsITu1CVSa3XJmeMPV5co2UT+TSPpjAs=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id CE1D360247;
        Tue,  6 Nov 2018 11:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541505169;
        bh=gWcSSXYnE3LredWSZWd3en+2tRTwJZM/56orLVI8/Ec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IJ+s+2KZ80gC8fzlNJVwNBJfOCDBI52WqKkdaale4pldjvsrrgzmN76SW9Xje53Lx
         4MWEnhZTE9Ax5/9yFy5UO/3vdgWteL7RWcpiq+ctRmEgshxWdIXM/k1OBvA2mUU5XP
         dSrZK3eR2mo1y+7TL3ty2g4pyIqEI3EIHlMwVxRk=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 06 Nov 2018 13:52:49 +0200
From:   merez@codeaurora.org
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Ahmad Masri <amasri@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 07/16] wil6210: refactor disconnect flow
In-Reply-To: <871s7ybir0.fsf@purkki.adurom.net>
References: <1540975944-30576-1-git-send-email-merez@codeaurora.org>
 <1540975944-30576-8-git-send-email-merez@codeaurora.org>
 <871s7ybir0.fsf@purkki.adurom.net>
Message-ID: <6852209b6e110737dc189ec89a49078f@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-06 12:30, Kalle Valo wrote:
> Maya Erez <merez@codeaurora.org> writes:
> 
>> From: Ahmad Masri <amasri@codeaurora.org>
>> 
>> Separate sending command to the fw from the event handling function to
>> simplify the disconnect flow and track the from_event flag correctly.
>> 
>> Signed-off-by: Ahmad Masri <amasri@codeaurora.org>
>> Signed-off-by: Maya Erez <merez@codeaurora.org>
> 
> [...]
> 
>> +static int wil_disconnect_cid(struct wil6210_vif *vif, int cid,
>> +			      u16 reason_code)
>> +__acquires(&sta->tid_rx_lock) __releases(&sta->tid_rx_lock)
>> +{
>> +	struct wil6210_priv *wil = vif_to_wil(vif);
>> +	struct wireless_dev *wdev = vif_to_wdev(vif);
>> +	struct wil_sta_info *sta = &wil->sta[cid];
>> +	bool del_sta = false;
>> +
>> +	might_sleep();
>> +	wil_dbg_misc(wil, "disconnect_cid: CID %d, MID %d, status %d\n",
>> +		     cid, sta->mid, sta->status);
>> +
>> +	if (sta->status == wil_sta_unused)
>> +		return 0;
>> +
>> +	if (vif->mid != sta->mid) {
>> +		wil_err(wil, "STA MID mismatch with VIF MID(%d)\n", vif->mid);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* inform lower layers */
>> +	if (wdev->iftype == NL80211_IFTYPE_AP && disable_ap_sme)
>> +		del_sta = true;
>> +
>> +	/* disconnect by sending command disconnect/del_sta and wait
>> +	 * synchronously for WMI_DISCONNECT_EVENTID event.
>> +	 */
>> +	return wmi_disconnect_sta(vif, sta->addr, reason_code, del_sta);
>> +}
> 
> I don't get use of __acquires() and __releases() in this function. I 
> see
> similar pattern already in wil6210 but care to explain why this is
> needed? I don't see the function even accessing tid_rx_lock so I'm very
> confused.

I assume it is a copy / paste leftover that we missed in the code 
review.
We will remove it.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
