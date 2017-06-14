Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53898 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751606AbdFNWMr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 18:12:47 -0400
Received: from [192.168.100.149] (firewall.candelatech.com [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail2.candelatech.com (Postfix) with ESMTPSA id B695240A339
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 15:12:46 -0700 (PDT)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Question on flushing and deauth frames
Message-ID: <10e690bb-b201-13e2-8c4d-1708bab37106@candelatech.com> (sfid-20170615_001250_737255_E5AE8CA2)
Date: Wed, 14 Jun 2017 15:12:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k is a bit weird about flushing frames, and at least my variant of the wave-2
firmware does not always put the deauth frame on the air when deleting stations.

It will likely not be much fun to fix this.  I was wondering if the code below
from ieee80211_set_disassoc() could (easily?) be made to wait for a tx-status of the deauth frame
instead of trying to force a flush?

        /*
          * drop any frame before deauth/disassoc, this can be data or
          * management frame. Since we are disconnecting, we should not
          * insist sending these frames which can take time and delay
          * the disconnection and possible the roaming.
          */
         if (tx)
                 ieee80211_flush_queues(local, sdata, true);

         /* deauthenticate/disassociate now */
         if (tx || frame_buf)
                 ieee80211_send_deauth_disassoc(sdata, ifmgd->bssid, stype,
                                                reason, tx, frame_buf);

         /* flush out frame - make sure the deauth was actually sent */
         if (tx)
                 ieee80211_flush_queues(local, sdata, false);

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
