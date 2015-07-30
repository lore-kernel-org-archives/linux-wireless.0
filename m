Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34037 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbbG3VhS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 17:37:18 -0400
Received: by obre1 with SMTP id e1so40698146obr.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:37:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438292115-39495-2-git-send-email-filbranden@google.com>
References: <1438292115-39495-1-git-send-email-filbranden@google.com> <1438292115-39495-2-git-send-email-filbranden@google.com>
From: enh <enh@google.com>
Date: Thu, 30 Jul 2015 14:36:57 -0700
Message-ID: <CAJgzZoq4iqe_DQVNbDBjJkdpD15LrQY8aApJco5hbr0W-soA6A@mail.gmail.com> (sfid-20150730_233723_671783_102AEB98)
Subject: Re: [PATCH 1/2] iw: fix references to libnl in Android.mk
To: Filipe Brandenburger <filbranden@google.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Christopher Wiley <wiley@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 30, 2015 at 2:35 PM, Filipe Brandenburger
<filbranden@google.com> wrote:
> The latest AOSP refers to that library as libnl and not libnl_2.
>
> TEST=Built AOSP tree with this patchset, tested the generated iw binary.
>
> Signed-off-by: Filipe Brandenburger <filbranden@google.com>
> ---
>  Android.mk | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/Android.mk b/Android.mk
> index 735b236809ef..0820892c6c19 100644
> --- a/Android.mk
> +++ b/Android.mk
> @@ -11,13 +11,13 @@ LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS)) android-nl.c
>
>  LOCAL_C_INCLUDES := \
>         $(LOCAL_PATH) \
> -       external/libnl-headers/
> +       external/libnl/include

i think you can just remove the whole LOCAL_C_INCLUDES section; libnl
exports its headers. (sorry for not noticing this earlier.)

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



-- 
Elliott Hughes - http://who/enh - http://jessies.org/~enh/
Android native code/tools questions? Mail me/drop by/add me as a reviewer.
