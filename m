Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51672 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1IMHSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:18:42 -0400
Subject: Re: [PATCH 3.1] iwlagn: fix stack corruption
From: Johannes Berg <johannes@sipsolutions.net>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: julia@diku.dk, John Linville <linville@tuxdriver.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Alexander Diewald <alex@diewald.cc>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com> (sfid-20110912_211617_837991_28F0A685)
References: <1315854505.11834.3.camel@jlt3.sipsolutions.net>
	 <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com>
	 (sfid-20110912_211617_837991_28F0A685)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 09:18:01 +0200
Message-ID: <1315898281.4554.0.camel@jlt3.sipsolutions.net> (sfid-20110913_091845_167623_9907D8A5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-09-12 at 12:14 -0700, Daniel Halperin wrote:
> On Mon, Sep 12, 2011 at 12:08 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      2011-09-12 21:01:34.000000000 +0200
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      2011-09-12 21:01:43.000000000 +0200
> > @@ -167,7 +167,7 @@ static int iwlagn_set_temperature_offset
> >
> >        memset(&cmd, 0, sizeof(cmd));
> >        iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
> > -       memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(offset_calib));
> > +       memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(*offset_calib));
> >        if (!(cmd.radio_sensor_offset))
> >                cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
> 
> Nice catch!
> 
> This kinda bug seems ideal for Julia Lawall's stuff to catch, doesn't it?
> 
> Right: memcpy(addr, obj, sizeof(*obj))
> Wrong: memcpy(addr, obj, sizeof(obj))

That thought occurred to me as well, but I had been debugging until late
at night so didn't even try to write a script to flag this. :)

johannes

