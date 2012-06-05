Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467Ab2FEPxC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 11:53:02 -0400
Message-ID: <1338911579.4514.47.camel@jlt3.sipsolutions.net> (sfid-20120605_175307_136047_C4FD1EEC)
Subject: Re: [PATCH 3.5] iwlwifi: fix double free/complete in firmware
 loading
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 05 Jun 2012 17:52:59 +0200
In-Reply-To: <CA+55aFxV4b-CkCby=skn0s6GAM1kptsRJVcHeE6hoFVLY5T8uQ@mail.gmail.com> (sfid-20120605_174851_874161_7B46655E)
References: <1338881890.4514.13.camel@jlt3.sipsolutions.net>
	 <CA+55aFxV4b-CkCby=skn0s6GAM1kptsRJVcHeE6hoFVLY5T8uQ@mail.gmail.com>
	 (sfid-20120605_174851_874161_7B46655E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-05 at 08:48 -0700, Linus Torvalds wrote:
> On Tue, Jun 5, 2012 at 12:38 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > @@ -861,13 +861,20 @@ static void iwl_ucode_callback(const struct firmware *ucode_raw, void *context)
> >
> >        /* We have our copies now, allow OS release its copies */
> >        release_firmware(ucode_raw);
> > -       complete(&drv->request_firmware_complete);
> >
> >        drv->op_mode = iwl_dvm_ops.start(drv->trans, drv->cfg, &drv->fw);
> >
> > -       if (!drv->op_mode)
> > -               goto out_free_fw;
> > +       if (!drv->op_mode) {
> > +               complete(&drv->request_firmware_complete);
> > +               goto out_release_driver;
> > +       }
> 
> If you do it this way, you might as well replace the
> 
>    complete(&drv->request_firmware_complete);
>    goto out_release_driver;
> 
> with just a "goto out_unbind".

Good point.

johannes

