Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35327 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972AbbFJKM6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 06:12:58 -0400
Received: by igbzc4 with SMTP id zc4so31831630igb.0
        for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2015 03:12:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433923607-20927-3-git-send-email-johnny.kim@atmel.com>
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com> <1433923607-20927-3-git-send-email-johnny.kim@atmel.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 10 Jun 2015 20:12:37 +1000
Message-ID: <CAGRGNgUqO9OGDBXsVRW7CksShmH7XcHYhwghxh2ErM6Lz2kWZg@mail.gmail.com> (sfid-20150610_121301_648098_08E8BE02)
Subject: Re: [PATCH 2/4] staging: wilc1000: add syntax for 64-bit machine
To: Johnny Kim <johnny.kim@atmel.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	chris.park@atmel.com, Rachel.kim@atmel.com, dean.lee@atmel.com,
	tony.cho@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johnny,

On Wed, Jun 10, 2015 at 6:06 PM, Johnny Kim <johnny.kim@atmel.com> wrote:
> The driver take pointer value to integer value for message packet.
> So, The driver was fixed to save and load the address
> on 64-bit machine.
>
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 24 ++++++++++++++++++++----
>  drivers/staging/wilc1000/wilc_wlan.c      | 19 +++++++++++++++----
>  drivers/staging/wilc1000/wilc_wlan.h      |  6 +++++-
>  3 files changed, 40 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index cfe3364..4b005fa 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -6918,9 +6918,14 @@ void NetworkInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
>  {
>         WILC_Sint32 s32Error = WILC_SUCCESS;
>         tstrHostIFmsg strHostIFmsg;
> -       size_t drvHandler;
> +       size_t drvHandler = 0;
>         tstrWILC_WFIDrv *pstrWFIDrv = NULL;
>
> +#ifdef CONFIG_64BIT
> +       drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
> +       drvHandler <<= 32;
> +#endif
> +

This does nothing as it's overwritten in the next line.

>         drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
>         pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
>
> @@ -6968,13 +6973,18 @@ void GnrlAsyncInfoReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
>  {
>         WILC_Sint32 s32Error = WILC_SUCCESS;
>         tstrHostIFmsg strHostIFmsg;
> -       size_t drvHandler;
> +       size_t drvHandler = 0;
>         tstrWILC_WFIDrv *pstrWFIDrv = NULL;
>
>         /*BugID_5348*/
>         down(&hSemHostIntDeinit);
>
> -       drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
> +#ifdef CONFIG_64BIT
> +       drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
> +       drvHandler <<= 32;
> +#endif
> +
> +       drvHandler |= ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
>         pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
>         PRINT_D(HOSTINF_DBG, "General asynchronous info packet received \n");
>
> @@ -7031,8 +7041,14 @@ void host_int_ScanCompleteReceived(u8 *pu8Buffer, WILC_Uint32 u32Length)
>  {
>         WILC_Sint32 s32Error = WILC_SUCCESS;
>         tstrHostIFmsg strHostIFmsg;
> -       size_t drvHandler;
> +       size_t drvHandler = 0;
>         tstrWILC_WFIDrv *pstrWFIDrv = NULL;
> +
> +#ifdef CONFIG_64BIT
> +       drvHandler = ((pu8Buffer[u32Length - 8]) | (pu8Buffer[u32Length - 7] << 8) | (pu8Buffer[u32Length - 6] << 16) | (pu8Buffer[u32Length - 5] << 24));
> +       drvHandler <<= 32;
> +#endif
> +

Same here.

>         drvHandler = ((pu8Buffer[u32Length - 4]) | (pu8Buffer[u32Length - 3] << 8) | (pu8Buffer[u32Length - 2] << 16) | (pu8Buffer[u32Length - 1] << 24));
>         pstrWFIDrv = (tstrWILC_WFIDrv *)drvHandler;
>
> diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
> index 739be55..d20ffe0 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.c
> +++ b/drivers/staging/wilc1000/wilc_wlan.c
> @@ -1867,7 +1867,7 @@ static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
>  {
>         wilc_wlan_dev_t *p = (wilc_wlan_dev_t *)&g_wlan;
>         wilc_cfg_frame_t *cfg = &p->cfg_frame;
> -       int total_len = p->cfg_frame_offset + 4 + DRIVER_HANDLER_SIZE;
> +       int total_len = p->cfg_frame_offset + sizeof(size_t) + DRIVER_HANDLER_SIZE;
>         int seq_no = p->cfg_seq_no % 256;
>         size_t driver_handler = (size_t)drvHandler;
>
> @@ -1883,10 +1883,21 @@ static int wilc_wlan_cfg_commit(int type, size_t drvHandler)
>         cfg->wid_header[1] = seq_no;    /* sequence number */
>         cfg->wid_header[2] = (uint8_t)total_len;
>         cfg->wid_header[3] = (uint8_t)(total_len >> 8);
> +#ifdef CONFIG_64BIT
>         cfg->wid_header[4] = (uint8_t)driver_handler;
> -       cfg->wid_header[5] = (uint8_t)(driver_handler >> 8);
> -       cfg->wid_header[6] = (uint8_t)(driver_handler >> 16);
> -       cfg->wid_header[7] = (uint8_t)(driver_handler >> 24);
> +       cfg->wid_header[5] = (uint8_t)(driver_handler >> 8L);
> +       cfg->wid_header[6] = (uint8_t)(driver_handler >> 16L);
> +       cfg->wid_header[7] = (uint8_t)(driver_handler >> 24L);
> +       cfg->wid_header[8] = (uint8_t)(driver_handler >> 32L);
> +       cfg->wid_header[9] = (uint8_t)(driver_handler >> 40L);
> +       cfg->wid_header[10] = (uint8_t)(driver_handler >> 48L);
> +       cfg->wid_header[11] = (uint8_t)(driver_handler >> 56L);
> +#else
> +       cfg->wid_header[4] = (uint8_t)driver_handler;
> +       cfg->wid_header[5] = (uint8_t)(driver_handler >> 8L);
> +       cfg->wid_header[6] = (uint8_t)(driver_handler >> 16L);
> +       cfg->wid_header[7] = (uint8_t)(driver_handler >> 24L);
> +#endif
>         p->cfg_seq_no = seq_no;
>
>         /**
> diff --git a/drivers/staging/wilc1000/wilc_wlan.h b/drivers/staging/wilc1000/wilc_wlan.h
> index 0ba7ec6..e026baf 100644
> --- a/drivers/staging/wilc1000/wilc_wlan.h
> +++ b/drivers/staging/wilc1000/wilc_wlan.h
> @@ -15,7 +15,11 @@
>  #define DRIVER_HANDLER_SIZE 4
>  #define MAX_MAC_HDR_LEN         26 /* QOS_MAC_HDR_LEN */
>  #define SUB_MSDU_HEADER_LENGTH  14
> +#ifdef CONFIG_64BIT
> +#define SNAP_HDR_LEN            12
> +#else
>  #define SNAP_HDR_LEN            8
> +#endif
>  #define ETHERNET_HDR_LEN          14
>  #define WORD_ALIGNMENT_PAD        0
>
> @@ -297,7 +301,7 @@ typedef struct {
>         uint8_t ether_header[14];
>         uint8_t ip_header[20];
>         uint8_t udp_header[8];
> -       uint8_t wid_header[8];
> +       uint8_t wid_header[4+sizeof(uintptr_t)];
>         uint8_t frame[MAX_CFG_FRAME_SIZE];
>  } wilc_cfg_frame_t;

How about you turn wid_header into a proper struct with a function
pointer instead of adding horrible hacks on top of already horrible
code?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
