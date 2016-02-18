Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m50-133.163.com ([123.125.50.133]:50596 "EHLO m50-133.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946176AbcBROUs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2016 09:20:48 -0500
From: Geliang Tang <geliangtang@163.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/3] staging: rtl8723au: use list_for_each_entry*() and cleaning
Date: Thu, 18 Feb 2016 22:19:28 +0800
Message-Id: <cover.1455804404.git.geliangtang@163.com> (sfid-20160218_152129_917342_ADF4EE28)
In-Reply-To: <wrfjtwl76ybi.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 17, 2016 at 12:28:33PM -0500, Jes Sorensen wrote:
> kbuild test robot <lkp@intel.com> writes:
> > Hi Geliang,
> >
> > [auto build test ERROR on staging/staging-testing]
> > [also build test ERROR on v4.5-rc4 next-20160217]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Geliang-Tang/staging-rtl8723au-use-list_for_each_entry/20160217-220638
> > config: i386-randconfig-s1-201607 (attached as .config)
> > reproduce:
> >         # save the attached .config to linux build tree
> >         make ARCH=i386 
> >
> > Note: the linux-review/Geliang-Tang/staging-rtl8723au-use-list_for_each_entry/20160217-220638 HEAD 495811a52aba181af76c3baf57da3d81a79c2fe8 builds fine.
> >       It only hurts bisectibility.
> >
> > All errors (new ones prefixed by >>):
> >
> >    drivers/staging/rtl8723au/core/rtw_recv.c: In function 'rtw_free_recvframe23a_queue':
> >>> drivers/staging/rtl8723au/core/rtw_recv.c:203:2: error: 'plist' undeclared (first use in this function)
> >      plist = phead->next;
> >      ^
> 
> This doesn't work, you cannot break interim builds. Your patch 2 needs
> to go before patch 1, and you must always check that they compile for
> each patch you apply.
> 
> NACK

Sorry for the trouble caused. I updated my patchs to fix this problem.

- Geliang

This patch set uses list_for_each_entry*() instead of
list_for_each*(), removes useless codes, and cleans
whitespaces and blank lines.

Changes in v5:
 - fix build error.
Changes in v4:
 - revise the patchs as Jes suggested.
Changes in v3:
 - split it into three patches.
Changes in v2:
 - drop the coding style fixing in v1.

Geliang Tang (3):
  staging: rtl8723au: use list_for_each_entry*()
  staging: rtl8723au: core: rtw_recv: remove useless codes
  staging: rtl8723au: whitespace and blank line cleaning

 drivers/staging/rtl8723au/core/rtw_ap.c           | 92 ++++++-----------------
 drivers/staging/rtl8723au/core/rtw_mlme.c         | 38 +++-------
 drivers/staging/rtl8723au/core/rtw_mlme_ext.c     | 13 ++--
 drivers/staging/rtl8723au/core/rtw_recv.c         | 42 ++++-------
 drivers/staging/rtl8723au/core/rtw_sta_mgt.c      | 36 +++------
 drivers/staging/rtl8723au/core/rtw_xmit.c         | 90 ++++++++--------------
 drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 22 ++----
 drivers/staging/rtl8723au/os_dep/usb_ops_linux.c  |  9 +--
 8 files changed, 106 insertions(+), 236 deletions(-)

-- 
2.5.0


