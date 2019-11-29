Return-Path: <SRS0=lMj3=ZV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99098C43215
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 11:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CECE217F5
	for <linux-wireless@archiver.kernel.org>; Fri, 29 Nov 2019 11:27:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726811AbfK2L1B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Nov 2019 06:27:01 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:53500 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbfK2L1B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Nov 2019 06:27:01 -0500
Received: by mail-io1-f69.google.com with SMTP id w19so20156608iod.20
        for <linux-wireless@vger.kernel.org>; Fri, 29 Nov 2019 03:27:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=1R/eyR91b2qzrd9oYXwpA7kVnLlS3eW/CPo2xuZ2tZs=;
        b=psT84Lm6CLIlRwdCQ1qvCwvf26j1cPapvRyn6Y9Niy5Y3MYDBgr0QemD99VWCRGoBs
         3tD80xPCnEj3PRRJJ5V5AF+jczw/Iop2yYmu0Y2ZBXsQZ+pOCDCkqifGCDAqGDFTEOnf
         9jVy4T/vDUCEkIpMLTgxfHGDys8VYbLBjet7ltJU9jxUlAxyTasV3amjLHMpMD1pq5/C
         fSGqI/JTLQ0QLbfo77cN7B+MdD2jmWH0aXYFLWcJnHh1idfoKfCxBpOX+9lEczew+SIu
         bCtb5NjWMuWOUYA0qPwqujflrstT92TfcqxjbS5mA/sAB66xWJ/C8UppywlSvX63XbbM
         DKkw==
X-Gm-Message-State: APjAAAVxiEc8qTnunRYybAlqJV7eTUQVJKNxYnNfKv16SoQQW9Mm9AIP
        jVkQjXuwrN8uej/qXVgCIiFIR86kHTBMH9Vff4OPOevZA54G
X-Google-Smtp-Source: APXvYqx2WOuve6jGICcXm51Pk+hIsPcOb1OO3yj2Zia1Hs0+ZR99DkvW/INJgLvPm6G6NaW5WS+Y11Kyq0HaFv6HhYvElj2iUAAo
MIME-Version: 1.0
X-Received: by 2002:a92:c525:: with SMTP id m5mr52192194ili.91.1575026820788;
 Fri, 29 Nov 2019 03:27:00 -0800 (PST)
Date:   Fri, 29 Nov 2019 03:27:00 -0800
In-Reply-To: <20191129104156.GH29518@localhost>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002a380f05987a8239@google.com>
Subject: Re: WARNING: ODEBUG bug in rsi_probe
From:   syzbot <syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com>
To:     amitkarwar@gmail.com, andreyknvl@google.com, davem@davemloft.net,
        johan@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        siva8118@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger  
crash:

Reported-and-tested-by:  
syzbot+1d1597a5aa3679c65b9f@syzkaller.appspotmail.com

Tested on:

commit:         d34f9519 usb-fuzzer: main usb gadget fuzzer driver
git tree:       https://github.com/google/kasan.git
kernel config:  https://syzkaller.appspot.com/x/.config?x=c73d1bb5aeaeae20
dashboard link: https://syzkaller.appspot.com/bug?extid=1d1597a5aa3679c65b9f
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
patch:          https://syzkaller.appspot.com/x/patch.diff?x=122808a6e00000

Note: testing is done by a robot and is best-effort only.
