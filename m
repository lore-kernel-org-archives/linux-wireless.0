Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA6EBC4332F
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Nov 2023 08:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbjKGIZQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 Nov 2023 03:25:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233590AbjKGIZN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Nov 2023 03:25:13 -0500
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F07DA
        for <linux-wireless@vger.kernel.org>; Tue,  7 Nov 2023 00:25:06 -0800 (PST)
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-1e9b0514cb2so6784992fac.2
        for <linux-wireless@vger.kernel.org>; Tue, 07 Nov 2023 00:25:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699345506; x=1699950306;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/VeWHnX3FKLObEtyX6GlSBLB+HcaO16fQrZJABNKmrA=;
        b=hbf8suVAhNjTcl/1LOA7E2ZmAjMwahZNXNtnEoMrwi7bDHLqbOoLY9dvCjMe/n5LH4
         HED+eegagSdOkrCb+vPzP6S1wu0EbxGTApfaDC7iNfTj3XVpOF68UayaaYmD3vCveA3n
         SY9rMKD9DdvqSEhht9TRZoHqbTVIRPamvLe6fAIs0SX4GhD2CnkKinUE8BD4QktpbLXq
         mCcI/8h/r994tyeVx/Gcf/H1brM/KS7fQdUGJPtQwcbUa5B/RoRxLGGuCP8QR5tFyMud
         PxwP9dQkyxKvX8l+iHgqO5sF/IWRXu8GQm5tAqUQ5hE9JhNO6ZFV6FPPhVIuV2Vzdui0
         Pdzg==
X-Gm-Message-State: AOJu0YxH8QyldVCkarRLfxBrkYBZgo5FiSQucu2+Njuh+RDli9rlMxsp
        9Hyrs5X8swP+Tue7IwUy/Nr4B4HgrAztGjQun9LgXRqouFV8
X-Google-Smtp-Source: AGHT+IGJEd5Nq1Mz1pOFbxEaR60SDM8zts1GWxm0RyeCCsYGeWxT13dinNOJtnz8GWzdFwASj7cOe1upjxWEL6VJP2SWJnCZs7e9
MIME-Version: 1.0
X-Received: by 2002:a05:6870:241a:b0:1dd:7381:e05 with SMTP id
 n26-20020a056870241a00b001dd73810e05mr950466oap.3.1699345506174; Tue, 07 Nov
 2023 00:25:06 -0800 (PST)
Date:   Tue, 07 Nov 2023 00:25:06 -0800
In-Reply-To: <000000000000bcd80b06046a98ac@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003f0e4406098bb529@google.com>
Subject: Re: [syzbot] [wireless?] WARNING in ieee80211_link_release_channel
From:   syzbot <syzbot+9817a610349542589c42@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jiri@nvidia.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

syzbot has bisected this issue to:

commit c2368b19807affd7621f7c4638cd2e17fec13021
Author: Jiri Pirko <jiri@nvidia.com>
Date:   Fri Jul 29 07:10:35 2022 +0000

    net: devlink: introduce "unregistering" mark and use it during devlinks iteration

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1734cd60e80000
start commit:   d68b4b6f307d Merge tag 'mm-nonmm-stable-2023-08-28-22-48' ..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14b4cd60e80000
console output: https://syzkaller.appspot.com/x/log.txt?x=10b4cd60e80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c45ae22e154d76fa
dashboard link: https://syzkaller.appspot.com/bug?extid=9817a610349542589c42
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=128eab18680000

Reported-by: syzbot+9817a610349542589c42@syzkaller.appspotmail.com
Fixes: c2368b19807a ("net: devlink: introduce "unregistering" mark and use it during devlinks iteration")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
