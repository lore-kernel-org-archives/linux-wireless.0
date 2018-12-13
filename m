Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59CA4C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A09A20851
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:26:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KNlWOamG"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1A09A20851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbeLMO0U (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:26:20 -0500
Received: from mail-it1-f181.google.com ([209.85.166.181]:36061 "EHLO
        mail-it1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbeLMO0T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:26:19 -0500
Received: by mail-it1-f181.google.com with SMTP id c9so4059890itj.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2018 06:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=VUa401z9zuK7cyvpYQQZWGwg0DbXeLRygi8SNSR+cls=;
        b=KNlWOamG9US/gpLJyxhg4+1mOGFQ99Im1i/csz79WmQyRJMa04Q7unGEMTanwRWv+S
         AM9yfX5ItQKNL8hvIeY/8Y+qyEw4fVgu2VXSoUf6PsETO+oZgQaZ7f8j9WtNjc0moLqW
         ZZokWWXj6r/NZCtNnxmJdWz1yGc7991Iu7SlC920l9AYEB0nat4levCtyuMFJpP86fu5
         yv5cLCAz8LaQNdYdg7yi77oc5E8hSzgyhdgqepmehUXve0wGIjH41QJjw75ZeyqCP4F9
         VhIMMmJkKVE/dkMXjRhoSGSxdir7RObkWE146VTVhMpSMiJg3Xu+fLNmZBIny4YWKImF
         lsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=VUa401z9zuK7cyvpYQQZWGwg0DbXeLRygi8SNSR+cls=;
        b=G8BSvdD30eyHV6BwcjB8d3c7s+NL7zuJFYVi4hKMPspSwRTkRTNoTWWYcVECLyT2ZK
         rLMKvTSUfsJDQwrAYIabbapqcwSaIR1Dq77381khK0GEkDVXyeZdZo1rlALimLE5vEzt
         BfSQvDaUskiIkUqhVDXhSPtk8pKd+FYC5MATebmJfhJoX8Y/6b0yQLCwybEemy0aq25H
         j8L8BWPBooxurs25CGHMpdw4jc7mEuyUEsytU+JvzzE3qR7iMLfHY6wU3FbjhPn5dK7z
         lfX3EVokin+P6L+pdmJybx6TGDQRZfAaWoqBGVkAiDfuHzmKms2YrnHjI8mts85NEjgJ
         Bgiw==
X-Gm-Message-State: AA+aEWbWsN3EAZRz16CkLFx0zlkgyfkKDJskhiPbTUzkZS2KDC1caCa6
        ZKBcv+K7560wFYPU+XqT0IuUbHzUK1dSm+MKsjY=
X-Google-Smtp-Source: AFSGD/WYU/y4QpHnbMJnoObJg5mDU+b9fk0Oq1R5kYgH8olVTqOVuzmC0ZuCMllPbJlVtutZzwRDwfgjtrKM75EJfXk=
X-Received: by 2002:a24:fa05:: with SMTP id v5mr11125490ith.43.1544711178799;
 Thu, 13 Dec 2018 06:26:18 -0800 (PST)
MIME-Version: 1.0
From:   Sid Hayn <sidhayn@gmail.com>
Date:   Thu, 13 Dec 2018 09:26:09 -0500
Message-ID: <CAM0KTbBUXJsBfO0=hQgeTGVteym6iuObdyNynWumQnnGY0L3wg@mail.gmail.com>
Subject: mt76x[02]u 802.11w support
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        sgruszka@redhat.com, linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Per a conversation with Lorenzo, it seems that 802.11w for mt76x[02]u
has only been fixed in 4.20.  As 4.19 is a LTS kernel, I'd like to
request that work be backported.  While the improvements in 4.20 and
4.21 are already fairly obvious, a lot of people will be running 4.19
for years to come.  This is good hardware, with a working driver
(thanks team) but in the next few months excitement is going to turn
toward WPA3 which requires working 802.11w.

Pretty please backport 802.11w support to 4.19

Thanks,
Zero
