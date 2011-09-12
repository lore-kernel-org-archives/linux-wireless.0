Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:15917 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1ILTZJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 15:25:09 -0400
Subject: Re: [PATCH 3.1] iwlagn: fix stack corruption
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"julia@diku.dk" <julia@diku.dk>,
	John Linville <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	Alexander Diewald <alex@diewald.cc>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com>
References: <1315854505.11834.3.camel@jlt3.sipsolutions.net>
	 <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Sep 2011 11:40:29 -0700
Message-ID: <1315852829.3547.203.camel@wwguy-huron> (sfid-20110912_212513_538455_50961925)
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
> 
Thank you very much for catch my mistake

Wey


