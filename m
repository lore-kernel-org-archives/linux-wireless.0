Return-Path: <SRS0=3oid=2D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BDB3C34002
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BF4D246B1
	for <linux-wireless@archiver.kernel.org>; Fri, 13 Dec 2019 20:36:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="osaGSDGf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbfLMLQK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 13 Dec 2019 06:16:10 -0500
Received: from mail-oi1-f170.google.com ([209.85.167.170]:41598 "EHLO
        mail-oi1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbfLMLQJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Dec 2019 06:16:09 -0500
Received: by mail-oi1-f170.google.com with SMTP id i1so736131oie.8
        for <linux-wireless@vger.kernel.org>; Fri, 13 Dec 2019 03:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zGbUusGmcKHHNzvysS5kwUk1GddQwYh5NDnDa6dHUBo=;
        b=osaGSDGfM0tPh1+raplBcHZz68ZqlZDak4koYhwOpun5uU6HmYjK72z9jH6ohxX2XW
         XbIkMTBrqfxRoU1SujGQoQt1QTOeo07GTAtbm7ticIWs2lamS2y5c+dm5SdfEyWoAyIj
         a98QUr7UxaLpO9ud8XiPvYl1UiTUQSxE0t41vlK0Uk3/m1alAKuXq7SmQOFdBBhYdLAb
         UjCNL9QBEsGC1Hq4Q18A14FOwYJbI/qRc8u/zasKArIhYPpHp0HEQXptNFf0Kx+9GcWO
         CYJ8iTCgrjXb9atKK5cGcGJUUOCozr1IQdpMQ1poYX4iFpUxAfpbRcALoiGF7t2bxwNG
         jcNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zGbUusGmcKHHNzvysS5kwUk1GddQwYh5NDnDa6dHUBo=;
        b=WtT9CsRics4rltEvtl/7pEg5Zddn0Yn+87YcM6oYVzGrAUVZB8i76Xrh8Xyb381Br0
         a5gMNun3gW+8VKcPXnJKk3Rffe/2xjf3VU8SEIOc4te/yW83L/taMYNQiPbjNvJUEdBW
         NQ9jApAI8o4gjB/0qz6XitZC4bPMtJApgzV7VJH6Y/jyZ6+iOLAYgKyiAAjozfBPShl6
         mA0BzwUCBObcAg6dPrEBDwz5/6UtORNlgG8GUoZbKB+FM5C8v31twGZ7wZ6wI9j6Hm4R
         T2yKAZ93lrn4G30q5V96pMjWw6b0jALpcjDWNNwVzYnvv5F559DzQEsy5LlpHwtGwTCS
         gXnQ==
X-Gm-Message-State: APjAAAWbWXfJez2T1CSLo7Oa7XoYF5IB0o5iPQUZqBufCOWqSIvykN8+
        JA/lLuCEssJrdI+38zKDHnD689O81kCHg63wHxlLTR6ES4lOxw==
X-Google-Smtp-Source: APXvYqzSNKX83LpVNNklonOI5C4CGJHCHoZjTfea2UBGAbrKu/Hk9mhTudM5cNg50G6pJMZ1ueohPde5kuNRjEX3KBY=
X-Received: by 2002:aca:f305:: with SMTP id r5mr6906930oih.174.1576235769044;
 Fri, 13 Dec 2019 03:16:09 -0800 (PST)
MIME-Version: 1.0
From:   Justin Capella <justincapella@gmail.com>
Date:   Fri, 13 Dec 2019 03:15:57 -0800
Message-ID: <CAMrEMU9Mz+0RNmmGQHic_cWPf45LHeK3Mzcy6a=GuYkvgdN+RQ@mail.gmail.com>
Subject: qca988x fw crash/unrecoverable pcie errors causes error loop
To:     ath10k <ath10k@lists.infradead.org>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Paste: http://ix.io/24hJ

I think a station went out of range, and somehow that crashed the fw,
but when it tried to recover it was unable to read CE, and so fails to
recover, eventually an correctable PCI error occurred but *80211_ in
an attempt to reconfig is trying to stop all interfaces, which
includes stopping aggregation for the peers...
