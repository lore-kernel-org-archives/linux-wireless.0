Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbcBQR2e (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2016 12:28:34 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Geliang Tang <geliangtang@163.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] staging: rtl8723au: use list_for_each_entry*()
References: <201602172303.ReBGrDL1%fengguang.wu@intel.com>
Date: Wed, 17 Feb 2016 12:28:33 -0500
In-Reply-To: <201602172303.ReBGrDL1%fengguang.wu@intel.com> (kbuild test
	robot's message of "Wed, 17 Feb 2016 23:16:34 +0800")
Message-ID: <wrfjtwl76ybi.fsf@redhat.com> (sfid-20160217_182855_000197_E9DC67E3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

kbuild test robot <lkp@intel.com> writes:
> Hi Geliang,
>
> [auto build test ERROR on staging/staging-testing]
> [also build test ERROR on v4.5-rc4 next-20160217]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Geliang-Tang/staging-rtl8723au-use-list_for_each_entry/20160217-220638
> config: i386-randconfig-s1-201607 (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
>
> Note: the linux-review/Geliang-Tang/staging-rtl8723au-use-list_for_each_entry/20160217-220638 HEAD 495811a52aba181af76c3baf57da3d81a79c2fe8 builds fine.
>       It only hurts bisectibility.
>
> All errors (new ones prefixed by >>):
>
>    drivers/staging/rtl8723au/core/rtw_recv.c: In function 'rtw_free_recvframe23a_queue':
>>> drivers/staging/rtl8723au/core/rtw_recv.c:203:2: error: 'plist' undeclared (first use in this function)
>      plist = phead->next;
>      ^

This doesn't work, you cannot break interim builds. Your patch 2 needs
to go before patch 1, and you must always check that they compile for
each patch you apply.

NACK

Jes
