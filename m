Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:31588 "EHLO mail.neratec.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752660AbdATO3w (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 09:29:52 -0500
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Subject: [RFC 0/1] ath9k: Frame corruption simulator
Date: Fri, 20 Jan 2017 15:29:28 +0100
Message-Id: <1484922570-23659-1-git-send-email-Wojciech.Dubowik@neratec.com> (sfid-20170120_153006_449716_824B8432)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have been debugging customer reported timeout and loss of
communication and I have relaized that I don't have such a lossy
environment available in the lab. To speed up debugging I have
written frame corruption simulator which will allow me to
totally loose specific types of packets. I have been mostly
using it with the mask 0x5000 which drops some EAPOL
and deauthentication frames. This way I was able to test better
timeouts and fail paths.
At the moment only management, null function and EAPOL frames
are supported. One can add more if necessary.

Wojciech Dubowik (1):
  ath9k: Add frame corruption simulator

 drivers/net/wireless/ath/ath9k/Kconfig |  15 +++++
 drivers/net/wireless/ath/ath9k/ath9k.h |   7 +++
 drivers/net/wireless/ath/ath9k/debug.c |  49 +++++++++++++++
 drivers/net/wireless/ath/ath9k/xmit.c  | 106 +++++++++++++++++++++++++++++++++
 4 files changed, 177 insertions(+)

-- 
2.7.4
