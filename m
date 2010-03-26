Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33129 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab0CZGHl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 02:07:41 -0400
Subject: Re: [PATCH] iw: Add support for connection quality monitor
 configuation
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Mar 2010 23:07:29 -0700
Message-ID: <1269583649.4581.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-03-26 at 07:46 +0200, Juuso Oikarinen wrote:
> This patch adds the cqm option to iw allowing enabling/disabling the
> rssi connection quality monitoring mode, and configuring rssi threshold and
> hysteresis.
> 
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---
>  Makefile  |    2 +-
>  cqm.c     |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  event.c   |   33 +++++++++++++++++++++++++++++++++
>  nl80211.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 138 insertions(+), 1 deletions(-)
>  create mode 100644 cqm.c
> 
> diff --git a/Makefile b/Makefile
> index c51706b..e21900a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -17,7 +17,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
>  OBJS = iw.o genl.o event.o info.o phy.o \
>  	interface.o ibss.o station.o survey.o util.o \
>  	mesh.o mpath.o scan.o reg.o version.o \
> -	reason.o status.o connect.o link.o offch.o ps.o
> +	reason.o status.o connect.o link.o offch.o ps.o cqm.c
>  OBJS += sections.o
>  ALL = iw
>  
> diff --git a/cqm.c b/cqm.c
> new file mode 100644
> index 0000000..3da2b54
> --- /dev/null
> +++ b/cqm.c
> @@ -0,0 +1,54 @@
> +#include <errno.h>
> +
> +#include <netlink/genl/genl.h>
> +#include <netlink/genl/family.h>
> +#include <netlink/genl/ctrl.h>
> +#include <netlink/msg.h>
> +#include <netlink/attr.h>
> +
> +#include "nl80211.h"
> +#include "iw.h"
> +
> +static int iw_cqm_rssi(struct nl80211_state *state, struct nl_cb *cb,
> +		       struct nl_msg *msg, int argc, char **argv)
> +{
> +	struct nl_msg *cqm = NULL;
> +	int thold = 0;
> +	int hyst = 0;
> +	int ret = -ENOSPC;
> +
> +	/* get the required args */
> +	if (argc < 1 || argc > 2)
> +		return 1;
> +
> +	if (strcmp(argv[0], "off")) {
> +		thold = atoi(argv[0]);
> +
> +		if (thold == 0)
> +			return -EINVAL;
> +
> +		if (argc == 2)
> +			hyst = atoi(argv[1]);
> +	}
> +
> +	/* connection quality monitor attributes */
> +	cqm = nlmsg_alloc();
> +
> +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_THOLD, thold);
> +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_HYST, hyst);

Hmm. guess I missed that in the kernel side review, but should we change
the API so that leaving them out means disabling?

johannes

