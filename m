Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36154 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbbCSIIB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 04:08:01 -0400
Received: by wgra20 with SMTP id a20so55316231wgr.3
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2015 01:08:00 -0700 (PDT)
MIME-Version: 1.0
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 19 Mar 2015 13:37:39 +0530
Message-ID: <CABPxzYKPhgW6-ugi8kaO8sDvTKm-ScAOOXWavuTNo4w4+WS+6g@mail.gmail.com> (sfid-20150319_090810_076347_A512FDD0)
Subject: cfg80211: Beacon hints for DFS channels
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <mcgrof@do-not-panic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In the Regulatory and DFS wiki it is mentioned that
beacon hints are not processed for DFS channels.
But i could not find the related piece of code which
does this.

So in DFS channels can we process beacon hints?
Assuming that if AP is beaconing then there is no
RADAR in that channel. But how do we handle
channel switch (if we dont disconnect) then that
channel is enabled for active scan?
      (or)
should be we have something like this:

---

 net/wireless/reg.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 8c6cf52..25b3173 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1384,7 +1384,8 @@ static void handle_reg_beacon(struct wiphy
*wiphy, unsigned int chan_idx,
        chan_before.center_freq = chan->center_freq;
        chan_before.flags = chan->flags;

-       if (chan->flags & IEEE80211_CHAN_NO_IR) {
+       if (!(chan->flags & IEEE80211_CHAN_RADAR) &&
+             (chan->flags & IEEE80211_CHAN_NO_IR)) {
                chan->flags &= ~IEEE80211_CHAN_NO_IR;
                channel_changed = true;
        }


-- 
Thanks,
Regards,
Chaitanya T K.
