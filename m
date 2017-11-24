Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-by2nam01on0104.outbound.protection.outlook.com ([104.47.34.104]:33519
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751834AbdKXGfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Nov 2017 01:35:44 -0500
Subject: Re: [PATCH] brcmfmac: transfer firmware error to Linux error code in
 fwil
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        kvalo@codeaurora.org, chi-hsien.lin@cypress.com
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
References: <1511341876-10198-1-git-send-email-wright.feng@cypress.com>
 <5A16A5D2.8020600@broadcom.com>
From: Wright Feng <wright.feng@cypress.com>
Message-ID: <3874d5a7-ff87-a7d9-8ecd-e50db80b93d8@cypress.com> (sfid-20171124_073617_152338_E0CD387E)
Date: Fri, 24 Nov 2017 14:35:22 +0800
MIME-Version: 1.0
In-Reply-To: <5A16A5D2.8020600@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On 2017/11/23 下午 06:41, Arend van Spriel wrote:
> On 11/22/2017 10:11 AM, Wright Feng wrote:
>> fil_cmd_data_set and fil_cmd_data_get return proprietary error code
>> when getting error from firmware layer. The vendor tools or utilities
>> that uses libnl may stuck in some commands when wl is down.
>> For example, issue "scan" command after issuing "down" command, the
>> "scan" command will be the blocking call and stuck as no response from
>> libnl. It is caused by that firmware returns BCME_NOTUP(-4) when wl
>> is down, but the -4 is -EINTR in Linux kernel, so libnl catches the
>> error and not passes to upper layer.
>> Because of that, the fwil should return Linux error code instead of
>> the proprietary error code, and the tools or utilities should get the
>> real firmware error code by command "bcmerror" or "bcmerrorstr" after
>> receiving the error from libnl.
> 
> Hi Wright,
> 
> I recall you had a discussion (on the wireless list?) with Franky about 
> this, but I did not chime in at that time. I am not a proponent for 
> mapping our firmware errors to linux errors. It is tempting to do so 
> because there is clear overlap for some, but still it is quirky and has 
> no value in my opinion. This issue was already addressed in the past 
> although not specifically for fixing the -EINTR case. I did some digging 
> in the git history. Here was my original change:
Yes, Franky and I had a discussion in "[PATCH] brcmfmac: return -EPERM 
when getting error in vendor command handler" on wireless list, that's 
why I made a new patch for mapping firmware error code to Linux error. 
Like you said, some of firmware errors do not have good corresponding 
value in Linux, so returning generic error is good to me.
> 
> commit 9c6476668025e76a8365be783f2649fe3259b91c
> Author: Arend van Spriel <arend@broadcom.com>
> Date:   Tue Oct 28 14:56:09 2014 +0100
> 
>      brcmfmac: do not use firmware error code in driver
> 
>      Passing the firmware error codes up the driver may be mapped to
>      linux error numbers which may impact proper fault analysis. So
>      better pass up a generic failure code, ie. -EBADE and only show
>      firmware error code in FIL debug message.
> 
>      Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>      Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>      Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
>      Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>      Signed-off-by: Arend van Spriel <arend@broadcom.com>
>      Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> The idea here was to have a single error code and have a debug message 
> showing the firmware error string. This single error code could be used 
> by vendor tools (not really an upstream concern) to query the driver for 
> the firmware error code through a vendor specific command.
> 
> Now what happened is that Hante while inspecting logs with only error 
> messages observed -EBADE and wanted to know firmware error. So he made 
> the following patch a year later:
> 
> commit 21000b3f3da45a5a33de3815f3c2b3584102960e
> Author: Hante Meuleman <meuleman@broadcom.com>
> Date:   Wed Nov 25 11:32:38 2015 +0100
> 
>      brcmfmac: Return actual error by fwil.
> 
>      FWIL is always mapping back errors to EBADE. This is not very
>      conventient when trying to understand problems by reading logs.
>      Some callers print the error code, but that is quite useless
>      when the exact error code is not returned. It also makes it
>      impossible to differentiate based on error code. This patch
>      changes the return of EBADE into the actual error code.
> 
>      Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>      Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>      Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>      Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>      Signed-off-by: Arend van Spriel <arend@broadcom.com>
>      Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> However, the consequence of this was that we ended up returning firmware 
> error codes into the kernel domain and user-space >
> Below the change I came up with. Let me know what you think.
Thanks for the info, now I know the whole history.
And I have 2 comments below.
> 
> Regards,
> Arend
> ---8<--------------------------------------------------------
> commit e340892a4bb5a74248b19504bb972497d38a4a03
> Author: Arend van Spriel <arend.vanspriel@broadcom.com>
> Date:   Thu Nov 23 11:13:41 2017 +0100
> 
>      brcmfmac: separate firmware errors from i/o errors
> 
>      When using the firmware api it can fail simply because firmware does
>      not like the request or it fails due to issues in the host interface.
>      Currently, there is only a single error code which is confusing. So
>      adding a parameter to pass the firmware error separately and in case
>      of a firmware error always return -EBADE to user-space.
> 
>      Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
>      Reviewed-by: Pieter-Paul Giesberts 
> <pieter-paul.giesberts@broadcom.com>
>      Reviewed-by: Franky Lin <franky.lin@broadcom.com>
>      Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> index 9f2d0b0..353ed28 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcdc.c
> @@ -165,7 +165,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub 
> *drvr, u32 id, u32 len)
> 
>   static int
>   brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
> -                void *buf, uint len)
> +                void *buf, uint len, int *fwerr)
>   {
>       struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
>       struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
> @@ -175,6 +175,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub 
> *drvr, u32 id, u32 len)
> 
>       brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
> 
> +    *fwerr = 0;
>       ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, false);
>       if (ret < 0) {
>           brcmf_err("brcmf_proto_bcdc_msg failed w/status %d\n",
> @@ -211,17 +212,18 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub 
> *drvr, u32 id, u32 len)
>           memcpy(buf, info, len);
>       }
> 
> +    ret = 0;
> +
>       /* Check the ERROR flag */
>       if (flags & BCDC_DCMD_ERROR)
> -        ret = le32_to_cpu(msg->status);
> -
> +        *fwerr = le32_to_cpu(msg->status);
>   done:
>       return ret;
>   }
> 
>   static int
>   brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
> -              void *buf, uint len)
> +              void *buf, uint len, int *fwerr)
>   {
>       struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
>       struct brcmf_proto_bcdc_dcmd *msg = &bcdc->msg;
> @@ -230,6 +232,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub 
> *drvr, u32 id, u32 len)
> 
>       brcmf_dbg(BCDC, "Enter, cmd %d len %d\n", cmd, len);
> 
> +    *fwerr = 0;
>       ret = brcmf_proto_bcdc_msg(drvr, ifidx, cmd, buf, len, true);
>       if (ret < 0)
>           goto done;
> @@ -251,7 +254,7 @@ static int brcmf_proto_bcdc_cmplt(struct brcmf_pub 
> *drvr, u32 id, u32 len)
> 
Does it exist any possible case or set command that causes the ret value 
is greater than 0? The positive ret value may be identified as error 
because following check is removed from brcmf_fil_cmd_data function.
	if (err >= 0)
		return 0;


