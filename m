Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:2832 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754709Ab0ESTIx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 May 2010 15:08:53 -0400
Message-ID: <4BF43742.8080204@gmail.com>
Date: Wed, 19 May 2010 21:08:50 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 7/7] rt2x00: Fix HT40 operation in rt2800.
References: <1274282769-19244-1-git-send-email-gwingerde@gmail.com>	 <1274282769-19244-8-git-send-email-gwingerde@gmail.com> <AANLkTikIaVSC6ZXjRUKD7J1rbGdf-JWCO7H4TGU5KZnx@mail.gmail.com>
In-Reply-To: <AANLkTikIaVSC6ZXjRUKD7J1rbGdf-JWCO7H4TGU5KZnx@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/10 20:14, Ivo Van Doorn wrote:
>> +u16 rt2x00ht_center_channel(struct rt2x00_dev *rt2x00dev,
>> +                           struct ieee80211_conf *conf)
>> +{
>> +       struct hw_mode_spec *spec = &rt2x00dev->spec;
>> +       int center_channel;
>> +       u16 i;
>> +
>> +       /*
>> +        * Initialize center channel to current channel.
>> +        */
>> +       center_channel = spec->channels[conf->channel->hw_value].channel;
>> +
>> +       /*
>> +        * Adjust center channel to HT40+ and HT40- operation.
>> +        */
>> +       if (conf_is_ht40_plus(conf))
>> +               center_channel += 2;
>> +       else if (conf_is_ht40_minus(conf))
>> +               center_channel -= (center_channel == 14) ? 1 : 2;
>> +
>> +       for (i = 0; i < spec->num_channels; i++)
>> +               if (spec->channels[i].channel == center_channel)
>> +                       return i;
>> +
>> +       BUG();
>> +}
> 
> This isn't worth a BUG(), perhaps a debug message or WARN(),
> I would say a debug message and retuning the hw_value.
> 

Oops, yes. BUG() is a bit too much here. This is simply left-over from testing.
Personally I think WARN() should be more appropriate, as it signifies an error situation
that really should not happen, and we want to atract a bit more attention to it than a
simple debug message.

v2 is on its way.

---
Gertjan.

