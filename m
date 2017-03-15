Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53686 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753162AbdCOP0O (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Mar 2017 11:26:14 -0400
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k <ath10k@lists.infradead.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Should ath10k enable RX_FLAG_ALLOW_SAME_PN
Message-ID: <a22597d0-f0b0-9536-5753-c1bed7a5f20d@candelatech.com> (sfid-20170315_162655_105913_E81CBF17)
Date: Wed, 15 Mar 2017 08:26:12 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We notice a strange problem when receiving ath10k frames in
raw mode (with modified firmware).

The very first data message (UDP discovery response) is dropped
in WPA2 + AES mode, and it appears that if we would set the
RX_FLAG_ALLOW_SAME_PN it would be accepted.  ath9k in software-crypt
mode does not have this issue as far as we can tell.

So, maybe ath10k should set this flag??

Here is commit ID from the logic that introduced this flag, in case
that helps jog some memory.

commit f631a77ba920f7153a1094d09cd8f2ebbffd0328
Author: Sara Sharon <sara.sharon@intel.com>
Date:   Tue May 3 15:59:44 2016 +0300

     mac80211: allow same PN for AMSDU sub-frames

     Some hardware (iwlwifi an example) de-aggregate AMSDUs and copy the IV
     as is to the generated MPDUs, so the same PN appears in multiple
     packets without being a replay attack.  Allow driver to explicitly
     indicate that a frame is allowed to have the same PN as the previous
     frame.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
