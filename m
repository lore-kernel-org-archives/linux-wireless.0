Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:57824 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab1ILTZB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Sep 2011 15:25:01 -0400
Date: Mon, 12 Sep 2011 21:24:55 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Daniel Halperin <dhalperi@cs.washington.edu>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>,
	Alexander Diewald <alex@diewald.cc>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 3.1] iwlagn: fix stack corruption
In-Reply-To: <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1109122123560.13009@ask.diku.dk> (sfid-20110912_212508_243445_127DC3B2)
References: <1315854505.11834.3.camel@jlt3.sipsolutions.net>
 <CALSq=BYqNg_xukL5oJuu3pPqU=FcgR+Lov=PdGjMxtL3UNu8HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-251054898-1315855495=:13009"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-251054898-1315855495=:13009
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 12 Sep 2011, Daniel Halperin wrote:

> On Mon, Sep 12, 2011 at 12:08 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> > --- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      2011-09-12 21:01:34.000000000 +0200
> > +++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      2011-09-12 21:01:43.000000000 +0200
> > @@ -167,7 +167,7 @@ static int iwlagn_set_temperature_offset
> >
> >        memset(&cmd, 0, sizeof(cmd));
> >        iwl_set_calib_hdr(&cmd.hdr, IWL_PHY_CALIBRATE_TEMP_OFFSET_CMD);
> > -       memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(offset_calib));
> > +       memcpy(&cmd.radio_sensor_offset, offset_calib, sizeof(*offset_calib));
> >        if (!(cmd.radio_sensor_offset))
> >                cmd.radio_sensor_offset = DEFAULT_RADIO_SENSOR_OFFSET;
> 
> Nice catch!
> 
> This kinda bug seems ideal for Julia Lawall's stuff to catch, doesn't it?
> 
> Right: memcpy(addr, obj, sizeof(*obj))
> Wrong: memcpy(addr, obj, sizeof(obj))

Yes...  I have tried in the past the following:

x = <+... sizeof(x) ...+>

But that doesn't catch the above because there is no return value.  I will 
try it.

julia
---511516320-251054898-1315855495=:13009--
