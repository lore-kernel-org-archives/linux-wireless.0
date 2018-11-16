Return-Path: <SRS0=ZGUU=N3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D43C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 12:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5329B208A3
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Nov 2018 12:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jaNtpkZl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jaNtpkZl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5329B208A3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbeKPW3h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Nov 2018 17:29:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51920 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727727AbeKPW3h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Nov 2018 17:29:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6D744606E1; Fri, 16 Nov 2018 12:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542370649;
        bh=bk5FEvnJ2/kWE+2A1nRwqHlMNe7DhcUI2Wthd/UTpmk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jaNtpkZlCbKB4Wqd9l78LK53Hpu+bbjvPyxx/kmkPIIwbzNfoy24ofMWkfG/eQ+uE
         tDlnOfj5q4NDAfPVkK8HfE8X/vvU8xlE6x4v2EtUskfZ4V3hh+09kigEBg8iKTKyHY
         XmvGknl8PK7Ju/xDKorl+w6+R6vJgfJbLgYUL73g=
Received: from x230.qca.qualcomm.com (87-95-226-75.bb.dnainternet.fi [87.95.226.75])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8FA106035F;
        Fri, 16 Nov 2018 12:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542370649;
        bh=bk5FEvnJ2/kWE+2A1nRwqHlMNe7DhcUI2Wthd/UTpmk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jaNtpkZlCbKB4Wqd9l78LK53Hpu+bbjvPyxx/kmkPIIwbzNfoy24ofMWkfG/eQ+uE
         tDlnOfj5q4NDAfPVkK8HfE8X/vvU8xlE6x4v2EtUskfZ4V3hh+09kigEBg8iKTKyHY
         XmvGknl8PK7Ju/xDKorl+w6+R6vJgfJbLgYUL73g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 8FA106035F
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 3/3] ath10k: Add support to configure ftm responder role
References: <1534293018-4930-1-git-send-email-pradeepc@codeaurora.org>
        <1534293018-4930-4-git-send-email-pradeepc@codeaurora.org>
        <36962f12-84ff-d1a9-8273-a8e3444db108@dd-wrt.com>
        <871s99lrlv.fsf@kamboji.qca.qualcomm.com>
Date:   Fri, 16 Nov 2018 14:17:24 +0200
In-Reply-To: <871s99lrlv.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Mon, 01 Oct 2018 16:32:44 +0300")
Message-ID: <87ftw16wtn.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>
>> Am 15.08.2018 um 02:30 schrieb Pradeep Kumar Chitrapu:
>>>   +	if (test_bit(WMI_SERVICE_RTT, ar->wmi.svc_map))
>>> +		wiphy_ext_feature_set(ar->hw->wiphy,
>>> +				      NL80211_EXT_FEATURE_SET_FTM_RESPONDER);
>>> +
>>
>> not sure if this is accurate. even if WMI_SERVICE_RTT is set, the
>> firmware may not support this feature. this feature doesnt seem to be
>> implemented in current firmware releases
>> i checked the firmware sourcecode i have from 3.4 series and it doesnt
>> support this feature
>
> Pradeep, did you check this? It's really bad if ath10k enables the
> feature even if the firmware doesn't support this.

Pradeep, please clarify the situation. I don't want to enable features
when firmware doesn't support it.

-- 
Kalle Valo
