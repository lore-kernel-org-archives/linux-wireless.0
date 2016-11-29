Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56986 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753347AbcK2X7E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2016 18:59:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, briselec@gmail.com
Subject: [PATCH 0/1] rtl8xxxu: Workaround for 8192eu/8723bu not reconnecting
Date: Tue, 29 Nov 2016 18:59:01 -0500
Message-Id: <20161129235902.11882-1-Jes.Sorensen@redhat.com> (sfid-20161130_005907_694644_5ABB1BEE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Hi,

This patch works around the issue with 8192eu and 8723bu devices not
being able to reconnect. It is still not clear why this fails, and
looking at rtlwifi it does issue the command for 8192ee and 8723be
devices.

Until we have a better idea of what is going on, I have commented out
the offending code. I prefer not deleting it until we have a better
understanding of why this is causing issues.

Credits to Barry Day for tracking down and isolating the issue.

Kalle, not sure if this can make it to 4.9, but if it's possible it
would be ideal since this is causing real issues in the field.

Cheers,
Jes


Jes Sorensen (1):
  rtl8xxxu: Work around issue with 8192eu and 8723bu devices not
    reconnecting

 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 8 ++++++++
 1 file changed, 8 insertions(+)

-- 
2.7.4
