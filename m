Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:37839 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbcE0UBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 16:01:11 -0400
Received: by mail-wm0-f47.google.com with SMTP id z87so5001889wmh.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 13:01:10 -0700 (PDT)
Subject: Re: [RFCv2] brcmfmac: Add tracepoints for bcmdhd-dissector tool
To: Mikael Kanstrup <mikael.kanstrup@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
References: <CACZXzRAVUoStnsBfAsPipangkPmXjUg4vYxENMEb15tnYjxk-g@mail.gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <af9e3eac-ac88-56e0-d35c-61a781bdef54@broadcom.com> (sfid-20160527_220115_725824_3723E1D1)
Date: Fri, 27 May 2016 22:01:02 +0200
MIME-Version: 1.0
In-Reply-To: <CACZXzRAVUoStnsBfAsPipangkPmXjUg4vYxENMEb15tnYjxk-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27-5-2016 16:24, Mikael Kanstrup wrote:
> Add hexdump tracepoints to be used bcmdhd-dissector:
>   https://github.com/kanstrup/bcmdhd-dissector
> 
> bcmdhd-dissector is a Wireshark LUA plugin dissector used to decode
> protocol data between the brcmfmac driver and the wifi chip firmware.
> This includes decoding firmware command requests and responses as
> well as events and even tx/rx data interleaved if the data_dump
> tracepoint is enabled.

I really don't know what to think of this. Adding tracepoints that do
perform a memcpy() makes me want to push back. Also there are already
tracepoints that capture bus protocol data. So I think it is better to
see if you can use those and use the trace-cmd plugin to add ether
header encapsulation. I have looked at your patch so there are some
comments below.

> Signed-off-by: Mikael Kanstrup <mikael.kanstrup@gmail.com>
> ---
> v2:
> - Add description of bcmdhd-dissector as suggested by Rafał
> - Fix tx/rx data dump.
> - Fix tx data dump on USB interface.
> 
> Also updated the github project page with some screenshots.
> 
>  .../wireless/broadcom/brcm80211/brcmfmac/bcdc.c    |  4 ++
>  .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |  2 +
>  .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  1 +
>  .../wireless/broadcom/brcm80211/brcmfmac/debug.c   | 54 ++++++++++++++++++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/debug.h   | 15 ++++++
>  .../wireless/broadcom/brcm80211/brcmfmac/fweh.c    |  2 +
>  .../broadcom/brcm80211/brcmfmac/tracepoint.h       | 33 +++++++++++++
>  .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  3 ++
>  8 files changed, 114 insertions(+)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> index 6af658e..197942c 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> @@ -134,6 +134,8 @@ brcmf_proto_bcdc_msg(struct brcmf_pub *drvr, int
> ifidx, uint cmd, void *buf,
>   if (len > BRCMF_TX_IOCTL_MAX_MSG_SIZE)
>   len = BRCMF_TX_IOCTL_MAX_MSG_SIZE;
> 
> + brcmf_dbg_dissect_dump(BRCMF_DISSECT_IOCTL, 1, &bcdc->msg, len);
> +

Not sure what happened but your indentation has gone bonkers. Better fix it.

>   /* Send request */
>   return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg, len);
>  }
> @@ -152,6 +154,8 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub
> *drvr, u32 id, u32 len)
>   break;
>   } while (BCDC_DCMD_ID(le32_to_cpu(bcdc->msg.flags)) != id);
> 
> + brcmf_dbg_dissect_dump(BRCMF_DISSECT_IOCTL, 0, &bcdc->msg, len);
> +
>   return ret;
>  }
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> index da0cdd3..1dc91ea 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> @@ -782,6 +782,8 @@ int brcmf_sdiod_send_pkt(struct brcmf_sdio_dev *sdiodev,
>   addr, skb);
>   if (err)
>   break;
> + brcmf_dbg_dissect_data_dump(skb->data + 0x1a,
> +    skb->len - 0x1a);

Better come up with a reasonable define for that 0x1a value. Just seems
like the wrong place to put the trace. Why not in core.c in the
.start_xmit() callback or can this call sleep?

