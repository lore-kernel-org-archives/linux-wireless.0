Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418E4C77B7F
	for <linux-wireless@archiver.kernel.org>; Mon,  8 May 2023 13:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbjEHN33 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 May 2023 09:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbjEHN3T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 May 2023 09:29:19 -0400
Received: from bin-mail-out-05.binero.net (bin-mail-out-05.binero.net [195.74.38.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A412BCD1
        for <linux-wireless@vger.kernel.org>; Mon,  8 May 2023 06:29:09 -0700 (PDT)
X-Halon-ID: 4b80ee04-eda4-11ed-b7d6-cf458ee68324
Authorized-sender: petter@technux.se
Received: from localhost.localdomain (user33.85-195-12.netatonce.net [85.195.12.33])
        by bin-vsp-out-03.atm.binero.net (Halon) with ESMTPSA
        id 4b80ee04-eda4-11ed-b7d6-cf458ee68324;
        Mon, 08 May 2023 15:29:05 +0200 (CEST)
From:   Petter Mabacker <petter@technux.se>
To:     s.hauer@pengutronix.de
Cc:     linux-wireless@vger.kernel.org, petter@technux.se,
        pkshih@realtek.com, tony0620emma@gmail.com
Subject: Re: rtw88: rtw8822cu (LM842) -> failed to get tx report from firmware
Date:   Mon,  8 May 2023 15:29:01 +0200
Message-Id: <20230508132901.44137-1-petter@technux.se>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411124836.GM19113@pengutronix.de>
References: <20230411124836.GM19113@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I'm working with a Linux 6.1 based track, but with all the mentioned bug fixes cherry-picked to that track. They have all made the LM842 a lot more stabile, but the issue I see with "tx report failed" is currently blocking me from using the LM842, since the mender upgrade is a crucial part for my use-case.

I have been trying to find a better way to reproduce the issue, without any success so far. For me it takes just 10-30 sec with above mention flooding using iperf to at least trigger a similar case.

...
[  671.908527] rtw_8822cu 1-1:1.2: failed to get rx_queue, overflow
[  671.914632] rtw_8822cu 1-1:1.2: failed to get rx_queue, overflow
[  671.920750] rtw_8822cu 1-1:1.2: failed to get rx_queue, overflow
[  671.926792] rtw_8822cu 1-1:1.2: failed to get rx_queue, overflow
[  671.932924] rtw_8822cu 1-1:1.2: failed to get rx_queue, overflow

[  694.709045] rtw_8822cu 1-1:1.2: failed to get tx report from firmware

[  710.169496] rtw_8822cu 1-1:1.2: firmware failed to report density after scan
[  717.701235] rtw_8822cu 1-1:1.2: failed to send h2c command


I can also mention that I'm running this in a i.MX6 SoloX based board.

I will let you guys know if I find a better way to reproduce the issue. But if you have any good ideas what above error (that brings down the entire interface) really mean (for example does it indicate kernel or firmware issue), please feel free to share some information about it and it might help me in troubleshooting the issue further.

BR Petter
