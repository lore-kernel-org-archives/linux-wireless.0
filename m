Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pasmtpa.tele.dk ([80.160.77.114]:35053 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXL3XLW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Dec 2007 18:11:22 -0500
Date: Mon, 31 Dec 2007 00:11:20 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: better rate control algorithm selection
Message-ID: <20071230231120.GB16557@uranus.ravnborg.org> (sfid-20071230_231201_517123_EB2AE895)
References: <1198253375.16241.76.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1198253375.16241.76.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes.

On Fri, Dec 21, 2007 at 05:09:35PM +0100, Johannes Berg wrote:
> Sam, I'm not entirely happy with the Makefile hacks. Can you take a look
> at the comment there and tell me whether there's any way to convince
> Kbuild to resolve the rc80211_pid.o even when rc80211_pid.o isn't in
> obj-y or obj-m but within mac80211-y?
> 
> Also, I'm not really happy with the ieee80211_rate.h #if but I don't see
> any way around that.
> 
> Below is the patch, comments welcome. I think this is the way we want
> it, tristate for all rate control algorithms regardless of whether
> mac80211 is modular (where =y then means "build algorithm into
> mac80211") and forcing one of the algorithms to y to do exactly that.
> 
> From: Johannes Berg <johannes@sipsolutions.net>
> Subject: [PATCH] mac80211: better rate control algorithm selection
> 
> This patch changes mac80211's Kconfig/Makefile to:
>  * select between the PID and the SIMPLE rate control
>    algorithm as default
>  * always allow tri-state for the rate control algorithms,
>    building those that are selected 'y' into the mac80211
>    module (if that is a module, otherwise all into the kernel)
>  * force the default rate control algorithm to be built into
>    mac80211
> 
> It also makes both rate control algorithms proper modules again
> with MODULE_LICENSE etc.
> 
> Only if EMBEDDED is the user allowed to select "NONE" as default
> which will cause no algorithm to be selected, this will work
> only when the driver brings one itself (e.g. iwlwifi drivers).
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  net/mac80211/Kconfig            |   37 ++++++++++++++++++-------------------
>  net/mac80211/Makefile           |   40 ++++++++++++++++++++++++++++++++++------
>  net/mac80211/ieee80211.c        |   34 +++++++++++-----------------------
>  net/mac80211/ieee80211_rate.h   |   38 ++++++++++++++++++++++++++++++++------
>  net/mac80211/rc80211_pid_algo.c |   24 ++++++++++++++++++++++--
>  net/mac80211/rc80211_simple.c   |   21 ++++++++++++++++++++-
>  6 files changed, 137 insertions(+), 57 deletions(-)
> 
> --- everything.orig/net/mac80211/Kconfig	2007-12-21 12:32:03.258062609 +0100
> +++ everything/net/mac80211/Kconfig	2007-12-21 16:38:32.983806424 +0100
> @@ -13,25 +13,17 @@ config MAC80211
>  	  This option enables the hardware independent IEEE 802.11
>  	  networking stack.
>  
> -config MAC80211_RC_DEFAULT_CHOICE
> -	bool "Choose default rate control algorithm" if EMBEDDED
> -	default y
> -	depends on MAC80211
> -	---help---
> -	  This options enables selection of a default rate control
> -	  algorithm to be built into the mac80211 module.  Alternate
> -	  rate control algorithms might be built into the mac80211
> -	  module as well.
> +menu "Rate control algorithm selection"
> +	depends on MAC80211 != n
>  
>  choice
>  	prompt "Default rate control algorithm"
>  	default MAC80211_RC_DEFAULT_PID
> -	depends on MAC80211 && MAC80211_RC_DEFAULT_CHOICE
>  	---help---
>  	  This option selects the default rate control algorithm
>  	  mac80211 will use. Note that this default can still be
>  	  overriden through the ieee80211_default_rc_algo module
> -	  parameter.
> +	  parameter if different algorithms are available.
>  
>  config MAC80211_RC_DEFAULT_PID
>  	bool "PID controller based rate control algorithm"
> @@ -50,19 +42,27 @@ config MAC80211_RC_DEFAULT_SIMPLE
>  	  dumb algorithm. You should choose the PID rate control
>  	  instead.
>  
> +config MAC80211_RC_DEFAULT_NONE
> +	bool "No default algorithm"
> +	depends on EMBEDDED
> +	help
> +	  Selecting this option will select no default algorithm
> +	  and allow you to not build any. Do not choose this
> +	  option unless you know your driver comes with another
> +	  suitable algorithm.
>  endchoice
>  
> +comment "Selecting 'y' for an algorithm will"
> +comment "build the algorithm into mac80211."
> +
>  config MAC80211_RC_DEFAULT
>  	string
> -	depends on MAC80211
>  	default "pid" if MAC80211_RC_DEFAULT_PID
>  	default "simple" if MAC80211_RC_DEFAULT_SIMPLE
>  	default ""
>  
>  config MAC80211_RC_PID
> -	bool "PID controller based rate control algorithm"
> -	default y
> -	depends on MAC80211
> +	tristate "PID controller based rate control algorithm"
>  	---help---
>  	  This option enables a TX rate control algorithm for
>  	  mac80211 that uses a PID controller to select the TX
> @@ -72,16 +72,15 @@ config MAC80211_RC_PID
>  	  different rate control algorithm.
>  
>  config MAC80211_RC_SIMPLE
> -	bool "Simple rate control algorithm (DEPRECATED)"
> -	default n
> -	depends on MAC80211
> +	tristate "Simple rate control algorithm (DEPRECATED)"
>  	---help---
>  	  This option enables a very simple, non-responsive TX
>  	  rate control algorithm. This algorithm is deprecated
> -	  and will be removed from the kernel in near future.
> +	  and will be removed from the kernel in the near future.
>  	  It has been replaced by the PID algorithm.
>  
>  	  Say N unless you know what you are doing.
> +endmenu
>  
>  config MAC80211_LEDS
>  	bool "Enable LED triggers"
> --- everything.orig/net/mac80211/Makefile	2007-12-21 13:09:22.008062120 +0100
> +++ everything/net/mac80211/Makefile	2007-12-21 16:58:21.893811361 +0100
> @@ -1,17 +1,44 @@
>  obj-$(CONFIG_MAC80211) += mac80211.o
>  
> +#
> +# Rate control algorithms
> +#
> +# Build in those that are 'y' and build as modules those that are 'm'
> +# Kconfig enforces (unless EMBEDDED) that one is always 'y'
> +#
> +mac80211-rc-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
> +# Hmm. I'd like to not do this but Kbuild doesn't resolve
> +# the rc80211_pid.o into rc80211_pid-y when it isn't right
> +# within the objs-m/objs-y list...
> +ifeq ($(CONFIG_MAC80211_RC_PID),y)
> +mac80211-rc-$(CONFIG_MAC80211_RC_PID) += $(rc80211_pid-y)
> +else
> +ifeq ($(CONFIG_MAC80211_RC_PID),m)
> +mac80211-rc-$(CONFIG_MAC80211_RC_PID) += rc80211_pid.o
> +endif
> +endif
> +
> +rc80211_pid-y += rc80211_pid_algo.o
> +rc80211_pid-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o
> +
> +# extra #defines for the header file
> +CFLAGS_rc80211_simple.o += -DRC80211_SIMPLE_COMPILE
> +CFLAGS_rc80211_pid_algo.o += -DRC80211_PID_COMPILE
> +
> +# build the ones selected 'm' as modules
> +obj-m += $(mac80211-rc-m)
> +
> +#
> +# mac80211 building
> +#
>  mac80211-objs-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
>  mac80211-objs-$(CONFIG_NET_SCHED) += wme.o
> -mac80211-objs-$(CONFIG_MAC80211_RC_SIMPLE) += rc80211_simple.o
> -mac80211-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_algo.o
>  
> -mac80211-debugfs-objs-$(CONFIG_MAC80211_RC_PID) += rc80211_pid_debugfs.o
>  mac80211-objs-$(CONFIG_MAC80211_DEBUGFS) += \
>  	debugfs.o \
>  	debugfs_sta.o \
>  	debugfs_netdev.o \
> -	debugfs_key.o \
> -	$(mac80211-debugfs-objs-y)
> +	debugfs_key.o
>  
>  mac80211-objs := \
>  	ieee80211.o \
> @@ -32,4 +59,5 @@ mac80211-objs := \
>  	key.o \
>  	util.o \
>  	event.o \
> -	$(mac80211-objs-y)
> +	$(mac80211-objs-y) \
> +	$(mac80211-rc-y)


This looks overly complicated.
Reading your patch several times rsulted in this conclusions:

rc80211_simple.o is build-in or module decided alone by CONFIG_MAC80211_SIMPLE
and the relation to MAC80211_RC_PID is just bogus.

MAC80211_RC_PID build-in =>
    rc80211_pid_algo as build-in
    rc80211_pid_debugfs as build-in if CONFIG_MAC80211_DEBUGFS equals y (is enabled)

MAC80211_RC_PID module =>
   rc80211_pid.o as a module 
   rc80211_pid_algo.o and rc80211_pid_debugfs.o are ignored

The rest looks like ordinary relations - but expressed a bit ackward.
Following is a more clean approach that uses the mac80211-y syntax to specify
the .o files used as part of the module.


# The mac80211 module
obj-$(CONFIG_MAC80211) += mac80211.o

# If RC algorithm in build-in
rate-rc-y := rc80211_pid_algo.o
rate-rc-$(CONFIG_MAC80211_DEBUGFS) += rc80211_pid_debugfs.o

# If RC algorithm is modular
rate-rc-m := rc80211_pid.o

mac80211-y += ieee80211.o key.o util.o event.o
mac80211-$(CONFIG_MAC80211_LEDS) += ieee80211_led.o
mac80211-$(CONFIG_NET_SCHED) += wme.o
mac80211-$(CONFIG_MAC80211_DEBUGFS) += debugfs.o debugfs_sta.o
mac80211-$(CONFIG_MAC80211_DEBUGFS) += debugfs_netdev.o debugfs_key.o

# And this part select the rate algorithm
mac80211-$(CONFIG_MAC80211_SIMPLE) += rc80211_simple.o
mac80211-$(CONFIG_MAC80211_RC_PID) += $(rate-rc-$(CONFIG_MAC80211_RC_PID))

# Modular rate algorithm was assigned to mac80211-m - make it a separate module
obj-m += $(mac80211-m)


Let me know if this are in line with what you tried to achieve
or you need more feedback.
And sorry for the late answer.

	Sam
