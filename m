Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:33523 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750981AbdCJItt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 03:49:49 -0500
Received: by mail-ua0-f177.google.com with SMTP id u30so108275606uau.0
        for <linux-wireless@vger.kernel.org>; Fri, 10 Mar 2017 00:49:48 -0800 (PST)
MIME-Version: 1.0
From: Rostyslav Khudolii <rkhudolii@airtame.com>
Date: Fri, 10 Mar 2017 09:49:47 +0100
Message-ID: <CAPXt_dabk8KNL0HTHZJfoHT+93ZS+3R31tVEPb4zpKJWE65cMw@mail.gmail.com> (sfid-20170310_094952_335386_C643D863)
Subject: [PATCH] ath6kl: Remove old 802.11a-only channels
To: kvalo@qca.qualcomm.com
Cc: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org,
        Attila Sukosd <attila@airtame.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channels 34/38/42/46 can only be used for compatibility with
old devices sold in Japan. Modern products, such as AR6003/AR6004
don't support these channels.
Keeping them in the upstream is error prone and requires full
network stack support.
A custom patch should be used in case such compatibility is required.

Signed-off-by: Rostyslav Khudolii <rkhudolii@airtame.com>
Cc: Attila Sukosd <attila@airtame.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c
b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 363b30a..aae65ce 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -102,10 +102,8 @@ static struct ieee80211_channel ath6kl_2ghz_channels[] = {
 };

 static struct ieee80211_channel ath6kl_5ghz_a_channels[] = {
-       CHAN5G(34, 0), CHAN5G(36, 0),
-       CHAN5G(38, 0), CHAN5G(40, 0),
-       CHAN5G(42, 0), CHAN5G(44, 0),
-       CHAN5G(46, 0), CHAN5G(48, 0),
+       CHAN5G(36, 0), CHAN5G(40, 0),
+       CHAN5G(44, 0), CHAN5G(48, 0),
        CHAN5G(52, 0), CHAN5G(56, 0),
        CHAN5G(60, 0), CHAN5G(64, 0),
        CHAN5G(100, 0), CHAN5G(104, 0),
