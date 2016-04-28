Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35081 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbcD1X0z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2016 19:26:55 -0400
Received: by mail-oi0-f46.google.com with SMTP id x19so101209008oix.2
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2016 16:26:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461850619-15298-1-git-send-email-yongqin.liu@linaro.org>
References: <1461850619-15298-1-git-send-email-yongqin.liu@linaro.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 29 Apr 2016 09:26:35 +1000
Message-ID: <CAGRGNgUzimCmk+2aBDwqcqxnjRUhRni93UZ9Ln88amX84c8u8w@mail.gmail.com> (sfid-20160429_012659_977445_10CE3B7C)
Subject: Re: [PATCH 1/1] iw: Android.mk & version.sh: update for Android based compilation
To: Yongqin Liu <yongqin.liu@linaro.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>,
	Filipe Brandenburger <filbranden@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, Apr 28, 2016 at 11:36 PM, Yongqin Liu <yongqin.liu@linaro.org> wrote:
> update the Android.mk file and version.sh script for
> Android based compilation
>
> Android.mk:  the same file as the one in AOSP master tip
> version.sh:  update to get the version information from the
>    git repository where this file is located instead of the
>    the current directory where it is executed, otherwise if
>    there is .git directory in the current directory, it will
>    get the wrong version information.
>    And improved the version check since the tag information
>    may not be mirrored like what AOSP does now.
>
> Change-Id: I8fa59f0e5c7ebd61b364c77fdccf8e74da2e565c
> Signed-off-by: Yongqin Liu <yongqin.liu@linaro.org>
> ---
>  Android.mk | 30 ++++++++++++++++++++----------
>  version.sh | 39 +++++++++++++++++++++++++++------------
>  2 files changed, 47 insertions(+), 22 deletions(-)
>
> diff --git a/Android.mk b/Android.mk
> index 4a50f89..20b0432 100644
> --- a/Android.mk
> +++ b/Android.mk
> @@ -1,22 +1,32 @@
>  LOCAL_PATH := $(call my-dir)
> -IW_SOURCE_DIR := $(LOCAL_PATH)
>
>  include $(CLEAR_VARS)
>
> -IW_ANDROID_BUILD=y
> -NO_PKG_CONFIG=y
> -include $(LOCAL_PATH)/Makefile
> -
> -LOCAL_SRC_FILES := $(patsubst %.o,%.c,$(OBJS))
> +LOCAL_SRC_FILES := \
> +  iw.c genl.c event.c info.c phy.c \
> +  interface.c ibss.c station.c survey.c util.c ocb.c \
> +  mesh.c mpath.c mpp.c scan.c reg.c \
> +  reason.c status.c connect.c link.c offch.c ps.c cqm.c \
> +  bitrate.c wowlan.c coalesce.c roc.c p2p.c vendor.c \
> +  sections.c
>
>  LOCAL_CFLAGS += -DCONFIG_LIBNL20
> +
> +# Silence some warnings for now. Needs to be fixed upstream. b/26105799

Comments like this worry me: who is being referred to as "upstream",
what are these warnings and why has nobody fixed them?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
