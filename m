Return-Path: <SRS0=sX2r=PO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC6CC43612
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 07:19:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0196A218EA
	for <linux-wireless@archiver.kernel.org>; Sun,  6 Jan 2019 07:19:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I27b60O5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfAFHTG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 6 Jan 2019 02:19:06 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:33542 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfAFHTG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 6 Jan 2019 02:19:06 -0500
Received: by mail-io1-f67.google.com with SMTP id t24so32614384ioi.0;
        Sat, 05 Jan 2019 23:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFK9Nsxe2U25Ot+Ax+RUnhMmXMrDnTvrZH+rLSlz5rA=;
        b=I27b60O5fqvXkyPCYPMVlEr9QZ1p+fSQ0+PPE9XGVQLz2UOHITjG8n6GiuLxCxOHlX
         kL8XZ6dnB7/D5WGzONn1UeXZIdbgslLSgd3Y/zjLULRrlqGzxA9YN3T+ob4dZQW9bFX7
         MXXNblXPdAEdvP9sdlPncIE1HlRAyhx7JaF5qqz6f4fiuLrdGNaB4fX7rJvVsEfEXqyi
         28lmyHBkh0o8bgBNGpIT77yQf9sDGdliKTY4LO1bn08mvXQVOcyV9kgQNxkklauGP1ZL
         MFsiCx2AEKmiiHI2o5bMOADuakxrAeXCkgOa5tL5ffIddFuiGhdcczw1sMG2iVNcdu88
         ABuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFK9Nsxe2U25Ot+Ax+RUnhMmXMrDnTvrZH+rLSlz5rA=;
        b=R/jocgdgnm+gpN6Z0gvslJpUfPswQWnQPrsrIX9lOLJ5Jbb/LVNjpSaGpARE4T3qqp
         n+kirQRCAi2WhYgwaQZFdGsGb2jTHxD5zm2AU/t2wovkTSuJa0Uh4uADn4pumLspCb0u
         tjdJU8HzZEQluX5deN5tO9KwpMtLkbu8hg5szoLIbKu3PkQFd7kX+yDODXkBJpMQdEpH
         4gpqX5lLP/9SLosYl9jsPbnIX0TI4600INjQXCSjh9CxImchJTq9mhCzp2BGqKVyxT6L
         +YyMCDIwhgjYZfloZ5jJXyYoJ+bNy49iVsGksBZJ3nhv2oWFOW+GTr00n0rZ4pzJ6dQm
         QgKw==
X-Gm-Message-State: AJcUukcwu1u1jqT9t4gqWZ1ke8L/6SHDbEUmzB3JuYCKHJoKY/lHbV9y
        7+2tbBeahLffwY7qDK+taO8dsFjZwtR7c++uh0A=
X-Google-Smtp-Source: ALg8bN4gswAu/GKHlXQgnDq8RLK/eGZoX+xJJxGUVoX0K4X+GP6DQRaANu6KzCtWYHdR8KOgflBHAyLIbNI9QE8Eu9Y=
X-Received: by 2002:a6b:7402:: with SMTP id s2mr37888944iog.219.1546759144668;
 Sat, 05 Jan 2019 23:19:04 -0800 (PST)
MIME-Version: 1.0
References: <20190105091025.GA28917@localhost.localdomain> <61a272a5-3c6f-4e69-2ce9-b7c58b427750@lwfinger.net>
In-Reply-To: <61a272a5-3c6f-4e69-2ce9-b7c58b427750@lwfinger.net>
From:   =?UTF-8?Q?J=C3=BAlius_Milan?= <jmilan.dev@gmail.com>
Date:   Sun, 6 Jan 2019 08:18:53 +0100
Message-ID: <CAP=P++DRiM8Rb8vg9hBJ-N2uhfL0Rrj+njYwgZW80yQZ4jQH4g@mail.gmail.com>
Subject: Re: [PATCH v2] staging: wilc1000: fix cast to restricted __le32
To:     Larry Finger <Larry.Finger@lwfinger.net>
Cc:     linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, gregkh@linuxfoundation.org,
        ajay.kathat@microchip.com, adham.abozaeid@microchip.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Thank you for your review Larry

> Before you send V3

Oh, v3 was already sent a few moments before your message.

> Before you send V3, are you sure this is the correct fix? As "frame_type" is
> input as u16, it seems to me that the frame_type member of struct wilc_reg_frame
> should be __le16, not __le32.

Yes, I am confident about it.
The frame_type member of struct wilc_reg_frame contains in some cases
32 bit value
as you can see in function wilc_wlan_cfg_set_wid.
Cast to 32 bits is also safe, due to resultant endianness.

Julius
