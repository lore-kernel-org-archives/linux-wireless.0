Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38778 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810AbbGaGzt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2015 02:55:49 -0400
Received: by wibxm9 with SMTP id xm9so19264395wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 23:55:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438292828-13583-1-git-send-email-filbranden@google.com>
References: <CAJgzZoq4iqe_DQVNbDBjJkdpD15LrQY8aApJco5hbr0W-soA6A@mail.gmail.com>
 <1438292828-13583-1-git-send-email-filbranden@google.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 31 Jul 2015 09:55:33 +0300
Message-ID: <CA+XVXfcbZbUphZKvJTNvA9a67iN0rokaUqrDku=Bp5Tx_9R-Uw@mail.gmail.com> (sfid-20150731_085552_504297_47AFACDB)
Subject: Re: [PATCH v2 1/2] iw: fix references to libnl in Android.mk
To: Filipe Brandenburger <filbranden@google.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Elliott Hughes <enh@google.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Christopher Wiley <wiley@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Won't this break iw build with earlier Android trees? Did you test
this on something like KK?

On Fri, Jul 31, 2015 at 12:47 AM, Filipe Brandenburger
<filbranden@google.com> wrote:
> The latest AOSP refers to that library as libnl and not libnl_2.
>
> TEST=Built AOSP tree with this patchset, tested the generated iw binary.
>
> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> ---
> v2: Removed now redundant LOCAL_C_INCLUDES as suggested by Elliott.
>     Retested to confirm it still builds and works as intended.
>
>  Android.mk | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/Android.mk b/Android.mk
> index 735b236809ef..03bcc3e93d4d 100644
> --- a/Android.mk
> +++ b/Android.mk
> @@ -9,15 +9,11 @@ include $(LOCAL_PATH)/Makefile
>
>  LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS)) android-nl.c
>
> -LOCAL_C_INCLUDES := \
> -       $(LOCAL_PATH) \
> -       external/libnl-headers/
> -
>  LOCAL_CFLAGS += -DCONFIG_LIBNL20
>  LOCAL_LDFLAGS := -Wl,--no-gc-sections
>  #LOCAL_MODULE_TAGS := optional
>  LOCAL_MODULE_TAGS := eng
> -LOCAL_STATIC_LIBRARIES := libnl_2
> +LOCAL_STATIC_LIBRARIES := libnl
>  LOCAL_MODULE := iw
>
>  $(IW_SOURCE_DIR)/version.c:
> --
> 2.5.0.rc2.392.g76e840b
>
