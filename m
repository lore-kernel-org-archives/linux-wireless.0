Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61042 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab1DWLfY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Apr 2011 07:35:24 -0400
Received: by wwa36 with SMTP id 36so1276502wwa.1
        for <linux-wireless@vger.kernel.org>; Sat, 23 Apr 2011 04:35:23 -0700 (PDT)
Subject: Re: [PATCH 4/4] iwlwifi: split the drivers for agn and legacy
 devices 3945/4965
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
In-Reply-To: <1298315209-17986-5-git-send-email-wey-yi.w.guy@intel.com>
References: <1298315209-17986-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1298315209-17986-5-git-send-email-wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 14:35:17 +0300
Message-ID: <1303558517.8537.7.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-21 at 11:06 -0800, Wey-Yi Guy wrote:
> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> 
> Intel WiFi devices 3945 and 4965 now have their own driver in the folder
> 
> 	drivers/net/wireless/iwlegacy
> 
> Add support to build these drivers independently of the driver for
> AGN devices. Selecting the 3945 builds iwl3945.ko and iwl_legacy.ko,
> and selecting the 4965 builds iwl4965.ko and iwl_legacy.ko. iwl-legacy.ko
> contains code shared between both devices.
> 
> The 3945 is an ABG/BG device, with no support for 802.11n. The 4965 is a 2x3
> ABGN device.

This one came to me as a surprise, I updated the kernel, and whoops, the
wireless led, blinks all the time!
It turns out that in splitted driver iwl3945 doesn't have any led
support, and indeed the light on my notebook doesn't change state often.
It ether doesn't light up at all, or just blinks at constant rate.

I have iwl3945.

Best regards,
	Maxim Levitsky

