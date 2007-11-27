Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:39242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756640AbXK0QWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2007 11:22:16 -0500
Subject: Re: [PATCH] libertas: Add debugfs hooks for configuring LED
	behavior.
From: Dan Williams <dcbw@redhat.com>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: olpc-devel@laptop.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <474b4f06.0e578c0a.0e12.fffff5df@mx.google.com>
References: <474b4f06.0e578c0a.0e12.fffff5df@mx.google.com>
Content-Type: text/plain
Date: Tue, 27 Nov 2007 11:16:49 -0500
Message-Id: <1196180209.5194.10.camel@localhost.localdomain> (sfid-20071127_162219_535590_7A6CCBAE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2007-11-26 at 14:56 -0800, Andrey Yurovsky wrote:
> This is a rewrite of
> http://lists.laptop.org/pipermail/devel/2007-October/007144.html to use debugfs
> instead of private ioctls.  This will help manufacturing test the proper
> functioning of the LEDs without having to associate.
> 
> See the changes to README for documentation.

Awesome, thanks for doing this.  Hopefully after the parts that Quanta
need get put in, we can move the rest of the needed ioctls (mesh and
whatnot) over to debugfs for the time being.

I'll port the patch over to the new namespace and repost it, if that's
OK with you, so that it applies cleanly to wireless-2.6/everything and
2.6.25.

Dan

> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
> Signed-off-by: Javier Cardona <javier@cozybit.com>
> ---
>  drivers/net/wireless/libertas/README    |   23 +++
>  drivers/net/wireless/libertas/debugfs.c |  252 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/libertas/dev.h     |    3 +
>  3 files changed, 278 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/README b/drivers/net/wireless/libertas/README
> index 9f2b029..b62a624 100644
> --- a/drivers/net/wireless/libertas/README
> +++ b/drivers/net/wireless/libertas/README
> @@ -655,4 +655,27 @@ setuserscan
>      All entries in the scan table (not just the new scan data when keep=1)
>      will be displayed upon completion by use of the getscantable ioctl.
>  
> +leds
> +
> +	The leds directory contains the interface for configuring LED
> +	functions based on firmware state.
> +
> +	Path: /debugfs/libertas_wireless/ethX/leds/
> +
> +	Each state is represented by a filename.  Each LED configuration is
> +	represented by the following three fields:
> +	LED Behavior Argument
> +
> +	To read the current configuration for a given state, do:
> +		cat state
> +	To set the current configuration, do:
> +		echo "1 2 4" > state
> +
> +	The LED field specifies the LED number (1 or 2).  The Behavior field
> +	specifies what the LED should do: 0 for steady on, 1 for stead off, and
> +	2 for blinking.  The Argument field is used for behavior 2 and sets the
> +	duty and cycle.  It is defined as (duty<<4|cycle) where duty may be
> +	0 to 4 and cycle may be 0 to 5.  For behaviors other than 2, the 
> +	Argument may be left as 0.
> +
>  ==============================================================================
> diff --git a/drivers/net/wireless/libertas/debugfs.c b/drivers/net/wireless/libertas/debugfs.c
> index 5bb42da..38fdfd7 100644
> --- a/drivers/net/wireless/libertas/debugfs.c
> +++ b/drivers/net/wireless/libertas/debugfs.c
> @@ -1612,6 +1612,224 @@ out_unlock:
>  	return res;
>  }
>  
> +static ssize_t libertas_leds_read(struct file *file,
> +				  char __user *userbuf,
> +				  size_t count, loff_t *ppos,
> +				  int firmwarestate)
> +{
> +	wlan_private *priv = file->private_data;
> +	ssize_t pos = 0;
> +	int res, i = 0;
> +	unsigned long addr = get_zeroed_page(GFP_KERNEL);
> +	char *buf = (char *)addr;
> +	struct cmd_ds_802_11_led_ctrl ctrl;
> +	struct mrvlietypes_ledbhv *bhv = (struct mrvlietypes_ledbhv *)ctrl.data;
> +
> +	memset(&ctrl, 0, sizeof(ctrl));
> +	ctrl.action = cpu_to_le16(CMD_ACT_GET);
> +
> +	res = libertas_prepare_and_send_command(priv, CMD_802_11_LED_GPIO_CTRL,
> +			0, CMD_OPTION_WAITFORRSP, 0, (void *)&ctrl);
> +	if (res) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	bhv = (struct mrvlietypes_ledbhv *)
> +		((unsigned char *)bhv->ledbhv + bhv->header.len);
> +	while (i < ((MAX_LEDS)*4) &&
> +			(bhv->header.type != MRVL_TERMINATE_TLV_ID) ) {
> +		if (bhv->ledbhv[0].firmwarestate == firmwarestate) {
> +			pos += snprintf(buf+pos, len-pos, "LED%d: %d %d\n",
> +					bhv->ledbhv[0].led,
> +					bhv->ledbhv[0].ledstate,
> +					bhv->ledbhv[0].ledarg);
> +		}
> +		bhv++;
> +	}
> +
> +	res = simple_read_from_buffer(userbuf, count, ppos, buf, pos);
> +
> +out_unlock:
> +	free_page(addr);
> +	return res;
> +}
> +
> +static ssize_t libertas_leds_write(struct file *file,
> +				   const char __user *userbuf,
> +				   size_t count, loff_t *ppos,
> +				   int firmwarestate)
> +{
> +	wlan_private *priv = file->private_data;
> +	ssize_t buf_size, res;
> +	int led, ledstate, ledarg;
> +	unsigned long addr = get_zeroed_page(GFP_KERNEL);
> +	char *buf = (char *)addr;
> +	struct cmd_ds_802_11_led_ctrl ctrl;
> +	struct mrvlietypes_ledbhv *bhv = (struct mrvlietypes_ledbhv *)ctrl.data;
> +
> +	buf_size = min(count, len - 1);
> +	if (copy_from_user(buf, userbuf, count)) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +	res = sscanf(buf, "%d %d %d", &led, &ledstate, &ledarg);
> +	if (res != 3) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	bhv->header.type = cpu_to_le16(TLV_TYPE_LEDBEHAVIOR);
> +	bhv->header.len = 4;
> +
> +	ctrl.action = cpu_to_le16(CMD_ACT_SET);
> +	ctrl.numled = cpu_to_le16(0);
> +
> +	bhv->ledbhv[0].firmwarestate = firmwarestate;
> +	bhv->ledbhv[0].led = led;
> +	bhv->ledbhv[0].ledstate = ledstate;
> +	bhv->ledbhv[0].ledarg = ledarg;
> +
> +	res = libertas_prepare_and_send_command(priv, CMD_802_11_LED_GPIO_CTRL,
> +			0, CMD_OPTION_WAITFORRSP, 0, (void *)&ctrl);
> +	if (res) {
> +		res = -EFAULT;
> +		goto out_unlock;
> +	}
> +
> +	return count;
> +
> +out_unlock:
> +	free_page(addr);
> +	return res;
> +}
> +
> +static ssize_t libertas_disconnected_read(struct file *file,
> +					  char __user *userbuf,
> +					  size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 0);
> +}
> +
> +static ssize_t libertas_disconnected_write(struct file *file,
> +					   const char __user *userbuf,
> +					   size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 0);
> +}
> +
> +static ssize_t libertas_scanning_read(struct file *file,
> +				      char __user *userbuf,
> +				      size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 1);
> +}
> +
> +static ssize_t libertas_scanning_write(struct file *file,
> +				       const char __user *userbuf,
> +				       size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 1);
> +}
> +
> +static ssize_t libertas_connected_read(struct file *file,
> +				       char __user *userbuf,
> +				       size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 2);
> +}
> +
> +static ssize_t libertas_connected_write(struct file *file,
> +					const char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 2);
> +}
> +
> +static ssize_t libertas_sleeping_read(struct file *file,
> +					char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 3);
> +}
> +
> +static ssize_t libertas_sleeping_write(struct file *file,
> +					const char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 3);
> +}
> +
> +static ssize_t libertas_deepsleep_read(struct file *file,
> +					char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 4);
> +}
> +
> +static ssize_t libertas_deepsleep_write(struct file *file,
> +					const char __user *userbuf,
> +					size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 4);
> +}
> +
> +static ssize_t libertas_linklost_read(struct file *file,
> +				      char __user *userbuf,
> +				      size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 6);
> +}
> +
> +static ssize_t libertas_linklost_write(struct file *file,
> +				       const char __user *userbuf,
> +				       size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 6);
> +}
> +
> +static ssize_t libertas_disassociated_read(struct file *file,
> +					   char __user *userbuf,
> +					   size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 7);
> +}
> +
> +static ssize_t libertas_disassociated_write(struct file *file,
> +					    const char __user *userbuf,
> +					    size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 7);
> +}
> +
> +static ssize_t libertas_transfer_read(struct file *file,
> +				      char __user *userbuf,
> +				      size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 9);
> +}
> +
> +static ssize_t libertas_transfer_write(struct file *file,
> +				       const char __user *userbuf,
> +				       size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 9);
> +}
> +
> +static ssize_t libertas_idle_read(struct file *file,
> +				  char __user *userbuf,
> +				  size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_read(file, userbuf, count, ppos, 10);
> +}
> +
> +static ssize_t libertas_idle_write(struct file *file,
> +				   const char __user *userbuf,
> +				   size_t count, loff_t *ppos)
> +{
> +	return libertas_leds_write(file, userbuf, count, ppos, 10);
> +}
> +
>  #define FOPS(fread, fwrite) { \
>  	.owner = THIS_MODULE, \
>  	.open = open_file_generic, \
> @@ -1659,6 +1877,27 @@ static struct libertas_debugfs_files debugfs_regs_files[] = {
>  	{"wrrf", 0600, FOPS(NULL, libertas_wrrf_write), },
>  };
>  
> +static struct libertas_debugfs_files debugfs_leds_files[] = {
> +	{"disconnected", 0644, FOPS(libertas_disconnected_read,
> +				    libertas_disconnected_write), },
> +	{"scanning", 0644, FOPS(libertas_scanning_read,
> +				libertas_scanning_write), },
> +	{"connected", 0644, FOPS(libertas_connected_read,
> +				 libertas_connected_write), },
> +	{"sleeping", 0644, FOPS(libertas_sleeping_read,
> +				libertas_sleeping_write), },
> +	{"deep_sleep", 0644, FOPS(libertas_deepsleep_read,
> +				  libertas_deepsleep_write), },
> +	{"link_lost", 0644, FOPS(libertas_linklost_read,
> +				 libertas_linklost_write), },
> +	{"disassociated", 0644, FOPS(libertas_disassociated_read,
> +				     libertas_disassociated_write), },
> +	{"transfer", 0644, FOPS(libertas_transfer_read,
> +				libertas_transfer_write), },
> +	{"idle", 0644, FOPS(libertas_idle_read,
> +			    libertas_idle_write), },
> +};
> +
>  void libertas_debugfs_init(void)
>  {
>  	if (!libertas_dir)
> @@ -1720,6 +1959,19 @@ void libertas_debugfs_init_one(wlan_private *priv, struct net_device *dev)
>  							     &files->fops);
>  	}
>  
> +	priv->leds_dir = debugfs_create_dir("leds", priv->debugfs_dir);
> +	if (!priv->leds_dir)
> +		goto exit;
> +
> +	for (i = 0; i < ARRAY_SIZE(debugfs_leds_files); i++) {
> +		files = &debugfs_leds_files[i];
> +		priv->debugfs_leds_files[i] = debugfs_create_file(files->name,
> +				files->perm,
> +				priv->leds_dir,
> +				priv,
> +				&files->fops);
> +	}
> +
>  #ifdef PROC_DEBUG
>  	libertas_debug_init(priv, dev);
>  #endif
> diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
> index 404ca50..c0168de 100644
> --- a/drivers/net/wireless/libertas/dev.h
> +++ b/drivers/net/wireless/libertas/dev.h
> @@ -129,6 +129,9 @@ struct _wlan_private {
>  	struct dentry *regs_dir;
>  	struct dentry *debugfs_regs_files[6];
>  
> +	struct dentry *leds_dir;
> +	struct dentry *debugfs_leds_files[9];
> +
>  	u32 mac_offset;
>  	u32 bbp_offset;
>  	u32 rf_offset;

