Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38059 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751033AbdFAD11 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 23:27:27 -0400
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>
Subject: [RFC 0/3] staging: ks7010: cfg80211 conversion, add FIL 
Date: Thu,  1 Jun 2017 13:27:05 +1000
Message-Id: <1496287628-16787-1-git-send-email-me@tobin.cc> (sfid-20170601_052805_222733_AF0D3BFA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current ks7010 driver uses the WEXT interface. This series is the
initial stage of re-writing the driver to use cfg80211.

Patch set applies on Linus' mainline.

5ed02dbb497422bf225783f46e6eadd237d23d6b Linux 4.12-rc3

Throws 4 compiler warnings for functions defined and not used.

As a first step I have implemented a Firmware Interface Layer (FIL)
based on how the current driver interfaces with the firmware.

This is my first interaction with wireless networking and device
driver development. Please be as pedantic as you like, I am here to
learn.

I have attempted to document the driver functionality thoroughly,
including explanation of wireless networking features. My
understanding is far from complete, if I have made mistakes please do
point them out. My aim is for this driver to be approachable by
developers new to Wi-Fi drivers (as well as shamelessly educating
myself).

I am unsure of the etiquette when attempting such a conversion so
elected to keep the original code in a sub directory but exclude it
from the build process.

Also the code does not include a licence comment in each file. It does
include the MODULE_LICENSE("GPL") macro. I am unsure of the correct
handling of the licensing, in particular which exact form of license
comment to use and what to do about copyright. I do not wish to
violate, or upset, the previous developers in any way. I am not employed
by a company, all work is my own and is based on the current kernel driver.

Thank you for taking the time to read this and thank you in advance
for any time that you spend on this RFC. All feedback very much
appreciated.

Regards,
Tobin.

Tobin C. Harding (3):
  staging: ks7010: move WEXT files to sub directory
  staging: ks7010: Add cfg80211 files
  MAINTAINERS: add maintainer entry for ks7010

 MAINTAINERS                                 |    7 +
 drivers/staging/ks7010/Kconfig              |    6 +-
 drivers/staging/ks7010/Makefile             |    9 +-
 drivers/staging/ks7010/README.rst           |   73 +
 drivers/staging/ks7010/TODO                 |   36 -
 drivers/staging/ks7010/TODO.rst             |   17 +
 drivers/staging/ks7010/cfg80211.c           |   45 +
 drivers/staging/ks7010/cfg80211.h           |    9 +
 drivers/staging/ks7010/common.h             |   10 +
 drivers/staging/ks7010/eap.h                |   36 +
 drivers/staging/ks7010/eap_packet.h         |  144 --
 drivers/staging/ks7010/fil.c                | 1294 ++++++++++++
 drivers/staging/ks7010/fil.h                |  527 +++++
 drivers/staging/ks7010/fil_types.h          |  845 ++++++++
 drivers/staging/ks7010/hif.c                |  104 +
 drivers/staging/ks7010/hif.h                |   23 +
 drivers/staging/ks7010/ks7010.h             |   94 +
 drivers/staging/ks7010/ks7010_sdio.c        | 1079 ----------
 drivers/staging/ks7010/ks7010_sdio.h        |  164 --
 drivers/staging/ks7010/ks_hostif.c          | 2638 -----------------------
 drivers/staging/ks7010/ks_hostif.h          |  685 ------
 drivers/staging/ks7010/ks_wlan.h            |  514 -----
 drivers/staging/ks7010/ks_wlan_ioctl.h      |   67 -
 drivers/staging/ks7010/ks_wlan_net.c        | 2999 ---------------------------
 drivers/staging/ks7010/main.c               |  122 ++
 drivers/staging/ks7010/michael_mic.c        |  148 --
 drivers/staging/ks7010/michael_mic.h        |   25 -
 drivers/staging/ks7010/sdio.c               |  399 ++++
 drivers/staging/ks7010/sdio.h               |   86 +
 drivers/staging/ks7010/tx.c                 |   29 +
 drivers/staging/ks7010/wext/Kconfig         |   10 +
 drivers/staging/ks7010/wext/Makefile        |    4 +
 drivers/staging/ks7010/wext/TODO            |   36 +
 drivers/staging/ks7010/wext/eap_packet.h    |  144 ++
 drivers/staging/ks7010/wext/ks7010_sdio.c   | 1079 ++++++++++
 drivers/staging/ks7010/wext/ks7010_sdio.h   |  164 ++
 drivers/staging/ks7010/wext/ks_hostif.c     | 2638 +++++++++++++++++++++++
 drivers/staging/ks7010/wext/ks_hostif.h     |  685 ++++++
 drivers/staging/ks7010/wext/ks_wlan.h       |  514 +++++
 drivers/staging/ks7010/wext/ks_wlan_ioctl.h |   67 +
 drivers/staging/ks7010/wext/ks_wlan_net.c   | 2999 +++++++++++++++++++++++++++
 drivers/staging/ks7010/wext/michael_mic.c   |  148 ++
 drivers/staging/ks7010/wext/michael_mic.h   |   25 +
 43 files changed, 12240 insertions(+), 8507 deletions(-)
 create mode 100644 drivers/staging/ks7010/README.rst
 delete mode 100644 drivers/staging/ks7010/TODO
 create mode 100644 drivers/staging/ks7010/TODO.rst
 create mode 100644 drivers/staging/ks7010/cfg80211.c
 create mode 100644 drivers/staging/ks7010/cfg80211.h
 create mode 100644 drivers/staging/ks7010/common.h
 create mode 100644 drivers/staging/ks7010/eap.h
 delete mode 100644 drivers/staging/ks7010/eap_packet.h
 create mode 100644 drivers/staging/ks7010/fil.c
 create mode 100644 drivers/staging/ks7010/fil.h
 create mode 100644 drivers/staging/ks7010/fil_types.h
 create mode 100644 drivers/staging/ks7010/hif.c
 create mode 100644 drivers/staging/ks7010/hif.h
 create mode 100644 drivers/staging/ks7010/ks7010.h
 delete mode 100644 drivers/staging/ks7010/ks7010_sdio.c
 delete mode 100644 drivers/staging/ks7010/ks7010_sdio.h
 delete mode 100644 drivers/staging/ks7010/ks_hostif.c
 delete mode 100644 drivers/staging/ks7010/ks_hostif.h
 delete mode 100644 drivers/staging/ks7010/ks_wlan.h
 delete mode 100644 drivers/staging/ks7010/ks_wlan_ioctl.h
 delete mode 100644 drivers/staging/ks7010/ks_wlan_net.c
 create mode 100644 drivers/staging/ks7010/main.c
 delete mode 100644 drivers/staging/ks7010/michael_mic.c
 delete mode 100644 drivers/staging/ks7010/michael_mic.h
 create mode 100644 drivers/staging/ks7010/sdio.c
 create mode 100644 drivers/staging/ks7010/sdio.h
 create mode 100644 drivers/staging/ks7010/tx.c
 create mode 100644 drivers/staging/ks7010/wext/Kconfig
 create mode 100644 drivers/staging/ks7010/wext/Makefile
 create mode 100644 drivers/staging/ks7010/wext/TODO
 create mode 100644 drivers/staging/ks7010/wext/eap_packet.h
 create mode 100644 drivers/staging/ks7010/wext/ks7010_sdio.c
 create mode 100644 drivers/staging/ks7010/wext/ks7010_sdio.h
 create mode 100644 drivers/staging/ks7010/wext/ks_hostif.c
 create mode 100644 drivers/staging/ks7010/wext/ks_hostif.h
 create mode 100644 drivers/staging/ks7010/wext/ks_wlan.h
 create mode 100644 drivers/staging/ks7010/wext/ks_wlan_ioctl.h
 create mode 100644 drivers/staging/ks7010/wext/ks_wlan_net.c
 create mode 100644 drivers/staging/ks7010/wext/michael_mic.c
 create mode 100644 drivers/staging/ks7010/wext/michael_mic.h

-- 
2.7.4
