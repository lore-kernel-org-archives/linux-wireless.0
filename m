Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34009 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3HATDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Aug 2013 15:03:32 -0400
MIME-Version: 1.0
In-Reply-To: <20130801174749.GC10904@shaftnet.org>
References: <1375338204-2021-8-git-send-email-sujith@msujith.org>
 <1375370826-1387-1-git-send-email-sujith@msujith.org> <51FA8ECD.7070401@lenbrook.com>
 <20130801174749.GC10904@shaftnet.org>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 1 Aug 2013 12:03:08 -0700
Message-ID: <CAB=NE6XqfKeddOSu=my3JOZDvg7nQtacZU6o4VeZXTZSLAAEnQ@mail.gmail.com> (sfid-20130801_210336_031550_4C99A999)
Subject: Re: cross compile backports?
To: Solomon Peachy <pizza@shaftnet.org>
Cc: Jonathan Bagg <jbagg@lenbrook.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 1, 2013 at 10:47 AM, Solomon Peachy <pizza@shaftnet.org> wrote:
> On Thu, Aug 01, 2013 at 12:37:33PM -0400, Jonathan Bagg wrote:
>> I've been cross compiling compat-wireless and now I'm trying
>> backports.  It looks like conf.c and zconf.tab.c are being compiled
>> as arm and then the build process is trying to run conf on my x86
>> host.  Results using the below make parameters I was using for
>> compat-wireless......
>
> Howdy.  :)
>
> (btw, I'm CC'ing the backports mailing list, which is a better place to
>  ask these sorts of questions)
>
> I found that the backports cross-compile process worked much the same
> way as building compat-wireless.  This is what I'm doing currently in my
> build script:  (This is using a backports package generated last night
> using the backports git HEAD code with the cw1200 driver integrated)
>
>  set -a
>  CROSS_COMPILE=${CROSS_COMPILE}
>  ARCH=${TARGET_CPU}
>  KLIB_BUILD=${DEV_PATH}/${LINUX_DIR}
>  KLIB=${TARGET_ROOT_ON_HOST}
>  set +a
>  make oldconfig  # menuconfig worked here too
>  make
>  make install
>
> That said, the 'make install' target isn't currently sane for
> cross-builds due to the bacport_firmware_install script not respecting
> prefixes.  I just commented that script (and a few others like initrd
> updates) out of the Makefiles, and I had a successful build/install.

Thanks, now:

https://backports.wiki.kernel.org/index.php/Documentation#Cross_compiling

Patches welcome to help improve the cross compile install target.

  Luis
