Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:32853 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033028AbdD0Nxz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Apr 2017 09:53:55 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id 7D6804B63E2
        for <linux-wireless@vger.kernel.org>; Thu, 27 Apr 2017 15:47:12 +0200 (CEST)
Message-ID: <1493300827.2281.13.camel@hadess.net> (sfid-20170427_155404_223564_BD66C8A7)
Subject: Re: [PATCH] staging: rtl8723bs: Revert ignoring_unreachable_code
 kfree
From: Bastien Nocera <hadess@hadess.net>
To: Ian W MORRISON <ianwmorrison@gmail.com>,
        linux-wireless@vger.kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, jes.sorensen@gmail.com,
        Hans de Goede <hdegoede@redhat.com>,
        gregkh@linuxfoundation.org
Date: Thu, 27 Apr 2017 15:47:07 +0200
In-Reply-To: <CAFXWsS9rNZ1QWt_CNK-gOfb1Mqwch25XxB43d6B_8SX76vBW4Q@mail.gmail.com>
References: <CAFXWsS9fNn=YF--408O=weoNHfAv+g+CXJ8Df8=BC4m4Lt1aSg@mail.gmail.com>
         <CAFXWsS9rNZ1QWt_CNK-gOfb1Mqwch25XxB43d6B_8SX76vBW4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-04-27 at 23:44 +1000, Ian W MORRISON wrote:
> I tried building the RTL8723BS SDIO wifi driver which has just been
> incorporated in staging for linux-next as an external module and
> found that it fails with 'Segmentation Fault'. I've tracked this down
> to commit 6557ddfec348c13d7798ea9e44f11b6459f2f652 (staging:
> rtl8723bs: Fix various errors in os_dep/ioctl_cfg80211.c) which
> includes the fix
> 'drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:3547
> rtw_wdev_alloc() info: ignoring unreachable code'. The moving of line
> 'kfree((u8 *)wdev);' causes the segmentation error so I've included
> the following patch to revert it.

What error? Both versions look equally incorrect, eg. either it's
leaking data in which case the kfree() is necessary and should be in a
callable location, or it's not, and the call should be removed.
