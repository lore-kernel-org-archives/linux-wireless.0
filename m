Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61263 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbYLLQYn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 11:24:43 -0500
Subject: Re: Userspace tools: Roadmap?
From: Pavel Roskin <proski@gnu.org>
To: pat-lkml <pat-lkml@erley.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4941EF69.5040108@erley.org>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>
	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>
Content-Type: text/plain
Date: Fri, 12 Dec 2008 11:24:40 -0500
Message-Id: <1229099080.14423.15.camel@dv> (sfid-20081212_172446_639675_073DBF1D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-11 at 23:58 -0500, pat-lkml wrote:
> Attached is a newer 'better' version based off of how hostapd is
> handling this.  This patch adds an option, CONFIG_LIBNL20, which enables
> LIBNL20 compatibility.  I haven't ever been able to get iw to build with
> libnl-1.0 or libnl-1.1 on my system, so I haven't been able to test
> that, but it should work.
...
> +ifeq ($(NLVERSION), 2.0)
> +CFLAGS += `pkg-config --cflags libnl-2.0` -DCONFIG_LIBNL20
> +LDFLAGS += `pkg-config --libs libnl-2.0`
> +LIBS += -lnl -lnl-genl -lnl-nf -lnl-route
> +NLTESTVERSION = 2.0
> +else
> +CFLAGS += `pkg-config --cflags libnl-1`
> +LDFLAGS += `pkg-config --libs libnl-1.0`

I think you mean "libnl-1" without ".0" here.

> +LIBS += -lnl
> +NLTESTVERSION = 1
> +endif

It would be better to have a variable for pkg-config name of the
library, that is "libnl-1" or "libnl-2.0".

LDCONFIG and LIBS could both be derived from pkg-config by using
--libs-only-l, --libs-only-other and --libs-only-L.  --libs-only-l goes
to LIBS, --libs-only-L goes to LDFLAGS and I guess --libs-only-other
could go to LDFLAGS as well.

>  version_check:
> -	@if ! pkg-config --atleast-version=$(NLVERSION) libnl-1; then echo
> "You need at least libnl version $(NLVERSION)"; exit 1; fi
> +	@if ! pkg-config --atleast-version=$(NLVERSION)
> libnl-$(NLTESTVERSION); then echo "You need at least libnl version
> $(NLVERSION)"; exit 1; fi

I would consider autodetection for libnl version here if it's not too
hard.

> +#ifdef CONFIG_LIBNL20
> +/* libnl 2.0 compatibility code */
> +#define nl_handle_alloc_cb nl_socket_alloc_cb
> +#define nl_handle_alloc nl_socket_alloc
> +#define nl_handle_destroy nl_socket_free
> +#endif /* CONFIG_LIBNL20 */

Please use macros with arguments to ensure their correct number.

>From my experience with external Linux drivers (MadWifi in particular),
it's easier to follow the current API and provide compatibility for the
old API, not the other way around.  This way, it's easier to track
further API changes.  Also, the new API is usually easier to understand.

> +#ifdef CONFIG_LIBNL20
> +	if (genl_ctrl_alloc_cache(state->nl_handle, &(state->nl_cache))) {
> +#else
>  	state->nl_cache = genl_ctrl_alloc_cache(state->nl_handle);
>  	if (!state->nl_cache) {
> +#endif

Perhaps you could provide a compatibility genl_ctrl_alloc_cache() macro
for libnl1 and avoid this ifdef?

-- 
Regards,
Pavel Roskin