>       /* Check the ERROR flag */
>       if (flags & BCDC_DCMD_ERROR)
> -        ret = le32_to_cpu(msg->status);
> +        *fwerr = le32_to_cpu(msg->status);
> 
>   done:
>       return ret;
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
> index f6a2df9..688f256 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil.c
> @@ -107,7 +107,7 @@ static const char *brcmf_fil_get_errstr(u32 err)
>   brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, 
> bool set)
>   {
>       struct brcmf_pub *drvr = ifp->drvr;
> -    s32 err;
> +    s32 err, fwerr;
> 
>       if (drvr->bus_if->state != BRCMF_BUS_UP) {
>           brcmf_err("bus is down. we have nothing to do.\n");
> @@ -117,16 +117,17 @@ static const char *brcmf_fil_get_errstr(u32 err)
>       if (data != NULL)
>           len = min_t(uint, len, BRCMF_DCMD_MAXLEN);
>       if (set)
> -        err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd, data, len);
> +        err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd,
> +                       data, len, &fwerr);
>       else
> -        err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len);
> -
> -    if (err >= 0)
> -        return 0;
> -
> -    brcmf_dbg(FIL, "Failed: %s (%d)\n",
> -          brcmf_fil_get_errstr((u32)(-err)), err);
> +        err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd,
> +                         data, len, &fwerr);
> 
> +    if (fwerr < 0) {
> +        brcmf_dbg(FIL, "Firmware error: %s (%d)\n",
> +              brcmf_fil_get_errstr((u32)(-fwerr)), fwerr);
> +        err = -EBADE;
> +    }
>       return err;
>   }
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> index d2c834c..e212a79 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
> @@ -477,7 +477,7 @@ static void brcmf_msgbuf_ioctl_resp_wake(struct 
> brcmf_msgbuf *msgbuf)
> 
> 
>   static int brcmf_msgbuf_query_dcmd(struct brcmf_pub *drvr, int ifidx,
> -                   uint cmd, void *buf, uint len)
> +                   uint cmd, void *buf, uint len, int *fwerr)
>   {
>       struct brcmf_msgbuf *msgbuf = (struct brcmf_msgbuf *)drvr->proto->pd;
>       struct sk_buff *skb = NULL;
> @@ -485,6 +485,7 @@ static int brcmf_msgbuf_query_dcmd(struct brcmf_pub 
> *drvr, int ifidx,
>       int err;
> 
>       brcmf_dbg(MSGBUF, "ifidx=%d, cmd=%d, len=%d\n", ifidx, cmd, len);
> +    *fwerr = 0;
>       msgbuf->ctl_completed = false;
>       err = brcmf_msgbuf_tx_ioctl(drvr, ifidx, cmd, buf, len);
>       if (err)
> @@ -508,14 +509,15 @@ static int brcmf_msgbuf_query_dcmd(struct 
> brcmf_pub *drvr, int ifidx,
>       }
>       brcmu_pkt_buf_free_skb(skb);
> 
> -    return msgbuf->ioctl_resp_status;
> +    *fwerr = msgbuf->ioctl_resp_status;
> +    return 0;
>   }
> 
> 
>   static int brcmf_msgbuf_set_dcmd(struct brcmf_pub *drvr, int ifidx,
> -                 uint cmd, void *buf, uint len)
> +                 uint cmd, void *buf, uint len, int *fwerr)
>   {
> -    return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len);
> +    return brcmf_msgbuf_query_dcmd(drvr, ifidx, cmd, buf, len, fwerr);
>   }
> 
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h 
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
> index 2404f8a..8a8e08f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/proto.h
> @@ -30,9 +30,9 @@ struct brcmf_proto {
>       int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws,
>                  struct sk_buff *skb, struct brcmf_if **ifp);
>       int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
> -              void *buf, uint len);
> +              void *buf, uint len, int *fwerr);
>       int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void 
> *buf,
> -            uint len);
> +            uint len, int *fwerr);
>       int (*tx_queue_data)(struct brcmf_pub *drvr, int ifidx,
>                    struct sk_buff *skb);
>       int (*txdata)(struct brcmf_pub *drvr, int ifidx, u8 offset,
> @@ -71,14 +71,16 @@ static inline int brcmf_proto_hdrpull(struct 
> brcmf_pub *drvr, bool do_fws,
>       return drvr->proto->hdrpull(drvr, do_fws, skb, ifp);
>   }
>   static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int 
> ifidx,
> -                     uint cmd, void *buf, uint len)
> +                     uint cmd, void *buf, uint len,
> +                     int *fwerr)
>   {
> -    return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len);
> +    return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len,fwerr);
A blank space is missing before fwerr.
>   }
>   static inline int brcmf_proto_set_dcmd(struct brcmf_pub *drvr, int ifidx,
> -                       uint cmd, void *buf, uint len)
> +                       uint cmd, void *buf, uint len,
> +                       int *fwerr)
>   {
> -    return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len);
> +    return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len, fwerr);
>   }
> 
>   static inline int brcmf_proto_tx_queue_data(struct brcmf_pub *drvr, 
> int ifidx,
> 
