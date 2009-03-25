Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:29171 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbZCYMAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Mar 2009 08:00:36 -0400
Received: by fg-out-1718.google.com with SMTP id 16so713883fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 25 Mar 2009 05:00:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903251221.38912.chunkeey@web.de>
References: <1237959016-17311-1-git-send-email-jcmvbkbc@gmail.com>
	 <1237959016-17311-2-git-send-email-jcmvbkbc@gmail.com>
	 <200903251221.38912.chunkeey@web.de>
Date: Wed, 25 Mar 2009 15:00:33 +0300
Message-ID: <73aaf0dd0903250500g51494e04iab9382e23d44f695@mail.gmail.com> (sfid-20090325_130040_156332_A33F41C0)
Subject: Re: [PATCH 2/2] p54spi: fix p54_upload_firmware
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> checkpatch.pl complains
>
> WARNING: line over 80 characters
> #94: FILE: drivers/net/wireless/p54/p54spi.c:269:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 void *fw =3D kmemdup(pr=
iv->firmware->data, _fw_len, GFP_KERNEL);
>
> ERROR: that open brace { should be on the previous line
> #95: FILE: drivers/net/wireless/p54/p54spi.c:270:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (fw)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 {
>
Sorry, I haven't been used to checkpatch.

> what do you think about the attached proposal?

It looks generally better. But (fw + offset) wouldn't compile, because
fw is void*.

--=20
Max
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
