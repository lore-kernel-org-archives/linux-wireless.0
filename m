Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB9EC65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F2362084D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:29:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nti/6M/A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gvurhiKP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F2362084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbeJFTcU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:32:20 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50512 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeJFTcU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:32:20 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 26D886053C; Sat,  6 Oct 2018 12:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538828954;
        bh=SIwJ3AkqNvV43gKWJnNMe+St75WNzOxxdRFlkZwBADg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nti/6M/AUAEKHFb5uHeAcVD06R+uQkKgRgHyql/HRtGrnd+8mfGYDOW4n1ghlp4Cf
         Aa5J3bM/XauoohvkJ+76PNW2bDjjoH+9MCilUCxlrBEyFsMSdCg6PrGoizQJKAuwnV
         mRdhq2zJ1fdkxXYu0Orqi80e1Xd4pVlrN4/gbwFY=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 031D66053C;
        Sat,  6 Oct 2018 12:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538828953;
        bh=SIwJ3AkqNvV43gKWJnNMe+St75WNzOxxdRFlkZwBADg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gvurhiKPsDIdA6CIi/mK7SmV+AymQPG9RMMx9cvABhpsIrB1PDpAAUSy1j26PKUnq
         udCvc1ZG77y2L63pjRf7Xhy+/vsRYN1J0XFtRpntBd4H/FEcrl2efrkY/m6vtWynp9
         +BdNKOynTwb/YnkaO7bw2Ky9znsRidnFavODwUCA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 031D66053C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 03/12] rtw88: hci files
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
        <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
        <20181004130212.GC16819@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
Date:   Sat, 06 Oct 2018 15:29:08 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
        (Tony Chuang's message of "Fri, 5 Oct 2018 12:07:06 +0000")
Message-ID: <87d0snfecr.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> > +		}
>> > +
>> > +		info = IEEE80211_SKB_CB(skb);
>> > +		ieee80211_tx_info_clear_status(info);
>> > +		info->flags |= IEEE80211_TX_STAT_ACK;
>> > +		ieee80211_tx_status_irqsafe(hw, skb);
>> 
>> Always report ACK ?
>
> The ACK report is for mac80211 stack, it looks abnormal at the first glance.
> But we can only do this for every data frame because there is no ack report
> unless the driver ask the firmware to give one.
> Ask for every data frame is resource consuming.

I don't remember how mac80211 wants to handle the cases when the
hardware doesn't provide ack status, but lying that to mac80211 sounds
like a bad idea to me. Anyone have any suggestions how this should be
handled?

At the minimum add a proper comment explaining why you are lying to
mac80211.

-- 
Kalle Valo
