Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx07-00252a01.pphosted.com ([62.209.51.214]:54531 "EHLO
        mx07-00252a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1759576AbdEXNDc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 May 2017 09:03:32 -0400
Received: from pps.filterd (m0102628.ppops.net [127.0.0.1])
        by mx07-00252a01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4OCshVr022920
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 14:03:31 +0100
Received: from mail-wm0-f72.google.com (mail-wm0-f72.google.com [74.125.82.72])
        by mx07-00252a01.pphosted.com with ESMTP id 2ajb6ya1n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK)
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 14:03:30 +0100
Received: by mail-wm0-f72.google.com with SMTP id 204so37839560wmy.1
        for <linux-wireless@vger.kernel.org>; Wed, 24 May 2017 06:03:30 -0700 (PDT)
MIME-Version: 1.0
From: James Hughes <james.hughes@raspberrypi.org>
Date: Wed, 24 May 2017 14:03:29 +0100
Message-ID: <CAE_XsM+GFPvar3o0Z_NYdNDRgOH_CKw1Y=NE_bxLPTN6tPH8CA@mail.gmail.com> (sfid-20170524_150652_999018_B13DC660)
Subject: brcmfmac: brcm43430 Invalid mailbox value issue
To: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Plain text resend)

We are seeing an issue on Raspberry Pi which uses the bcm43430 chip.
It's been tested up to 4.9 which still shows the issue (it's been
there for some time, > 1yr). I'm trying to find someone who can test
on 4.11 as I cannot replicate  (The latest kernel we have that works
on a Pi)

It exhibits as a log entry, and subsequent death of wireless connectivity.

"Unknown mailbox data content: 0x40012"

Look at the driver code, it appears to be checking the return
value from a mailbox (presumably the one to the chip firmware), which
has the 0x4 in the top word which shouldn't be there.

The driver simply adds a log entry, but otherwise ignores the situation.
However, we see wireless failure from this point.

Since I believe this value is being returned from the chip, I cannot
investigate much further. The public datasheet is of no help. We do appear
to be using the latest firmware file.

I'm not sure how to proceed on this one. It would be interesting to
know under what circumstances that value can be returned from the
mailbox.

More details can be found at the end of this github issue.

https://github.com/raspberrypi/linux/issues/1342


James Hughes
Raspberry Pi
