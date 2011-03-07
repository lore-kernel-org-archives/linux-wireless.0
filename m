Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42336 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1CGNbD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2011 08:31:03 -0500
Received: by iyb26 with SMTP id 26so3901267iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2011 05:31:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D74BC3C.1080203@cn.fujitsu.com>
References: <4D74BC3C.1080203@cn.fujitsu.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 8 Mar 2011 00:30:42 +1100
Message-ID: <AANLkTi=T0eeNXrfBLdiPGch1X5EnHY+WrqYekXnZ+5=-@mail.gmail.com>
Subject: Re: [PATCH] wireless: used kzalloc instead of kmalloc & memset
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: buytenh@wantstofly.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 7, 2011 at 22:06, Shan Wei <shanwei@cn.fujitsu.com> wrote:
> Use kcalloc or kzalloc rather than the combination of kmalloc and memset.

[snip]

> Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
> ---
>  drivers/net/wireless/mwl8k.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index df5959f..43776e6 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -1056,13 +1056,12 @@ static int mwl8k_rxq_init(struct ieee80211_hw *hw, int index)
>        }
>        memset(rxq->rxd, 0, size);
>
> -       rxq->buf = kmalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);
> +       rxq->buf = kzalloc(MWL8K_RX_DESCS * sizeof(*rxq->buf), GFP_KERNEL);

Random nit, you're changing this from kmalloc to kzalloc when it would
be trivial to change it to kcalloc instead if you don't restrict the T
variable in your semantic patch to a type.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
