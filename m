Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbXLGSbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 13:31:10 -0500
Subject: Re: [RFC] endianness fixes
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1197050972.30465.15.camel@localhost.localdomain>
References: <200712071615.19156.hs4233@mail.mn-solutions.de>
	 <1197050972.30465.15.camel@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 07 Dec 2007 13:25:17 -0500
Message-Id: <1197051917.30465.32.camel@localhost.localdomain> (sfid-20071207_183113_978752_3D16A1B1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-12-07 at 13:09 -0500, Dan Williams wrote:
> On Fri, 2007-12-07 at 16:15 +0100, Holger Schurig wrote:
> > Hi !
> > 
> > Recently I found that that sparse by default doesn't endianness
> > checks. So I changed my compilation habit to be
> > 
> > make modules C=1 SUBDIRS=drivers/net/wireless/libertas CHECKFLAGS="-D__CHECK_ENDIAN__"      
> > 
> > so that I get the little-endian checks from sparse as well. That
> > showed up a good bunch of problems. The following RFC patch is
> > against libertas-2.6. I hope that all fixes are correct.
> > 
> > 
> > diff --git a/drivers/net/wireless/libertas/hostcmd.h b/drivers/net/wireless/libertas/hostcmd.h
> > index be69ae6..32c97b9 100644
> > --- a/drivers/net/wireless/libertas/hostcmd.h
> > +++ b/drivers/net/wireless/libertas/hostcmd.h
> > @@ -418,13 +418,13 @@ struct cmd_ds_802_11_rf_antenna {
> >  };
> >  
> >  struct cmd_ds_802_11_monitor_mode {
> > -	u16 action;
> > -	u16 mode;
> > +	__le16 action;
> > +	__le16 mode;
> >  };
> >  
> >  struct cmd_ds_set_boot2_ver {
> > -	u16 action;
> > -	u16 version;
> > +	__le16 action;
> > +	__le16 version;
> >  };
> >  
> >  struct cmd_ds_802_11_ps_mode {
> > diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> > index 9563636..4a45d2b 100644
> > --- a/drivers/net/wireless/libertas/cmd.c
> > +++ b/drivers/net/wireless/libertas/cmd.c
> > @@ -431,7 +431,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
> >  		u8 mode = (u8) (size_t) pdata_buf;
> >  		pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
> >  		pSNMPMIB->oid = cpu_to_le16((u16) DESIRED_BSSTYPE_I);
> > -		pSNMPMIB->bufsize = sizeof(u8);
> > +		pSNMPMIB->bufsize = cpu_to_le16(sizeof(u8));
> >  		if (mode == IW_MODE_ADHOC) {
> >  			ucTemp = SNMP_MIB_VALUE_ADHOC;
> >  		} else {
> > @@ -451,8 +451,8 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
> >  			pSNMPMIB->oid = cpu_to_le16((u16) DOT11D_I);
> >  
> >  			if (cmd_action == CMD_ACT_SET) {
> > -				pSNMPMIB->querytype = CMD_ACT_SET;
> > -				pSNMPMIB->bufsize = sizeof(u16);
> > +				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_SET);
> > +				pSNMPMIB->bufsize = cpu_to_le16(sizeof(u16));
> >  				ulTemp = *(u32 *)pdata_buf;
> >  				*((__le16 *)(pSNMPMIB->value)) =
> >  				    cpu_to_le16((u16) ulTemp);
> > @@ -484,7 +484,7 @@ static int lbs_cmd_802_11_snmp_mib(struct lbs_private *priv,
> >  		{
> >  
> >  			u32 ulTemp;
> > -			pSNMPMIB->oid = le16_to_cpu((u16) RTSTHRESH_I);
> > +			pSNMPMIB->oid = cpu_to_le16(RTSTHRESH_I);
> >  
> >  			if (cmd_action == CMD_ACT_GET) {
> >  				pSNMPMIB->querytype = cpu_to_le16(CMD_ACT_GET);
> > @@ -759,7 +759,7 @@ static int lbs_cmd_reg_access(struct lbs_private *priv,
> >  
> >  	offval = (struct lbs_offset_value *)pdata_buf;
> >  
> > -	switch (cmdptr->command) {
> > +	switch (le16_to_cpu(cmdptr->command)) {
> >  	case CMD_MAC_REG_ACCESS:
> >  		{
> >  			struct cmd_ds_mac_reg_access *macreg;
> > @@ -999,7 +999,7 @@ void lbs_queue_cmd(struct lbs_adapter *adapter,
> >  	}
> >  
> >  	/* Exit_PS command needs to be queued in the header always. */
> > -	if (cmdptr->command == CMD_802_11_PS_MODE) {
> > +	if (le16_to_cpu(cmdptr->command) == CMD_802_11_PS_MODE) {
> >  		struct cmd_ds_802_11_ps_mode *psm = &cmdptr->params.psmode;
> >  		if (psm->action == cpu_to_le16(CMD_SUBCMD_EXIT_PS)) {
> >  			if (adapter->psstate != PS_STATE_FULL_POWER)
> > @@ -1062,15 +1062,14 @@ static int DownloadcommandToStation(struct lbs_private *priv,
> >  	adapter->cur_cmd_retcode = 0;
> >  	spin_unlock_irqrestore(&adapter->driver_lock, flags);
> >  
> > -	cmdsize = cmdptr->size;
> > -	command = cpu_to_le16(cmdptr->command);
> > +	cmdsize = le16_to_cpu(cmdptr->size);
> > +	command = le16_to_cpu(cmdptr->command);
> >  
> >  	lbs_deb_host("DNLD_CMD: command 0x%04x, size %d, jiffies %lu\n",
> > -		    command, le16_to_cpu(cmdptr->size), jiffies);
> > +		    command, cmdsize, jiffies);
> >  	lbs_deb_hex(LBS_DEB_HOST, "DNLD_CMD", cmdnode->bufvirtualaddr, cmdsize);
> >  
> >  	cmdnode->cmdwaitqwoken = 0;
> > -	cmdsize = cpu_to_le16(cmdsize);
> >  
> >  	ret = priv->hw_host_to_card(priv, MVMS_CMD, (u8 *) cmdptr, cmdsize);
> >  
> > @@ -1426,9 +1425,10 @@ int lbs_prepare_and_send_command(struct lbs_private *priv,
> >  
> >  #define ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN 8
> >  			cmdptr->size =
> > -			    cpu_to_le16(gpio->header.len + S_DS_GEN +
> > -					     ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
> > -			gpio->header.len = cpu_to_le16(gpio->header.len);
> > +			    cpu_to_le16(le16_to_cpu(gpio->header.len)
> > +				+ S_DS_GEN
> > +				+ ACTION_NUMLED_TLVTYPE_LEN_FIELDS_LEN);
> > +			gpio->header.len = gpio->header.len;
> 
> You can remove the line immediately.  gpio->header.len _should_ be

By which I meant "immediately above".  Take all the time you want to
actually hit Ctl+K or whatever your line-delete key combo is :)

Dan

> __le16 already (from types.h) so therefore we don't need this bit at
> all.
> 
> Rest of the stuff looks great though.
> 
> Dan
> 
> >  			ret = 0;
> >  			break;
> > diff --git a/drivers/net/wireless/libertas/cmdresp.c b/drivers/net/wireless/libertas/cmdresp.c
> > index 22a6973..d229967 100644
> > --- a/drivers/net/wireless/libertas/cmdresp.c
> > +++ b/drivers/net/wireless/libertas/cmdresp.c
> > @@ -561,7 +561,7 @@ static int lbs_ret_802_11_subscribe_event(struct lbs_private *priv,
> >  	lbs_deb_enter(LBS_DEB_CMD);
> >  
> >  	if (dst_event->action == cpu_to_le16(CMD_ACT_GET)) {
> > -		dst_event->events = le16_to_cpu(cmd_event->events);
> > +		dst_event->events = cmd_event->events;
> >  		memcpy(dst_event->tlv, cmd_event->tlv, sizeof(dst_event->tlv));
> >  	}
> >  
> > @@ -882,7 +882,7 @@ int lbs_process_rx_command(struct lbs_private *priv)
> >  
> >  	if (adapter->cur_cmd->pdata_size) {
> >  		struct cmd_ds_gen *r = (struct cmd_ds_gen *)resp;
> > -		u16 sz = cpu_to_le16(resp->size) - S_DS_GEN;
> > +		u16 sz = le16_to_cpu(resp->size) - S_DS_GEN;
> >  		if (sz > *adapter->cur_cmd->pdata_size) {
> >  			lbs_pr_err("response 0x%04x doesn't fit into "
> >  				"buffer (%d > %d)\n", respcmd,
> > diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> > index d5fc7d7..c51ca0b 100644
> > --- a/drivers/net/wireless/libertas/if_usb.c
> > +++ b/drivers/net/wireless/libertas/if_usb.c
> > @@ -107,7 +107,7 @@ static void if_usb_set_boot2_ver(struct lbs_private *priv)
> >  	int rsp_len = sizeof(b2_cmd);
> >  
> >  	b2_cmd.action = 0;
> > -	b2_cmd.version = cpu_to_le16(priv->boot2_version);
> > +	b2_cmd.version = priv->boot2_version;
> >  
> >  	if (lbs_cmd(priv, CMD_SET_BOOT2_VER, &b2_cmd, sizeof(b2_cmd),
> >  		    &b2_cmd, &rsp_len)) {
> > @@ -227,7 +227,7 @@ static int if_usb_probe(struct usb_interface *intf,
> >  	priv->hw_host_to_card = if_usb_host_to_card;
> >  	priv->hw_get_int_status = if_usb_get_int_status;
> >  	priv->hw_read_event_cause = if_usb_read_event_cause;
> > -	priv->boot2_version = le16_to_cpu(udev->descriptor.bcdDevice);
> > +	priv->boot2_version = udev->descriptor.bcdDevice;
> >  
> >  	/* Delay 200 ms to waiting for the FW ready */
> >  	if_usb_submit_rx_urb(cardp);
> > 
> > 
> > I now only have a few sparse warnings related to get_unaligned() or a weird
> > casting in if_sdio.c.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

