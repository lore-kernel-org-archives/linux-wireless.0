Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from host2.marvell.com ([65.219.4.2]:6551 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932590AbZE0SiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 14:38:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 27 May 2009 11:38:01 -0700
Subject: RE: [PATCH 3/4] libertas: implement function init/shutdown commands
 for SD8688
Message-ID: <477F20668A386D41ADCC57781B1F704301E888DAD0@SC-VEXCH1.marvell.com>
References: <1242787701-10685-1-git-send-email-bzhao@marvell.com>
	 <1242787701-10685-3-git-send-email-bzhao@marvell.com>
 <1243369656.11433.6.camel@localhost.localdomain>
In-Reply-To: <1243369656.11433.6.camel@localhost.localdomain>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for the review.

> -----Original Message-----
> From: Dan Williams [mailto:dcbw@redhat.com]
> Sent: Tuesday, May 26, 2009 1:28 PM
> To: Bing Zhao
> Cc: libertas-dev@lists.infradead.org; linux-wireless@vger.kernel.org
> Subject: Re: [PATCH 3/4] libertas: implement function init/shutdown commands for SD8688
> 
> On Tue, 2009-05-19 at 19:48 -0700, Bing Zhao wrote:
> > SD8688 is a WLAN/Bluetooth combo chip and both functions are supported
> > in a single firmware image. FUNC_INIT and FUNC_SHUTDOWN commands are
> > implemented to utilize the multiple function feature.
> >
> > When SD8688 card is inserted, the firmware image should be downloaded
> > only once through either WLAN function (Libertas driver) or Bluetooth
> > function (Bluetooth driver).
> >
> > This patch adds function init/shutdown for SD8688 WLAN function only.
> >
> > Signed-off-by: Bing Zhao <bzhao@marvell.com>
> > ---
> >  drivers/net/wireless/libertas/dev.h     |    2 +
> >  drivers/net/wireless/libertas/host.h    |    2 +
> >  drivers/net/wireless/libertas/if_sdio.c |   41 ++++++++++++++++++++++++++++--
> >  drivers/net/wireless/libertas/main.c    |   20 +++++++++++++++
> >  4 files changed, 62 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> > index cbaafa6..a4455ec 100644
> > --- a/drivers/net/wireless/libertas/dev.h
> > +++ b/drivers/net/wireless/libertas/dev.h
> > @@ -321,6 +321,8 @@ struct lbs_private {
> >
> >  	u32 monitormode;
> >  	u8 fw_ready;
> > +	u8 fn_init_required;
> > +	u8 fn_shutdown_required;
> >  };
> >
> >  extern struct cmd_confirm_sleep confirm_sleep;
> > diff --git a/drivers/net/wireless/libertas/host.h b/drivers/net/wireless/libertas/host.h
> > index 8ff8ac9..fe8f0cb 100644
> > --- a/drivers/net/wireless/libertas/host.h
> > +++ b/drivers/net/wireless/libertas/host.h
> > @@ -86,6 +86,8 @@
> >  #define CMD_MESH_CONFIG_OLD			0x00a3
> >  #define CMD_MESH_CONFIG				0x00ac
> >  #define	CMD_SET_BOOT2_VER			0x00a5
> > +#define	CMD_FUNC_INIT				0x00a9
> > +#define	CMD_FUNC_SHUTDOWN			0x00aa
> >  #define CMD_802_11_BEACON_CTRL			0x00b0
> >
> >  /* For the IEEE Power Save */
> > diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
> > index e998c12..478d766 100644
> > --- a/drivers/net/wireless/libertas/if_sdio.c
> > +++ b/drivers/net/wireless/libertas/if_sdio.c
> > @@ -61,6 +61,7 @@ struct if_sdio_model {
> >  	int model;
> >  	const char *helper;
> >  	const char *firmware;
> > +	struct if_sdio_card *card;
> >  };
> >
> >  static struct if_sdio_model if_sdio_models[] = {
> > @@ -69,18 +70,21 @@ static struct if_sdio_model if_sdio_models[] = {
> >  		.model = IF_SDIO_MODEL_8385,
> >  		.helper = "sd8385_helper.bin",
> >  		.firmware = "sd8385.bin",
> > +		.card = NULL,
> >  	},
> >  	{
> >  		/* 8686 */
> >  		.model = IF_SDIO_MODEL_8686,
> >  		.helper = "sd8686_helper.bin",
> >  		.firmware = "sd8686.bin",
> > +		.card = NULL,
> >  	},
> >  	{
> >  		/* 8688 */
> >  		.model = IF_SDIO_MODEL_8688,
> >  		.helper = "sd8688_helper.bin",
> >  		.firmware = "sd8688.bin",
> > +		.card = NULL,
> >  	},
> >  };
> >
> > @@ -539,7 +543,6 @@ static int if_sdio_prog_helper(struct if_sdio_card *card)
> >  	ret = 0;
> >
> >  release:
> > -	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
> >  	sdio_release_host(card->func);
> >  	kfree(chunk_buffer);
> >  release_fw:
> > @@ -675,7 +678,6 @@ static int if_sdio_prog_real(struct if_sdio_card *card)
> >  	ret = 0;
> >
> >  release:
> > -	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
> >  	sdio_release_host(card->func);
> >  	kfree(chunk_buffer);
> >  release_fw:
> > @@ -718,6 +720,9 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
> >  		goto out;
> >
> >  success:
> > +	sdio_claim_host(card->func);
> > +	sdio_set_block_size(card->func, IF_SDIO_BLOCK_SIZE);
> > +	sdio_release_host(card->func);
> 
> What's the reason for setting the block size later?  Does it only need
> to be set after the firmware download is complete?  Just not sure about
> SDIO block sizes, not my area of expertise...
> 

In case that the firmware is already downloaded, we jump to "success" without re-downloading helper and firmware images:

        if (scratch == IF_SDIO_FIRMWARE_OK) {
                lbs_deb_sdio("firmware already loaded\n");
                goto success;
        }

In this case we never call sdio_set_block_size API to configure the block size to 256 (IF_SDIO_BLOCK_SIZE). So the default block size defined in CIS table will be used by MMC/SDIO driver. This is OK for SD8385/SD8686 because the default block size read from CIS happens to be 256. But for SD8688, the CIS block size is 512. If we take this default block size 512 we will have to transfer 4 blocks data (4x512=2048 bytes) for a regular data packet (15xx bytes + headers) from host to device. Due to a buffer limitation in firmware, this will corrupt the firmware.

When block size is set to 256, we transfer 7 blocks (or 7x256=1792 bytes) data to firmware for the same packet.

> > 	ret = 0;
> >
> >  out:
> > @@ -903,6 +908,8 @@ static int if_sdio_probe(struct sdio_func *func,
> >  		goto free;
> >  	}
> >
> > +	if_sdio_models[i].card = card;
> > +
> 
> So I think this is problematic; the problem is that if we have two
> libertas SDIO cards in the system (which could happen although not
> likely) then this would overwrite the first card info.  Also seems
> somewhat suspect to be writing into the structure which is otherwise
> essentially 'const'.
> 

I added this "card" variable to the if_sdio_model structure in order to save the card pointer because I need the "card" or "priv" pointer to issue function SHUTDOWN command. The SHUTDOWN command is only needed if the libertas_sdio module is removed by user (rmmod libertas_sdio). As the exit_module() does not take any parameter, I have to save the card pointer somewhere. I chose to add this "card" variable in if_sdio_model structure to avoid adding new global variable. Sure, the issues raised by multiple cards must be taken into account.

> > 	card->helper = if_sdio_models[i].helper;
> >  	card->firmware = if_sdio_models[i].firmware;
> >
> > @@ -985,6 +992,12 @@ static int if_sdio_probe(struct sdio_func *func,
> >  	if (ret)
> >  		goto reclaim;
> >
> > +	/*
> > +	 * FUNC_INIT is required for SD8688 WLAN/BT multiple functions
> > +	 */
> > +	priv->fn_init_required =
> > +		(card->model == IF_SDIO_MODEL_8688) ? 1 : 0;
> > +
> 
> I'd rather, I think, have generalized startup/shutdown hooks at the
> interface level (like reset_card and hw_host_to_card) that the interface
> can set to a function or to NULL, and call them that way.
> 

Will do FUNC_INIT command directly in if_sdio_probe() as it's SDIO specific.

> >
> >  	ret = lbs_start_card(priv);
> >  	if (ret)
> >  		goto err_activate_card;
> > @@ -1025,23 +1038,30 @@ static void if_sdio_remove(struct sdio_func *func)
> >  {
> >  	struct if_sdio_card *card;
> >  	struct if_sdio_packet *packet;
> > +	int ret;
> >
> >  	lbs_deb_enter(LBS_DEB_SDIO);
> >
> >  	card = sdio_get_drvdata(func);
> >
> > +	lbs_stop_card(card->priv);
> 
> Seems odd, was this causing some problem when it was below
> surpriseremoved?  I mention this becuase there's a lot of stuff during
> the command processing paths that uses surpriseremoved to break out
> early, and moving stop_card() above that may break stuff there.
> 

I wanted to send FUNC_SHUTDOWN command in lbs_stop_card() but "surpriseremoved" blocks sending any command. Have to find another way to bypass this check for SHUTDOWN command.

> > 	card->priv->surpriseremoved = 1;
> >
> >  	lbs_deb_sdio("call remove card\n");
> > -	lbs_stop_card(card->priv);
> >  	lbs_remove_card(card->priv);
> >
> >  	flush_workqueue(card->workqueue);
> >  	destroy_workqueue(card->workqueue);
> >
> >  	sdio_claim_host(func);
> > +
> > +	/* Disable interrupts */
> > +	sdio_writeb(func, 0x00, IF_SDIO_H_INT_MASK, &ret);
> 
> What was the reason for this?  Was it a mistake/omission in the original
> code or something?
> 

I wanted to play it safe when user unloads the libertas_sdio module (using rmmod command). It seems not necessary however. It will be reverted.

> > 	sdio_release_irq(func);
> >  	sdio_disable_func(func);
> > +
> >  	sdio_release_host(func);
> >
> >  	while (card->packets) {
> > @@ -1084,8 +1104,23 @@ static int __init if_sdio_init_module(void)
> >
> >  static void __exit if_sdio_exit_module(void)
> >  {
> > +	int i;
> > +	struct if_sdio_card *card;
> > +
> >  	lbs_deb_enter(LBS_DEB_SDIO);
> >
> > +	for (i = 0; i < ARRAY_SIZE(if_sdio_models); i++) {
> > +		card = if_sdio_models[i].card;
> > +
> > +		/*
> > +		 * FUNC_SHUTDOWN is required for SD8688 WLAN/BT
> > +		 * multiple functions
> > +		 */
> > +		if (card && card->priv)
> > +			card->priv->fn_shutdown_required =
> > +				(card->model == IF_SDIO_MODEL_8688) ? 1 : 0;
> > +	}
> > +
> 
> So this seems pretty weird; I don't think we should be storing the card
> value there.  Why does this have to be done from exit_module() instead
> of stop_card?  If fn_init_required is TRUE, why wouldn't
> fn_shutdown_required also be TRUE?
> 

The SHUTDOWN command is sent only if the user removes the module (rmmod libertas_sdio). It should not be sent if the user simply ejects the card from the slot. The fn_init_required flag is always TRUE. The fn_shutdown_required flag is TRUE when libertas_sdio module is removed (card still in slot); or FALSE if the card is unplugged. Anyway, both flags will be removed in the updated patch.

Previously I thought about using a global variable to solve this problem. A flag (user_rmmod) is set to 1 in exit_module(), and then the flag is checked in if_sdio_remove() to determine if SHUTDOWN command should be issued or not. But, is a global variable allowed?

> >  	sdio_unregister_driver(&if_sdio_driver);
> >
> >  	lbs_deb_leave(LBS_DEB_SDIO);
> > diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
> > index 89575e4..a58a123 100644
> > --- a/drivers/net/wireless/libertas/main.c
> > +++ b/drivers/net/wireless/libertas/main.c
> > @@ -1002,9 +1002,17 @@ static int lbs_setup_firmware(struct lbs_private *priv)
> >  {
> >  	int ret = -1;
> >  	s16 curlevel = 0, minlevel = 0, maxlevel = 0;
> > +	struct cmd_header cmd;
> >
> >  	lbs_deb_enter(LBS_DEB_FW);
> >
> > +	if (priv->fn_init_required) {
> > +		memset(&cmd, 0, sizeof(cmd));
> > +		if (__lbs_cmd(priv, CMD_FUNC_INIT, &cmd, sizeof(cmd),
> > +				lbs_cmd_copyback, (unsigned long) &cmd))
> > +			lbs_pr_alert("CMD_FUNC_INIT command failed\n");
> > +	}
> > +
> 
> I'd rather have this in the generic code in main.c as a callback into
> the interface code from lbs_start_card(), or else since for the moment
> it's SDIO-specific (will it also be used with GSPI or USB?) we could
> just put this into if_sdio_probe().
> 

It will be moved to if_sdio_probe() as it's for SDIO only.

> >  	/* Read MAC address from firmware */
> >  	memset(priv->current_addr, 0xff, ETH_ALEN);
> >  	ret = lbs_update_hw_spec(priv);
> > @@ -1192,6 +1200,9 @@ struct lbs_private *lbs_add_card(void *card, struct device *dmdev)
> >  	priv->mesh_open = 0;
> >  	priv->infra_open = 0;
> >
> > +	priv->fn_init_required = 0;
> > +	priv->fn_shutdown_required = 0;
> > +
> >  	/* Setup the OS Interface to our functions */
> >   	dev->netdev_ops = &lbs_netdev_ops;
> >  	dev->watchdog_timeo = 5 * HZ;
> > @@ -1373,11 +1384,20 @@ void lbs_stop_card(struct lbs_private *priv)
> >  	struct net_device *dev;
> >  	struct cmd_ctrl_node *cmdnode;
> >  	unsigned long flags;
> > +	struct cmd_header cmd;
> >
> >  	lbs_deb_enter(LBS_DEB_MAIN);
> >
> >  	if (!priv)
> >  		goto out;
> > +
> > +	if (priv->fn_shutdown_required) {
> > +		memset(&cmd, 0, sizeof(cmd));
> > +		if (__lbs_cmd(priv, CMD_FUNC_SHUTDOWN, &cmd, sizeof(cmd),
> > +				lbs_cmd_copyback, (unsigned long) &cmd))
> > +			lbs_pr_alert("CMD_FUNC_SHUTDOWN command failed\n");
> > +	}
> 
> Again, if this is SDIO specific then lets put this into
> if_sdio_remove(), if it's not SDIO specific (ie, will apply to USB or
> GSPI variants) then lets do the interface-hook thing I mentioned
> earlier.
> 

It will be moved to if_sdio interface driver because it is SDIO specific.
If a global variable (the flag for user_rmmod) can be added, the command can be issued in if_sdio_remove() and no need to add "card" variable in if_sdio_model structure.

> Dan
> 
> >  	dev = priv->dev;
> >
> >  	netif_stop_queue(dev);


Thanks,

Bing
