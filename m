Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34751 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbbG3Vf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 17:35:27 -0400
Received: by pacan13 with SMTP id an13so29836628pac.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:35:27 -0700 (PDT)
From: Filipe Brandenburger <filbranden@google.com>
To: Johannes Berg <johannes.berg@intel.com>,
	Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Elliott Hughes <enh@google.com>,
	Christopher Wiley <wiley@google.com>,
	Filipe Brandenburger <filbranden@google.com>
Subject: [PATCH 0/2] iw: fixes to Android.mk to include "iw" in AOSP builds
Date: Thu, 30 Jul 2015 14:35:13 -0700
Message-Id: <1438292115-39495-1-git-send-email-filbranden@google.com> (sfid-20150730_233636_420641_73AD4AC6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on including "iw" on Android AOSP eng builds and it turns out we
need some fixes to Android.mk to make it build on a current AOSP tree.

We already have an Android git repo set up with the "iw" tree:
https://android.googlesource.com/platform/external/iw.git

The two patches in this patchset will fix the references to libnl and remove
the nla_put_flag that might have been necessary in the past but is no longer
needed.

One alternative is to remove Android.mk from the upstream repo at kernel.org,
in which case we could simply maintain it downstream in the Android repo
instead.  If that's what you prefer, let me know and I can send you an
alternative commit to just remove those files.

Let me know if you have questions or suggestions.

Cheers,
Filipe


Filipe Brandenburger (2):
  iw: fix references to libnl in Android.mk
  iw: remove android-nl.c with unneeded workaround

 Android.mk   | 6 +++---
 android-nl.c | 6 ------
 2 files changed, 3 insertions(+), 9 deletions(-)
 delete mode 100644 android-nl.c

-- 
2.5.0.rc2.392.g76e840b

