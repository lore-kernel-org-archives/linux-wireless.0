Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0077.outbound.protection.outlook.com ([104.47.40.77]:43840
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751400AbdGAIqH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Jul 2017 04:46:07 -0400
Date: Sat, 1 Jul 2017 11:45:52 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 3/8] qtnfmac: implement AP_VLAN iftype support
Message-ID: <20170701084549.rqvia27dyxuco4gs@bars> (sfid-20170701_104614_998284_147B2CCC)
References: <20170620195517.18373-1-sergey.matyukevich.os@quantenna.com>
 <20170620195517.18373-4-sergey.matyukevich.os@quantenna.com>
 <878tkd49m1.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <878tkd49m1.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
> 
> > This patch implements AP_VLAN interface type support enabling
> > the use of dynamic VLAN mode in hostapd.
> >
> > Implementation notes.

[...]

> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 
> This looks somewhat controversial to me but I'm not very familiar with
> VLANs. Do other wireless drivers do something similar or how is this
> usually implemented? Or not at all?
> 
> --
> Kalle Valo

Well, IIUC this feature is not supported by other full-mac drivers at the
moment, so no good example to follow. I don't think it is too controversial.
Probably the restrictions on hostapd AP_VLAN interface names can be
frowned upon. But at the moment this information is not passed by hostapd
to kernel. It needs some additional work both in hostapd and cfg80211
to get this info directly in the driver.

Anyways, other patches in this series are more straighforward. So I will split
submission in v2: AP_VLAN support will be posted separately as RFC in order to
some feedback regarding the overall approach.

Regards,
Sergey
