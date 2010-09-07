Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63143 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab0IGHgL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 03:36:11 -0400
Received: by iwn5 with SMTP id 5so5070577iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Sep 2010 00:36:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283612809-6798-2-git-send-email-hauke@hauke-m.de>
References: <1283612809-6798-1-git-send-email-hauke@hauke-m.de> <1283612809-6798-2-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Sep 2010 00:35:46 -0700
Message-ID: <AANLkTikAzCto11UH65sYAcCTEG_cZMNXY66pjmc6ObgJ@mail.gmail.com>
Subject: Re: [PATCH 1/5] compat-wireless: add conditions form config into compat_autoconf.h
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 4, 2010 at 8:06 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> We do not have to use "ifneq ($(CONFIG_...),)", "ifdef CONFIG_..." will
> also work. It does not matter if it was set to m or y.
> Now this can be added into compat_autoconf.h without changing the script.
>
> The special handling for CONFIG_CFG80211_WEXT is not needed any more,
> because it is only activated when CONFIG_WIRELESS_EXT is also set.
> Enabling this condition only for kernel <= 2.6.32 was wrong. In compat-
> wireless we are able to deactivate CONFIG_WIRELESS_EXT for every
> kernel. For activating it we need CONFIG_WIRELESS_EXT on every kernel.
> If kernel <= 2.6.31 was build with cfg80211 support CONFIG_WIRELESS_EXT
> was also selected, so it was activated in most cases for that kernel
> versions. But it is possible to build compat-wireless without having
> cfg80211 while building the kernel and that caused problems in the past.

This patch addresses two things in one, can it be split as I do not
agree with the WEXT one. For example I do not have
CONFIG_WIRELESS_EXT:

mcgrof@tux ~/wireless-testing (git::master)$ grep WIRELESS_EXT .config
CONFIG_WIRELESS_EXT_SYSFS=y

  Luis
