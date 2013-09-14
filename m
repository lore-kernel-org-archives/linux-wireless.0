Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s15283307.onlinehome-server.info ([87.106.208.187]:46445 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959Ab3INBPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 21:15:16 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v4] Bluetooth: btmrvl: add calibration data download support
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1379115162-10194-1-git-send-email-bzhao@marvell.com>
Date: Fri, 13 Sep 2013 18:15:09 -0700
Cc: <linux-bluetooth@vger.kernel.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	<linux-wireless@vger.kernel.org>,
	Mike Frysinger <vapier@chromium.org>,
	Hyuckjoo Lee <hyuckjoo.lee@samsung.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Message-Id: <525C3DAD-2AD3-468F-8309-630EEE54A3CE@holtmann.org> (sfid-20130914_031534_333673_81105F22)
References: <1379115162-10194-1-git-send-email-bzhao@marvell.com>
To: Bing Zhao <bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bing,

> A text file containing calibration data in hex format can
> be provided at following path:
> 
> /lib/firmware/mrvl/sd8797_caldata.conf
> 
> The data will be downloaded to firmware during initialization.
> 
> Reviewed-by: Mike Frysinger <vapier@chromium.org>
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Signed-off-by: Bing Zhao <bzhao@marvell.com>
> Signed-off-by: Hyuckjoo Lee <hyuckjoo.lee@samsung.com>
> ---
> v2: Remove module parameter. The calibration data will be downloaded
>    only when the device speicific data file is provided.
>    (Marcel Holtmann)
> v3: Fix crash (misaligned memory access) on ARM
> v4: Simplify white space parsing and save some CPU cycles (Mike Frysinger)
> 
> drivers/bluetooth/btmrvl_drv.h  |  10 ++-
> drivers/bluetooth/btmrvl_main.c | 140 +++++++++++++++++++++++++++++++++++++++-
> drivers/bluetooth/btmrvl_sdio.c |   9 ++-
> drivers/bluetooth/btmrvl_sdio.h |   2 +
> 4 files changed, 157 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/bluetooth/btmrvl_drv.h b/drivers/bluetooth/btmrvl_drv.h
> index 27068d1..5ef5e84 100644
> --- a/drivers/bluetooth/btmrvl_drv.h
> +++ b/drivers/bluetooth/btmrvl_drv.h
> @@ -23,6 +23,8 @@
> #include <linux/bitops.h>
> #include <linux/slab.h>
> #include <net/bluetooth/bluetooth.h>
> +#include <linux/ctype.h>
> +#include <linux/firmware.h>
> 
> #define BTM_HEADER_LEN			4
> #define BTM_UPLD_SIZE			2312
> @@ -41,6 +43,8 @@ struct btmrvl_thread {
> struct btmrvl_device {
> 	void *card;
> 	struct hci_dev *hcidev;
> +	struct device *dev;
> +	const char *cal_data;
> 
> 	u8 dev_type;
> 
> @@ -91,6 +95,7 @@ struct btmrvl_private {
> #define BT_CMD_HOST_SLEEP_CONFIG	0x59
> #define BT_CMD_HOST_SLEEP_ENABLE	0x5A
> #define BT_CMD_MODULE_CFG_REQ		0x5B
> +#define BT_CMD_LOAD_CONFIG_DATA		0x61
> 
> /* Sub-commands: Module Bringup/Shutdown Request/Response */
> #define MODULE_BRINGUP_REQ		0xF1
> @@ -116,10 +121,13 @@ struct btmrvl_private {
> #define PS_SLEEP			0x01
> #define PS_AWAKE			0x00
> 
> +#define BT_CMD_DATA_SIZE		32
> +#define BT_CAL_DATA_SIZE		28
> +
> struct btmrvl_cmd {
> 	__le16 ocf_ogf;
> 	u8 length;
> -	u8 data[4];
> +	u8 data[BT_CMD_DATA_SIZE];
> } __packed;
> 
> struct btmrvl_event {
> diff --git a/drivers/bluetooth/btmrvl_main.c b/drivers/bluetooth/btmrvl_main.c
> index 9a9f518..77e940e 100644
> --- a/drivers/bluetooth/btmrvl_main.c
> +++ b/drivers/bluetooth/btmrvl_main.c
> @@ -57,8 +57,9 @@ bool btmrvl_check_evtpkt(struct btmrvl_private *priv, struct sk_buff *skb)
> 		ocf = hci_opcode_ocf(opcode);
> 		ogf = hci_opcode_ogf(opcode);
> 
> -		if (ocf == BT_CMD_MODULE_CFG_REQ &&
> -					priv->btmrvl_dev.sendcmdflag) {
> +		if ((ocf == BT_CMD_MODULE_CFG_REQ ||
> +		     ocf == BT_CMD_LOAD_CONFIG_DATA) &&
> +		    priv->btmrvl_dev.sendcmdflag) {
> 			priv->btmrvl_dev.sendcmdflag = false;
> 			priv->adapter->cmd_complete = true;
> 			wake_up_interruptible(&priv->adapter->cmd_wait_q);
> @@ -552,6 +553,132 @@ static int btmrvl_service_main_thread(void *data)
> 	return 0;
> }
> 
> +static int btmrvl_parse_cal_cfg(const u8 *src, u32 len, u8 *dst, u32 dst_size)
> +{
> +	const u8 *s = src;
> +	u8 *d = dst;
> +	int ret;
> +	u8 tmp[3];
> +
> +	tmp[2] = '\0';
> +	while ((s - src) < len) {
> +		if (isspace(*s)) {
> +			s++;
> +			continue;
> +		}
> +
> +		if (isxdigit(*s)) {
> +			if ((d - dst) >= dst_size) {
> +				BT_ERR("calibration data file too big!!!");
> +				return -EINVAL;
> +			}
> +
> +			memcpy(tmp, s, 2);
> +
> +			ret = kstrtou8(tmp, 16, d++);
> +			if (ret < 0)
> +				return ret;
> +
> +			s += 2;
> +		} else {
> +			s++;
> +		}
> +	}
> +	if (d == dst)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int btmrvl_load_cal_data(struct btmrvl_private *priv,
> +				u8 *config_data)
> +{
> +	struct sk_buff *skb;
> +	struct btmrvl_cmd *cmd;
> +	int i;
> +
> +	skb = bt_skb_alloc(sizeof(*cmd), GFP_ATOMIC);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (struct btmrvl_cmd *)skb->data;
> +	cmd->ocf_ogf =
> +		cpu_to_le16(hci_opcode_pack(OGF, BT_CMD_LOAD_CONFIG_DATA));
> +	cmd->length = BT_CMD_DATA_SIZE;
> +	cmd->data[0] = 0x00;
> +	cmd->data[1] = 0x00;
> +	cmd->data[2] = 0x00;
> +	cmd->data[3] = BT_CMD_DATA_SIZE - 4;
> +
> +	/* swap cal-data bytes */
> +	for (i = 4; i < BT_CMD_DATA_SIZE; i++)
> +		cmd->data[i] = config_data[(i/4)*8 - 1 - i];
> +
> +	bt_cb(skb)->pkt_type = MRVL_VENDOR_PKT;
> +	skb_put(skb, sizeof(*cmd));
> +	skb->dev = (void *)priv->btmrvl_dev.hcidev;
> +	skb_queue_head(&priv->adapter->tx_queue, skb);
> +	priv->btmrvl_dev.sendcmdflag = true;
> +	priv->adapter->cmd_complete = false;

since the Bluetooth HCI core got ->setup() support with proper synchronous HCI request handling available for every single driver (see the Intel support in btusb.c), why not start using that with this driver as well.

Regards

Marcel

