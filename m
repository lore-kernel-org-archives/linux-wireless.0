Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52022 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab2FEPsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 11:48:52 -0400
Received: by wibhj8 with SMTP id hj8so4072395wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 05 Jun 2012 08:48:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1338881890.4514.13.camel@jlt3.sipsolutions.net>
References: <1338881890.4514.13.camel@jlt3.sipsolutions.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Jun 2012 08:48:29 -0700
Message-ID: <CA+55aFxV4b-CkCby=skn0s6GAM1kptsRJVcHeE6hoFVLY5T8uQ@mail.gmail.com> (sfid-20120605_174856_119592_04E88431)
Subject: Re: [PATCH 3.5] iwlwifi: fix double free/complete in firmware loading
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 5, 2012 at 12:38 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> @@ -861,13 +861,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
>
>        /* We have our copies now, allow OS release its copies */
>        release_firmware(ucode_raw);
> -       complete(&drv->request_firmware_complete);
>
>        drv->op_mode = iwl_dvm_ops.start(drv->trans, drv->cfg, &drv->fw);
>
> -       if (!drv->op_mode)
> -               goto out_free_fw;
> +       if (!drv->op_mode) {
> +               complete(&drv->request_firmware_complete);
> +               goto out_release_driver;
> +       }

If you do it this way, you might as well replace the

   complete(&drv->request_firmware_complete);
   goto out_release_driver;

with just a "goto out_unbind".

                Linus
