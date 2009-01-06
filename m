Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:49252 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690AbZAFOjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 09:39:23 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2814126fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 06:39:21 -0800 (PST)
Message-ID: <69e28c910901060639i6e71a713sb410c4422f43ab1e@mail.gmail.com> (sfid-20090106_153931_951570_49E8E82B)
Date: Tue, 6 Jan 2009 15:39:21 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: valentin.manea@gmail.com
Subject: Re: IWL config.mk problems
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090106123301.63ca1ea7@nero>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090106123301.63ca1ea7@nero>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2009 at 11:33 AM, Valentin Manea
<valentin.manea@gmail.com> wrote:
> Hi,
>
>
>   The current config.mk in the latest compat wireless nightly is too old
> and the IWL AGN drivers cannot be built. Instead of the current options, the
> config should have something like:
>
> CONFIG_IWLWIFI=y
> CONFIG_IWLCORE=y
> CONFIG_IWLWIFI_LEDS=y
> CONFIG_IWLWIFI_RFKILL=y
> # CONFIG_IWLWIFI_DEBUG is not set
> CONFIG_IWLAGN=y
> CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
> CONFIG_IWLAGN_LEDS=y
> CONFIG_IWL4965=y
> CONFIG_IWL5000=y
>
>  I had a bug report on the Intel Wireless tracker but they told me I should
> notify it here.
>
>
> Thanks,
> Valentin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Please make that CONFIG_IWLWIFI_DEBUG=y - we are dealing with
bleeding-edge code here, and this config option does not actually turn
on debugging - it enables the userspace to turn on debugging. If it is
not set, iwlwifi debugging is force-off.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
