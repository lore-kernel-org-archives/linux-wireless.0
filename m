Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8522C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:34:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FB1120823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:34:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="avVSkWmN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ur6HPX0G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbfBDPeD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:34:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbfBDPeD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:34:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 83D7C607F4; Mon,  4 Feb 2019 15:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549294442;
        bh=dTUP2OmAHR/Ei6FE3WhHnc63J9BxltNzY8dGzpptAxs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=avVSkWmN3PfXzXcj2FxfneOSGRpeIca0nNajcOOC6qBJTS42ba8dBevQHZhsO0b8u
         pt7QuePakw+U14cmwkD/qnuob8VuX4Dn7ZETyqoR0YHVFwQmYpMqzETzSSDUB50bOw
         5OW8bOMXuwnhHEhW9/ZL99QloEmEld6ZCzKpaz+Q=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6CB5C606AC;
        Mon,  4 Feb 2019 15:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549294441;
        bh=dTUP2OmAHR/Ei6FE3WhHnc63J9BxltNzY8dGzpptAxs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ur6HPX0GloXBTKdDuph5h/5XI0LGshTJRh52HGkYfQb5GITT0izyoy0/GfKy7+Wjo
         O/XhVw2JNH05X1jUj5+b4oe0k29OvYpLM0hvJg6H5ahS0G78CH+O3ZfTDYMtyJZT7+
         gz4po9jr2h6dUz73fSwGWLXTVCLLhmXzE0tgf+Xw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6CB5C606AC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Surabhi Vishnoi <svishnoi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Fill tx_duration for each peer in Tx stats per STA
References: <1548999390-25576-1-git-send-email-svishnoi@codeaurora.org>
Date:   Mon, 04 Feb 2019 17:33:57 +0200
In-Reply-To: <1548999390-25576-1-git-send-email-svishnoi@codeaurora.org>
        (Surabhi Vishnoi's message of "Fri, 1 Feb 2019 11:06:30 +0530")
Message-ID: <8736p3effe.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Surabhi Vishnoi <svishnoi@codeaurora.org> writes:

> Firmware sends the tx_duration for each in HTT_T2H_MSG_TYPE_PEER_STATS
> msg. Fill the tx_duration sent by firmware in the tx stats information
> per STA.
>
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0

Same here, please let me know the firmware version so I can add it.

-- 
Kalle Valo
