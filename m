Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42567 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab0ESSOq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 14:14:46 -0400
Received: by fxm10 with SMTP id 10so2664366fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 11:14:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274282769-19244-8-git-send-email-gwingerde@gmail.com>
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>
	 <1274282769-19244-8-git-send-email-gwingerde@gmail.com>
Date: Wed, 19 May 2010 20:14:44 +0200
Message-ID: <AANLkTikIaVSC6ZXjRUKD7J1rbGdf-JWCO7H4TGU5KZnx@mail.gmail.com>
Subject: Re: [PATCH 7/7] rt2x00: Fix HT40 operation in rt2800.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
> +                           struct ieee80211_conf *conf)
> +{
> +       struct hw_mode_spec *spec = &rt2x00dev->spec;
> +       int center_channel;
> +       u16 i;
> +
> +       /*
> +        * Initialize center channel to current channel.
> +        */
> +       center_channel = spec->channels[conf->channel->hw_value].channel;
> +
> +       /*
> +        * Adjust center channel to HT40+ and HT40- operation.
> +        */
> +       if (conf_is_ht40_plus(conf))
> +               center_channel += 2;
> +       else if (conf_is_ht40_minus(conf))
> +               center_channel -= (center_channel == 14) ? 1 : 2;
> +
> +       for (i = 0; i < spec->num_channels; i++)
> +               if (spec->channels[i].channel == center_channel)
> +                       return i;
> +
> +       BUG();
> +}

This isn't worth a BUG(), perhaps a debug message or WARN(),
I would say a debug message and retuning the hw_value.

Ivo
