Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AC23C10F14
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 10:13:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29E2D2082E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 10:13:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="KqvPelDz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbfDLKNJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 06:13:09 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:60404 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLKNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 06:13:09 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190412101306euoutp01f4f5ef92d29069bf9218887420c288b5~UsnTdpBzI1216212162euoutp01Q
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 10:13:06 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190412101306euoutp01f4f5ef92d29069bf9218887420c288b5~UsnTdpBzI1216212162euoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1555063986;
        bh=s2Tp9OXuTYVy3RNH7SHukzXrletl2Lhz48o0gPjr2aQ=;
        h=To:Cc:From:Subject:Date:References:From;
        b=KqvPelDzhgBdLleOu/pq4SV7QwQk9HDUmrOqfEArwV7+p2SyOYnaTyvt4t9QwuwPz
         IKhA2s7DuCXawZtW3H/vLIx9HImuZmz2qIHLVitgIbNGf+QDquDa5M+y3pFwWIit1N
         3eJggmTgH7uSSitlaiGs39zwmD28KlW9bRc6kwx8=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190412101305eucas1p1cb1ad870251eddf135cfa71415f6473a~UsnStGRws1516515165eucas1p14;
        Fri, 12 Apr 2019 10:13:05 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 77.6A.04325.1B460BC5; Fri, 12
        Apr 2019 11:13:05 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190412101304eucas1p1178d633eb7aa83c46a9386384ba0c300~UsnSCAw6Y1516515165eucas1p13;
        Fri, 12 Apr 2019 10:13:04 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190412101304eusmtrp1d446b4d40869e74fba2aab271e6c75f2~UsnRzwKm-2510125101eusmtrp1C;
        Fri, 12 Apr 2019 10:13:04 +0000 (GMT)
X-AuditID: cbfec7f5-b75ff700000010e5-ae-5cb064b14141
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 29.05.04146.0B460BC5; Fri, 12
        Apr 2019 11:13:04 +0100 (BST)
Received: from [106.120.51.71] (unknown [106.120.51.71]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190412101303eusmtip256de0937f44a7ee080ae5e48caca75c0~UsnRQfHLg1838318383eusmtip26;
        Fri, 12 Apr 2019 10:13:03 +0000 (GMT)
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     =?UTF-8?Q?Arve_Hj=c3=b8nnev=c3=a5g?= <arve@android.com>,
        Todd Kjos <tkjos@android.com>,
        Martijn Coenen <maco@android.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Christian Brauner <christian@brauner.io>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Adham Abozaeid <adham.abozaeid@microchip.com>,
        Ajay Singh <ajay.kathat@microchip.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-wireless@vger.kernel.org
From:   Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] staging: remove redundant 'default n' from Kconfig
Message-ID: <76b9b4d9-ade2-8284-0223-a6ecafd0ad14@samsung.com>
Date:   Fri, 12 Apr 2019 12:13:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:45.0) Gecko/20100101
        Thunderbird/45.3.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA02SfUhTURjGO7t3d9fh7DgN3zQqFloZZZF/XNLCUuRSQd9h3930otJctusq
        +xArKJNotaAPU3QTPxqWU2zZLI1pLd1cRJhFoX2YSLUiUyrRytud1H+/9z3Pc97nPRyaUD+S
        h9OZuhxer+O0GkpJ2h/+9M6vS7NtX3jj42TGc+UcwVj6k5gvY70Uc/zzLOauZ0TBnCyvpZjK
        /EjmqaOYYs7absmZT9WvFIy9Jl/OVNaPypiyZyOKBBVrb7LL2bGSrwTb09xKsubBYTlbbz1D
        sS0lNQr21Y8KxH6rn76W3qqMT+O1mQd4fcyy3cqMrlIXmX0t9lBLq0uWj8qjC1EADTgWPja8
        oAqRklbjagQP37SQUjGE4MHvakIqviGoM1qICcv5S91+VRWC6pf9fr8PQfk9t1xUheLFYOws
        UohM4GcEtNWtEJnCS+DCaSsSOQQnwn2riRJZhZeBzz06zjRN4kgYGFwh4hScAkbPbEkRDO1X
        +0jpxhlw21f8NxzgDgWUWttIKVwSXDF7FBKHwAdXg5+ngfviWVIy3EQwVjDgd99GUHXxFyWp
        4qDV9UQuTibwXKh1xEjt5dDrdiCxDTgInvuCpRBBYLJfJqS2CgpOqSV1FNgqbdTE2MI71/3v
        xoLD9E4mshrvgKdVRnQezSz6b7Wi/1Yr+pehDBFWFMYbhKx0Xlis4w8uELgswaBLX5C6L6se
        jf8v9y/XcCNqHt3jRJhGmkCVLbF2u1rOHRBys5wIaEITqtpIjrdUaVzuYV6/b5feoOUFJ4qg
        SU2Y6sik19vUOJ3L4ffyfDavnziV0QHh+SjZc6G8dPOWZPtjMl7W3Wjh3GFjGyrpVXntTSX7
        bamNHd0m85Ap730yLA28M+fE1J6GTeY1CfMmd2GvozPKlHP5e1hJn/fY+oij9uyd/PWIPmdK
        1+rmdUkBhpt7ppJNz+nOldMPKePYHff6vd+X3ndbTgVpG99urlDXnLANPTmn1ZBCBrcomtAL
        3B8pqsVwWwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t/xe7obUjbEGOxqlLc4M6OP2WLRMxeL
        93/vs1k0vlO22HPmF7tF8+L1bBbLGlQtLu+aw2bRs2Erq8WbFXfYLbataWC1WLbpD5PFgmu/
        2B14Pbbt3sbq8XfuR2aPe/sOs3gs/PSV1WPTqk42j/1z17B73PmxlNHj8ya5AI4oPZui/NKS
        VIWM/OISW6VoQwsjPUNLCz0jE0s9Q2PzWCsjUyV9O5uU1JzMstQifbsEvYyr84+zFMw2qdh/
        +DhTA+NirS5GTg4JAROJCdOus3QxcnEICSxllHi8/gp7FyMHUEJG4vj6MogaYYk/17rYQGwh
        gdeMEusb+UFsEQFjif6zs9hBepkFbjFLPFl4BqyITcBKYmL7KkYQW1jAWeLAqklgcV4BO4m3
        p/+wgcxnEVCVePHJCSQsKhAhcethBwtEiaDEyZlPwGxmAXWJP/MuMUPY8hLb385hnsDIPwtJ
        2SwkZbOQlC1gZF7FKJJaWpybnltsqFecmFtcmpeul5yfu4kRGGXbjv3cvIPx0sbgQ4wCHIxK
        PLwBVutjhFgTy4orcw8xSnAwK4nwhrAAhXhTEiurUovy44tKc1KLDzGaAt09kVlKNDkfmADy
        SuINTQ3NLSwNzY3Njc0slMR5zxtURgkJpCeWpGanphakFsH0MXFwSjUwxv6STuxyiQ2uTAgt
        V9l89Iqd36oNf+9E3ApX0Aq2lveQ6eRyW9jI3Kb/vzHtygHFvFublO5M8NgkUHqswau11l+x
        nM/30uZ3wW6cMeynhGTvywcsv36C4/cSMwGTfR4H1mv4NNwK6isWzZmrvXza+58tOd9022LE
        7813O3PlUfr/B+/CIkKVWIozEg21mIuKEwF5jMgCyAIAAA==
