Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FD1C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 21:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71B2B20863
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 21:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="earKQISY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfBAVqX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 16:46:23 -0500
Received: from mail-ed1-f49.google.com ([209.85.208.49]:40250 "EHLO
        mail-ed1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726600AbfBAVqX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 16:46:23 -0500
Received: by mail-ed1-f49.google.com with SMTP id g22so6644287edr.7
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 13:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=nnRsCDBP5iiuobny+MEIDSQdb3m3xXEdi8kQFR4MugU=;
        b=earKQISY4uol/5f0F6AMT0sKc8gPcyAXBSxEH0pJ7+0ph7aP7yzuvnk7bXw4WZDTu4
         PH7ACnx48uckEDWoCA+098I/lvS9csq4Bk3xJgB6mwiXDIKrAsczS/hDhAcRZo4mSllj
         scquOfL6+pBINd4PyyJZeW0ria0L3f6ZSUR/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nnRsCDBP5iiuobny+MEIDSQdb3m3xXEdi8kQFR4MugU=;
        b=irKTl8fTPMPaS8J8yemrxSxWwDXDbIUmgMVUbZAHRUfOdn/wsbl2lFRGqpphx7J3dY
         H2vhxDmZzpT/AiTa3Z3czVql0IChFi0td/SBLY6iHNt8Wg9QFuzDhw9p0CT7p8KMDm6y
         +/4Rm2SZxKH0YUxrR848emndqcIVNTkpyqvji/BRf9URFx8slzPTtDUpbw9jCyWCv5y3
         s1f7eJ4lYHR7wvTHfJA0ReXEADfeOLwibdObhcsLW3RFxWG6bbvFOr7au3GaOJpudxJK
         siKqsm+/4Cg9omlEUeUR1bfn9JRZlajQ+2UT7tZXnFKbnmVj5uaNH0cJTWKdbL33V8A9
         Y1Ug==
X-Gm-Message-State: AJcUukeVt8XRsrh0mUG7sWHqvuZSgmEW/nMHXdRKc0SokvHQc4kYMccC
        XSSdqbbJkI8DtatMzdIMRnoSA6715FE=
X-Google-Smtp-Source: ALg8bN75JnVEtgbFtUYYv9xk8UuA8E2KnkKHTGtZLp5LoCgFmRJdwL6AGKfeje9DTVMb84Ywlm9daQ==
X-Received: by 2002:a50:ad0b:: with SMTP id y11mr39252437edc.113.1549057580212;
        Fri, 01 Feb 2019 13:46:20 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id b13sm25760eja.74.2019.02.01.13.46.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Feb 2019 13:46:19 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id a20so6636103edc.8
        for <linux-wireless@vger.kernel.org>; Fri, 01 Feb 2019 13:46:18 -0800 (PST)
X-Received: by 2002:a17:906:7c42:: with SMTP id g2mr36448700ejp.212.1549057578239;
 Fri, 01 Feb 2019 13:46:18 -0800 (PST)
MIME-Version: 1.0
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 1 Feb 2019 13:46:06 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMVAP4CsE=vaomOn5mu_uAM0jc3jvWGzaVPFFif4kTX+Q@mail.gmail.com>
Message-ID: <CA+ASDXMVAP4CsE=vaomOn5mu_uAM0jc3jvWGzaVPFFif4kTX+Q@mail.gmail.com>
Subject: iw release cadence?
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes,

Is there any sort of release cadence to the iw tool? Or is it pretty
arbitrary? I'm curious, since it's been more than a year since the
"v4.14" release. I'd like to package up bugfixes and a few features,
but it'd be much nicer to just pull a new official tag/tarball than to
drop a bunch of individual patches into my build system. If you're
going to tag something soon though, I can...just wait for you :)

More bluntly: can I haz release please?

Regards,
Brian
