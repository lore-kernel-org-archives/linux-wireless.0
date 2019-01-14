Return-Path: <SRS0=xBvi=PW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97FE2C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 22:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CD4720657
	for <linux-wireless@archiver.kernel.org>; Mon, 14 Jan 2019 22:57:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bEP6EN0r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbfANW5w (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 14 Jan 2019 17:57:52 -0500
Received: from mail-wm1-f51.google.com ([209.85.128.51]:35585 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726745AbfANW5w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Jan 2019 17:57:52 -0500
Received: by mail-wm1-f51.google.com with SMTP id t200so1351549wmt.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2019 14:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=fPk72At9mv6VZZaId+SWoodoIdFQDrNoQpH/JvdT6s8=;
        b=bEP6EN0rfcQrBtrw4NBRyWe0sCThJs5kfu/n6+pHoJEZZUzA6c+jSKmyEQBbmzB/zV
         LdXozvmyfS6+ZmrDpixIllwCUy5i6TZWjcyNtq0mRWXqGwOJpNm7tizIfKcQyorz+IMi
         wBLo5HLIoXnVSpmt/ilD7Al6iRQ1qFuxXZZGbk8MKfSTfKJwdqmPF/pkkkMgZgiP+tLy
         xoY8CD1BcXxz59ivx72IPyNKDi90arnuEeFxzA36AQsz2DiA+Om+1SET0nLAaYBO6Uc1
         bfaertPNy1Zcv7rs9Yjbh5uVJTeZE/1sWKiSNmhiRMuRUxHHZITUaWAJ3IwvOZwMeq9p
         zJkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=fPk72At9mv6VZZaId+SWoodoIdFQDrNoQpH/JvdT6s8=;
        b=Ku7akIq0pkAl73HtMoqxQDvKJnNVR2VcKmlV5LbbVv2clUU7Idqs5gp+x/ZH/0vv6p
         wFEZQOmdYnJVLbbuob5z6kiDhDlB1Ep0WmbAXmREUj2vFwUE0LoAqeYtCGqFJXJFoRCk
         FGKqH8olAy6s6eBw4O/RTuHjJX95hZRQ4eOCIQT9RYvbHGPD/F7RWB7MPiCZy+a1l+U0
         Nkdtwr5OuIsEz0gNP0DVt2eV84HHQKekVCUPmKsjNAnaD+3zrW41vIYw6NxHJtjPEgKG
         rnYWd2FC8bL2wZY2Uyv+iodzNxpD81cJyIM7lu5vUJiqVG8qDn1iJX0/ZBxeRpZMKkkR
         JEZA==
X-Gm-Message-State: AJcUukcv9vsZslfx/PIz/fZ/3VuqCpFemwJGS2jJuEqr+zeYSV8kPS8l
        YZ35iwrIHzxL1MQjp1d7Fes=
X-Google-Smtp-Source: ALg8bN76MIkmXeYR1mjON23cuoC9m7vX9gMPkgNxC7/jcdsUI2weU9RjS02taBVoNOxvGQKaSbb0Xw==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr1031796wmi.10.1547506669782;
        Mon, 14 Jan 2019 14:57:49 -0800 (PST)
Received: from [10.0.0.91] (194-96-77-95.hdsl.highway.telekom.at. [194.96.77.95])
        by smtp.gmail.com with ESMTPSA id j33sm113731937wre.91.2019.01.14.14.57.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Jan 2019 14:57:49 -0800 (PST)
From:   Till Kamppeter <till.kamppeter@gmail.com>
Subject: Google Summer of Code 2019 - Project ideas page for the Linux
 Foundation online
To:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Jeff Licquia <jeff@licquia.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Open Printing <printing-architecture@lists.linux-foundation.org>,
        dl9pf@gmx.de, Mats Wichmann <mats@wichmann.us>,
        Denis Silakov <silakov@ispras.ru>,
        =?UTF-8?Q?Jan-Simon_M=c3=b6ller?= <jsmoeller@linuxfoundation.org>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Vadim Mutilin <mutilin@ispras.ru>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Ira McDonald <blueroofmusic@gmail.com>,
        Michael Sweet <msweet@apple.com>,
        Tobias Hoffmann <smilingthax@googlemail.com>,
        Jay Berkenbilt <ejb@ql.org>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Matt Germonprez <germonprez@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Gary O'Neall <garysourceauditor@gmail.com>
Cc:     Aveek Basu <aveek.basu@lexmark.com>
Message-ID: <6c4b4cf5-748e-7f7a-8f90-b34084ed4c2b@gmail.com>
Date:   Mon, 14 Jan 2019 23:57:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

I have set up a page for project ideas for the Linux Foundation's
participation in the Google Summer of Code 2019:

https://wiki.linuxfoundation.org/gsoc/google-summer-code-2019

Please add your ideas to the sub-page of your work group. Also remove 
project ideas which are already done in one of the previous years or not 
needed any more and make sure that all contact info is up-to-date and 
all links are working.

If you have problems mail me with your project ideas and other editing 
wishes.

The ideas list is in the Linux Foundation Wiki. If you want to edit and 
did not have the edit rights already from previous years, please tell me 
and I give you edit rights. I need your Linux Foundation user name for 
that and the e-mail address associated with this account for this.

Please also take into account that the deadline for our application as 
mentoring organization is Feb 6 and after that Google will evaluate the 
applications. So have your ideas (at least most of them, ideas can be 
posted up to the student application deadline) in by then to raise our 
chances to get accepted.

    Till
