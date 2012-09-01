Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58315 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2IAQFZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2012 12:05:25 -0400
Received: by vbbff1 with SMTP id ff1so4176392vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Sep 2012 09:05:24 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 Sep 2012 12:05:23 -0400
Message-ID: <CA+7oygfSuwomt5GxWKNvcjqTjSeW_gS9zvcFVqJN75EZp03zxw@mail.gmail.com> (sfid-20120901_180542_242821_369500D1)
Subject: want to use mac80211/cfg80211 from kernel tree...
From: George Nychis <gnychis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a long story cut very short, but I have an Android kernel tree
which has mac80211 and cfg80211 built as modules and support for a
Broadcom chipset.

I want to add support for rt2x00 from compat-wireless, cross-compiling
it.  I am able to successfully cross-compile it, however the build in
compat-wireless creates its own set of mac80211 and cfg80211 modules.
So now I end up with:

*  In kernel tree:  cfg80211.ko, mac80211.ko, and dhd.ko which are
compatible with each other.
*  In compat-wireless: cfg80211.ko, mac80211.ko, and rt*.ko which are compatible

So, I can't insert all of these modules because dhd.ko is only
compatible (due to versions) with cfg80211.ko and mac80211.ko that
were built with the kernel, and the Ralink modules are only compatible
with cfg80211.ko and mac80211.ko that were built with compat-wireless.

Is there any way for me to get compat-wireless to not build its own
versions of cfg80211.ko and mac80211.ko, and use those in the
KERNEL_DIR?  That way I don't have two sets of cfg80211/mac80211 and I
can insert all modules?

Thanks!
George
