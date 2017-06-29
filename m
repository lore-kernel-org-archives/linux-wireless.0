Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0078.outbound.protection.outlook.com ([104.47.40.78]:53024
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751804AbdF2QqV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 12:46:21 -0400
Date: Thu, 29 Jun 2017 19:46:09 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 2/8] qtnfmac: cleanup and fixes preparing AP_VLAN support
Message-ID: <20170629164607.lxe3hucgzftsvbte@bars> (sfid-20170629_184627_250209_2EC1E171)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
 <20170620195517.18373-3-sergey.matyukevich.os@quantenna.com>
 <87shil4a8c.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87shil4a8c.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 27, 2017 at 08:21:55PM +0300, Kalle Valo wrote:
> 
> External Email
> 
> 
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> > This patch implements various cleanups and fixes aimed to
> > simplify adding AP_VLAN support to qtnfmac driver:
> >
> > - Remove unused flag field from qlink_intf_info
> > - Add interface type to qlink_cmd_change_sta
> > - Modify qtnf_cmd_send_change_sta: add interface type to command
> > - Fix handling of iftype mask reported by firmware:
> >   Firmware sends supported interface type rather than mask. As a result,
> >   types field of ieee80211_iface_limit structure may end up having
> >   multiple iftype bits set. This leads to WARN_ON from
> >   wiphy_verify_combinations.
> >
> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> Again multiple changes in one patch.

Ok, I will split this patch into more reasonable chunks in v2.
