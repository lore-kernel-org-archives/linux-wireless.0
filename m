Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:32841 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756401AbdGLLtj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Jul 2017 07:49:39 -0400
Received: by mail-qk0-f182.google.com with SMTP id a66so4990930qkb.0
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jul 2017 04:49:39 -0700 (PDT)
Message-ID: <59660CC3.9030809@broadcom.com> (sfid-20170712_134945_365012_E2DCBB39)
Date: Wed, 12 Jul 2017 13:49:23 +0200
From: Arend van Spriel <arend.vanspriel@broadcom.com>
MIME-Version: 1.0
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH V2] brcmfmac: fix possible buffer overflow in brcmf_cfg80211_mgmt_tx()
References: <1499458154-18358-1-git-send-email-arend.vanspriel@broadcom.com>
In-Reply-To: <1499458154-18358-1-git-send-email-arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/7/2017 10:09 PM, Arend van Spriel wrote:
> The lower level nl80211 code in cfg80211 ensures that "len" is between
> 25 and NL80211_ATTR_FRAME (2304).  We subtract DOT11_MGMT_HDR_LEN (24) from
> "len" so thats's max of 2280.  However, the action_frame->data[] buffer is
> only BRCMF_FIL_ACTION_FRAME_SIZE (1800) bytes long so this memcpy() can
> overflow.
>
> 	memcpy(action_frame->data, &buf[DOT11_MGMT_HDR_LEN],
> 	       le16_to_cpu(action_frame->len));
>
> Cc: stable@vger.kernel.org # 3.9.x
> Fixes: 18e2f61db3b70 ("brcmfmac: P2P action frame tx.")
> Reported-by: "freenerguo(郭大兴)" <freenerguo@tencent.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> ---
>   V2:
>    - added Fixes: tag and Cc: for stable kernels.
>    - Cc: patch to netdev list.
> ---
> Hi David,
>
> Here is the patch as Linus send it to us and security@kernel.org. I
> removed the lower bound check as that is already done in cfg80211.
> Now I signed off on the patch although formally I suppose Linus should
> sign it off. Putting it out there so people can respond as deemed
> necessary.
>
> The reason for submitting it to your tree is the fact that Kalle is
> on vacation for next 10 days or so which was indicated to me by Johannes.
> The patch applies to the master branch of your net repository. For
> reference V1 of this patch can be found here [1].

Hi Dave,

Not sure if you missed this one. It is addressing a reported security 
issue and intended for the net repository, not net-next which is 
obviously closed [2].

Regards,
Arend

[2] http://vger.kernel.org/~davem/net-next.html

> Regards,
> Arend
>
> [1] https://patchwork.kernel.org/patch/9829977/
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 5 +++++
>   1 file changed, 5 insertions(+)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> index cd1d673..d182a00 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
> @@ -4851,6 +4851,11 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
>   		cfg80211_mgmt_tx_status(wdev, *cookie, buf, len, true,
>   					GFP_KERNEL);
>   	} else if (ieee80211_is_action(mgmt->frame_control)) {
> +		if (len > BRCMF_FIL_ACTION_FRAME_SIZE + DOT11_MGMT_HDR_LEN) {
> +			brcmf_err("invalid action frame length\n");
> +			err = -EINVAL;
> +			goto exit;
> +		}
>   		af_params = kzalloc(sizeof(*af_params), GFP_KERNEL);
>   		if (af_params == NULL) {
>   			brcmf_err("unable to allocate frame\n");
>
