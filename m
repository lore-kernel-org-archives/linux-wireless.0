Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:57100 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283Ab2LKX1U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Dec 2012 18:27:20 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so25271lag.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Dec 2012 15:27:19 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5452866.tG58b6Y9lW@lx-vladimir>
References: <5452866.tG58b6Y9lW@lx-vladimir>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 11 Dec 2012 15:26:59 -0800
Message-ID: <CAB=NE6WwW2jqieVi57Jecx_QHT7+h7yvQbk893CRjLC=sNED1g@mail.gmail.com> (sfid-20121212_002724_144541_70D5F30C)
Subject: Re: [PATCH] crda: fix compilation with libnl-3.0
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 10, 2012 at 7:58 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> From 97f1b27e02740ce6bb83c548de0c0a7fbe9b648f Mon Sep 17 00:00:00 2001
> From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> Date: Mon, 10 Dec 2012 17:54:29 +0200
> Subject: [PATCH] crda: fix compilation with libnl-3.0
>
> On the distributives that use libnl v.3, libnl-genl named
> libnl-genl-3.
>
> Checked for both rpm based distros and Ubuntu.
>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Makefile b/Makefile
> index 084d8e5..f5bd130 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -51,7 +51,7 @@ NL3FOUND := $(shell pkg-config --atleast-version=3 libnl-3.0 && echo Y)
>
>  ifeq ($(NL3FOUND),Y)
>  CFLAGS += -DCONFIG_LIBNL30
> -NLLIBS += -lnl-genl
> +NLLIBS += -lnl-genl-3
>  NLLIBNAME = libnl-3.0
>  else

Thanks but see upstream commit f2a073df, this added this:

+NLLIBS += $(shell pkg-config --libs libnl-genl-3.2)

But I never made a new release with that so I just tag'd v1.1.3 to
kick out a new release. If the wireless.kernel.org tarball generation
cronjob is still alive it will make a new tarball tomorrow sometime
with this release.

mcgrof@frijol ~/devel/crda (git::master)$ git shortlog v1.1.2..v1.1.3
Luis R. Rodriguez (15):
      crda: synch up nl80211.h
      crda: fix null string assumption for alpha2
      crda: add support to send DFS master region
      crda: use stdint.h instead of linux/types.h
      crda: move country2rd() and its helper to reglib.c
      crda: add a reglib iterator reglib_for_each_country()
      crda: make intersect.c use reglib_for_each_country()
      crda: close fd upon leaving
      crda: add new reglib_get_country_alpha2()
      crda: add dfs_region to the ieee80211_regdomain data structure
      crda: make crda use reglib_get_country_alpha2()
      crda: clean header files
      crda: make country2rd() static
      crda: make usage of regdb.h exclusive to reglib.c
      crda: rename reglib_get_*() routines

Stefan Lippers-Hollmann (1):
      crda: add nested support for libnl-3.2

  Luis
