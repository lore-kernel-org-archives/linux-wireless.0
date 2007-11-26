Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:39452 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632AbXKZQSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 11:18:22 -0500
Received: by nf-out-0910.google.com with SMTP id g13so776688nfb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 08:18:16 -0800 (PST)
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH 2/2] iwlwifi: add power management support -v2
Date: Mon, 26 Nov 2007 17:18:14 +0100
Cc: "Miguel =?iso-8859-15?q?Bot=F3n?=" <mboton.lkml@gmail.com>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	yi.zhu@intel.com
References: <200711170006.49654.mboton.lkml@gmail.com> <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
In-Reply-To: <1ba2fa240711162215p30b8bc7fj9f36020378ff596a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200711261718.14711.mboton@gmail.com> (sfid-20071126_161825_968749_BCADE853)
From: Miguel =?iso-8859-15?q?Bot=F3n?= <mboton.lkml@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 November 2007 07:15:05 Tomas Winkler wrote:
> Why power management shouldn't be enabled while in AC? The semantic o=
f this
> ioctls is quite unclear.

IWL_POWER_AC and IWL_POWER_BATTERY are just two power modes. IWL_POWER_=
AC=20
would be the default power mode when we're in AC (no power saving) and=20
IWL_POWER_BATTERY would be the default power mode when we're in battery=
=20
(power saving mode). That's why we set IWL_POWER_ENABLED flag with=20
IWL_POWER_BATTERY, because it is the only power mode that saves power.

We can change to IWL_POWER_BATTERY or IWL_POWER_AC in any moment.

This patch, depending if power management is enabled or not, sets which=
 power=20
mode we should use, Then, it checks if we're already using this mode or=
 not.

--=20
	Miguel Bot=F3n
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
