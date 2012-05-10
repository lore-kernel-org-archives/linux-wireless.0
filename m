Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:40803 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757455Ab2EJRbz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 13:31:55 -0400
Date: Thu, 10 May 2012 13:31:39 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>,
	<florian.c.schilhabel@googlemail.com>, <ali@internetdog.org>,
	<netdev@vger.kernel.org>, Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 0/3] staging: delete duplicated files/functionality in
 rtl8712
Message-ID: <20120510173139.GA16704@windriver.com> (sfid-20120510_193206_694889_005906FC)
References: <1336621641-15467-1-git-send-email-paul.gortmaker@windriver.com>
 <20120510165451.GA12958@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20120510165451.GA12958@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Re: [PATCH 0/3] staging: delete duplicated files/functionality in rtl8712] On 10/05/2012 (Thu 09:54) Greg Kroah-Hartman wrote:

[...]

> Can you regenerate these with the full deletion content?  There have
> been some spelling fixes in these files, and your patches do not apply
> due to them.  I can hand-edit the patches if you regenerate it.
> 
> Or if you rebase on the last linux-next tree, that will pick those
> changes up and then I can apply these properly.

I've rebased it onto your staging-next of today, so it should be
hopefully seamless for you now.

Thanks,
Paul.
---

The following changes since commit 0e545f6d165ad0180b0d04fe1291f6f6268047ff:

  staging: rts5139: remove unused variable option.ww_enable (2012-05-10 09:57:21 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux.git rtl8712-staging-next

for you to fetch changes up to 9a0fbbb52ab08017ac51aceef76514799837f4b0:

  staging: delete all duplicated endian crap from rtl8712 driver (2012-05-10 13:10:03 -0400)

----------------------------------------------------------------
Paul Gortmaker (3):
      staging: wean rtl8712 off of its ancient duplicate of if_ether.h
      staging: wean rtl8712 off of its ancient duplicate of ip.h
      staging: delete all duplicated endian crap from rtl8712 driver

 drivers/staging/rtl8712/big_endian.h        |   94 --------------
 drivers/staging/rtl8712/generic.h           |  178 ---------------------------
 drivers/staging/rtl8712/hal_init.c          |    1 -
 drivers/staging/rtl8712/if_ether.h          |  141 ---------------------
 drivers/staging/rtl8712/ip.h                |  137 --------------------
 drivers/staging/rtl8712/little_endian.h     |   94 --------------
 drivers/staging/rtl8712/osdep_service.h     |    2 -
 drivers/staging/rtl8712/rtl8712_cmd.c       |    1 -
 drivers/staging/rtl8712/rtl8712_recv.c      |    5 +-
 drivers/staging/rtl8712/rtl8712_xmit.c      |    1 -
 drivers/staging/rtl8712/rtl871x_byteorder.h |   32 -----
 drivers/staging/rtl8712/rtl871x_cmd.c       |    1 -
 drivers/staging/rtl8712/rtl871x_recv.c      |    4 +-
 drivers/staging/rtl8712/rtl871x_xmit.c      |    1 -
 drivers/staging/rtl8712/swab.h              |  131 --------------------
 drivers/staging/rtl8712/usb_ops.c           |    1 -
 drivers/staging/rtl8712/wifi.h              |    1 -
 drivers/staging/rtl8712/xmit_linux.c        |    6 +-
 18 files changed, 7 insertions(+), 824 deletions(-)
 delete mode 100644 drivers/staging/rtl8712/big_endian.h
 delete mode 100644 drivers/staging/rtl8712/generic.h
 delete mode 100644 drivers/staging/rtl8712/if_ether.h
 delete mode 100644 drivers/staging/rtl8712/ip.h
 delete mode 100644 drivers/staging/rtl8712/little_endian.h
 delete mode 100644 drivers/staging/rtl8712/rtl871x_byteorder.h
 delete mode 100644 drivers/staging/rtl8712/swab.h

