Return-Path: <SRS0=a98u=MM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C556C004D2
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 19:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FC2220833
	for <linux-wireless@archiver.kernel.org>; Sun, 30 Sep 2018 19:12:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FC2220833
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728510AbeJABqS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 30 Sep 2018 21:46:18 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:38589 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbeJABqS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 30 Sep 2018 21:46:18 -0400
Received: by mail-it1-f196.google.com with SMTP id i76-v6so3058256ita.3
        for <linux-wireless@vger.kernel.org>; Sun, 30 Sep 2018 12:12:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZLPX7jIgqpIsyVazBvNI3w1r7qGA7+un4zgJcKrb+iU=;
        b=SQ+aSTEV4+B3kNSqG0cbnpOgj+cYHnOetFldLLkZa5tsx9RE/rKco0CbuhdKBrOvIF
         xZB594L7j9nDH5IAKxt3DZ3X5dG3YFZmDWe3D5qtiORiKQ21oCvyiUnd9uW6NBW8/qlK
         lUt2bke6F/wlsmIQDOh0Xm6hlnhY0pbuML1lIMP2mP8HGLMqZLSknu2h/95mYQM1Tw3h
         bHjCHoGhBs+qUd2VncTy7BSbzgmSD7UpT684a5aW3utW00sKHUsKcZzHO58zKJZ4cBQ6
         ieAkKJRxqwSoSeEJyhGInqe0Zh82Fm2Qd4N6iOA0PZE9B6SnMr4otvsVO4zSMIL1z8RJ
         Erug==
X-Gm-Message-State: ABuFfogB3ccZTiBazQu2Eu18WfsmAPk+APsq3mkI7DpPaPS/v/c1JzSR
        3hwW8MCwS6U8YVO/cnAyaX/2NULxuQ5+VkDkpf6FrSwh
X-Google-Smtp-Source: ACcGV62l44/XVUUzeihVWEMEaagH4+0xOiA7gerWcB/jbQavzw41ruixx3Tfe9fDuXZjt1IRkzoPK72auP+ZYH0/WbQ=
X-Received: by 2002:a24:8045:: with SMTP id g66-v6mr8164465itd.45.1538334724990;
 Sun, 30 Sep 2018 12:12:04 -0700 (PDT)
MIME-Version: 1.0
References: <1538037450-18949-1-git-send-email-sgruszka@redhat.com> <15a61b47-c506-391f-5d2a-2db73e0871e7@nbd.name>
In-Reply-To: <15a61b47-c506-391f-5d2a-2db73e0871e7@nbd.name>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sun, 30 Sep 2018 21:11:53 +0200
Message-ID: <CAJ0CqmUf05dLWSRL7sTxY5o0nB9TBEeU42bgLnF8Dp0c39epug@mail.gmail.com>
Subject: Re: [RFC 0/4] mt76x0: phy/rf fixups for PCIe
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On 2018-09-27 10:37, Stanislaw Gruszka wrote:
> > This is RFC for now, especially I'm interesting if patch 3 and 4
> > is direction we should go.
> >
> > This is on top of Lorenzo github mt7610ev5 branch.
> Looks good to me.
>
> Thanks,
>
> - Felix

Hi Stanislaw,

I tested this series and it works fine, so feel free to add my
'tested-by' when you submit the patchset.
I guess we should add a 'mt76_is_usb()' check in rf_rr()/rf_wr(),
agree? Something like:

@@ -111,7 +111,8 @@
 static int
 rf_wr(struct mt76x02_dev *dev, u32 offset, u8 val)
 {
-    if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
+    if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state) &&
+        mt76_is_usb(dev)) {
         struct mt76_reg_pair pair = {
             .reg = offset,
             .value = val,
@@ -129,7 +130,8 @@
     int ret;
     u32 val;

-    if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state)) {
+    if (test_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state) &&
+        mt76_is_usb(dev)) {
         struct mt76_reg_pair pair = {
             .reg = offset,
         };


Regards,
Lorenzo
