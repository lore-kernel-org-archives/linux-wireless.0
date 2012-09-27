Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:48571 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab2I0EGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 00:06:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174])
	by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_ARCFOUR_SHA1:16)
	(Exim 4.71)
	(envelope-from <ming.lei@canonical.com>)
	id 1TH5Mg-0007Um-6x
	for linux-wireless@vger.kernel.org; Thu, 27 Sep 2012 04:06:18 +0000
Received: by eaac13 with SMTP id c13so450174eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 21:06:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347503608-3521-1-git-send-email-ming.lei@canonical.com>
References: <1347503608-3521-1-git-send-email-ming.lei@canonical.com>
Date: Thu, 27 Sep 2012 12:06:17 +0800
Message-ID: <CACVXFVOkTNOtk6_nxG4CgcgZX5iLCiuSusxvbBpn43F1=L=X2g@mail.gmail.com> (sfid-20120927_060623_566062_C2947487)
Subject: Re: [PATCH -next] wireless: ath9k-htc: fix possible use after free
From: Ming Lei <ming.lei@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: Ming Lei <ming.lei@canonical.com>, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 13, 2012 at 10:33 AM, Ming Lei <ming.lei@canonical.com> wrote:
> Inside ath9k_hif_usb_firmware_fail(), the instance of
> 'struct struct hif_device_usb' may be freed by
> ath9k_hif_usb_disconnect() after
>
>         complete(&hif_dev->fw_done);
>
> But 'hif_dev' is still accessed after the line code
> above is executed.
>
> This patch fixes the issue by not accessing 'hif_dev'
> after 'complete(&hif_dev->fw_done)' inside
> ath9k_hif_usb_firmware_fail().
>
> Cc: ath9k-devel@lists.ath9k.org
> Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> Cc: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>

Gentle ping, :-)

Thanks,
--
Ming Lei
