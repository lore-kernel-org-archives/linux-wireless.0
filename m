Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A63EECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 16:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA7B20658
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 16:26:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hkzdUv3Z"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FA7B20658
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbeJTAdZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 20:33:25 -0400
Received: from mail-oi1-f181.google.com ([209.85.167.181]:41761 "EHLO
        mail-oi1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727038AbeJTAdZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 20:33:25 -0400
Received: by mail-oi1-f181.google.com with SMTP id l197-v6so27257101oib.8
        for <linux-wireless@vger.kernel.org>; Fri, 19 Oct 2018 09:26:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=C3ivOx1ppIHIbCjTMfA/pWAObIz5qtGmLbdQycidQ54=;
        b=hkzdUv3ZCBWgEmjrlw2Y7zNC+FCkUC3OYgUhwnRkTJutl+Dw79NYZmhsnSozRzpL0e
         nkDcX0RnYImw7HFtDc2AfJkzFO+1X7luaOMhrwgcmqTsexJPu31LgvTwjU/xwkJz9MGJ
         dbfdfjhj6nzr6uaAYXRr0bNehDlMBwFNyWczNr4VrsoPTUbKIKzQNFUx1krqU8Z9VjEq
         YuFCbjvO78Gax2TxLwdETpbBl+hRh3GwxpRrwayz/4W3Han3koljCiLkKbgRaLKIFfv2
         V3V9bP7wxHQBDnyEgt6J0XYyVGjOKmDJibnuxXvwh7bH8K2V7Xdc04ci6/BneLbvB0gV
         //7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=C3ivOx1ppIHIbCjTMfA/pWAObIz5qtGmLbdQycidQ54=;
        b=kKopKAfSnpdZiEyuiFWjG2OBFykc0CUPd2F5tlZPqhc5IAFdpGPvYMElirykqIyCA+
         HGTotLfNtih+e/9Y6MhIWNBwockhGczw3AIXI7Op2gX1K7lX+Pma6+iveaOG+ao1qu75
         /pWVkWG5Tb6kVnuf94SoKKt/D4L8TG3Lve7SjoNFnLsPERt50yk5ld+gRbWtCVEhPHJ9
         IX7eTkEXJkkfpN6wRBO3wtdoAFqZ2yRcd7ovBz6+EOoZTuKg3/gAo5iK8IH9+ZNuQ+iY
         eZZm2/mUip/NiGNYwO/gXpBtiluzuQVuTNzKK/cN+7GpE83JMpRUzi6bfkLSM61asE4Z
         ZiRA==
X-Gm-Message-State: ABuFfohXciRxsjnlK1kUkVJzRTwiGWUDhI/VCFrzmh7IoBRp7UcbPQUV
        QJS8ytT6cKMqpvMTDWWFooSyET0T86YIwdgMYG7mtA==
X-Google-Smtp-Source: ACcGV60yslsPGRt7lKyvzxC8vemzDip2VZig5dWVYsbcd0f0YMCKZVFuyjPPjgO4VGpFy0nUUBLlqPZD03uqgBy3m4c=
X-Received: by 2002:aca:14f:: with SMTP id 76-v6mr2001174oib.290.1539966396046;
 Fri, 19 Oct 2018 09:26:36 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 19 Oct 2018 09:26:35
 -0700 (PDT)
In-Reply-To: <20180929021321.1e1b6c3e@fem-net.de>
References: <20180929021321.1e1b6c3e@fem-net.de>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 19 Oct 2018 18:26:35 +0200
Message-ID: <CAKR_QV+CO57oHgRoAo2JfPkxu-Res4iaU633yC8NtdJOkVxqJw@mail.gmail.com>
Subject: Re: Handling user regdom hints while having intersected world regdom
To:     =?UTF-8?B?UGV0ZXIgR3Jvw59l?= <pegro@friiks.de>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

After this change, on interface reconfig regdomains for both int. and
usb radio are no longer 98. instead they are both set to US (int.
radio regdomain) while usb should be set to GB. I am not sure if there
is an easy way to handle this.
Bad thing is that regdomains still intersect for few seconds on usb
card insert and during that time int. radio resets it's txpower to
max->described in this bug issue:
https://bugs.openwrt.org/index.php?do=details&task_id=1745
