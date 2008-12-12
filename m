Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pool-71-115-147-71.gdrpmi.dsl-w.verizon.net ([71.115.147.71]:37639
	"EHLO s0be.servebeer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYLLXm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 18:42:26 -0500
Message-ID: <4942F6DE.5010004@erley.org> (sfid-20081213_004234_270908_4D25F632)
Date: Fri, 12 Dec 2008 18:42:22 -0500
From: pat-lkml <pat-lkml@erley.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Userspace tools: Roadmap?
References: <1228692546.8826.1288759933@webmail.messagingengine.com>	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>	 <1228778295.10662.1288975589@webmail.messagingengine.com>	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>	 <1229099080.14423.15.camel@dv> <1229119118.3572.6.camel@johannes.berg>	 <4942E7A4.3050206@erley.org> <1229121535.3565.4.camel@johannes.berg> <4942F59B.1060605@erley.org>
In-Reply-To: <4942F59B.1060605@erley.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Crap, please ignore, attached the wrong patch.

pat-lkml wrote:
> This converts iw to use libnl-2, and adds compatibility with libnl-1.
> There is not currently a good way to detect the libnl version during
> compilation, as the versioning in the netlink/version.h is defined as a
> string "2.0" rather than a major and a minor number, so we must detect
> it in the Makefile.
> 
> Signed-off-by: Pat Erley <pat-lkml@erley.org>
> 
> ---
> 
> I'm still not very familiar with Makefile magic, so if there's a better
> way to do what I'm doing in the Makefile, just let me know.  Also, I'm
> preparing a similar patch for crda.
> 
> ---
> 
> diff --git a/Makefile b/Makefile
> index df59b51..a87e9a0 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -10,14 +10,28 @@ MKDIR ?= mkdir -p
>  INSTALL ?= install
>  CC ?= "gcc"
> 
> -CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
> -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
> `pkg-config --cflags libnl-1`
> +CFLAGS += -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
> -fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
>  CFLAGS += -O2 -g
> -LDFLAGS += `pkg-config --libs libnl-1`
> -NLVERSION = 1.0
> 
>  OBJS = iw.o info.o phy.o interface.o station.o util.o mpath.o reg.o
> mesh.o genl.o
>  ALL = iw
> 
> +NL1FOUND := $(shell pkg-config --atleast-version=1 libnl-1 && echo Y)
> +NL2FOUND := $(shell pkg-config --atleast-version=2 libnl-2.0 && echo Y)
> +
> +ifeq ($(NL1FOUND),Y)
> +NLLIBNAME = libnl-1
> +endif
> +
> +ifeq ($(NL2FOUND),Y)
> +CFLAGS += -DCONFIG_LIBNL20
> +LIBS += -lnl-genl
> +NLLIBNAME = libnl-2.0
> +endif
> +
> +LDFLAGS += `pkg-config --libs $(NLLIBNAME)`
> +CFLAGS += `pkg-config --cflags $(NLLIBNAME)`
> +
>  ifeq ($(V),1)
>  Q=
>  NQ=true
> @@ -29,8 +43,15 @@ endif
>  all: version_check $(ALL)
> 
>  version_check:
> -	@if ! pkg-config --atleast-version=$(NLVERSION) libnl-1; then echo
> "You need at least libnl version $(NLVERSION)"; exit 1; fi
> -
> +ifeq ($(NL2FOUND),Y)
> +	@echo "Found libnl-2.0"
> +else
> +ifeq ($(NL1FOUND),Y)
> +        @echo "Found libnl-1"
> +else
> +	$(error No libnl found)
> +endif
> +endif
> 
>  version.h: version.sh
>  	@$(NQ) ' GEN  version.h'
> @@ -42,7 +63,7 @@ version.h: version.sh
> 
>  iw:	$(OBJS)
>  	@$(NQ) ' CC  ' iw
> -	$(Q)$(CC) $(LDFLAGS) $(OBJS) -o iw
> +	$(Q)$(CC) $(LDFLAGS) $(OBJS) $(LIBS) -o iw
> 
>  check:
>  	$(Q)$(MAKE) all CC="REAL_CC=$(CC) CHECK=\"sparse -Wall\" cgcc"
> diff --git a/iw.c b/iw.c
> index afae643..03ffbb9 100644
> --- a/iw.c
> +++ b/iw.c
> @@ -23,13 +23,24 @@
>  #include "iw.h"
>  #include "version.h"
> 
> +#ifndef CONFIG_LIBNL20
> +/* libnl 2.0 compatibility code */
> +
> +#define nl_socket_alloc(_h) nl_handle_alloc(_h)
> +#define nl_socket_free(_h)  nl_handle_destroy(_h)
> +#define compat_genl_ctrl_alloc_cache(_nl_handle, _nl_cache) \
> +        return (_nl_cache = genl_ctrl_alloc_cache(_nl_handle)) == null
> +
> +#define genl_ctrl_alloc_cache(_h) compat_genl_ctrl_alloc_cache(_h)
> +#endif /* CONFIG_LIBNL20 */
> +
>  static int debug = 0;
> 
>  static int nl80211_init(struct nl80211_state *state)
>  {
>  	int err;
> 
> -	state->nl_handle = nl_handle_alloc();
> +	state->nl_handle = nl_socket_alloc();
>  	if (!state->nl_handle) {
>  		fprintf(stderr, "Failed to allocate netlink handle.\n");
>  		return -ENOMEM;
> @@ -41,8 +52,7 @@ static int nl80211_init(struct nl80211_state *state)
>  		goto out_handle_destroy;
>  	}
> 
> -	state->nl_cache = genl_ctrl_alloc_cache(state->nl_handle);
> -	if (!state->nl_cache) {
> +	if (genl_ctrl_alloc_cache(state->nl_handle, &(state->nl_cache))) {
>  		fprintf(stderr, "Failed to allocate generic netlink cache.\n");
>  		err = -ENOMEM;
>  		goto out_handle_destroy;
> @@ -60,7 +70,7 @@ static int nl80211_init(struct nl80211_state *state)
>   out_cache_free:
>  	nl_cache_free(state->nl_cache);
>   out_handle_destroy:
> -	nl_handle_destroy(state->nl_handle);
> +	nl_socket_free(state->nl_handle);
>  	return err;
>  }
> 
> @@ -68,7 +78,7 @@ static void nl80211_cleanup(struct nl80211_state *state)
>  {
>  	genl_family_put(state->nl80211);
>  	nl_cache_free(state->nl_cache);
> -	nl_handle_destroy(state->nl_handle);
> +	nl_socket_free(state->nl_handle);
>  }
> 
>  __COMMAND(NULL, NULL, NULL, 0, 0, 0, CIB_NONE, NULL);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

