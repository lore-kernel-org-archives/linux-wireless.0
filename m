Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61878 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757560Ab2EIRDf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 13:03:35 -0400
Received: by vbbff1 with SMTP id ff1so493469vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 10:03:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FA15A70.2020108@stericsson.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
Date: Wed, 9 May 2012 13:03:33 -0400
Message-ID: <CABF+-6VjWxN6mP4E+7WoR=RZxmSU70GPbua77Vmw+z=JnnKcUg@mail.gmail.com> (sfid-20120509_190339_307422_A40F29B7)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dmitry,

> The driver was tested with WSM_A30.02.0380 (and lot of other releases:)).
> The firmware was available at igloocommunity.org, I will try to find a link.

I found cw1200 firmware files within the following:
http://releases.linaro.org/12.04/ubuntu/leb-snowball/hwpack_linaro-lt-snowball-x11-base_20120424-15_armhf_supported.tar.gz

The wsm_xx.bin files from that tarball are identical to the ones I
already had for build 380.  However, the sdd_xx.bin files are
different.  When I use the sdd files from snowball nothing seems to
work.  I cannot scan or make any connections.

What are the sdd files for and why would they be different?

I noticed the driver parses some information directly from the sdd
file in the cw1200_parse_SDD_file function.  Does the file get used
for anything else?

With both sdd files I have the log shows:

    PTA element found.
    Listen Interval 5

If a PTA element is found the code always sets priv->is_BT_Present =
true.  If I do not have Blue Tooth in my system should this still be
set?


Thanks,

Kevin
