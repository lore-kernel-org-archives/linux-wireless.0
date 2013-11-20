Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f176.google.com ([209.85.128.176]:49478 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KTHkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 02:40:43 -0500
Received: by mail-ve0-f176.google.com with SMTP id oz11so1210190veb.7
        for <linux-wireless@vger.kernel.org>; Tue, 19 Nov 2013 23:40:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEFj986hb2BLvcF2Bz3jRb_BRq3b+jZ5FwWALc0gdjXhLFU8tA@mail.gmail.com>
References: <1384870413-5569-1-git-send-email-yeohchunyeow@gmail.com>
	<CAFSJ42ZLhh5ns-aaO8G38TH1em37iHnYKvgF7BjSK-ZhA7jNcA@mail.gmail.com>
	<CAEFj986hb2BLvcF2Bz3jRb_BRq3b+jZ5FwWALc0gdjXhLFU8tA@mail.gmail.com>
Date: Wed, 20 Nov 2013 07:40:43 +0000
Message-ID: <CAFSJ42YQ5aKo+8NH-rvi_pm7dudpqpWYLJ69JpzKg_7agiOeKg@mail.gmail.com> (sfid-20131120_084047_221157_6C698598)
Subject: Re: [PATCH] wcn36xx: set self sta entry as HT capable
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	wcn36xx <wcn36xx@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

How about wcn36xx_smd_set_sta_default_ht_params?

This function will set all of the following fields to default values:
sta_params->ht_capable
sta_params->tx_channel_width_set
sta_params->lsig_txop_protection
sta_params->max_ampdu_size
sta_params->max_ampdu_density
sta_params->max_amsdu_size
sta_params->sgi_20Mhz
sta_params->sgi_40mhz
sta_params->green_field_capable
sta_params->delayed_ba_support
sta_params->dsss_cck_mode_40mhz

And then in  wcn36xx_smd_set_sta_params it is called like this:
wcn36xx_set_default_rates(&sta_params->supported_rates);
wcn36xx_smd_set_sta_default_ht_params

How does that sound?


On Wed, Nov 20, 2013 at 7:26 AM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Eugene
>
>> Why would the function that is setting default HT params will also set
>> default rates? There is no connection between HT params and default
>> rates.
> How about rename the function name to wcn36xx_smd_set_self_sta?
>
> ----
> Chun-Yeow



-- 
Best regards,
Eugene
