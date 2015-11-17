Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:34008 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbbKQGKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2015 01:10:43 -0500
Received: by ioir85 with SMTP id r85so8868194ioi.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Nov 2015 22:10:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
References: <1447738373-15804-1-git-send-email-steve.derosier@lairdtech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 17 Nov 2015 17:10:23 +1100
Message-ID: <CAGRGNgXezDJhLkYKVexKQOOF7OrLLXg+M8h4M7=OJSF_qLgQvA@mail.gmail.com> (sfid-20151117_071050_023665_BA7E7671)
Subject: Re: [PATCH 0/2] ath6kl_sdio: add control of CHIP_PWD_L via GPIO
To: Steve deRosier <derosier@gmail.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath6kl@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Steve deRosier <steve.derosier@lairdtech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Steve,

On Tue, Nov 17, 2015 at 4:32 PM, Steve deRosier <derosier@gmail.com> wrote:
> This set of two patches adds the ablity for ath6kl_sdio to control the
> CHIP_PWD_L pin on startup and for suspend/wakeup. This is importaint because
> on some platforms, this is the only way to achieve minimum power consumption.
> The CHIP_PWD_L pin is used to hold the ath chip in reset and this is the
> proper way to achieve its lowest power state (per QCA's datasheets).
>
> This GPIO is controled by the kernel standard GPIOLIB and as such depends on
> CONFIG_GPIOLIB. If this isn't enabled, then the various usages will generally
> compile out. Even if enabled, by default the GPIO is set to an invalid number,
> and each use will check: if not a valid GPIO, then behavior will be unchanged.
>
> This adds a new module parameter to allow the user to set the GPIO to use.

I want to say that this should go in DeviceTree or equivalent, however
ath6kl doesn't have DeviceTree support, so...

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
