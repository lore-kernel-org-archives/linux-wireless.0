Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40513 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767Ab2HGSBc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2012 14:01:32 -0400
Received: by ggnl2 with SMTP id l2so3985098ggn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Aug 2012 11:01:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6UUCVUDAn75UNX1uH=BMPkmjCtWr16iYBrGifkESCv=sA@mail.gmail.com>
References: <1343938505.4471.31.camel@jlt3.sipsolutions.net> <CAB=NE6UUCVUDAn75UNX1uH=BMPkmjCtWr16iYBrGifkESCv=sA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 7 Aug 2012 10:55:23 -0700
Message-ID: <CAB=NE6VUre2eDdszhw3wCq7mrWvZW1uB7n5yp+hOTRTChZNRBQ@mail.gmail.com> (sfid-20120807_200135_661013_6A7A8561)
Subject: Re: [PATCH] compat: handle pci suspend/resume on kernel 2.6.29
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 6, 2012 at 12:15 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, Aug 2, 2012 at 1:15 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> Before kernel 2.6.29, we use compat_pci_{suspend,resume}
>> and not the SIMPLE_DEV_PM_OPS, which include the code for
>> PCI device handling. For 2.6.30 and higher, the core PCI
>> code includes the device handling.
>>
>> That leaves 2.6.29 as the odd one out and causes suspend
>> and resume to fail. Fix it by including the PCI device
>> handling code in the definition of SIMPLE_DEV_PM_OPS for
>> that kernel version.
>>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Applied and pushed, thanks!

I applied this onto the linux-3.5.y branch for compat but get this
when compiling against 2.6.29:


/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/ipw2x00/libipw_rx.c:338:10:
warning: variable ‘type’ set but not used [-Wunused-but-set-variable]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:
In function ‘il_enqueue_hcmd’:
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:3089:6:
warning: variable ‘len’ set but not used [-Wunused-but-set-variable]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:
In function ‘__check_bt_coex_active’:
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:3316:1:
warning: return from incompatible pointer type [enabled by default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:
At top level:
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
error: conflicting type qualifiers for ‘il_pm_ops’
In file included from
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:43:0:
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.h:1854:32:
note: previous declaration of ‘il_pm_ops’ was here
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
warning: initialization from incompatible pointer type [enabled by
default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
warning: (near initialization for ‘il_pm_ops.suspend’) [enabled by
default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
warning: initialization from incompatible pointer type [enabled by
default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
warning: (near initialization for ‘il_pm_ops.freeze’) [enabled by
default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
warning: initialization from incompatible pointer type [enabled by
default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4916:7:
warning: (near initialization for ‘il_pm_ops.poweroff’) [enabled by
default]
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:4922:1:
error: conflicting type qualifiers for ‘il_pm_ops’
In file included from
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:43:0:
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.h:1854:32:
note: previous declaration of ‘il_pm_ops’ was here
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:
In function ‘il_isr’:
/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.c:5415:12:
warning: variable ‘inta_mask’ set but not used
[-Wunused-but-set-variable]
  CC [M]  /home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/ath/ath6kl/sdio.o
make[4]: *** [/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy/common.o]
Error 1
make[3]: *** [/home/mcgrof/staging/2/compat-wireless-3.5-3-snpc/drivers/net/wireless/iwlegacy]
Error 2

  Luis
