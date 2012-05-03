Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:33070 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754456Ab2ECUId (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:08:33 -0400
Received: by vbbff1 with SMTP id ff1so1573903vbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 13:08:32 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 3 May 2012 16:08:31 -0400
Message-ID: <CABF+-6U8=HCG9w6UZbzXF3nEUL76pAtJ4+3DcXa83e_iQHz1Hw@mail.gmail.com> (sfid-20120503_220836_549500_C4E69001)
Subject: Re: [PATCHv2 15/21] cw1200: debug.*, implementation of the driver's debugfs.
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

There seems to be a small problem in this patch.  If
CONFIG_CW1200_DEBUGFS is not defined then compilation fails with
"multiple definition of `cw1200_print_fw_version'".

>+int cw1200_print_fw_version(struct cw1200_common *priv, u8 *buf, size_t len)
>+{
>+}

The above code near the end of debug.h should probably just be a
function prototype and not include a function body.


Best regards,

Kevin
