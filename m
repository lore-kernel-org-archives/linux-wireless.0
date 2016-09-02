Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:52770 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750992AbcIBHj4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 03:39:56 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: Brian Norris <briannorris@chromium.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [v4,1/2] mwifiex: add manufacturing mode support
Date: Fri, 2 Sep 2016 07:39:20 +0000
Message-ID: <29070775a9ed4977aed3a5617778d5ae@SC-EXCH04.marvell.com> (sfid-20160902_094001_753104_4A0E5E38)
References: <1469525960-6643-1-git-send-email-akarwar@marvell.com>
 <20160831193441.GA30908@localhost>
In-Reply-To: <20160831193441.GA30908@localhost>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Brian,

> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Thursday, September 01, 2016 1:05 AM
> To: Amitkumar Karwar
> Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam
> Subject: Re: [v4,1/2] mwifiex: add manufacturing mode support
> 
> Hi,
> 
> On Tue, Jul 26, 2016 at 03:09:19PM +0530, Amitkumar Karwar wrote:
> > By default normal mode is chosen when driver is loaded. This patch
> > adds a provision to choose manufacturing mode via module parameters.
> >
> > Below command loads driver in manufacturing mode insmod mwifiex.ko
> > mfg_mode=1.
> >
> > Tested-by: chunfan chen <jeffc@marvell.com>
> > Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> > ---
> > v4: Removed mfg_firmware module parameter and hardcoded the firmware
> name
> >     in driver(Kalle Valo).
> > ---
> >  drivers/net/wireless/marvell/mwifiex/cmdevt.c |  8 ++++++++
> >  drivers/net/wireless/marvell/mwifiex/init.c   | 22 +++++++++++++++---
> ----
> >  drivers/net/wireless/marvell/mwifiex/main.c   | 25
> +++++++++++++++++++++----
> >  drivers/net/wireless/marvell/mwifiex/main.h   |  2 ++
> >  drivers/net/wireless/marvell/mwifiex/pcie.c   |  2 +-
> >  drivers/net/wireless/marvell/mwifiex/sdio.c   |  2 +-
> >  drivers/net/wireless/marvell/mwifiex/usb.c    |  2 +-
> >  7 files changed, 49 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> > b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> > index d433aa0..636cfa0 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
> > @@ -595,6 +595,14 @@ int mwifiex_send_cmd(struct mwifiex_private
> *priv, u16 cmd_no,
> >  			return -1;
> >  		}
> >  	}
> > +	/* We don't expect commands in manufacturing mode. They are cooked
> > +	 * in application and ready to download buffer is passed to the
> driver
> > +	*/
> 
> You have the alignment wrong here. Needs an extra space.
> 
> > +	if (adapter->mfg_mode && cmd_no) {
> > +		dev_dbg(adapter->dev, "Ignoring commands in manufacturing
> mode\n");
> > +		return -1;
> > +	}
> > +
> >
> >  	/* Get a new command node */
> >  	cmd_node = mwifiex_get_cmd_node(adapter); diff --git
> > a/drivers/net/wireless/marvell/mwifiex/init.c
> > b/drivers/net/wireless/marvell/mwifiex/init.c
> > index 1489c90..82839d9 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/init.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/init.c
> > @@ -298,6 +298,7 @@ static void mwifiex_init_adapter(struct
> mwifiex_adapter *adapter)
> >  	memset(&adapter->arp_filter, 0, sizeof(adapter->arp_filter));
> >  	adapter->arp_filter_size = 0;
> >  	adapter->max_mgmt_ie_index = MAX_MGMT_IE_INDEX;
> > +	adapter->mfg_mode = mfg_mode;
> >  	adapter->key_api_major_ver = 0;
> >  	adapter->key_api_minor_ver = 0;
> >  	eth_broadcast_addr(adapter->perm_addr);
> > @@ -553,15 +554,22 @@ int mwifiex_init_fw(struct mwifiex_adapter
> *adapter)
> >  				return -1;
> >  		}
> >  	}
> > +	if (adapter->mfg_mode) {
> > +		adapter->hw_status = MWIFIEX_HW_STATUS_READY;
> > +		ret = -EINPROGRESS;
> > +	} else {
> > +		for (i = 0; i < adapter->priv_num; i++) {
> > +			if (adapter->priv[i]) {
> > +				ret = mwifiex_sta_init_cmd(adapter->priv[i],
> > +							   first_sta, true);
> > +				if (ret == -1)
> > +					return -1;
> > +
> > +				first_sta = false;
> > +			}
> > +
> >
> > -	for (i = 0; i < adapter->priv_num; i++) {
> > -		if (adapter->priv[i]) {
> > -			ret = mwifiex_sta_init_cmd(adapter->priv[i],
> first_sta,
> > -						   true);
> > -			if (ret == -1)
> > -				return -1;
> >
> > -			first_sta = false;
> >  		}
> >  	}
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/main.c
> > b/drivers/net/wireless/marvell/mwifiex/main.c
> > index db4925d..7fbf74b 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/main.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.c
> > @@ -23,6 +23,7 @@
> >  #include "11n.h"
> >
> >  #define VERSION	"1.0"
> > +#define MFG_FIRMWARE	"mwifiex_mfg.bin"
> >
> >  static unsigned int debug_mask = MWIFIEX_DEFAULT_DEBUG_MASK;
> > module_param(debug_mask, uint, 0); @@ -36,6 +37,9 @@ static unsigned
> > short driver_mode;  module_param(driver_mode, ushort, 0);
> > MODULE_PARM_DESC(driver_mode,
> >  		 "station=0x1(default), ap-sta=0x3, station-p2p=0x5,
> > ap-sta-p2p=0x7");
> > +bool mfg_mode;
> 
> Does this really need to be global? It's only actually used in init.c,
> so could it help to move it to init.c and make it static?

We also use mfg_mode in main.c(mwifiex_init_hw_fw), so it can't be moved to init.s

> 
> > +module_param(mfg_mode, bool, 0);
> > +MODULE_PARM_DESC(mfg_mode, "0:disable 1:enable (bool)");
> 
> That's not a very helpful description. Perhaps you could mention in a
> word or two what this mode means?
> 
> Brian

Thanks. I just submitted v5 patches addressing your comments.

Regards,
Amitkumar Karwar

> 
> >
> >  /*
> >   * This function registers the device and performs all the necessary
> > @@ -559,10 +563,12 @@ static void mwifiex_fw_dpc(const struct firmware
> *firmware, void *context)
> >  		goto done;
> >  	}
> >  	/* Wait for mwifiex_init to complete */
> > -	wait_event_interruptible(adapter->init_wait_q,
> > -				 adapter->init_wait_q_woken);
> > -	if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
> > -		goto err_init_fw;
> > +	if (!adapter->mfg_mode) {
> > +		wait_event_interruptible(adapter->init_wait_q,
> > +					 adapter->init_wait_q_woken);
> > +		if (adapter->hw_status != MWIFIEX_HW_STATUS_READY)
> > +			goto err_init_fw;
> > +	}
> >
> >  	priv = adapter->priv[MWIFIEX_BSS_ROLE_STA];
> >  	if (mwifiex_register_cfg80211(adapter)) { @@ -666,6 +672,17 @@
> > static int mwifiex_init_hw_fw(struct mwifiex_adapter *adapter)  {
> >  	int ret;
> >
> > +	/* Override default firmware with manufacturing one if
> > +	 * manufacturing mode is enabled
> > +	 */
> > +	if (mfg_mode) {
> > +		if (strlcpy(adapter->fw_name, MFG_FIRMWARE,
> > +			    sizeof(adapter->fw_name)) >=
> > +			    sizeof(adapter->fw_name)) {
> > +			pr_err("%s: fw_name too long!\n", __func__);
> > +			return -1;
> > +		}
> > +	}
> >  	ret = request_firmware_nowait(THIS_MODULE, 1, adapter->fw_name,
> >  				      adapter->dev, GFP_KERNEL, adapter,
> >  				      mwifiex_fw_dpc);
> > diff --git a/drivers/net/wireless/marvell/mwifiex/main.h
> > b/drivers/net/wireless/marvell/mwifiex/main.h
> > index 5902600..fcc2af35 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/main.h
> > +++ b/drivers/net/wireless/marvell/mwifiex/main.h
> > @@ -58,6 +58,7 @@
> >  #include "sdio.h"
> >
> >  extern const char driver_version[];
> > +extern bool mfg_mode;
> >
> >  struct mwifiex_adapter;
> >  struct mwifiex_private;
> > @@ -990,6 +991,7 @@ struct mwifiex_adapter {
> >  	u32 drv_info_size;
> >  	bool scan_chan_gap_enabled;
> >  	struct sk_buff_head rx_data_q;
> > +	bool mfg_mode;
> >  	struct mwifiex_chan_stats *chan_stats;
> >  	u32 num_in_chan_stats;
> >  	int survey_idx;
> > diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > index 453ab6a..a6af85d 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/pcie.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
> > @@ -225,7 +225,7 @@ static void mwifiex_pcie_remove(struct pci_dev
> *pdev)
> >  	if (!adapter || !adapter->priv_num)
> >  		return;
> >
> > -	if (user_rmmod) {
> > +	if (user_rmmod && !adapter->mfg_mode) {
> >  #ifdef CONFIG_PM_SLEEP
> >  		if (adapter->is_suspended)
> >  			mwifiex_pcie_resume(&pdev->dev);
> > diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > index d3e1561..6dba409 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/sdio.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
> > @@ -289,7 +289,7 @@ mwifiex_sdio_remove(struct sdio_func *func)
> >
> >  	mwifiex_dbg(adapter, INFO, "info: SDIO func num=%d\n", func->num);
> >
> > -	if (user_rmmod) {
> > +	if (user_rmmod && !adapter->mfg_mode) {
> >  		if (adapter->is_suspended)
> >  			mwifiex_sdio_resume(adapter->dev);
> >
> > diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c
> > b/drivers/net/wireless/marvell/mwifiex/usb.c
> > index 0857575..ba616ec 100644
> > --- a/drivers/net/wireless/marvell/mwifiex/usb.c
> > +++ b/drivers/net/wireless/marvell/mwifiex/usb.c
> > @@ -611,7 +611,7 @@ static void mwifiex_usb_disconnect(struct
> usb_interface *intf)
> >  	if (!adapter->priv_num)
> >  		return;
> >
> > -	if (user_rmmod) {
> > +	if (user_rmmod && !adapter->mfg_mode) {
> >  #ifdef CONFIG_PM
> >  		if (adapter->is_suspended)
> >  			mwifiex_usb_resume(intf);
