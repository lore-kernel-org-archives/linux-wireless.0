Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58624 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751576AbdF0RV7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Jun 2017 13:21:59 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/8] qtnfmac: cleanup and fixes preparing AP_VLAN support
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
        <20170620195517.18373-3-sergey.matyukevich.os@quantenna.com>
Date: Tue, 27 Jun 2017 20:21:55 +0300
In-Reply-To: <20170620195517.18373-3-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 20 Jun 2017 22:55:11 +0300")
Message-ID: <87shil4a8c.fsf@purkki.adurom.net> (sfid-20170627_192203_095442_74023643)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> This patch implements various cleanups and fixes aimed to
> simplify adding AP_VLAN support to qtnfmac driver:
>
> - Remove unused flag field from qlink_intf_info
> - Add interface type to qlink_cmd_change_sta
> - Modify qtnf_cmd_send_change_sta: add interface type to command
> - Fix handling of iftype mask reported by firmware:
>   Firmware sends supported interface type rather than mask. As a result,
>   types field of ieee80211_iface_limit structure may end up having
>   multiple iftype bits set. This leads to WARN_ON from
>   wiphy_verify_combinations.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>

Again multiple changes in one patch.

-- 
Kalle Valo
