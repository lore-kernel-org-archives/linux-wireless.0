Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:6660 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbEHJ2x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 May 2015 05:28:53 -0400
Message-ID: <554C81D2.8080602@broadcom.com> (sfid-20150508_112901_443316_AE08279E)
Date: Fri, 8 May 2015 11:28:50 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: <brcm80211-dev-list@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH RFC:rxctl wait timed out] brcmfmac: add BCM43526 USB support
References: <1431030535-11083-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1431030535-11083-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/15 22:28, Rafał Miłecki wrote:
> Signed-off-by: Rafał Miłecki<zajec5@gmail.com>
> ---
> Hi,
>
> I'm trying to add BCM43526 support. This chipset can be found in:
> 1) Some USB dongles, e.g. Tenda W900U uses revision 2
> 2) Some routers, e.g. Asus RT-AC53U uses revision 3+
>
> Unfortunately attached patch doesn't seem to be enough, brcmfmac doesn't
> work with my Tenda W900U. I keep getting following error:
>> brcmfmac: brcmf_usb_recv_ctl Enter
>> brcmf_usb_rx_ctlpkt: rxctl wait timed out
>> brcmfmac: brcmf_fil_cmd_data Failed: -5
>
> It seems that:
> 1) driver sends TX URB and gets completion callback called
> 2) driver sents RX URB but it never gets completed
>
> This seems to happen for the very first wlioctl send to the firmware
> which is BRCMF_C_GET_VAR. I tried hacking brcmf_c_preinit_dcmds to start
> with BRCMF_C_GET_REVINFO instead, but the result is the same.
> I believe firmware simply doesn't reply to any wlioctl.
>
> I tried extracing firmware from:
> 1) Tenda W900U's bcmwlhigh6.sys
> 2) Tenda W900U's bcmwlhigh664.sys
> 3) DWA-182A1 Vistax64's bcmwlhigh664.sys
> 4) DWA-182A1 Win7x86's bcmwlhigh6.sys
>
> Firmware seems to be OK because extracting 43526b instead of 43526a
> results in:
> brcmf_usb_resetcfg: Cannot talk to Dongle. Firmware is not UP, 1000 ms
>
> Any idea what may be wrong/missing?

Hi Rafał,

Unfortunately this device is a BMAC device. You can tell by the 'high' 
word in the windows driver name. So there is no chance whatsoever to get 
this device going with brcmfmac.

Regards,
Arend

