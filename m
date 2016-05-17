Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:36659 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178AbcEQDZj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 23:25:39 -0400
Received: by mail-pa0-f65.google.com with SMTP id xm6so465607pab.3
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2016 20:25:38 -0700 (PDT)
From: Adrian Chadd <adrian@freebsd.org>
To: linux-wireless@vger.kernel.org
Cc: Adrian Chadd <adrian@freebsd.org>,
	Kalle Valo <kvalo@codeaurora.org>, b43-dev@lists.infradead.org
Subject: [PATCH] b43: don't fall back to CCK rates on 5GHz OFDM for RTS frames
Date: Mon, 16 May 2016 20:25:33 -0700
Message-Id: <1463455534-22512-1-git-send-email-adrian@freebsd.org> (sfid-20160517_052543_183473_A0541190)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a small issue with selecting fallback rates for
RTS frames.  For OFDM PHY rates in 5GHz mode we shouldn't
fall back to CCK.

Adrian Chadd (1):
  [b43] don't unconditionally fall back to CCK if the rate is 6MB OFDM.

 drivers/net/wireless/broadcom/b43/xmit.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

-- 
2.6.3

