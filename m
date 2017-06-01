Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42143 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbdFADpn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 23:45:43 -0400
Date: Thu, 1 Jun 2017 12:45:37 +0900
From: Greg KH <greg@kroah.com>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: linux-wireless@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] staging: ks7010: move WEXT files to sub directory
Message-ID: <20170601034537.GA7468@kroah.com> (sfid-20170601_054612_857267_AC8499A5)
References: <1496287628-16787-1-git-send-email-me@tobin.cc>
 <1496287628-16787-2-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1496287628-16787-2-git-send-email-me@tobin.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 01, 2017 at 01:27:06PM +1000, Tobin C. Harding wrote:
> Current driver implements the WEXT interface. WEXT is in maintenance
> mode, we need to re-write the driver using cfg80211. The current
> driver is handy as a reference for the new implementation, we can keep
> it in tree for now.
> 
> Move WEXT driver to sub directory, add dummy Makefile and Kconfig so
> build completes successfully but does not process any files from the
> WEXT directory.
> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  drivers/staging/ks7010/Kconfig              |    6 +-
>  drivers/staging/ks7010/Makefile             |    3 -
>  drivers/staging/ks7010/TODO                 |   36 -
>  drivers/staging/ks7010/eap_packet.h         |  144 --
>  drivers/staging/ks7010/ks7010_sdio.c        | 1079 ----------
>  drivers/staging/ks7010/ks7010_sdio.h        |  164 --
>  drivers/staging/ks7010/ks_hostif.c          | 2638 -----------------------
>  drivers/staging/ks7010/ks_hostif.h          |  685 ------
>  drivers/staging/ks7010/ks_wlan.h            |  514 -----
>  drivers/staging/ks7010/ks_wlan_ioctl.h      |   67 -
>  drivers/staging/ks7010/ks_wlan_net.c        | 2999 ---------------------------
>  drivers/staging/ks7010/michael_mic.c        |  148 --
>  drivers/staging/ks7010/michael_mic.h        |   25 -
>  drivers/staging/ks7010/wext/Kconfig         |   10 +
>  drivers/staging/ks7010/wext/Makefile        |    4 +
>  drivers/staging/ks7010/wext/TODO            |   36 +
>  drivers/staging/ks7010/wext/eap_packet.h    |  144 ++
>  drivers/staging/ks7010/wext/ks7010_sdio.c   | 1079 ++++++++++
>  drivers/staging/ks7010/wext/ks7010_sdio.h   |  164 ++
>  drivers/staging/ks7010/wext/ks_hostif.c     | 2638 +++++++++++++++++++++++
>  drivers/staging/ks7010/wext/ks_hostif.h     |  685 ++++++
>  drivers/staging/ks7010/wext/ks_wlan.h       |  514 +++++
>  drivers/staging/ks7010/wext/ks_wlan_ioctl.h |   67 +
>  drivers/staging/ks7010/wext/ks_wlan_net.c   | 2999 +++++++++++++++++++++++++++
>  drivers/staging/ks7010/wext/michael_mic.c   |  148 ++
>  drivers/staging/ks7010/wext/michael_mic.h   |   25 +
>  26 files changed, 8514 insertions(+), 8507 deletions(-)
>  delete mode 100644 drivers/staging/ks7010/TODO
>  delete mode 100644 drivers/staging/ks7010/eap_packet.h
>  delete mode 100644 drivers/staging/ks7010/ks7010_sdio.c
>  delete mode 100644 drivers/staging/ks7010/ks7010_sdio.h
>  delete mode 100644 drivers/staging/ks7010/ks_hostif.c
>  delete mode 100644 drivers/staging/ks7010/ks_hostif.h
>  delete mode 100644 drivers/staging/ks7010/ks_wlan.h
>  delete mode 100644 drivers/staging/ks7010/ks_wlan_ioctl.h
>  delete mode 100644 drivers/staging/ks7010/ks_wlan_net.c
>  delete mode 100644 drivers/staging/ks7010/michael_mic.c
>  delete mode 100644 drivers/staging/ks7010/michael_mic.h
>  create mode 100644 drivers/staging/ks7010/wext/Kconfig
>  create mode 100644 drivers/staging/ks7010/wext/Makefile
>  create mode 100644 drivers/staging/ks7010/wext/TODO
>  create mode 100644 drivers/staging/ks7010/wext/eap_packet.h
>  create mode 100644 drivers/staging/ks7010/wext/ks7010_sdio.c
>  create mode 100644 drivers/staging/ks7010/wext/ks7010_sdio.h
>  create mode 100644 drivers/staging/ks7010/wext/ks_hostif.c
>  create mode 100644 drivers/staging/ks7010/wext/ks_hostif.h
>  create mode 100644 drivers/staging/ks7010/wext/ks_wlan.h
>  create mode 100644 drivers/staging/ks7010/wext/ks_wlan_ioctl.h
>  create mode 100644 drivers/staging/ks7010/wext/ks_wlan_net.c
>  create mode 100644 drivers/staging/ks7010/wext/michael_mic.c
>  create mode 100644 drivers/staging/ks7010/wext/michael_mic.h

Please use the -M option to 'git format-patch" so that we can just see
file moves, not delete/add like you have here.

thanks,

greg k-h
