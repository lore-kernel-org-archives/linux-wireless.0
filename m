Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33320 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751543AbdISL4d (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 07:56:33 -0400
Received: by mail-io0-f195.google.com with SMTP id j26so4562635iod.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 04:56:32 -0700 (PDT)
MIME-Version: 1.0
From: Ramon Fontes <ramonreisfontes@gmail.com>
Date: Tue, 19 Sep 2017 08:56:12 -0300
Message-ID: <CAK8U23b-i_tYMzVpLiaRrA2PSTGU9Zm=4rQoYRU=WafPkU7ytA@mail.gmail.com> (sfid-20170919_135636_608678_AB2EFAD1)
Subject: [PATCH] mac80211_hwsim: enabling WDS
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm developing an wireless emulator
(https://github.com/intrig-unicamp/mininet-wifi) which relies on
mac80211_hwsim for loading virtual wireless interfaces. In order to
get access points wirelessly connected I was think to enable WDS (in
addition to the well known mesh mode).

Then, I went through mac80211_hwsim and I noticed that I could make it
work with BIT(NL80211_IFTYPE_WDS) in mac80211_hwsim. That said, I
thought to submit this patch.

ps. I'm not an expert in Linux Kernel and I don't know if something
else have to be done. It just worked applying this patch.

---
 drivers/net/wireless/mac80211_hwsim.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c
b/drivers/net/wireless/mac80211_hwsim.c
index 6467ffac9811e..1f8229e545190 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -453,6 +453,7 @@ static const struct ieee80211_iface_limit
hwsim_if_limits[] = {
                                 BIT(NL80211_IFTYPE_MESH_POINT) |
 #endif
                                 BIT(NL80211_IFTYPE_AP) |
+                                BIT(NL80211_IFTYPE_WDS) |
                                 BIT(NL80211_IFTYPE_P2P_GO) },
        /* must be last, see hwsim_if_comb */
        { .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) }
@@ -2562,6 +2563,7 @@ static int mac80211_hwsim_new_radio(struct
genl_info *info,
        hw->offchannel_tx_hw_queue = 4;
        hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
                                     BIT(NL80211_IFTYPE_AP) |
+                                    BIT(NL80211_IFTYPE_WDS) |
                                     BIT(NL80211_IFTYPE_P2P_CLIENT) |
                                     BIT(NL80211_IFTYPE_P2P_GO) |
                                     BIT(NL80211_IFTYPE_ADHOC) |