> [29078.703293] brcmfmac: brcmf_usb_probe Enter 0x0a5c:0xbd1d
> [29078.703297] brcmfmac: brcmf_usb_probe Broadcom high speed USB WLAN interface detected
> [29078.703298] brcmfmac: brcmf_usb_probe_cb Enter
> [29078.703299] brcmfmac: brcmf_usb_attach Enter
> [29078.703313] brcmfmac: brcmf_usb_dlneeded Enter
> [29078.704271] brcmfmac: brcmf_usb_dlneeded chip 43526 rev 0x2
> [29078.704276] brcmfmac: brcmf_fw_get_firmwares enter: dev=3-2
> [29078.704524] brcmfmac: brcmf_fw_request_code_done enter: dev=3-2
> [29078.704526] brcmfmac: brcmf_usb_probe_phase2 Start fw downloading
> [29078.704527] brcmfmac: check_file Enter
> [29078.704529] brcmfmac: brcmf_usb_fw_download Enter
> [29078.704530] brcmfmac: brcmf_usb_dlstart Enter
> [29078.704532] brcmfmac: brcmf_usb_dl_writeimage Enter, fw ffffc900050a8000, len 368640
> [29078.807929] brcmfmac: brcmf_usb_dl_writeimage Exit, err=0
> [29078.807932] brcmfmac: brcmf_usb_dlstart Exit, err=0
> [29078.807934] brcmfmac: brcmf_usb_dlrun Enter
> [29078.808624] brcmfmac: brcmf_usb_resetcfg Enter
> [29079.009038] brcmfmac: brcmf_usb_resetcfg postboot chip 0xa123/rev 0x1
> [29079.011264] brcmfmac: brcmf_usb_dlrun Exit
> [29079.011319] brcmfmac: brcmf_attach Enter
> [29079.011352] brcmfmac: brcmf_proto_attach Enter
> [29079.011366] brcmfmac: brcmf_usb_up Enter
> [29079.011368] brcmfmac: brcmf_usb_state_change Enter, current state=2, new state=3
> [29079.011369] brcmfmac: brcmf_usb_state_change DBUS is up
> [29079.011371] brcmfmac: brcmf_bus_change_state 0 ->  1
> [29079.011429] brcmfmac: brcmf_bus_start
> [29079.011431] brcmfmac: brcmf_add_if Enter, idx=0, ifidx=0
> [29079.011432] brcmfmac: brcmf_add_if allocate netdev interface
> [29079.011442] brcmfmac: brcmf_add_if  ==== pid:1495, if:wlan%d (00:00:00:00:00:00) created ===
> [29079.011443] brcmfmac: brcmf_bus_change_state 1 ->  1
> [29079.011446] brcmfmac: brcmf_proto_bcdc_query_dcmd Enter, cmd 262 len 20
> [29079.011447] brcmfmac: brcmf_proto_bcdc_msg Enter
>
> [29079.011449] brcmfmac: brcmf_usb_tx_ctlpkt Enter
> [29079.011450] brcmfmac: brcmf_usb_send_ctl Enter
> [29079.011491] brcmfmac: brcmf_usb_ctlwrite_complete Enter
> [29079.011494] brcmfmac: brcmf_usb_ctl_complete Enter, status=0
>
> [29079.011510] brcmfmac: brcmf_proto_bcdc_cmplt Enter
> [29079.011522] brcmfmac: brcmf_usb_rx_ctlpkt Enter
> [29079.011523] brcmfmac: brcmf_usb_recv_ctl Enter
> [29081.013165] brcmf_usb_rx_ctlpkt: rxctl wait timed out
> [29081.013170] brcmfmac: brcmf_fil_cmd_data Failed: -5
> [29081.013172] brcmfmac: brcmf_fil_iovar_data_get ifidx=0, name=cur_etheraddr, len=6
> [29081.013176] brcmf_c_preinit_dcmds: Retreiving cur_etheraddr failed, -52
> [29081.013177] brcmf_bus_start: failed: -52
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/usb.c        | 12 ++++++++++++
>   drivers/net/wireless/brcm80211/include/brcm_hw_ids.h |  2 ++
>   2 files changed, 14 insertions(+)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> index daba86d..e300c7d 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
> @@ -46,6 +46,8 @@
>   #define BRCMF_USB_43143_FW_NAME		"brcm/brcmfmac43143.bin"
>   #define BRCMF_USB_43236_FW_NAME		"brcm/brcmfmac43236b.bin"
>   #define BRCMF_USB_43242_FW_NAME		"brcm/brcmfmac43242a.bin"
> +#define BRCMF_USB_43526A_FW_NAME	"brcm/brcmfmac43526a.bin"
> +#define BRCMF_USB_43526B_FW_NAME	"brcm/brcmfmac43526b.bin"
>   #define BRCMF_USB_43569_FW_NAME		"brcm/brcmfmac43569.bin"
>
>   #define TRX_MAGIC		0x30524448	/* "HDR0" */
> @@ -993,6 +995,8 @@ static bool brcmf_usb_chip_support(int chipid, int chiprev)
>   		return (chiprev == 3);
>   	case BRCM_CC_43242_CHIP_ID:
>   		return true;
> +	case BRCM_CC_43526_CHIP_ID:
> +		return true;
>   	case BRCM_CC_43566_CHIP_ID:
>   	case BRCM_CC_43569_CHIP_ID:
>   		return true;
> @@ -1072,6 +1076,8 @@ static int check_file(const u8 *headers)
>
>   static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
>   {
> +	int chiprev = devinfo->bus_pub.chiprev;
> +
>   	switch (devinfo->bus_pub.devid) {
>   	case BRCM_CC_43143_CHIP_ID:
>   		return BRCMF_USB_43143_FW_NAME;
> @@ -1081,6 +1087,11 @@ static const char *brcmf_usb_get_fwname(struct brcmf_usbdev_info *devinfo)
>   		return BRCMF_USB_43236_FW_NAME;
>   	case BRCM_CC_43242_CHIP_ID:
>   		return BRCMF_USB_43242_FW_NAME;
> +	case BRCM_CC_43526_CHIP_ID:
> +		if (chiprev<= 2)
> +			return BRCMF_USB_43526A_FW_NAME;
> +		else
> +			return BRCMF_USB_43526B_FW_NAME;
>   	case BRCM_CC_43566_CHIP_ID:
>   	case BRCM_CC_43569_CHIP_ID:
>   		return BRCMF_USB_43569_FW_NAME;
> @@ -1461,6 +1472,7 @@ static struct usb_device_id brcmf_usb_devid_table[] = {
>   	BRCMF_USB_DEVICE(BRCM_USB_43143_DEVICE_ID),
>   	BRCMF_USB_DEVICE(BRCM_USB_43236_DEVICE_ID),
>   	BRCMF_USB_DEVICE(BRCM_USB_43242_DEVICE_ID),
> +	BRCMF_USB_DEVICE(BRCM_USB_43526_DEVICE_ID),
>   	BRCMF_USB_DEVICE(BRCM_USB_43569_DEVICE_ID),
>   	/* special entry for device with firmware loaded and running */
>   	BRCMF_USB_DEVICE(BRCM_USB_BCMFW_DEVICE_ID),
> diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> index 2124a17..56c1948 100644
> --- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
> @@ -39,6 +39,7 @@
>   #define BRCM_CC_4339_CHIP_ID		0x4339
>   #define BRCM_CC_4354_CHIP_ID		0x4354
>   #define BRCM_CC_4356_CHIP_ID		0x4356
> +#define BRCM_CC_43526_CHIP_ID		43526
>   #define BRCM_CC_43566_CHIP_ID		43566
>   #define BRCM_CC_43567_CHIP_ID		43567
>   #define BRCM_CC_43569_CHIP_ID		43569
> @@ -49,6 +50,7 @@
>   #define BRCM_USB_43143_DEVICE_ID	0xbd1e
>   #define BRCM_USB_43236_DEVICE_ID	0xbd17
>   #define BRCM_USB_43242_DEVICE_ID	0xbd1f
> +#define BRCM_USB_43526_DEVICE_ID	0xbd1d
>   #define BRCM_USB_43569_DEVICE_ID	0xbd27
>   #define BRCM_USB_BCMFW_DEVICE_ID	0x0bdc
>

