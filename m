Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37985 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab3BGQHC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 11:07:02 -0500
Message-ID: <5113D11C.7060608@hauke-m.de> (sfid-20130207_170710_311611_21BA2BE9)
Date: Thu, 07 Feb 2013 17:06:52 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: stable compat-drivers-3.8-rc5-1 is broken
References: <510FAB9B.1040102@gmail.com> <511278B7.8000600@gmail.com>
In-Reply-To: <511278B7.8000600@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/2013 04:37 PM, Xose Vazquez Perez wrote:
> hi,
> 
> with compat-drivers-3.8-rc5-1 I get:
> 
> make -C /lib/modules/3.7.5-101.fc17.x86_64/build M=/home/xose/tmp/compat-drivers-3.8-rc5-1 modules
> make[1]: Entering directory `/usr/src/kernels/3.7.5-101.fc17.x86_64'
>   CC [M]  /home/xose/tmp/compat-drivers-3.8-rc5-1/net/wireless/core.o
> /home/xose/tmp/compat-drivers-3.8-rc5-1/net/wireless/core.c: In function ‘cfg80211_netdev_notifier_call’:
> /home/xose/tmp/compat-drivers-3.8-rc5-1/net/wireless/core.c:895:3: error: implicit declaration of function ‘netdev_set_default_ethtool_ops’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

This bug is already fixed in the version for linux-next, I will do a new
release for 3.8 soon. You can apply this patch [0] manually to fix this
problem.

Hauke
[0]:
https://github.com/hauke/compat/commit/726d9b2ca3f75cba9f1d03e519c2b2e8bf6523a7

