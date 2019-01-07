Return-Path: <SRS0=TVdy=PP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E2F2C43387
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FAEF21736
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Jan 2019 13:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBrQTNZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730022AbfAGNX2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Jan 2019 08:23:28 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38590 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729846AbfAGNX1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Jan 2019 08:23:27 -0500
Received: by mail-ed1-f67.google.com with SMTP id h50so856243ede.5;
        Mon, 07 Jan 2019 05:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HIBinLwZ1ghjqd3NQ3ePFix2UVejfaQY7pzz6QW8sPw=;
        b=VBrQTNZDSe08jcHY20uRb39HyAf++fJ5S7cnJwcg5HcZu/miN7U5lCP9SwgYUbAJ3Y
         zvVT9LbhADr6gabH3kLE/4/i7Qe3WlCOmGAT16hKUyyAO4zJGuNNl/0XPodFUQBP14zb
         +3qOLWQ1Zktuci1DeMKB4Ag3BOFZrK18Z9vFEJB+XMPWsX6CV09a5/DzZyCzTpM1U6zl
         7ghPIhI87XZwU24OdLK7SWAlbKzRbvGXaK/FvNYvw6xEnB7Nj8660a8fgwsiz9ekcmqT
         onEQwH5kFNaxTn7dO3dshJFW6vDXgnTyZ6EjjlV6bAEJPj1LZ+v6sQMnH1ddoQyAfZoU
         emvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HIBinLwZ1ghjqd3NQ3ePFix2UVejfaQY7pzz6QW8sPw=;
        b=IkqPxGCzs+8fNpoFSu40zsS2Qv1dViahp56RxAFqr5qbHDmG3gE/FbAbTHHkm3TDSs
         dko5jxIsjQBBRWGhZSX9b02Fb1yEsgTCgZ9pDa1H5ZBhM115ySuZSBSzjIH0V03mZ7Dq
         ON4g3oRnO0nnb1pqWR7rtrww/Zq1wlZGecY4PSBaKeSsT5SfK/+QyT5MuaiYWSe4/r7C
         Nkp0OJod5oBsPYte65ej55ofyl9Cjcldy14hQ+3NjA2nxj7fZS0pgfrXptd68F8BEo8k
         1kKh5rDSYkEmrwWWmhnK0ZXeI8IfeB+q7u5e5YzOTRtOZwYqqS13upSDMD6ktPTgpOtL
         mnwA==
X-Gm-Message-State: AA+aEWaiFmMReomlF6vbpmWKcNi01ODhs449JoOpQkJRXunaIGQfTW5y
        dFkDWwyqhNXEfXG1o3+f6nY=
X-Google-Smtp-Source: AFSGD/WWePlxSEs4y7Ly3AuLsZtP0XzU1awgYeec9SpOhX32XDJyXyFpL+W3ex9/huXgdS3/wPqDdg==
X-Received: by 2002:a50:a55c:: with SMTP id z28mr55607764edb.124.1546867405558;
        Mon, 07 Jan 2019 05:23:25 -0800 (PST)
Received: from ltop.local ([2a02:a03f:407b:c500:4142:d3d:8d31:6743])
        by smtp.gmail.com with ESMTPSA id o37sm29790886edc.32.2019.01.07.05.23.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jan 2019 05:23:24 -0800 (PST)
Date:   Mon, 7 Jan 2019 14:23:23 +0100
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     =?utf-8?Q?J=C3=BAlius?= Milan <julikmilan@gmail.com>,
        kbuild test robot <lkp@intel.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, ajay.kathat@microchip.com,
        linux-wireless@vger.kernel.org, adham.abozaeid@microchip.com
Subject: Re: [PATCH] staging: wilc1000: fix cast to restricted __le32
Message-ID: <20190107132322.sk3lcvafg65fdd7b@ltop.local>
References: <20190105082323.GA27838@localhost.localdomain>
 <20190107125437.GA3200@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107125437.GA3200@kadam>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Jan 07, 2019 at 03:54:37PM +0300, Dan Carpenter wrote:
> I'm sort of surprised that the zero day bot didn't complain about this.
> It probably should.
> 
> The endianness checking is not turned on by default in Sparse.  You have
> to do "make C=1 CF=-D__CHECK_ENDIAN__" to turn it on.

Bitwise (and thus endian) checking is enabled by default in the kernel
since 05de97003 ("linux/types.h: enable endian checks for all sparse builds")
included in v4.10-rc1. Since then they make more than half of sparse
warnings (in a x86-64 allyesconfig).

Best regards,
-- Luc
