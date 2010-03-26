Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:38426 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0CZGSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 02:18:15 -0400
Subject: Re: [PATCH] iw: Add support for connection quality monitor
 configuation
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1269583649.4581.4.camel@jlt3.sipsolutions.net>
References: <1269582379-10253-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1269583649.4581.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Mar 2010 08:14:39 +0200
Message-ID: <1269584079.10120.889.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, 2010-03-26 at 07:07 +0100, ext Johannes Berg wrote:
> On Fri, 2010-03-26 at 07:46 +0200, Juuso Oikarinen wrote:
> > This patch adds the cqm option to iw allowing enabling/disabling the
> > rssi connection quality monitoring mode, and configuring rssi threshold and
> > hysteresis.
> > 
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > ---
> >  Makefile  |    2 +-
> >  cqm.c     |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  event.c   |   33 +++++++++++++++++++++++++++++++++
> >  nl80211.h |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
> >  4 files changed, 138 insertions(+), 1 deletions(-)
> >  create mode 100644 cqm.c
> > 
> > diff --git a/Makefile b/Makefile
> > index c51706b..e21900a 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -17,7 +17,7 @@ CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-aliasing
> >  OBJS = iw.o genl.o event.o info.o phy.o \
> >  	interface.o ibss.o station.o survey.o util.o \
> >  	mesh.o mpath.o scan.o reg.o version.o \
> > -	reason.o status.o connect.o link.o offch.o ps.o
> > +	reason.o status.o connect.o link.o offch.o ps.o cqm.c
> >  OBJS += sections.o
> >  ALL = iw
> >  
> > diff --git a/cqm.c b/cqm.c
> > new file mode 100644
> > index 0000000..3da2b54
> > --- /dev/null
> > +++ b/cqm.c
> > @@ -0,0 +1,54 @@
> > +#include <errno.h>
> > +
> > +#include <netlink/genl/genl.h>
> > +#include <netlink/genl/family.h>
> > +#include <netlink/genl/ctrl.h>
> > +#include <netlink/msg.h>
> > +#include <netlink/attr.h>
> > +
> > +#include "nl80211.h"
> > +#include "iw.h"
> > +
> > +static int iw_cqm_rssi(struct nl80211_state *state, struct nl_cb *cb,
> > +		       struct nl_msg *msg, int argc, char **argv)
> > +{
> > +	struct nl_msg *cqm = NULL;
> > +	int thold = 0;
> > +	int hyst = 0;
> > +	int ret = -ENOSPC;
> > +
> > +	/* get the required args */
> > +	if (argc < 1 || argc > 2)
> > +		return 1;
> > +
> > +	if (strcmp(argv[0], "off")) {
> > +		thold = atoi(argv[0]);
> > +
> > +		if (thold == 0)
> > +			return -EINVAL;
> > +
> > +		if (argc == 2)
> > +			hyst = atoi(argv[1]);
> > +	}
> > +
> > +	/* connection quality monitor attributes */
> > +	cqm = nlmsg_alloc();
> > +
> > +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_THOLD, thold);
> > +	NLA_PUT_U32(cqm, NL80211_ATTR_CQM_RSSI_HYST, hyst);
> 
> Hmm. guess I missed that in the kernel side review, but should we change
> the API so that leaving them out means disabling?

Heh, yep, the kernel part does not disable this if these are left out. 

Actually, I can think of one downside to the approach you propose: when
this gets extended, there will be multiple different cqm parameters, and
they would have to be always configured simultaneously, otherwise some
of the configurations would end up disabled. At least with iw, that
would be somewhat awkward?

-Juuso

> johannes
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


