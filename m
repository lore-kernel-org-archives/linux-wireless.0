Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:55690 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992867AbXCCB3E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 20:29:04 -0500
Message-ID: <45E8CF5E.5090305@garzik.org>
Date: Fri, 02 Mar 2007 20:29:02 -0500
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, marcelo@kvack.org
Subject: Re: Please pull 'libertas' branch of wireless-2.6
References: <20070227205649.GH5826@tuxdriver.com>
In-Reply-To: <20070227205649.GH5826@tuxdriver.com>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Here is the libertas wireless driver for OLPC.  It has been beaten into
> shape by a couple of review rounds on netdev and is now mostly good.
> I'm sure Marcelo isn't going anywhere... :-)
> 
> This also includes a fixup patch from me to account for the recent
> netdev class_device -> device changes.  You probably want Marcelo to
> bless it before you pull into the upstream branch of netdev-2.6.
> 
> Thanks,
> 
> John
> 
> ---
> 
> The following changes since commit c8f71b01a50597e298dc3214a2f2be7b8d31170c:
>   Linus Torvalds (1):
>         Linux 2.6.21-rc1
> 
> are found in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git libertas
> 
> John W. Linville (1):
>       libertas: fix build breakage from netdev class_device -> device
> 
> Marcelo Tosatti (1):
>       Marvell Libertas 8388 802.11b/g USB driver
> 
>  drivers/net/wireless/Kconfig               |   13 +
>  drivers/net/wireless/Makefile              |    1 +
>  drivers/net/wireless/libertas/11d.c        |  754 ++++++++
>  drivers/net/wireless/libertas/11d.h        |  105 ++
>  drivers/net/wireless/libertas/LICENSE      |   16 +
>  drivers/net/wireless/libertas/Makefile     |   21 +
>  drivers/net/wireless/libertas/README       | 1044 +++++++++++
>  drivers/net/wireless/libertas/assoc.c      |  588 ++++++
>  drivers/net/wireless/libertas/assoc.h      |   30 +
>  drivers/net/wireless/libertas/cmd.c        | 1958 ++++++++++++++++++++
>  drivers/net/wireless/libertas/cmdresp.c    | 1031 +++++++++++
>  drivers/net/wireless/libertas/debugfs.c    | 1968 ++++++++++++++++++++
>  drivers/net/wireless/libertas/debugfs.h    |    6 +
>  drivers/net/wireless/libertas/decl.h       |   83 +
>  drivers/net/wireless/libertas/defs.h       |  369 ++++
>  drivers/net/wireless/libertas/dev.h        |  403 ++++
>  drivers/net/wireless/libertas/ethtool.c    |  184 ++
>  drivers/net/wireless/libertas/fw.c         |  361 ++++
>  drivers/net/wireless/libertas/fw.h         |   13 +
>  drivers/net/wireless/libertas/host.h       |  338 ++++
>  drivers/net/wireless/libertas/hostcmd.h    |  693 +++++++
>  drivers/net/wireless/libertas/if_bootcmd.c |   38 +
>  drivers/net/wireless/libertas/if_usb.c     |  952 ++++++++++
>  drivers/net/wireless/libertas/if_usb.h     |  109 ++
>  drivers/net/wireless/libertas/ioctl.c      | 2500 +++++++++++++++++++++++++
>  drivers/net/wireless/libertas/join.c       | 1055 +++++++++++
>  drivers/net/wireless/libertas/join.h       |   64 +
>  drivers/net/wireless/libertas/main.c       | 1258 +++++++++++++
>  drivers/net/wireless/libertas/radiotap.h   |   57 +
>  drivers/net/wireless/libertas/rx.c         |  459 +++++
>  drivers/net/wireless/libertas/sbi.h        |   40 +
>  drivers/net/wireless/libertas/scan.c       | 2044 ++++++++++++++++++++
>  drivers/net/wireless/libertas/scan.h       |  216 +++
>  drivers/net/wireless/libertas/thread.h     |   52 +
>  drivers/net/wireless/libertas/tx.c         |  285 +++
>  drivers/net/wireless/libertas/types.h      |  289 +++
>  drivers/net/wireless/libertas/version.h    |    8 +
>  drivers/net/wireless/libertas/wext.c       | 2769 ++++++++++++++++++++++++++++
>  drivers/net/wireless/libertas/wext.h       |  147 ++
>  include/net/ieee80211_radiotap.h           |   31 +-
>  40 files changed, 22351 insertions(+), 1 deletions(-)
>  create mode 100644 drivers/net/wireless/libertas/11d.c
>  create mode 100644 drivers/net/wireless/libertas/11d.h
>  create mode 100644 drivers/net/wireless/libertas/LICENSE
>  create mode 100644 drivers/net/wireless/libertas/Makefile
>  create mode 100644 drivers/net/wireless/libertas/README
>  create mode 100644 drivers/net/wireless/libertas/assoc.c
>  create mode 100644 drivers/net/wireless/libertas/assoc.h
>  create mode 100644 drivers/net/wireless/libertas/cmd.c
>  create mode 100644 drivers/net/wireless/libertas/cmdresp.c
>  create mode 100644 drivers/net/wireless/libertas/debugfs.c
>  create mode 100644 drivers/net/wireless/libertas/debugfs.h
>  create mode 100644 drivers/net/wireless/libertas/decl.h
>  create mode 100644 drivers/net/wireless/libertas/defs.h
>  create mode 100644 drivers/net/wireless/libertas/dev.h
>  create mode 100644 drivers/net/wireless/libertas/ethtool.c
>  create mode 100644 drivers/net/wireless/libertas/fw.c
>  create mode 100644 drivers/net/wireless/libertas/fw.h
>  create mode 100644 drivers/net/wireless/libertas/host.h
>  create mode 100644 drivers/net/wireless/libertas/hostcmd.h
>  create mode 100644 drivers/net/wireless/libertas/if_bootcmd.c
>  create mode 100644 drivers/net/wireless/libertas/if_usb.c
>  create mode 100644 drivers/net/wireless/libertas/if_usb.h
>  create mode 100644 drivers/net/wireless/libertas/ioctl.c
>  create mode 100644 drivers/net/wireless/libertas/join.c
>  create mode 100644 drivers/net/wireless/libertas/join.h
>  create mode 100644 drivers/net/wireless/libertas/main.c
>  create mode 100644 drivers/net/wireless/libertas/radiotap.h
>  create mode 100644 drivers/net/wireless/libertas/rx.c
>  create mode 100644 drivers/net/wireless/libertas/sbi.h
>  create mode 100644 drivers/net/wireless/libertas/scan.c
>  create mode 100644 drivers/net/wireless/libertas/scan.h
>  create mode 100644 drivers/net/wireless/libertas/thread.h
>  create mode 100644 drivers/net/wireless/libertas/tx.c
>  create mode 100644 drivers/net/wireless/libertas/types.h
>  create mode 100644 drivers/net/wireless/libertas/version.h
>  create mode 100644 drivers/net/wireless/libertas/wext.c
>  create mode 100644 drivers/net/wireless/libertas/wext.h

pulled into #upstream

