Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:13660 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875AbYEVF7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 01:59:42 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2473125wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 21 May 2008 22:59:41 -0700 (PDT)
Message-ID: <43e72e890805212259u7515a12as69eeea253b197a64@mail.gmail.com> (sfid-20080522_075946_521184_ED0C6993)
Date: Wed, 21 May 2008 22:59:41 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC] make wext wireless bits optional and deprecate them
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Marcel Holtmann" <marcel@holtmann.org>,
	"Jean Tourrilhes" <jt@hpl.hp.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1211210578.6252.52.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1211026337.3827.25.camel@johannes.berg>
	 <CD993362-B1DE-4E4D-8A5B-E9E2AD7DA04C@holtmann.org>
	 <1211032475.6252.2.camel@johannes.berg>
	 <1211117795.686.15.camel@localhost.localdomain>
	 <1211199368.6252.19.camel@johannes.berg>
	 <1211210578.6252.52.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 19, 2008 at 8:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> [removing linux-kernel and netdev from CC, I suppose they won't care too
> much about these details]
>
> On Mon, 2008-05-19 at 14:18 +0200, Johannes Berg wrote:
>> > Instead of testing for wireless/, best thing would probably be to call
>> > SIOCGIWRANGE on the device and if it returns EOPNOTSUP then it's not
>> > wireless.  Some drivers may have to load firmware to figure out
>> > supported rates and encryption capabilities, but to be honest, NM does
>> > this to detect wireless devices and I haven't run into any issues in 4
>> > years using it.  If there are issues with drivers, then we need to fix
>> > the driver too.
>>
>> I was about to propose calling SIOCGIWNAME since that is what
>> wireless-tools do and that linux/wireless.h indicates.
>
> Here's a patch, comments?
>
> johannes
>
> ---
>  hald/linux/device.c |   16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> --- hal.orig/hald/linux/device.c        2008-05-19 06:46:23.000000000 +0200
> +++ hal/hald/linux/device.c     2008-05-19 06:55:25.000000000 +0200
> @@ -45,6 +45,10 @@
>   #include <linux/input.h>
>  #endif
>
> +/* for wireless extensions */
> +#include <linux/if.h>
> +#include <linux/wireless.h>
> +
>  #include <dbus/dbus.h>
>  #include <dbus/dbus-glib.h>
>
> @@ -532,10 +536,14 @@ net_add (const gchar *sysfs_path, const
>                const char *addr;
>                const char *parent_subsys;
>                char bridge_path[HAL_PATH_MAX];
> -               char wireless_path[HAL_PATH_MAX];
>                char phy80211_path[HAL_PATH_MAX];
>                struct stat s;
>                dbus_uint64_t mac_address = 0;
> +               int ioctl_fd;
> +               struct iwreq iwr;
> +
> +               ioctl_fd = socket (PF_INET, SOCK_DGRAM, 0);
> +               strncpy (iwr.ifr_ifrn.ifrn_name, IFNAMSIZ, ifname);

IFNAMSIZ should be the last argument.

  Luis
