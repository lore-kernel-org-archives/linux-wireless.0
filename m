Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from panicking.kicks-ass.org ([95.141.38.207]:53589 "EHLO
	panicking.kicks-ass.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab1DHKX3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 06:23:29 -0400
Subject: Re: [PATCH RFC 2/3] libertas: add set_power callback for iface
 subdrivers
From: Alberto Panizzo <alberto@amarulasolutions.com>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <201104081236.54157.anarsoul@gmail.com>
References: <1302207960-28536-1-git-send-email-anarsoul@gmail.com>
	 <1302207960-28536-3-git-send-email-anarsoul@gmail.com>
	 <1302253853.2649.28.camel@realization>
	 <201104081236.54157.anarsoul@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 12:23:14 +0200
Message-ID: <1302258194.2649.94.camel@realization>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-04-08 at 12:36 +0300, Vasily Khoruzhick wrote:
> On Friday 08 April 2011 12:10:53 Alberto Panizzo wrote:
> > > +	} else {
> > > +		/* Copy addr back to hw */
> > > +		memcpy(priv->current_addr, priv->dev->dev_addr, ETH_ALEN);
> > > +		hw_addr_cmd.hdr.size = cpu_to_le16(sizeof(hw_addr_cmd));
> > > +		hw_addr_cmd.action = cpu_to_le16(CMD_ACT_SET);
> > > +		memcpy(hw_addr_cmd.macadd, priv->current_addr, ETH_ALEN);
> > > +
> > > +		ret = lbs_cmd_with_response(priv, CMD_802_11_MAC_ADDRESS,
> > > +			&hw_addr_cmd);
> > > +		if (ret)
> > > +			lbs_deb_net("set MAC address failed\n");
> > 
> > Does this be really related to the subject of the patch?
> 
> Yep, this function is called right after power on, and we have to copy mac 
> address back to hardware (in case it was changed).

So, are you assuming that someone can change the wifi card while this 
is powered off? 

> 
> > > -	lbs_cmd_async(priv, CMD_MAC_CONTROL, &cmd.hdr, sizeof(cmd));
> > > +	ret = lbs_cmd_with_response(priv, CMD_MAC_CONTROL, &cmd);
> > > +	if (ret)
> > > +		lbs_deb_net("set MAC control failed\n");
> > 
> > Same here.
> 
> I changed cmd to be sync to be sure that there's no host<->card activity 
> during power down. Otherwise this command timedout.
> 
> > > +/**
> > > + * @brief This function gets the HW spec from the firmware and sets
> > > + *        some basic parameters.
> > > + *
> > > + *  @param priv    A pointer to struct lbs_private structure
> > > + *  @return        0 or -1
> > > + */
> > > +static int lbs_setup_firmware(struct lbs_private *priv)
> > > +{
> > > +	int ret = -1;
> > > +	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
> > > +
> > > +	lbs_deb_enter(LBS_DEB_FW);
> > > +
> > > +	/* Read MAC address from firmware */
> > > +	memset(priv->current_addr, 0xff, ETH_ALEN);
> > > +	ret = lbs_update_hw_spec(priv);
> > > +	if (ret)
> > > +		goto done;
> > > +
> > > +	/* Read power levels if available */
> > > +	ret = lbs_get_tx_power(priv, &curlevel, &minlevel, &maxlevel);
> > > +	if (ret == 0) {
> > > +		priv->txpower_cur = curlevel;
> > > +		priv->txpower_min = minlevel;
> > > +		priv->txpower_max = maxlevel;
> > > +	}
> > > +
> > > +	/* Send cmd to FW to enable 11D function */
> > > +	ret = lbs_set_snmp_mib(priv, SNMP_MIB_OID_11D_ENABLE, 1);
> > > +
> > > +	lbs_set_mac_control(priv);
> > > +done:
> > > +	lbs_deb_leave_args(LBS_DEB_FW, "ret %d", ret);
> > > +	return ret;
> > > +
> > 
> > Same for this function
> 
> Moved it to avoid forward declatation.

Mmm, personally I like more the forward declaration.. the moving do not
allow readers if you have modified something in the function.

>  
> > > +static void lbs_power_on(struct lbs_private *priv)
> > > +{
> > > +	if (priv->set_power) {
> > > +		priv->power_on_cnt++;
> > > +		if (priv->power_on_cnt == 1) {
> > 
> > Here you have room for race conditions. power_on_cnt should be
> > protected by a mutex.
> 
> I'm pretty sure that iface open/close (up/down?) is protected with mutex. So 
> why bother here? 
>  
> > > +			priv->set_power(priv, 1);
> > > +			lbs_setup_firmware(priv);
> > 
> > Do you think that all users needs 8002.11D?
> 
> It does nothing if mesh is not enabled in config.
> 
> > > @@ -201,15 +271,16 @@ int lbs_set_mac_address(struct net_device *dev,
> > > void *addr)
> > > 
> > >  	/* In case it was called from the mesh device */
> > >  	dev = priv->dev;
> > > 
> > > +	if (priv->power_on_cnt) {
> > 
> > Same here, you need at least a read lock.
> 
> In this place there's no iface yet (we're still in probe callback of driver).
> 
> lbs_power_on/lbs_power_off are called only on iface up/down and in 
> suspend/resume handlers (at least, for now), so we can't get race condition 
> here.

Ok, I understand what you are doing. It's the same as removing the 
module when the interface is not used..

I think this driver needs a good documentation of software flows: You 
are adding a mechanism that is really useful for saving power while the
wlan interface is not used. But this should not be the same as the 
policy this driver use through suspensions.

I know that at this moment, this driver is not managing Power Save very
well and ok, this allow you to give up and turn off the card during 
suspension.

>  
> > >  int lbs_suspend(struct lbs_private *priv)
> > >  {
> > > 
> > > -	int ret;
> > > +	int ret = 0;
> > > 
> > >  	lbs_deb_enter(LBS_DEB_FW);
> > > 
> > > -	if (priv->is_deep_sleep) {
> > > -		ret = lbs_set_deep_sleep(priv, 0);
> > > -		if (ret) {
> > > -			lbs_pr_err("deep sleep cancellation failed: %d\n", ret);
> > > -			return ret;
> > > +	if (priv->set_power)
> > > +		lbs_power_off(priv);
> > 
> > Do you really want to power off the chip on suspend only because
> > set_power exist?
> > Is this something that should be driven by userspace?
> >
> > And don't you want to setup any wake conditions?
> 
> Unfortunately there's no datasheet on libertas chip. And looks like there was 
> no WOL support in driver, so why keep it enabled?

Look for "CMD_802_11_HOST_SLEEP_CFG pdf" in google, you will be excited 
on the results..!

>  
> Thanks for review!
> 
> Regards
> Vasily


