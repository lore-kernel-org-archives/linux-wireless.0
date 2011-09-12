Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1ILTUd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 15:20:33 -0400
Received: by bkbzt4 with SMTP id zt4so2909998bkb.19
        for <linux-wireless@vger.kernel.org>; Mon, 12 Sep 2011 12:20:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1315854505.11834.3.camel@jlt3.sipsolutions.net>
References: <1315854505.11834.3.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Mon, 12 Sep 2011 12:14:33 -0700
Message-ID: <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com> (sfid-20110912_212041_202987_62A58CBC)
Subject: Re: [PATCH 3.1] iwlagn: fix stack corruption
To: Johannes Berg <johannes@sipsolutions.net>
Cc: julia@diku.dk, John Linville <linville@tuxdriver.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Alexander Diewald <alex@diewald.cc>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      2011-09-12 21:01:34.000000000 +0200
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      2011-09-12 21:01:43.000000000 +0200
> @@ -167,7 +167,7 @@ static int iwlagn_set_temperature_offset
>
>        memset(&cmd, 0, sizeof(cmd));
>        iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
> -       memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(offset_calib));
> +       memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(*offset_calib));
>        if (!(cmd.radio_sensor_offset))
>                cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;

Nice catch!

This kinda bug seems ideal for Julia Lawall's stuff to catch, doesn't it?

Right: memcpy(addr, obj, sizeof(*obj))
Wrong: memcpy(addr, obj, sizeof(obj))

Dan
