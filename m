Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:21050 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab0JEL4l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 07:56:41 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o95BuSIO010979
	for <linux-wireless@vger.kernel.org>; Tue, 5 Oct 2010 14:56:38 +0300
Subject: Re: [PATCHv2] wl1271: Add extended radio parameter initialization
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1286279274.15401.21.camel@chilepepper>
References: <1286277116-22486-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1286279274.15401.21.camel@chilepepper>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 14:56:30 +0300
Message-ID: <1286279790.11177.241.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-10-05 at 13:47 +0200, Luciano Coelho wrote:
> On Tue, 2010-10-05 at 13:11 +0200, juuso.oikarinen@nokia.com wrote:
> > From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > 
> > Currently a command to initialize extended radio parameter tables in the
> > hardware is missing.
> > 
> > Add the initialization
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> > v2: change the name of the length macro for the TX power compensation table
> 
> Thanks for fixing it, it looks clearer now.
> 
> Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
> 
> A couple of comments below.
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
> > index 33b946b..4e8b464 100644
> > --- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
> > +++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
> 
> [...]
> 
> > @@ -363,6 +365,16 @@ struct wl1271_radio_parms_cmd {
> >  	u8 padding3[2];
> >  } __packed;
> >  
> > +struct wl1271_ext_radio_parms_cmd {
> > +	struct wl1271_cmd_header header;
> > +
> > +	struct wl1271_cmd_test_header test;
> > +
> > +	u8 tx_per_channel_power_compensation_2[CONF_TX_PWR_COMPENSATION_LEN_2];
> > +	u8 tx_per_channel_power_compensation_5[CONF_TX_PWR_COMPENSATION_LEN_5];
> > +	u8 padding[3];
> > +} __attribute__ ((packed));
> > +
> 
> This should be __packed nowadays.  But I'll change that before applying
> the patch, so no need to resend.
> 
> [...]
> 
> > diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
> > index cb18f22..8d33a2b 100644
> > --- a/drivers/net/wireless/wl12xx/wl1271_main.c
> > +++ b/drivers/net/wireless/wl12xx/wl1271_main.c
> > @@ -242,6 +242,16 @@ static struct conf_drv_settings default_conf = {
> >  		.max_dwell_time_passive       = 60000,
> >  		.num_probe_reqs               = 2,
> >  	},
> > +	.rf = {
> > +		.tx_per_channel_power_compensation_2 = {
> > +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +		},
> > +		.tx_per_channel_power_compensation_5 = {
> > +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +			0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > +		},
> > +	},
> >  };
> 
> I guess we should not hardcode this in the driver, but add it to the NVS
> file.  But let's think about that later, because we need to agree on
> changing the NVS structure first.
> 

It should not be hardcoded, thats true. The current NVS does not have a
slot for these yet. When it does, we can change the code accordingly.

For now this functionality mainly acts as initialization to zero, so
that nothing bad happens in the firmware if when these values begin to
be used for some purpose.

-Juuso



