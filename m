Return-Path: <SRS0=od2B=OZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52A11C43387
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 12:16:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2372A2086C
	for <linux-wireless@archiver.kernel.org>; Sun, 16 Dec 2018 12:16:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RQRrp+V4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbeLPMQl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 16 Dec 2018 07:16:41 -0500
Received: from mail-lf1-f53.google.com ([209.85.167.53]:37454 "EHLO
        mail-lf1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730021AbeLPMQk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Dec 2018 07:16:40 -0500
Received: by mail-lf1-f53.google.com with SMTP id y11so7453238lfj.4
        for <linux-wireless@vger.kernel.org>; Sun, 16 Dec 2018 04:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=BHWpN6cryhSeuprntml5bijEFy8n+Qpo72yCcX2jYkQ=;
        b=RQRrp+V4u+xrUd6DFzZjh98LCrBwB/USckWRNQryBtUCYhb2i/A/GsD0+NHFXn+/rO
         kj+8Tsm+Gfw5ZhA7j6C6X6i9Mp1XW8x2wj5LrNU89RSTrVz0AIWTvEr1ws5VCk8Q95ZR
         sd3NTk5yeyGvNSQ0SCEmtSokO7Kzdssp68RDTdLTbMeqXgoZFDy8kN7RFPBTcOoxrXj4
         GAbTdRzv/K1gd6o4lK/BSEKll8AFLcOAZmgXxbGButADTYK7tBR3GIvyylhePJOULYuL
         Xs86DXp/jvzXOcGQvew8uefrAxj1oIlUDakK9nhTwhGMMIiFrJPFS710EVBwS0s+UHAg
         DUNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=BHWpN6cryhSeuprntml5bijEFy8n+Qpo72yCcX2jYkQ=;
        b=UcPimnWiikqIkDpRwts1ysCR1RqNCbIA5HDe4hEex8XpGXn4Zzq6h34dhgnfVr71WC
         tPEcMcQNEPRjHfhivtiH2DevqWrhSCvZxdx05htXVoKHvqUBolzTyynjJYiDzc3hpYoO
         Z89fM90NBTwl/B46hBQE3nzKvHgfCAxOOD1BZzwLCE2GEySfq4hjNGoHvMkmKph+H49n
         UEqOU6g2x0OIzs9sAZ2hpAcA6Cyo5tid1L/Jaxlw8rCNCEjdzwVpMQL4fsCLYJ3//dmm
         D+tQDuXEL3C53un5tNsTkANgVGLGCfVyrHxc29DTRcPdymel9msg+2W12AWh6mllJsBR
         d/0g==
X-Gm-Message-State: AA+aEWblnnlf7/3rDj/Oq0fDv5al8c8fYfxNLZggaWql7Of5Z2bL7HMh
        jyFUtw8OmQ3N7DeUX7/m6rdLvRa+EFnYAQ2mh8ELA9oknFU=
X-Google-Smtp-Source: AFSGD/W5pNp6/DRXROIaAlb8UAObs3hKy6QhIbMxhJhWSz3sg+Lds2KQmUeGtHrA6Ar+dDgdBaUZHd3Y8i9eWrulaPQ=
X-Received: by 2002:a19:d8d8:: with SMTP id r85mr5258888lfi.92.1544962598530;
 Sun, 16 Dec 2018 04:16:38 -0800 (PST)
MIME-Version: 1.0
From:   Marcin Sielski <marcin.sielski@gmail.com>
Date:   Sun, 16 Dec 2018 13:16:27 +0100
Message-ID: <CANWiEciGLPxDc5JT0+gVrzEyEC6GOcUJUf8XR4PrYHj4TysHpA@mail.gmail.com>
Subject: wireless-regdb for automotive
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Do you possibly have ideas how to adjust wireless-regdb package
to support also automotive use cases as described in:
https://www.efis.dk/documents/44659

Best Regards

Marcin Sielski
