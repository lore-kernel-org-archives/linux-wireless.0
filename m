Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:47843 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab2GBABj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 20:01:39 -0400
Received: by lbbgm6 with SMTP id gm6so6945162lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jul 2012 17:01:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341062181-28071-15-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de> <1341062181-28071-15-git-send-email-hauke@hauke-m.de>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 2 Jul 2012 10:01:17 +1000
Message-ID: <CAGRGNgU6SXLg5w88q6Lpg=kPnb-Q_ik0OJkhhWCXiw_VnVvczg@mail.gmail.com> (sfid-20120702_020142_213995_26FC8AC4)
Subject: Re: [PATCH v2 14/18] brcmsmac: extend xmtfifo_sz array
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, arend@broadcom.com,
	brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Hauke,

On Sat, Jun 30, 2012 at 11:16 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The xmtfifo_sz array contains the queue sizes for the different core
> revs. This array missed the sizes for the core rev 17 and 28. This
> patch extends the array to also include these sizes and adds a warning
> if no queue size is stored in the array for the given core rev.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> index 547ae5b..46d7646 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
> @@ -343,6 +349,18 @@ static const u16 xmtfifo_sz[][NFIFO] = {
>         {20, 192, 192, 21, 17, 5},
>         /* corerev 24: 2304, 14848, 5632, 3584, 3584, 1280 */
>         {9, 58, 22, 14, 14, 5},
> +       /* corerev 25: */
> +       {0, 0, 0, 0, 0, 0},
> +       /* corerev 26: */
> +       {0, 0, 0, 0, 0, 0},
> +       /* corerev 27: */
> +       {0, 0, 0, 0, 0, 0},
> +       /* corerev 28: 2304, 14848, 5632, 3584, 3584, 1280 */
> +       {9, 58, 22, 14, 14, 5},
> +       /* corerev 29: */
> +       {0, 0, 0, 0, 0, 0},
> +       /* corerev 30: */
> +       {0, 0, 0, 0, 0, 0},

Why add data for 29 and 30?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
