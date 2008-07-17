Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756825AbYGQSOI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2008 14:14:08 -0400
Subject: Re: [PATCH 1/3] libertas: support boot commands to write
	persistent firmware and bootloader
From: Dan Williams <dcbw@redhat.com>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
In-Reply-To: <487f84aa.1f068e0a.7ee7.3360@mx.google.com>
References: <487f84aa.1f068e0a.7ee7.3360@mx.google.com>
Content-Type: text/plain
Date: Thu, 17 Jul 2008 14:12:00 -0400
Message-Id: <1216318320.23645.32.camel@localhost.localdomain> (sfid-20080717_201418_521130_065C4EA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-15 at 17:45 -0700, Brian Cavagnolo wrote:
> Add locking and non-locking versions of if_usb_prog_firmware to support
> programming firmware after and before driver bring-up respectively.
> Add more suitable error codes for firmware programming process.
> Add capability checks for persistent features before attempting to use them.
> 
> Based on patches from Brajesh Dave and Priyank Singh.
> 
> Signed-off-by: Brian Cavagnolo <brian@cozybit.com>
> ---
>  drivers/net/wireless/libertas/defs.h       |    6 ++-
>  drivers/net/wireless/libertas/if_usb.c     |  107 ++++++++++++++++++++++-----
>  drivers/net/wireless/libertas/if_usb.h     |    5 ++
>  drivers/net/wireless/libertas/persistcfg.c |   24 ++++++
>  4 files changed, 121 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/defs.h b/drivers/net/wireless/libertas/defs.h
> index 12e6875..4b2428a 100644
> --- a/drivers/net/wireless/libertas/defs.h
> +++ b/drivers/net/wireless/libertas/defs.h
> @@ -243,6 +243,9 @@ static inline void lbs_deb_hex(unsigned int grp, const char *prompt, u8 *buf, in
>  
>  #define	CMD_F_HOSTCMD		(1 << 0)
>  #define FW_CAPINFO_WPA  	(1 << 0)
> +#define FW_CAPINFO_FIRMWARE_UPGRADE	(1 << 13)
> +#define FW_CAPINFO_BOOT2_UPGRADE	(1<<14)
> +#define FW_CAPINFO_PERSISTENT_CONFIG	(1<<15)
>  
>  #define KEY_LEN_WPA_AES			16
>  #define KEY_LEN_WPA_TKIP		32
> @@ -316,7 +319,8 @@ enum PS_STATE {
>  enum DNLD_STATE {
>  	DNLD_RES_RECEIVED,
>  	DNLD_DATA_SENT,
> -	DNLD_CMD_SENT
> +	DNLD_CMD_SENT,
> +	DNLD_BOOTCMD_SENT,
>  };
>  
>  /** LBS_MEDIA_STATE */
> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
> index 2478310..e83a4c2 100644
> --- a/drivers/net/wireless/libertas/if_usb.c
> +++ b/drivers/net/wireless/libertas/if_usb.c
> @@ -39,7 +39,10 @@ MODULE_DEVICE_TABLE(usb, if_usb_table);
>  
>  static void if_usb_receive(struct urb *urb);
>  static void if_usb_receive_fwload(struct urb *urb);
> -static int if_usb_prog_firmware(struct if_usb_card *cardp);
> +static int __if_usb_prog_firmware(struct if_usb_card *cardp,
> +					const char *fwname, int cmd);
> +static int if_usb_prog_firmware(struct if_usb_card *cardp,
> +					const char *fwname, int cmd);
>  static int if_usb_host_to_card(struct lbs_private *priv, uint8_t type,
>  			       uint8_t *payload, uint16_t nb);
>  static int usb_tx_block(struct if_usb_card *cardp, uint8_t *payload,
> @@ -66,10 +69,10 @@ static void if_usb_write_bulk_callback(struct urb *urb)
>  		lbs_deb_usb2(&urb->dev->dev, "Actual length transmitted %d\n",
>  			     urb->actual_length);
>  
> -		/* Used for both firmware TX and regular TX.  priv isn't
> -		 * valid at firmware load time.
> +		/* Boot commands such as UPDATE_FW and UPDATE_BOOT2 are not
> +		 * passed up to the lbs level.
>  		 */
> -		if (priv)
> +		if (priv && priv->dnld_sent != DNLD_BOOTCMD_SENT)
>  			lbs_host_to_card_done(priv);
>  	} else {
>  		/* print the failure status number for debug */
> @@ -231,7 +234,7 @@ static int if_usb_probe(struct usb_interface *intf,
>  	}
>  
>  	/* Upload firmware */
> -	if (if_usb_prog_firmware(cardp)) {
> +	if (__if_usb_prog_firmware(cardp, lbs_fw_name, BOOT_CMD_FW_BY_USB)) {
>  		lbs_deb_usbd(&udev->dev, "FW upload failed\n");
>  		goto err_prog_firmware;
>  	}
> @@ -510,7 +513,7 @@ static void if_usb_receive_fwload(struct urb *urb)
>  		if (le16_to_cpu(cardp->udev->descriptor.bcdDevice) < 0x3106) {
>  			kfree_skb(skb);
>  			if_usb_submit_rx_urb_fwload(cardp);
> -			cardp->bootcmdresp = 1;
> +			cardp->bootcmdresp = BOOT_CMD_RESP_OK;
>  			lbs_deb_usbd(&cardp->udev->dev,
>  				     "Received valid boot command response\n");
>  			return;
> @@ -526,7 +529,9 @@ static void if_usb_receive_fwload(struct urb *urb)
>  				lbs_pr_info("boot cmd response wrong magic number (0x%x)\n",
>  					    le32_to_cpu(bootcmdresp.magic));
>  			}
> -		} else if (bootcmdresp.cmd != BOOT_CMD_FW_BY_USB) {
> +		} else if ((bootcmdresp.cmd != BOOT_CMD_FW_BY_USB) &&
> +			   (bootcmdresp.cmd != BOOT_CMD_UPDATE_FW) &&
> +			   (bootcmdresp.cmd != BOOT_CMD_UPDATE_BOOT2)) {
>  			lbs_pr_info("boot cmd response cmd_tag error (%d)\n",
>  				    bootcmdresp.cmd);
>  		} else if (bootcmdresp.result != BOOT_CMD_RESP_OK) {
> @@ -564,8 +569,8 @@ static void if_usb_receive_fwload(struct urb *urb)
>  
>  	kfree_skb(skb);
>  
> -	/* reschedule timer for 200ms hence */
> -	mod_timer(&cardp->fw_timeout, jiffies + (HZ/5));
> +	/* Give device 5s to either write firmware to its RAM or eeprom */
> +	mod_timer(&cardp->fw_timeout, jiffies + (HZ*5));

Along with this change, I think you should also refuse to update
firmware on a device that has boot2 3106 or less.  Only 3107 and higher
will delay the last firmware block ACK response until the write to
EEPROM is complete.

The userspace firmware tool at one point (with <= 3106) was not waiting
long enough after sending the last block, thus when you pulled out the
dongle or rebooted the XO, the EEPROM had 1/2 the new Boot2, and 1/2 the
old Boot2.  Uncool.  It will now enforce a 20s wait if the boot2 version
is <= 3106.

So are you sure that 5 seconds is enough time for >= 3107 to write out
to EEPROM?  I believe Ronak said that it took up to 20 seconds to write
out and even updated the Boot2 specification with that information.
Thus, I think that while 5 seconds is a good timeout for any firmware
block _other_ than the last block, the last block potentially needs a
much higher timeout which I'm not sure you've accounted for here...
 
>  	if (cardp->fwfinalblk) {
>  		cardp->fwdnldover = 1;

Perhaps here if the boot command was UDPATE_FW or UPDATE_BOOT2 then the
timer should be set to 20 seconds instead of 5, otherwise to 5 seconds;
and if not the final block, then set it to 5 seconds.

Dan

> @@ -809,7 +814,49 @@ static int check_fwfile_format(uint8_t *data, uint32_t totlen)
>  }
>  
> 
> -static int if_usb_prog_firmware(struct if_usb_card *cardp)
> +/**
> +*  @brief This function programs the firmware subject to cmd
> +*
> +*  @param cardp             the if_usb_card descriptor
> +*         fwname            firmware or boot2 image file name
> +*         cmd               either BOOT_CMD_FW_BY_USB, BOOT_CMD_UPDATE_FW,
> +*                           or BOOT_CMD_UPDATE_BOOT2.
> +*  @return     0 or error code
> +*/
> +static int if_usb_prog_firmware(struct if_usb_card *cardp,
> +				const char *fwname, int cmd)
> +{
> +	struct lbs_private *priv = cardp->priv;
> +	unsigned long flags;
> +	int ret;
> +
> +	/* Ensure main thread is idle. */
> +	spin_lock_irqsave(&priv->driver_lock, flags);
> +	while (priv->cur_cmd != NULL || priv->dnld_sent != DNLD_RES_RECEIVED) {
> +		spin_unlock_irqrestore(&priv->driver_lock, flags);
> +		if (wait_event_interruptible(priv->waitq,
> +				(priv->cur_cmd == NULL &&
> +				priv->dnld_sent == DNLD_RES_RECEIVED))) {
> +			return -ERESTARTSYS;
> +		}
> +		spin_lock_irqsave(&priv->driver_lock, flags);
> +	}
> +	priv->dnld_sent = DNLD_BOOTCMD_SENT;
> +	spin_unlock_irqrestore(&priv->driver_lock, flags);
> +
> +	ret = __if_usb_prog_firmware(cardp, fwname, cmd);
> +
> +	spin_lock_irqsave(&priv->driver_lock, flags);
> +	priv->dnld_sent = DNLD_RES_RECEIVED;
> +	spin_unlock_irqrestore(&priv->driver_lock, flags);
> +
> +	wake_up_interruptible(&priv->waitq);
> +
> +	return ret;
> +}
> +
> +static int __if_usb_prog_firmware(struct if_usb_card *cardp,
> +					const char *fwname, int cmd)
>  {
>  	int i = 0;
>  	static int reset_count = 10;
> @@ -817,20 +864,32 @@ static int if_usb_prog_firmware(struct if_usb_card *cardp)
>  
>  	lbs_deb_enter(LBS_DEB_USB);
>  
> -	if ((ret = request_firmware(&cardp->fw, lbs_fw_name,
> -				    &cardp->udev->dev)) < 0) {
> +	ret = request_firmware(&cardp->fw, fwname, &cardp->udev->dev);
> +	if (ret < 0) {
>  		lbs_pr_err("request_firmware() failed with %#x\n", ret);
> -		lbs_pr_err("firmware %s not found\n", lbs_fw_name);
> +		lbs_pr_err("firmware %s not found\n", fwname);
>  		goto done;
>  	}
>  
> -	if (check_fwfile_format(cardp->fw->data, cardp->fw->size))
> +	if (check_fwfile_format(cardp->fw->data, cardp->fw->size)) {
> +		ret = -EINVAL;
>  		goto release_fw;
> +	}
> +
> +	/* Cancel any pending usb business */
> +	usb_kill_urb(cardp->rx_urb);
> +	usb_kill_urb(cardp->tx_urb);
> +
> +	cardp->fwlastblksent = 0;
> +	cardp->fwdnldover = 0;
> +	cardp->totalbytes = 0;
> +	cardp->fwfinalblk = 0;
> +	cardp->bootcmdresp = 0;
>  
>  restart:
>  	if (if_usb_submit_rx_urb_fwload(cardp) < 0) {
>  		lbs_deb_usbd(&cardp->udev->dev, "URB submission is failed\n");
> -		ret = -1;
> +		ret = -EIO;
>  		goto release_fw;
>  	}
>  
> @@ -838,8 +897,7 @@ restart:
>  	do {
>  		int j = 0;
>  		i++;
> -		/* Issue Boot command = 1, Boot from Download-FW */
> -		if_usb_issue_boot_command(cardp, BOOT_CMD_FW_BY_USB);
> +		if_usb_issue_boot_command(cardp, cmd);
>  		/* wait for command response */
>  		do {
>  			j++;
> @@ -847,12 +905,21 @@ restart:
>  		} while (cardp->bootcmdresp == 0 && j < 10);
>  	} while (cardp->bootcmdresp == 0 && i < 5);
>  
> -	if (cardp->bootcmdresp <= 0) {
> +	if (cardp->bootcmdresp == BOOT_CMD_RESP_NOT_SUPPORTED) {
> +		/* Return to normal operation */
> +		ret = -EOPNOTSUPP;
> +		usb_kill_urb(cardp->rx_urb);
> +		usb_kill_urb(cardp->tx_urb);
> +		if (if_usb_submit_rx_urb(cardp) < 0)
> +			ret = -EIO;
> +		goto release_fw;
> +	} else if (cardp->bootcmdresp <= 0) {
>  		if (--reset_count >= 0) {
>  			if_usb_reset_device(cardp);
>  			goto restart;
>  		}
> -		return -1;
> +		ret = -EIO;
> +		goto release_fw;
>  	}
>  
>  	i = 0;
> @@ -882,7 +949,7 @@ restart:
>  		}
>  
>  		lbs_pr_info("FW download failure, time = %d ms\n", i * 100);
> -		ret = -1;
> +		ret = -EIO;
>  		goto release_fw;
>  	}
>  
> diff --git a/drivers/net/wireless/libertas/if_usb.h b/drivers/net/wireless/libertas/if_usb.h
> index 5771a83..5ba0aee 100644
> --- a/drivers/net/wireless/libertas/if_usb.h
> +++ b/drivers/net/wireless/libertas/if_usb.h
> @@ -30,6 +30,7 @@ struct bootcmd
>  
>  #define BOOT_CMD_RESP_OK		0x0001
>  #define BOOT_CMD_RESP_FAIL		0x0000
> +#define BOOT_CMD_RESP_NOT_SUPPORTED	0x0002
>  
>  struct bootcmdresp
>  {
> @@ -50,6 +51,10 @@ struct if_usb_card {
>  	uint8_t ep_in;
>  	uint8_t ep_out;
>  
> +	/* bootcmdresp == 0 means command is pending
> +	 * bootcmdresp < 0 means error
> +	 * bootcmdresp > 0 is a BOOT_CMD_RESP_* from firmware
> +	 */
>  	int8_t bootcmdresp;
>  
>  	int ep_in_size;
> diff --git a/drivers/net/wireless/libertas/persistcfg.c b/drivers/net/wireless/libertas/persistcfg.c
> index 6d0ff8d..1547160 100644
> --- a/drivers/net/wireless/libertas/persistcfg.c
> +++ b/drivers/net/wireless/libertas/persistcfg.c
> @@ -22,6 +22,9 @@ static int mesh_get_default_parameters(struct device *dev,
>  	struct cmd_ds_mesh_config cmd;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(struct cmd_ds_mesh_config));
>  	ret = lbs_mesh_config_send(priv, &cmd, CMD_ACT_MESH_CONFIG_GET,
>  				   CMD_TYPE_MESH_GET_DEFAULTS);
> @@ -62,6 +65,9 @@ static ssize_t bootflag_set(struct device *dev, struct device_attribute *attr,
>  	uint32_t datum;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	ret = sscanf(buf, "%x", &datum);
>  	if (ret != 1)
> @@ -105,6 +111,9 @@ static ssize_t boottime_set(struct device *dev,
>  	uint32_t datum;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	ret = sscanf(buf, "%x", &datum);
>  	if (ret != 1)
> @@ -157,6 +166,9 @@ static ssize_t channel_set(struct device *dev, struct device_attribute *attr,
>  	uint16_t datum;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	ret = sscanf(buf, "%hx", &datum);
>  	if (ret != 1 || datum < 1 || datum > 11)
> @@ -214,6 +226,9 @@ static ssize_t mesh_id_set(struct device *dev, struct device_attribute *attr,
>  	int len;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	if (count < 2 || count > IW_ESSID_MAX_SIZE + 1)
>  		return -EINVAL;
>  
> @@ -273,6 +288,9 @@ static ssize_t protocol_id_set(struct device *dev,
>  	uint32_t datum;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	ret = sscanf(buf, "%x", &datum);
>  	if (ret != 1)
> @@ -327,6 +345,9 @@ static ssize_t metric_id_set(struct device *dev, struct device_attribute *attr,
>  	uint32_t datum;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	ret = sscanf(buf, "%x", &datum);
>  	if (ret != 1)
> @@ -381,6 +402,9 @@ static ssize_t capability_set(struct device *dev, struct device_attribute *attr,
>  	uint32_t datum;
>  	int ret;
>  
> +	if (!(priv->fwcapinfo & FW_CAPINFO_PERSISTENT_CONFIG))
> +		return -EOPNOTSUPP;
> +
>  	memset(&cmd, 0, sizeof(cmd));
>  	ret = sscanf(buf, "%x", &datum);
>  	if (ret != 1)

