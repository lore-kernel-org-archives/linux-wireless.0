Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:60073 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbXLJQJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Dec 2007 11:09:32 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 07/48] libertas: make more functions static
Date: Mon, 10 Dec 2007 17:08:31 +0100
Cc: David Woodhouse <dwmw2@infradead.org>,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <E1J1kpB-0006kg-FH@shinybook.infradead.org>
In-Reply-To: <E1J1kpB-0006kg-FH@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200712101708.32668.arnd@arndb.de> (sfid-20071210_160938_743439_AC465139)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 December 2007, David Woodhouse wrote:
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -13,6 +13,11 @@
> =A0#include "wext.h"
> =A0
> =A0static void cleanup_cmdnode(struct cmd_ctrl_node *ptempnode);
> +struct cmd_ctrl_node *lbs_get_cmd_ctrl_node(struct lbs_private *priv=
);
> +void lbs_set_cmd_ctrl_node(struct lbs_private *priv,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0struct cmd_ctrl=
_node *ptempnode,
> +=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 =A0 =A0u16 wait_option=
, void *pdata_buf);
> +

You should never need forward declarations for global functions in a C =
file,
it is error prone in any case:

* if the functions are only used in one file, make them static.
* Better, avoid forward declarations entirely by ordering the functions=
 in the
way they are called.
* If they are used in one file and defined in another, declare them in
a common header, and only there, in order to avoid the prototypes from =
diverging.

	Arnd <><
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
