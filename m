Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:56121 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2E0KqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 06:46:10 -0400
MIME-Version: 1.0
In-Reply-To: <1338115108-19091-2-git-send-email-ozancag@gmail.com>
References: <1338115108-19091-1-git-send-email-ozancag@gmail.com>
	<1338115108-19091-2-git-send-email-ozancag@gmail.com>
Date: Sun, 27 May 2012 13:46:09 +0300
Message-ID: <CAFub=KRHFG-_ioVFVGW15tim75dOs7Y3UXOWLX+vvH6Kb5Hm9w@mail.gmail.com> (sfid-20120527_124614_807172_5981DAC2)
Subject: Re: [PATCH 2/2] bin/get-compat-kernels: Do not depend on Ubuntu
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozancag@gmail.com>
To: mcgrof@kernel.org
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 27, 2012 at 1:38 PM, Ozan Çağlayan <ozancag@gmail.com> wrote:
> Use Ubuntu PPA vanilla kernels on other distributions too.
> The .deb files are extracted using 'ar' and 'tar'.
>
> Also check if the target directory exists before downloading
> the deb files.
>
> Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>

This patch shouldn't introduce any side effects for Ubuntu users. I
only changed a conditional to check
if the debs are installed by looking whether the directories are found
in the system.

There's also a "make 3.82" bug found in kernels < 2.6.29. I fixed that
using sed. As Ubuntu sticks with make 3.81, there's no need to fix
that bug when the system is Ubuntu.

I build tested with Ubuntu PPA's on Fedora 17 x86_64:

[root@ozzyfedora compat]# bin/ckmake
Trying kernel                  3.3.0-030300rc2-generic	[FAILED] (This
is caused because of the latest CoDel backports, ignore this)
Trying kernel                     3.2.2-030202-generic	[OK]
Trying kernel                    3.1.10-030110-generic	[OK]
Trying kernel                    3.0.18-030018-generic	[OK]
Trying kernel                  2.6.39-02063904-generic	[OK]
Trying kernel                  2.6.38-02063808-generic	[OK]
Trying kernel                  2.6.37-02063706-generic	[OK]
Trying kernel                  2.6.36-02063604-generic	[OK]
Trying kernel                  2.6.35-02063512-generic	[OK]
Trying kernel                  2.6.34-02063410-generic	[OK]
Trying kernel                  2.6.33-02063305-generic	[OK]
Trying kernel                  2.6.32-02063255-generic	[OK]
Trying kernel                  2.6.31-02063113-generic	[OK]
Trying kernel                  2.6.30-02063010-generic	[OK]
Trying kernel                  2.6.29-02062906-generic	[OK]
Trying kernel                  2.6.28-02062810-generic	[OK]
Trying kernel                    2.6.27-020627-generic	[OK]
Trying kernel                    2.6.26-020626-generic	[OK]
Trying kernel                    2.6.25-020625-generic	[OK]
Trying kernel                    2.6.24-020624-generic	[OK]
