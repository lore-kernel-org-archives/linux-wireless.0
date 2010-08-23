Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62029 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0HWEnw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 00:43:52 -0400
Received: by eyg5 with SMTP id 5so3014342eyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 22 Aug 2010 21:43:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikanjZf0LEqZjw5toeJz02Tcs6EcAiNdagJh=sQ@mail.gmail.com>
References: <AANLkTi=W=vkgb0gM7ZWsBeE79Fe3iabtKFgu2S7N5uLe@mail.gmail.com>
	<201008011137.49528.florian@openwrt.org>
	<AANLkTik=t=jeCG7=bgkq3LBwJP9vq7KmFpgDeHngPoq-@mail.gmail.com>
	<4C55F377.6040404@candelatech.com>
	<AANLkTinGqWZ8o9L=ePsbgzWtitWAHCt3=g_z6BM7EpjO@mail.gmail.com>
	<4C618713.9030303@candelatech.com>
	<AANLkTikanjZf0LEqZjw5toeJz02Tcs6EcAiNdagJh=sQ@mail.gmail.com>
Date: Mon, 23 Aug 2010 14:43:50 +1000
Message-ID: <AANLkTik9vPPxpxksGhRLkU+5y8YouJ+mbMHMBgt3B+3J@mail.gmail.com>
Subject: Re: virtual access poitns (ath5k/mac80211)
From: Ryszard <ryszard99@gmail.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Florian Fainelli <florian@openwrt.org>,
	Patrick McHardy <kaber@trash.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

now that i've got the kernel installed and working, i need to get some
modules installed.

I'm making the kernel with make-kpkg and want to do a make-kpkg
modules_install but am getting this error:
-----------------------------------------------------
root@bssapp1:~/linux-2.6.dev.31.y# time make-kpkg modules_image
exec debian/rules  DEBIAN_REVISION=2.6.31.12-10.00.Custom  modules_image
for module in  ; do                       \
          if test -d  $module; then                                \
            (cd $module;                                          \
              if ./debian/rules KVERS="2.6.31.12"
KSRC="/home/jwilliams/linux-2.6.dev.31.y" \
                             KMAINT="Unknown Kernel Package
Maintainer" KEMAIL="unknown@unconfigured.in.etc.kernel-pkg.conf"
\

KPKG_DEST_DIR="/home/jwilliams/linux-2.6.dev.31.y/.."       \
                             KPKG_MAINTAINER="Unknown Kernel Package
Maintainer"        \
                             KPKG_EXTRAV_ARG=""        \
                             ARCH="i386"         \
                             KDREV="2.6.31.12-10.00.Custom"
kdist_image; then    \
                  echo "Module $module processed fine";            \
              else                                                  \
                   echo "Module $module failed.";                  \
                   if [ "X" != "X" ]; then      \
                      echo "Perhaps $module does not understand --rootcmd?";  \
                      echo "If you see messages that indicate that it is not"; \
                      echo "in fact being built as root, please file a bug ";  \
                      echo "against $module.";                     \
                   fi;                                              \
                   echo "Hit return to Continue";                   \
                 read ans;                                        \
              fi;                                                   \
             );                                                    \
          else                                                      \
               echo "Module $module does not exist";               \
               echo "Hit return to Continue?";                      \
          fi;                                                       \
        done

real    0m6.557s
user    0m4.050s
sys     0m2.810s
root@bssapp1:~/linux-2.6.dev.31.y#
-----------------------------------------------------

does anyone have a hint or tip for me?!

regs
Jason


On 21 August 2010 13:07, Ryszard <ryszard99@gmail.com> wrote:
> I've managed to compile and get bens kernel installed.  the problem i
> had (for future reference) was the physical media not being
> recognised.  adding rootdelay=130 to the kernel options seemed to have
> fixed that.
>
> On 11 August 2010 03:06, Ben Greear <greearb@candelatech.com> wrote:
>> On 08/10/2010 09:54 AM, Luis R. Rodriguez wrote:
>>>
>>> On Sun, Aug 1, 2010 at 3:21 PM, Ben Greear<greearb@candelatech.com>
>>>  wrote:
>>
>>>> You would not believe how hard it is to keep up with the wireless tree.
>>>>  Last time,
>>>> by the time we had something stable, upstream had changed too much to
>>>> merge.
>>>
>>> This is why you should not do your development outside of
>>> wireless-testing. If you are doing development on a stable kernel tree
>>> then you will likely run into huge issues. You should do development
>>> on wireless-testing.git, always rebase when John has a new update, and
>>> break your changes out into a small changes as possible. If you follow
>>> these basic rules I believe you will likely have better luck with
>>> keeping your code up to date.
>>
>> That sounds nice, but at that time I was carrying a lot of other patches
>> needed to make my test environment work.  Fortunately, .35 pretty much
>> works out of the box, so I can develop on pristine upstream kernels now.
>>
>> Thanks,
>> Ben
>>
>> --
>> Ben Greear <greearb@candelatech.com>
>> Candela Technologies Inc  http://www.candelatech.com
>>
>>
>
