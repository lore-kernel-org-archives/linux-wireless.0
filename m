Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FE59C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:32:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74012084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 13:32:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VTDGygDm";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oTedxMYi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74012084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbeJAUKj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:10:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbeJAUKj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:10:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 14581609A5; Mon,  1 Oct 2018 13:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538400768;
        bh=se/Bsihd1mVsIp/qd5se+4FPRtlG/XYNzH7RNv+O/PI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VTDGygDmPGaFT/C4xgFwvoSTMRmGQGzu2m5F+2PZ4zfeJD9v0+dkjmuQ4WSamMb71
         896FU0cYwftLWHxgEwGXbk1VxPgqtmqHyt4bMQpLxbc37zPZrp2x/GC0APRkWzImsm
         BnZ9OxUTUDfmGWiGD6m44zILimYhjTivrwhAHIls=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 452AD6079B;
        Mon,  1 Oct 2018 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538400767;
        bh=se/Bsihd1mVsIp/qd5se+4FPRtlG/XYNzH7RNv+O/PI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oTedxMYiXeId1fSph0DNuHd/MrUhAjZ/5lbfCeUs9KqwC4edOyY2DzZF9fZCd7qXm
         e1868Uj/kpKBdUcK3BsvdIRIc6w6JJmtdXPK1sueSpY22BMOl1F4vjgriF1HWOBaHF
         HbZmBKaKzVBtHwei6FGudFAphNSs+5IUBGocf66M=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 452AD6079B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] ath10k: Add support to configure ftm responder role
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
        <1534293018-4930-4-git-send-email-pradeepc@codeaurora.org>
        <36962f12-84ff-d1a9-8273-a8e3444db108@dd-wrt.com>
Date:   Mon, 01 Oct 2018 16:32:44 +0300
In-Reply-To: <36962f12-84ff-d1a9-8273-a8e3444db108@dd-wrt.com> (Sebastian
        Gottschall's message of "Wed, 15 Aug 2018 12:16:50 +0200")
Message-ID: <871s99lrlv.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 15.08.2018 um 02:30 schrieb Pradeep Kumar Chitrapu:
>>   +	if (test_bit(WMI_SERVICE_RTT, ar->wmi.svc_map))
>> +		wiphy_ext_feature_set(ar->hw->wiphy,
>> +				      NL80211_EXT_FEATURE_SET_FTM_RESPONDER);
>> +
>
> not sure if this is accurate. even if WMI_SERVICE_RTT is set, the
> firmware may not support this feature. this feature doesnt seem to be
> implemented in current firmware releases
> i checked the firmware sourcecode i have from 3.4 series and it doesnt
> support this feature

Pradeep, did you check this? It's really bad if ath10k enables the
feature even if the firmware doesn't support this.

-- 
Kalle Valo
