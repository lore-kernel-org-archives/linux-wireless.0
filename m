Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:50422 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933224AbXBWWBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 17:01:31 -0500
Date: Fri, 23 Feb 2007 13:55:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] d80211: create net/wireless/Kconfig and make nl80211  optional
Message-Id: <20070223135539.8a4fdff6.randy.dunlap@oracle.com>
In-Reply-To: <45DF60F9.9090806@linux.intel.com>
References: <45DF518B.5060809@linux.intel.com>
	<1172263955.3870.85.camel@johannes.berg>
	<45DF60F9.9090806@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 23 Feb 2007 13:47:37 -0800 James Ketrenos wrote:

> Ok... this time for sure.  Maybe :)  At least its Friday.

almost ....

> James
> 
> ----
> 
> [PATCH] create net/wireless/Kconfig and make nl80211 optional
> 
> ---
>   net/Kconfig            |   17 +----------------
>   net/wireless/Kconfig   |   33 +++++++++++++++++++++++++++++++++
>   net/wireless/Makefile  |    3 ++-
>   net/wireless/nl80211.h |   10 ++++++++++
>   4 files changed, 46 insertions(+), 17 deletions(-)
> ---
> diff --git a/net/Kconfig b/net/Kconfig
> index 3bff36e..6fa4d68 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -228,22 +228,7 @@ config WIRELESS_EXT
>   config FIB_RULES
>   	bool
> 
> -config CFG80211
> -	tristate "Improved wireless configuration API"
> -
> -config CFG80211_WEXT_COMPAT
> -	bool "cfg80211 Wireless Extensions compatibility"
> -	depends CFG80211
> -	default y
> -	---help---
> -	This option allows using devices whose drivers have been
> -	converted to use the new cfg80211 with wireless extensions,
> -	providing WE-20 compatibility. Note that cfg80211's "native"
> -	interface is nl80211 using generic netlink. The wireless
> -	extensions are being deprecated, but userspace tools may still
> -	be using them.
> -
> -	If unsure, say Y.
> +source "net/wireless/Kconfig"
> 
>   endif   # if NET
>   endmenu # Networking
> diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
> new file mode 100644
> index 0000000..7e83504
> --- /dev/null
> +++ b/net/wireless/Kconfig
> @@ -0,0 +1,33 @@
> +config CFG80211
> +        tristate "Improved wireless configuration API"
> +
> +config CFG80211_WEXT_COMPAT
> +        bool "cfg80211 Wireless Extensions compatibility"
> +        depends CFG80211
> +        default y
> +        ---help---
> +        This option allows using devices whose drivers have been
> +        converted to use the new cfg80211 with wireless extensions,
> +        providing WE-20 compatibility.
> +	
> +        Note that cfg80211's "native" interface is nl80211 using
> +        generic netlink. The wireless extensions are being
> +        deprecated, but userspace tools may still be using them.
> +
> +        If unsure, say Y.

All of the text under ---help--- should be (should have been :) indented
2 spaces...  (yes, I know it wasn't before, but should have been).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
