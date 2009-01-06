Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:54102 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbZAFXgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 18:36:04 -0500
Received: by fg-out-1718.google.com with SMTP id 19so2903585fgg.17
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 15:36:02 -0800 (PST)
Message-ID: <3ace41890901061536k7722b63h906962283ce9e4ad@mail.gmail.com> (sfid-20090107_003610_107434_89825A01)
Date: Tue, 6 Jan 2009 23:36:02 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Rodrigo Fresneda" <fresneda@gmail.com>
Subject: Re: trouble with compat-old
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <e6236e5f0901060312h6946f9a1p49e299e723cb0190@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 6, 2009 at 11:12 AM, Rodrigo Fresneda <fresneda@gmail.com> wrote:

> WARNING: "iwl4965_agn_cfg"
> [/home/fresneda/compat-wireless-2.6-old/drivers/net/wireless/iwlwifi/iwlagn.ko]
> undefined!
>
> The module is built, but it cannot be inserted:
>
> FATAL: Error inserting iwlagn
> (/lib/modules/2.6.26-1-amd64/updates/drivers/net/wireless/iwlwifi/iwlagn.ko):
> Unknown symbol in module, or unknown parameter (see
> dmesg)
>
> And the output of dmesg:
>
> iwlagn: Unknown symbol iwl4965_agn_cfg


symbol iwl4965_agn_cfg is enabled if you select "Intel Wireless WiFi
4965AGN" support also.
config IWL4965 . Try selecting that when you build compat-wireless.old
. (seems that in some older version of
conpat-wireless, the 5000 code depends on the 4965 code).

Also, make sure that you do "depmod -a"
