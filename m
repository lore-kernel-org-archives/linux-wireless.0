Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51690 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993Ab0IIBpM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Sep 2010 21:45:12 -0400
Received: by bwz11 with SMTP id 11so709456bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 18:45:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283988329-44549-5-git-send-email-steve@cozybit.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com> <1283988329-44549-5-git-send-email-steve@cozybit.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 11:44:51 +1000
Message-ID: <AANLkTinhiQAVJKpyjXduVKDqvLXA8EgX7VCFTEu_F272@mail.gmail.com>
Subject: Re: [PATCH 4/9] libertas_tf: Add firmware reset to sdio driver and
 attempt firmware reload
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Minor nit:

On Thu, Sep 9, 2010 at 09:25, Steve deRosier <steve@cozybit.com> wrote:
> This patch adds a method to do a firmware/chip reset to the sdio driver and
> attempts to reload the firmware.
>
> Signed-off-by: Steve deRosier <steve@cozybit.com>
> ---
>  drivers/net/wireless/libertas_tf/if_sdio.c |   40 +++++++++++++++++++++++----
>  drivers/net/wireless/libertas_tf/main.c    |    7 ++++-
>  2 files changed, 40 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/net/wireless/libertas_tf/if_sdio.c b/drivers/net/wireless/libertas_tf/if_sdio.c
> index fed5aff..1e72b4c 100644
> --- a/drivers/net/wireless/libertas_tf/main.c
> +++ b/drivers/net/wireless/libertas_tf/main.c
> @@ -360,7 +364,8 @@ static int lbtf_op_start(struct ieee80211_hw *hw)
>        return 0;
>
>  err_prog_firmware:
> -//     priv->hw_reset_device(card);
> +       if (priv->hw_reset_device)
> +               priv->hw_reset_device(card);

Should this not be done in the first patch? - rather than just
commenting out the call: Would commenting out this line in the first
patch make the original version of libertas_tf unable to handle
firmware errors properly?

>        lbtf_deb_leave_args(LBTF_DEB_MACOPS, "error programing fw; ret=%d", ret);
>        return ret;
>  }

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
