Return-Path: <SRS0=mT4l=QC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CE86C282C7
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 11:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2977218A6
	for <linux-wireless@archiver.kernel.org>; Sat, 26 Jan 2019 11:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DkqfVYsg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfAZLYK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 26 Jan 2019 06:24:10 -0500
Received: from mail-io1-f51.google.com ([209.85.166.51]:40546 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfAZLYK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Jan 2019 06:24:10 -0500
Received: by mail-io1-f51.google.com with SMTP id k2so9792311iog.7
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2019 03:24:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hIAQz6nBG5FJt7vxBUqzw5o8M2i16lUi6iI59pJ3Wz8=;
        b=DkqfVYsgQs9n9bcow3oceSXz+dSLYnDLZy/NASAqf423QW2J1RCgsSo5iEZ9+zA09w
         f0lYPU8adkKWiIaNdc2uKCghCz0cf94fP1Hh/tgqjhsH7omQzHRo3hc9jX2TbhrKTNGA
         gnVdqgOlLKX1rXzyi+5+PLxufOZCUy49BGrQOon6oHWNSH7h3mx3Y2DE+ZKDPiqTjDsx
         eNAYDblrgtgIWq6wFZyDEEHAzZVRGYaJX+dpJrxuNSUfHOLnbyMrpmKcrDRuPtonDBWR
         Vt3ONk1i2LaK8rYgmBxi6vlnXFn47K+MMtQ0NpPLEZMAJza2vvymJitxswt3o7BG7fNx
         5L3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hIAQz6nBG5FJt7vxBUqzw5o8M2i16lUi6iI59pJ3Wz8=;
        b=pfWtn4ZJT0uuXkiXvD5Sfz13B0wAKQTEAMOpXFaNL3wl25zu5oDWeX2iVOBC00wXDu
         NXjR+sDxTJGudlG52yujtFTSboz1Ee1FbA2DIgAIUlnYy4TQaamvdZ8ewSRWLOzm8ZjZ
         3jz7xYVsPMB/EJn0UAvCd1RTTQ078eW/Yc6WBviPWYTybGS22KZvQX9zd2k3idfBmE+l
         yQ0v630Fv16vywRLmNxIzOKaUybS5I4/3/XETqAjBh6BWdtMSBaFO+diPDfQrDnlp/Dx
         we8x4glI7rIk7nYewAU4fAkdRIynrYX0cGjmofpM2w87FhEhpcXNFOtSwJPs4xqJevfS
         GDnw==
X-Gm-Message-State: AJcUukc35Xt1BpDSSMC4AjDVsZF9iY7MFnQ3aahgwhc3sUFaoMQDpkTQ
        ki7QQfgHidT9Hl4dCW8p3OwDhhqxKXzxWgvUs60=
X-Google-Smtp-Source: ALg8bN7PpC7DTggQh64yaiQ8/6hBIPUnbNpPqG3pqVjWD/YrreGomJ5Y81xr3TPD1HlBozxWAwlke80RzgbIVZheCGo=
X-Received: by 2002:a6b:6b02:: with SMTP id g2mr8348639ioc.18.1548501849205;
 Sat, 26 Jan 2019 03:24:09 -0800 (PST)
MIME-Version: 1.0
References: <6c4b4cf5-748e-7f7a-8f90-b34084ed4c2b@gmail.com>
 <MN2PR10MB36809F6F4FD540F41268AEA986810@MN2PR10MB3680.namprd10.prod.outlook.com>
 <CAKSHSL5sSV0pYkyV_PUkSN2+FT_DFxPHKbfRBg6JbMDvxNwYWg@mail.gmail.com>
In-Reply-To: <CAKSHSL5sSV0pYkyV_PUkSN2+FT_DFxPHKbfRBg6JbMDvxNwYWg@mail.gmail.com>
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
Date:   Sat, 26 Jan 2019 12:23:58 +0100
Message-ID: <CAKXUXMxthQgtrsW8fPK3D0sH75fx7S-x94L=wskwgR3JwbhacQ@mail.gmail.com>
Subject: Re: FW: Google Summer of Code 2019 - Project ideas page for the Linux
 Foundation online
To:     Aveek Basu <basu.aveek@gmail.com>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "Luis R. Rodriguez" <mcgrof@gmail.com>,
        Jeff Licquia <jeff@licquia.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ira McDonald <blueroofmusic@gmail.com>,
        Open Printing <printing-architecture@lists.linux-foundation.org>,
        dl9pf@gmx.de, Mats Wichmann <mats@wichmann.us>,
        Denis Silakov <silakov@ispras.ru>,
        Jan-Simon Moeller <jsmoeller@linuxfoundation.org>,
        Daniel Baluta <daniel.baluta@gmail.com>,
        Vadim Mutilin <mutilin@ispras.ru>,
        Tobias Hoffmann <smilingthax@googlemail.com>,
        Jay Berkenbilt <ejb@ql.org>,
        Nicholas Mc Guire <der.herr@hofr.at>,
        Matt Germonprez <germonprez@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        "Gary O'Neall" <garysourceauditor@gmail.com>,
        Till Kempeter <till.kamppeter@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Aveek, Hi Till,

Julia Lawall, Ralf Ramsauer and me have put together a set of GSoC
project proposals under Linux in High-Integrity Regulated Environments
(former: SIL2LinuxMP); we could also call it "Quality Assessment and
Assurance of the Linux kernel".
So, we are ready to get applications and we will use our channels to
start distributing to students as soon as we are certain that LF gets
accepted.

Thanks for your effort,

Lukas
