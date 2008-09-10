Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbYIJNGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 09:06:25 -0400
Subject: Re: [PATCH] libertas: Enable/disable automatic tx power control
	via SIOCSIWTXPOW.
From: Dan Williams <dcbw@redhat.com>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <aa050c750809091614r612cc8a9q5e635153cce0d713@mail.gmail.com>
References: <48c1c0c1.1b068e0a.343f.ffffcb0d@mx.google.com>
	 <1220996373.25237.18.camel@localhost.localdomain>
	 <aa050c750809091614r612cc8a9q5e635153cce0d713@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 09:07:11 -0400
Message-Id: <1221052031.4648.6.camel@localhost.localdomain> (sfid-20080910_150629_480703_40139C7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-09-09 at 16:14 -0700, Anna Neal wrote:
> Hello,
> 
> Thanks for the great feedback.
> 
> On Tue, Sep 9, 2008 at 2:39 PM, Dan Williams <dcbw@redhat.com> wrote:
> > On Fri, 2008-09-05 at 15:56 -0700, Anna Neal wrote:
> >> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> >> index 802547e..6cc4858 100644
> >> --- a/drivers/net/wireless/libertas/cmd.c
> >> +++ b/drivers/net/wireless/libertas/cmd.c
> >> +int lbs_tpc_cfg(struct lbs_private *priv, int enable, int8_t p0, int8_t p1,
> >> +             int8_t p2, int usesnr)
> >
> > Can we rename this to lbs_set_tpc_cfg()?  It's a setter, and there could
> > be a getter later, best to be clear about this.
> 
> Definitely.
> 
> >> +int lbs_power_adapt_cfg(struct lbs_private *priv, int enable, int8_t p0,
> >> +             int8_t p1, int8_t p2)
> >
> > Same here, can we change this to lbs_set_pa_cfg() or
> > lbs_set_power_adapt_cfg() ?
> 
> Makes sense.
> 
> >> +{
> >> +     struct cmd_ds_802_11_pa_cfg cmd;
> >> +     int ret;
> >> +
> >> +     memset(&cmd, 0, sizeof(cmd));
> >> +     cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> >> +     cmd.action = cpu_to_le16(CMD_ACT_SET);
> >> +     cmd.enable = !!enable;
> >> +     cmd.P0 = p0;
> >> +     cmd.P1 = p1;
> >> +     cmd.P2 = p2;
> >
> > And this isn't compatible with the V9 and later firmware, which uses the
> > PowerAdapt_Group_t Marvell IE.  I'd suggest defining two different
> > commands, one for V8 and below which uses the format you have here, and
> > one for V9 and above which uses the new format.  I have no idea what the
> > fields in PA_Group_t are, but I'm sure you can find out since you're
> > from CozyBit :)
> 
> We don't have V{9,10} hardware nor access to a final published spec.
> How about if we wrap our changes around version checks and leave
> things unchanged for other versions?

Odd.  In any case, your suggestion sounds fine.  I'll do the V9+ bits
when there's time.

Thanks!
Dan

> >> diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> >> index da618fc..a916bb9 100644
> >> --- a/drivers/net/wireless/libertas/host.h
> >> +++ b/drivers/net/wireless/libertas/host.h
> >> @@ -83,6 +83,7 @@
> >>  #define CMD_802_11_INACTIVITY_TIMEOUT                0x0067
> >>  #define CMD_802_11_SLEEP_PERIOD                      0x0068
> >>  #define CMD_802_11_TPC_CFG                   0x0072
> >> +#define CMD_802_11_PA_CFG                    0x0073
> >
> > Should also:
> >
> > #define CMD_802_11_POWER_ADAPT_CFG_EXT  0x0073   /* v9 firmware and above */
> >
> > and use that in the v9+ lbs_set_power_adapt_cfg_ext() function.
> 
> Again, without hardware or the final spec implementation of this may
> need to wait on my end.
> 
> >> +struct cmd_ds_802_11_pa_cfg {
> >> +     struct cmd_header hdr;
> >> +
> >> +     __le16 action;
> >> +     uint8_t enable;
> >> +     int8_t P0;
> >> +     int8_t P1;
> >> +     int8_t P2;
> >> +} __attribute__ ((packed));
> >> +
> >> +
> >
> > And for v9:
> >
> > struct pa_group {
> >        u16 level;
> >        u16 rate_map;
> >        u32 reserved;
> > }
> >
> > struct mrvl_ie_pa_group {
> >        mrvlietypes_header hdr;
> >        struct pa_group groups[5];
> > }
> >
> > struct cmd_ds_802_11_pa_cfg_ext {
> >        struct cmd_header hdr;
> >
> >        __le16 action;
> >        u16 enable;
> >        struct mrvl_ie_pa_group pa_groups;
> > }
> >
> > note that there isn't an existing GPL implementation of
> > POWER_ADAPT_CFG_EXT either at moblin or anywhere else, so I can't
> > suggest what to fill in for the rate_map and level of struct pa_group in
> > the implementation.  Ask Luis or Javier I guess since they probably have
> > access to that information.
> 
> Javier just confirmed that we don't have access to this.
> 
> >>  struct cmd_ds_802_11_led_ctrl {
> >>       __le16 action;
> >>       __le16 numled;
> >> diff --git a/drivers/net/wireless/libertas/wext.c b/drivers/net/wireless/libertas/wext.c
> >> index 426f1fe..b08bad8 100644
> >> --- a/drivers/net/wireless/libertas/wext.c
> >> +++ b/drivers/net/wireless/libertas/wext.c
> >> @@ -1820,7 +1820,17 @@ static int lbs_set_txpow(struct net_device *dev, struct iw_request_info *info,
> >>       }
> >>
> >>       if (vwrq->fixed == 0) {
> >> -             /* Auto power control */
> >> +             /* User requests automatic tx power control, however there are
> >> +              * many auto tx settings.  For now use firmware defaults until
> >> +              * we come up with a good way to expose these to the user. */
> >> +             ret = lbs_power_adapt_cfg(priv, 1, POW_ADAPT_DEFAULT_P0,
> >> +                             POW_ADAPT_DEFAULT_P1, POW_ADAPT_DEFAULT_P2);
> >
> > and do the firmware check right here and call lbs_set_power_adapt_cfg()
> > for V8 and lower, and lbs_set_power_adapt_cfg_ext() for v9 and higher
> > like so:
> >
> > if (priv->fwrelease >= 0x09000000) {
> >        ret = lbs_power_adapt_cfg_ext(...);
> > } else {
> >        ret = lbs_power_adapt_cfg(...);
> > }
> 
> So, to summarize, what I can do is...
> 
> > if (priv->fwrelease < 0x09000000) {
> >        ret = lbs_power_adapt_cfg(...);
> > }
> 
> ...would this be acceptable?  After all, it is still an improvement
> over what's currently in the driver.
> 
> Thanks again!
> 
> Anna

