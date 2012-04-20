Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:55715 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab2DTI5W convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 04:57:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120420064705.GE22649@elgon.mountain>
References: <20120420064705.GE22649@elgon.mountain>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 20 Apr 2012 18:57:00 +1000
Message-ID: <CAGRGNgVgtAYknmpB_8Q0OpcUWFjTxBistG+RNs1ORDZeckGsWw@mail.gmail.com> (sfid-20120420_105728_184194_96D3E4E7)
Subject: Re: [patch] wireless: at76c50x: allocating too much data
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

On Fri, Apr 20, 2012 at 16:47, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> This is a cut and paste mistake, sizeof(struct mib_local) was intended
> instead of sizeof(struct mib_phy).  The call to at76_get_mib() uses
> sizeof(struct mib_local) correctly.
>
> The current code works fine because mib_phy structs are larger than
> mib_local structs.  But we may as well clean it up.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/net/wireless/at76c50x-usb.c b/drivers/net/wireless/at76c50x-usb.c
> index faa8bcb..0bba5ea 100644
> --- a/drivers/net/wireless/at76c50x-usb.c
> +++ b/drivers/net/wireless/at76c50x-usb.c
> @@ -1122,7 +1122,7 @@ exit:
>  static void at76_dump_mib_local(struct at76_priv *priv)
>  {
>        int ret;
> -       struct mib_local *m = kmalloc(sizeof(struct mib_phy), GFP_KERNEL);
> +       struct mib_local *m = kmalloc(sizeof(struct mib_local), GFP_KERNEL);

Would it be better practice to use sizeof(*m)?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
