Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2ECS6M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 14:58:12 -0400
Message-ID: <1336071490.5167.7.camel@jlt3.sipsolutions.net> (sfid-20120503_205816_400444_5BBE6D69)
Subject: Re: [RFC 0/9] compat-wireless: restructure header files in compat
From: Johannes Berg <johannes@sipsolutions.net>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: mcgrof@gmail.com, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Date: Thu, 03 May 2012 20:58:10 +0200
In-Reply-To: <1335463674-13003-1-git-send-email-hauke@hauke-m.de> (sfid-20120426_200811_897687_43DE405B)
References: <1335463674-13003-1-git-send-email-hauke@hauke-m.de>
	 (sfid-20120426_200811_897687_43DE405B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-26 at 20:07 +0200, Hauke Mehrtens wrote:
> The patch series moves the compat code from include/linux/compat-*.h 
> into new files with the same name as the file where this code is placed 
> in the mainline kernel. With this approach we do not have to include 
> all include/linux/compat-*.h files in the build process any more, but 
> we extend the existing header files by the code needed.
> 
> This compiles without any warnings for me with kernel 3.2 to 3.4 and 
> fixes the problems with pr_fmt() without the need of any patch.
> Sometimes I had problems compiling compat-wireless, because some header 
> file I would not like to include was included because of compat-2.6.h 
> included mostly every header file available in the kernel.
> 
> This patch series is only done to support kernel >= 3.2, supporting the 
> other versions is just more work, but I want to have some responses on 
> this first. There are probably some other problems and some more 
> cleanup is possible.
> In the end we will remove the include/linux/compat-*.h files.
> 
> I have a problem where compat does changes to header files provided by 
> compat-wireless like #define NL80211_FEATURE_SK_TX_STATUS 0 in compat-
> 2.6.33.h. To make this work we should add an other include directory in 
> compat-wireless.
> The hierarchy of include directories should be this: 1. include dir 
> from compat, 2. include dir from compat-wireless, 3. the kernel include 
> dir, now the 1. and the 2. are but into one directory.


I think this is worthwhile. There may be some issues with it,
particularly when header files are renamed, but I think those can be
solved relatively easily, like we already did with tracing.

johannes