>   }
>   else
>   err = brcmf_sdiod_sglist_rw(sdiodev, SDIO_FUNC_2, true, addr,
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> index ff825cd..3415170 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
> @@ -548,6 +548,7 @@ void brcmf_rx_frame(struct device *dev, struct sk_buff *skb)
> 
>   /* process and remove protocol-specific header */
>   ret = brcmf_proto_hdrpull(drvr, true, skb, &ifp);
> + brcmf_dbg_dissect_data_dump(skb->data, skb->len);

Again the wrong place. Better put it just before netif_rx() call.

>   if (ret || !ifp || !ifp->ndev) {
>   if (ret != -ENODATA && ifp)
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> index e64557c..d0b078a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
> @@ -24,6 +24,7 @@
>  #include "bus.h"
>  #include "fweh.h"
>  #include "debug.h"
> +#include "tracepoint.h"
> 
>  static struct dentry *root_folder;
> 
> @@ -109,3 +110,56 @@ int brcmf_debugfs_add_entry(struct brcmf_pub
> *drvr, const char *fn,
>   drvr->dbgfs_dir, read_fn);
>   return PTR_ERR_OR_ZERO(e);
>  }
> +
> +static u8 brcmf_dbg_dump_buf[0x0e + BRCMF_DCMD_MAXLEN];

Don't use a global. There are people out there who have more than one
brcmfmac device running on their system.

> +int brcmf_dbg_dissect_dump(int type, int tx, void *data, int len)

just make this function void as you only return 0 below in every
possible code path.

> +{
> + /* These are ethernet headers with ethertype BC01, BC02, BC03 */
> + static const u8 event_hdr[] = {
> + 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff,
> + 0x00, 0x01, 0x01, 0x01, 0x01, 0x01,
> + 0xbc, 0x01 };
> + static const u8 ioctl_out_hdr[] = {
> + 0x00, 0x01, 0x01, 0x01, 0x01, 0x01,
> + 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff,
> + 0xbc, 0x02 };
> + static const u8 ioctl_in_hdr[] = {
> + 0xfc, 0xff, 0xff, 0xff, 0xff, 0xff,
> + 0x00, 0x01, 0x01, 0x01, 0x01, 0x01,
> + 0xbc, 0x03 };
> + const u8 *hdr;
> +
> + if (!trace_brcmf_dissect_hexdump_enabled())
> + return 0;
> +
> + switch (type) {
> + case BRCMF_DISSECT_IOCTL:
> + hdr = tx ? ioctl_out_hdr : ioctl_in_hdr;
> + break;
> + case BRCMF_DISSECT_EVENT:
> + /* If data dump is enabled all events will be
> + * logged through data path so don't do it here
> + */
> + if (trace_brcmf_dissect_data_hexdump_enabled())
> + return 0;
> + hdr = event_hdr;
> + break;
> + default:
> + return -EINVAL;
> + }
> +
> + memcpy(brcmf_dbg_dump_buf, hdr, 0x0e);

Is 0x0e maybe same as ETH_HLEN?

> + memcpy(brcmf_dbg_dump_buf + 0x0e, data, len);
> + trace_brcmf_dissect_hexdump(brcmf_dbg_dump_buf, len + 0x0e);
> + return 0;
> +}
> +
> +int brcmf_dbg_dissect_data_dump(void *data, int len)

make it void.

> +{
> + if (!trace_brcmf_dissect_data_hexdump_enabled())
> + return 0;
> +
> + trace_brcmf_dissect_data_hexdump(data, len);
> + return 0;
> +}
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> index 6687812..b889db8 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
> @@ -41,6 +41,9 @@
>  #define BRCMF_PCIE_VAL 0x00080000
>  #define BRCMF_FWCON_VAL 0x00100000
> 
> +#define BRCMF_DISSECT_IOCTL 0
> +#define BRCMF_DISSECT_EVENT 1
> +
>  /* set default print format */
>  #undef pr_fmt
>  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> @@ -116,6 +119,8 @@ void brcmf_debug_detach(struct brcmf_pub *drvr);
>  struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
>  int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
>      int (*read_fn)(struct seq_file *seq, void *data));
> +int brcmf_dbg_dissect_dump(int type, int tx, void *data, int len);
> +int brcmf_dbg_dissect_data_dump(void *data, int len);

just make it void functions.

Regards,
Arend
