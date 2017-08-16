Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-sn1nam02on0083.outbound.protection.outlook.com ([104.47.36.83]:7674
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751461AbdHPPsP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Aug 2017 11:48:15 -0400
Date: Wed, 16 Aug 2017 18:48:00 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 2/9] qtnfmac: switch to napi_gro_receive
Message-ID: <20170816154759.e47rzhrxeiwfhg6y@bars> (sfid-20170816_174819_972748_43225407)
References: <20170815130638.31718-1-sergey.matyukevich.os@quantenna.com>
 <20170815130638.31718-3-sergey.matyukevich.os@quantenna.com>
 <871sobtuyc.fsf@purkki.adurom.net>
 <87tw17sg6s.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87tw17sg6s.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> Use napi_gro_receive() rather than netif_receive_skb() in qtnfmac driver.
> >
> > Yes, I can easily see that from the diff so no need to document that :)
> > But the commit log should tell _why_ you did it.
> 
> And no need to resend because of this, I can improve the commit log
> during commit. Just let me know what I should add.

Sure. The motivation is to improve performance when GRO is enabled, e.g. by
reducing the number of TCP ACKs. Updated message would be:

Use napi_gro_receive() rather than netif_receive_skb() to improve
performance when GRO is enabled.

Regards,
Sergey