X-CMS-MailID: 20190412101304eucas1p1178d633eb7aa83c46a9386384ba0c300
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190412101304eucas1p1178d633eb7aa83c46a9386384ba0c300
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190412101304eucas1p1178d633eb7aa83c46a9386384ba0c300
References: <CGME20190412101304eucas1p1178d633eb7aa83c46a9386384ba0c300@eucas1p1.samsung.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

'default n' is the default value for any bool or tristate Kconfig
setting so there is no need to write it explicitly.

Also since commit f467c5640c29 ("kconfig: only write '# CONFIG_FOO
is not set' for visible symbols") the Kconfig behavior is the same
regardless of 'default n' being present or not:

    ...
    One side effect of (and the main motivation for) this change is making
    the following two definitions behave exactly the same:
    
        config FOO
                bool
    
        config FOO
                bool
                default n
    
    With this change, neither of these will generate a
    '# CONFIG_FOO is not set' line (assuming FOO isn't selected/implied).
    That might make it clearer to people that a bare 'default n' is
    redundant.
    ...

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
---
 drivers/staging/Kconfig                    |    1 -
 drivers/staging/android/Kconfig            |    2 --
 drivers/staging/axis-fifo/Kconfig          |    1 -
 drivers/staging/gs_fpgaboot/Kconfig        |    1 -
 drivers/staging/media/Kconfig              |    1 -
 drivers/staging/media/rockchip/vpu/Kconfig |    1 -
 drivers/staging/most/Kconfig               |    1 -
 drivers/staging/rtl8192e/Kconfig           |    1 -
 drivers/staging/wilc1000/Kconfig           |    1 -
 drivers/staging/wlan-ng/Kconfig            |    1 -
 10 files changed, 11 deletions(-)

Index: b/drivers/staging/Kconfig
===================================================================
--- a/drivers/staging/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/Kconfig	2019-04-12 12:04:20.786128367 +0200
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 menuconfig STAGING
 	bool "Staging drivers"
-	default n
 	---help---
 	  This option allows you to select a number of drivers that are
 	  not of the "normal" Linux kernel quality level.  These drivers
Index: b/drivers/staging/android/Kconfig
===================================================================
--- a/drivers/staging/android/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/android/Kconfig	2019-04-12 12:04:20.786128367 +0200
@@ -5,7 +5,6 @@ if ANDROID
 
 config ASHMEM
 	bool "Enable the Anonymous Shared Memory Subsystem"
-	default n
 	depends on SHMEM
 	help
 	  The ashmem subsystem is a new shared memory allocator, similar to
@@ -17,7 +16,6 @@ config ASHMEM
 
 config ANDROID_VSOC
 	tristate "Android Virtual SoC support"
-	default n
 	depends on PCI_MSI
 	help
 	  This option adds support for the Virtual SoC driver needed to boot
Index: b/drivers/staging/axis-fifo/Kconfig
===================================================================
--- a/drivers/staging/axis-fifo/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/axis-fifo/Kconfig	2019-04-12 12:04:59.734129348 +0200
@@ -5,7 +5,6 @@
 config XIL_AXIS_FIFO
 	tristate "Xilinx AXI-Stream FIFO IP core driver"
 	depends on OF
-	default n
 	help
 	  This adds support for the Xilinx AXI-Stream
 	  FIFO IP core driver.
Index: b/drivers/staging/gs_fpgaboot/Kconfig
===================================================================
--- a/drivers/staging/gs_fpgaboot/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/gs_fpgaboot/Kconfig	2019-04-12 12:04:20.790128367 +0200
@@ -4,6 +4,5 @@
 #
 config GS_FPGABOOT
 	tristate "Xilinx FPGA firmware download module"
-	default n
 	help
 	  Xilinx FPGA firmware download module
Index: b/drivers/staging/media/Kconfig
===================================================================
--- a/drivers/staging/media/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/media/Kconfig	2019-04-12 12:05:05.470129493 +0200
@@ -1,7 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 menuconfig STAGING_MEDIA
 	bool "Media staging drivers"
-	default n
 	help
 	  This option allows you to select a number of media drivers that
 	  don't have the "normal" Linux kernel quality level.
Index: b/drivers/staging/media/rockchip/vpu/Kconfig
===================================================================
--- a/drivers/staging/media/rockchip/vpu/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/media/rockchip/vpu/Kconfig	2019-04-12 12:04:20.794128367 +0200
@@ -6,7 +6,6 @@ config VIDEO_ROCKCHIP_VPU
 	select VIDEOBUF2_DMA_CONTIG
 	select VIDEOBUF2_VMALLOC
 	select V4L2_MEM2MEM_DEV
-	default n
 	help
 	  Support for the Video Processing Unit present on Rockchip SoC,
 	  which accelerates video and image encoding and decoding.
Index: b/drivers/staging/most/Kconfig
===================================================================
--- a/drivers/staging/most/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/most/Kconfig	2019-04-12 12:04:20.794128367 +0200
@@ -2,7 +2,6 @@
 menuconfig MOST
         tristate "MOST support"
 	depends on HAS_DMA
-        default n
         ---help---
 	  Say Y here if you want to enable MOST support.
 	  This driver needs at least one additional component to enable the
Index: b/drivers/staging/rtl8192e/Kconfig
===================================================================
--- a/drivers/staging/rtl8192e/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/rtl8192e/Kconfig	2019-04-12 12:04:20.794128367 +0200
@@ -2,7 +2,6 @@
 config RTLLIB
 	tristate "Support for rtllib wireless devices"
 	depends on WLAN && m
-	default n
 	select LIB80211
 	help
 	  If you have a wireless card that uses rtllib, say
Index: b/drivers/staging/wilc1000/Kconfig
===================================================================
--- a/drivers/staging/wilc1000/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/wilc1000/Kconfig	2019-04-12 12:04:20.794128367 +0200
@@ -34,7 +34,6 @@ config WILC1000_SPI
 config WILC1000_HW_OOB_INTR
 	bool "WILC1000 out of band interrupt"
 	depends on WILC1000_SDIO
-	default n
 	help
 	  This option enables out-of-band interrupt support for the WILC1000
 	  chipset. This OOB interrupt is intended to provide a faster interrupt
Index: b/drivers/staging/wlan-ng/Kconfig
===================================================================
--- a/drivers/staging/wlan-ng/Kconfig	2019-04-12 12:04:20.794128367 +0200
+++ b/drivers/staging/wlan-ng/Kconfig	2019-04-12 12:04:20.794128367 +0200
@@ -4,7 +4,6 @@ config PRISM2_USB
 	depends on WLAN && USB && CFG80211
 	select WIRELESS_EXT
 	select WEXT_PRIV
-	default n
 	help
 	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
 	  old USB wireless devices.
