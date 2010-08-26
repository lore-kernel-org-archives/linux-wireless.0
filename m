Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33900 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab0HZXfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 19:35:22 -0400
Received: by iwn5 with SMTP id 5so1993050iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 Aug 2010 16:35:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimbKnZ4WBgkXa9fm2Tj1=hfCOC8Zm=Skg+CfUgJ@mail.gmail.com>
References: <20100826204722.GA1745@tux> <AANLkTimbKnZ4WBgkXa9fm2Tj1=hfCOC8Zm=Skg+CfUgJ@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 26 Aug 2010 16:35:02 -0700
Message-ID: <AANLkTi=WjipNDTHbP-L5LCi8jsyJ0-vxCFnpBJracdJK@mail.gmail.com>
Subject: Re: issues with scanning in mac80211
To: Amod Bodas <Amod.Bodas@atheros.com>
Cc: Jouni Malinen <Jouni.Malinen@atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Helmut Schaa <Helmut.Schaa@gmx.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	ext Kalle Valo <kvalo@adurom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 26, 2010 at 4:11 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> As suggested by Jouni, I'll test using min(listen_interval,
> DTIM_PERIOD), this should only help with broadcast / multicast data
> upon a scan. If there are any other thresholds required by userspace
> this should likely be configured on the bg scan module I think.

Ah bleh, we cannot rely on the dtim as it is not exposed to drivers
unless otherwise requested. This can be done by using the new
IEEE80211_HW_NEED_DTIM_PERIOD but this is completely unused by drivers
today.

mcgrof@tux ~/wireless-testing (git::master)$ git grep
IEEE80211_HW_NEED_DTIM_PERIOD drivers/net/wireless/
mcgrof@tux ~/wireless-testing (git::master)$


commit e5b900d228b76d445a4240d9aeb3cd8f79205a91
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jul 29 16:08:55 2010 +0200

    mac80211: allow drivers to request DTIM period

    Some features require knowing the DTIM period
    before associating. This implements the ability
    to wait for a beacon in mac80211 before assoc
    to provide this value. It is optional since
    most likely not all drivers will need this.

    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

.... < amongst other hunks > ...

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cf8d721..b6c163a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -870,6 +870,11 @@ static void ieee80211_set_associated(struct
ieee80211_sub_if_data *sdata,

        ieee80211_led_assoc(local, 1);

+       if (local->hw.flags & IEEE80211_HW_NEED_DTIM_PERIOD)
+               bss_conf->dtim_period = bss->dtim_period;
+       else
+               bss_conf->dtim_period = 0;
+
        bss_conf->assoc = 1;
        /*
         * For now just always ask the driver to update the basic rateset
