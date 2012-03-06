Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34424 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758166Ab2CFBwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 20:52:51 -0500
Received: by iagz16 with SMTP id z16so6347811iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 17:52:50 -0800 (PST)
Message-ID: <4F556DF0.3070806@lwfinger.net> (sfid-20120306_025254_874259_DA918F40)
Date: Mon, 05 Mar 2012 19:52:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Williams <john@pond-weed.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8192cu driver ignores eeprom channel plan
References: <20120305213956.7c383096@buffy.scoobygang>
In-Reply-To: <20120305213956.7c383096@buffy.scoobygang>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/05/2012 03:39 PM, John Williams wrote:
> Larry,
>
> The various rtl8192xx drivers read the manufacturer-set channel plan
> into efuse.eeprom_channelplan, but ignore this and use
> efuse.channel_plan (which is never initialized) when deciding which
> channels to allow. The patch below allowed my device, purchased in
> Europe, to see channels 12 and 13 when configured with "iw reg set EC"
>
> It needs more work in order to accept being configured for arbitrary countries: would you like me to work on a more comprehensive patch?

Please - I have plenty to do. I had never had any problems with the allowed 
channels, as I use CRDA and it sets my domain to US, which is as restrictive as any.

I just tested, and the RTL8192CE that I have installed at the moment has 0xA 
(COUNTRY_CODE_WORLD_WIDE_13) in the eeprom, which happens to be what is set in 
rtlpriv->efuse.channel_plan in rtl8192ce. That is not surprising as the card 
came from Realtek and I would expect something appropriate for China.

Larry
