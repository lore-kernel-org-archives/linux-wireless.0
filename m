Return-Path: <SRS0=sGVr=Y7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89363C43331
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Nov 2019 18:45:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E64A2178F
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Nov 2019 18:45:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LAMgJYih"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfKGSpf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Nov 2019 13:45:35 -0500
Received: from mail-qk1-f181.google.com ([209.85.222.181]:38708 "EHLO
        mail-qk1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbfKGSpf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Nov 2019 13:45:35 -0500
Received: by mail-qk1-f181.google.com with SMTP id e2so2933834qkn.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Nov 2019 10:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3YdIQEG3U8jQurl2x19OKOKrjxp4OCgzS5thF6ciVas=;
        b=LAMgJYihdZSiDAga8kcyBZKJXznBMmZ/3xlyXIJ3ROdRUwuWyuXhhm3TSlZKPq4VKU
         DW5jwgBWD0zYdEbdfWlaODNFArdx2rK/efdfLGM8UCg1c3EyOngoY36kdKqYAdVS9wFt
         LWkz7OTzlvzDsaj3ocRyUJQSW1Z51OlU+rM2lROF/CT+j7h0phkzEw2nY18m942I2k8U
         bLgqpdGH07AVEAZDC3NUH52TXwrn15Q3vXVymgIjwD921STzHuhpp4t++mD1objoiC0x
         hRctNvneozdiYnzIxl8zwFXR7J+DLobcMeFoRGTM2Zl2tiaQy2HaPWx+iYxAmv+7plaz
         S8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3YdIQEG3U8jQurl2x19OKOKrjxp4OCgzS5thF6ciVas=;
        b=ZIbp4+RzR4CNWZjtqjQ8/5fw50YQn9igON9ZEBYBo5u8RWucRLI/2rPPr3oHJEBX04
         5HQPMGzymjnYfgQrNkxW7+nJRAc7l/sheTKPBvoHHZvSdi7AshnZ9wF7QUzklAy8X3aZ
         SyqZGe6siNK/Jcz0WIbfwuvVXsLEbVK7NFcaiS52xv0+gsxdTh+YkQGX9STGskKCij49
         mdwFUX+onYutVb09wg3Ope1jUVA9hlWt/JDDYfMjxHWAsc378tjEcV+85jb9/vqfnihr
         kq1NlzI0ak+2MnWT8I+H/JhfTqSOX9ltuL72himuficcEBuck3q8fz6EeRti3/2mK0xZ
         Rm3w==
X-Gm-Message-State: APjAAAVrho7gmFcc6kGCssIUFrD9UrEMhtWPsZI9m1TYi/Zt3ZTyfOfr
        39rs4M1RTq+qCkObYxOm5dN88n1MAIzfkIF/8rgRewTZstU=
X-Google-Smtp-Source: APXvYqwIMS4XUvGrNwPYl033e9GAxMH3LYIUAEX1rQdv9PpEhY2T4J7Q5rLPwWKJojogOGyoTZ5LoaeFrFyg/GTZHR8=
X-Received: by 2002:a37:4912:: with SMTP id w18mr1524385qka.206.1573152333658;
 Thu, 07 Nov 2019 10:45:33 -0800 (PST)
MIME-Version: 1.0
From:   Brian Norris <briannorris@google.com>
Date:   Thu, 7 Nov 2019 10:45:22 -0800
Message-ID: <CA+ASDXM=wh7TqO55BSV-Z12iJz08uVonJScCUDCRA+_h8JGe0Q@mail.gmail.com>
Subject: [FOR STABLE] wireless: Skip directory when generating certificates
To:     stable <stable@vger.kernel.org>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello stable!

I'd like to see the following commit included in -stable trees:

commit 32b5a2c9950b9284000059d752f7afa164deb15e
Author: Maxim Mikityanskiy <maxtram95@gmail.com>
Date:   Tue May 7 20:28:15 2019 +0300

    wireless: Skip directory when generating certificates

As it is, CONFIG_CFG80211_EXTRA_REGDB_KEYDIR is broken between v4.15 and v5.2.

Thanks,
Brian

P.S. I've take the "Option 2" in
Documentation/process/stable-kernel-rules.rst. Let me know if I should
do differently.
