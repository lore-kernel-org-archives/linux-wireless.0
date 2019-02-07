Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E208C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2482E2147C
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 14:14:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="oBSAwkUP";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Bpnzz0li"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfBGOOh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 09:14:37 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40166 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726558AbfBGOOh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 09:14:37 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4F43B607DF; Thu,  7 Feb 2019 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549548876;
        bh=5dl/IdNEQeqfO1AMpr58BoI8q4vDraMif9T5Wa9+VzA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=oBSAwkUPod027Kkme5oLx/Elk+qWqqZkNzGy31eF2K7X/dyfyMDgrSYMLhcfN4lqU
         MzkbVwj7943oZW1fZUnzE7Hlj+qw8C1NTZ+rEpTJma7ZXB/migHTP2Kgj8ZUhwXHDr
         CM/mT1Ue08NFQWX29umoFiFy8MJZDhDwpZAcSlLk=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6F09E60351;
        Thu,  7 Feb 2019 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549548875;
        bh=5dl/IdNEQeqfO1AMpr58BoI8q4vDraMif9T5Wa9+VzA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Bpnzz0li2lT0J1F/rI3A7r1z2sjQdmgCyPHdQTvUqQ1dWKny/PIVQXS171SQyzE9o
         hvHIVoN0BDbYYk+je64CwchNO3bFDlF1o9H9h3SxU+5lLcfwufAHhPNM5KFg/ulpKA
         /PodUNGz861zt0bvaNo/8OlSzcU3rKkeH/oNWjVk=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6F09E60351
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: Enable Factory Test Mode for WCN3990
References: <1535526038-4299-1-git-send-email-pillair@codeaurora.org>
        <20190205010207.GA219734@google.com>
Date:   Thu, 07 Feb 2019 16:14:31 +0200
In-Reply-To: <20190205010207.GA219734@google.com> (Brian Norris's message of
        "Mon, 4 Feb 2019 17:02:08 -0800")
Message-ID: <871s4jado8.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> On Wed, Aug 29, 2018 at 12:30:38PM +0530, Rakesh Pillai wrote:
>> The support to put WCN3990 firmware into Factory
>> test mode is not present currently. The WCN3990
>> firmware can operate in Factory test mode based
>> on the mode it receives in the wlan enable message
>> from the host driver.
>> 
>> When the host driver is started in testmode send
>> the operating mode as UTF mode, to the WCN3990
>> firmware, in the wlan enable message to start the
>> firmware in Factory test mode.
>> 
>> Tested on: WCN3990
>> Tested FW: WLAN.HL.2.0-01192-QCAHLSWMTPLZ-1.
>> 
>> Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
>> ---
>>  drivers/net/wireless/ath/ath10k/ahb.c      |  3 ++-
>>  drivers/net/wireless/ath/ath10k/core.c     |  2 +-
>>  drivers/net/wireless/ath/ath10k/hif.h      |  7 ++++---
>>  drivers/net/wireless/ath/ath10k/mac.c      |  2 +-
>>  drivers/net/wireless/ath/ath10k/pci.c      |  3 ++-
>>  drivers/net/wireless/ath/ath10k/sdio.c     |  3 ++-
>>  drivers/net/wireless/ath/ath10k/snoc.c     | 20 ++++++++++++++++----
>>  drivers/net/wireless/ath/ath10k/testmode.c |  2 +-
>>  drivers/net/wireless/ath/ath10k/usb.c      |  3 ++-
>>  9 files changed, 31 insertions(+), 14 deletions(-)
>
> What ever happened here? I'm told this is useful, but I see no comments
> and it's marked Deferred in patchwork:
>
> https://patchwork.kernel.org/patch/10579559/

Not sure, I guess it just got accidentally hidden with other patches.
It's in new state now.

> FWIW, it looks OK to me:
>
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Thanks!

-- 
Kalle Valo
