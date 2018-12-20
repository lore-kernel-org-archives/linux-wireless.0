Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A37BEC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 18:22:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 769B5217D9
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 18:22:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="bT2aoHe8";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P/c8MxPE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388830AbeLTSWW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 13:22:22 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41560 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730855AbeLTSWW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 13:22:22 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 25B8D606FC; Thu, 20 Dec 2018 18:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545330141;
        bh=0zMRYgSs6M0dlKODqNqUyEyC87inSpEUS8mTP9SfkCc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=bT2aoHe8a7vN1Q8BvO7vl2S5ax/vKz0wPX2p8wkg0L6deq109sn2USBvTJH74SUcy
         2PAje3OSyI1XcHIKMzGeVXZ3hZh1eaMofedM+HMlE52xttDgFhK2uA3Ye4XktL6d6o
         ZH49oMgD/2AV+u7yRCAR1fEzugvpuGj97rUZm0QQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5B1C06053B;
        Thu, 20 Dec 2018 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545330140;
        bh=0zMRYgSs6M0dlKODqNqUyEyC87inSpEUS8mTP9SfkCc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=P/c8MxPEXmhgOCv6xfo8hRNqGB92PjkL4vWZSzwL+dGLvTXg6vrufChkYz95FQalG
         UnPDbb5sDrxbdst5g8ANiIzQDqHkvHeoOUBPYT3/DsEIazHfz2NWjDt541EIo8ZaEz
         hwyyt1JMKIrPaspYyUEyoVKq76FhnmPjZDYbK0yE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5B1C06053B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     David Miller <davem@davemloft.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull-request: wireless-drivers-next 2018-12-20
References: <878t0kt6tu.fsf@kamboji.qca.qualcomm.com>
Date:   Thu, 20 Dec 2018 20:22:17 +0200
In-Reply-To: <878t0kt6tu.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Thu, 20 Dec 2018 20:02:21 +0200")
Message-ID: <874lb8t5wm.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ stephen

Kalle Valo <kvalo@codeaurora.org> writes:

> here's a pull request to net-next for 4.21. More info in the signed
> below.
>
> As I have been too busy this cycle not all of these have been in
> linux-next, but most of them has been tested by the kbuild bot and the
> last few remaining patches are being tested while I write this. So I'm
> not expecting any major problems, but if you see something do let me
> know.
>
> Happy Holidays and have a great New Year :)
>
> Kalle
>
> The following changes since commit d9bbd6a1a56eccb2b1198b8f2008d622982df0a1:
>
>   net: marvell: convert to DEFINE_SHOW_ATTRIBUTE (2018-12-03 17:33:44 -0800)
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2018-12-20
>
> for you to fetch changes up to fbbae71d374f24887d78631e50210b7110fffb84:
>
>   Merge ath-next from git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git (2018-12-20 19:25:43 +0200)

BTW, when merging wireless-drivers (which is in net tree now) with
wireless-drivers-next there's one simple conflict:

CONFLICT (content): Merge conflict in drivers/net/wireless/ath/ath10k/wmi.h

Please fix it by leaving all three enums in place, so something like
this:

diff --cc drivers/net/wireless/ath/ath10k/wmi.h
index 88210ddaedc4,c5a343c93013..000000000000
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@@ -205,8 -205,7 +205,9 @@@ enum wmi_service 
  	WMI_SERVICE_SPOOF_MAC_SUPPORT,
  	WMI_SERVICE_TX_DATA_ACK_RSSI,
  	WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
 +	WMI_SERVICE_VDEV_DISABLE_4_ADDR_SRC_LRN_SUPPORT,
 +	WMI_SERVICE_BB_TIMING_CONFIG_SUPPORT,
+ 	WMI_SERVICE_THERM_THROT,
  
  	/* keep last */
  	WMI_SERVICE_MAX,

-- 
Kalle Valo
