Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_DIGITS,
	FROM_LOCAL_HEX,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63206C63697
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Nov 2020 02:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19CB024655
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Nov 2020 02:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgKSCHM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Nov 2020 21:07:12 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:45951 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727307AbgKSCHK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Nov 2020 21:07:10 -0500
Received: by mail-io1-f69.google.com with SMTP id o17so3148919ioo.12
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2020 18:07:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=C3VJue3RGqKKiz/dey+cwbB/cJZLcFnQvx6oQYKE/kA=;
        b=an5asg5ouoqnZ4V2rRM/aMjLFXPde0B2RKTSBR6L1GkSTeEXWJVM+VEwGDIdWAeb99
         Ug8pzhAA4JnosJadLKf8qr+U/odhbodsUeDjD+cRfGswN/bVml+uupzVlyTNBLndI/+5
         aXWGnKHjFLH36aJ6E4CnMifowA3fbQALN/pxFW40pDzbtSnyK/YHjVMcELRU1Dfbcyrv
         nJ+Czk+nXI6FBIMPjUBnPcqNbsQXUFAZJr0Iqqp4Sm7u3R9lreS23VqOdhWmv0+eqrhi
         EtTiDXY928/caA5Q5f2AzcTrUGxLlfDB/cTVII5wm0LVu5D4F0D8sjlAYFqm91p9NU/m
         ZF6A==
X-Gm-Message-State: AOAM533pWAIT9TDqnsVCd7pUkw8VtdROXOsHjLDsvkNPH1nSzMQHtcBD
        LGVJ09cHDjOitgFyXBGsg5l+JBYEODJ463jw5AvRKn07uafr
X-Google-Smtp-Source: ABdhPJwGnfqYhdSrWrWlFmOilVg/nbpNsCCtVfqEKKfBbwvtt+AtVgNH1kqI3lh4iC2puEfZ8izsr5iBAXYRKFBDRtB9wzApLcos
MIME-Version: 1.0
X-Received: by 2002:a92:6e0a:: with SMTP id j10mr3269284ilc.272.1605751627741;
 Wed, 18 Nov 2020 18:07:07 -0800 (PST)
Date:   Wed, 18 Nov 2020 18:07:07 -0800
In-Reply-To: <00000000000055348705b43c701d@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005e834e05b46c2f37@google.com>
Subject: Re: KASAN: use-after-free Read in ath9k_hif_usb_rx_cb (2)
From:   syzbot <syzbot+03110230a11411024147@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, ath9k-devel@qca.qualcomm.com,
        davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

syzbot has bisected this issue to:

commit dcd479e10a0510522a5d88b29b8f79ea3467d501
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 9 12:17:11 2020 +0000

    mac80211: always wind down STA state

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100c9c16500000
start commit:   0fa8ee0d Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=120c9c16500000
console output: https://syzkaller.appspot.com/x/log.txt?x=140c9c16500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75292221eb79ace2
dashboard link: https://syzkaller.appspot.com/bug?extid=03110230a11411024147
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1587f841500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11ec0fe6500000

Reported-by: syzbot+03110230a11411024147@syzkaller.appspotmail.com
Fixes: dcd479e10a05 ("mac80211: always wind down STA state")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
