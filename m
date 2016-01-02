Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35235 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbcABXlm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 18:41:42 -0500
MIME-Version: 1.0
In-Reply-To: <5688390B.3080800@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net> <56883849.2080304@users.sourceforge.net>
 <5688390B.3080800@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sun, 3 Jan 2016 10:41:22 +1100
Message-ID: <CAGRGNgWiHKLrHMUySnCpfiF1+C=QV-i4C4KNmziga3-E1CLfKA@mail.gmail.com> (sfid-20160103_004223_182680_EA2AE4ED)
Subject: Re: [PATCH 1/3] NFC-mei_phy: Refactoring for mei_nfc_connect()
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Sun, Jan 3, 2016 at 7:54 AM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 2 Jan 2016 21:21:24 +0100
>
> This issue was detected by using the Coccinelle software.
>
> Adjust jump targets according to the current Linux coding style convention.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  drivers/nfc/mei_phy.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
> index 83deda4..8e3a69f 100644
> --- a/drivers/nfc/mei_phy.c
> +++ b/drivers/nfc/mei_phy.c
> @@ -173,8 +173,8 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
>
>         reply = kzalloc(connect_resp_length, GFP_KERNEL);
>         if (!reply) {
> -               kfree(cmd);
> -               return -ENOMEM;
> +               r = -ENOMEM;
> +               goto free_cmd;
>         }
>
>         connect_resp = (struct mei_nfc_connect_resp *)reply->data;
> @@ -189,7 +189,7 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
>         r = mei_cldev_send(phy->cldev, (u8 *)cmd, connect_length);
>         if (r < 0) {
>                 pr_err("Could not send connect cmd %d\n", r);
> -               goto err;
> +               goto free_reply;
>         }
>
>         bytes_recv = mei_cldev_recv(phy->cldev, (u8 *)reply,
> @@ -197,7 +197,7 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
>         if (bytes_recv < 0) {
>                 r = bytes_recv;
>                 pr_err("Could not read connect response %d\n", r);
> -               goto err;
> +               goto free_reply;
>         }
>
>         MEI_DUMP_NFC_HDR("connect reply", &reply->hdr);
> @@ -210,11 +210,10 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
>                 connect_resp->me_hotfix, connect_resp->me_build);
>
>         r = 0;
> -
> -err:
> +free_reply:
>         kfree(reply);
> +free_cmd:
>         kfree(cmd);
> -

Why are you deleting the two blank lines here?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
