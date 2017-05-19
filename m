Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36359 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdESGzW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 02:55:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAKR_QVJGxWF8+ZGGn08XiOgpYVGSjwQwqJoP10fY_bjfRg-uzw@mail.gmail.com>
References: <20170517144702.1381136-1-arnd@arndb.de> <87r2zl8lvi.fsf@codeaurora.org>
 <CAKR_QVJGxWF8+ZGGn08XiOgpYVGSjwQwqJoP10fY_bjfRg-uzw@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 19 May 2017 08:55:21 +0200
Message-ID: <CAK8P3a3Y7rCvmJo062-5G07HGiT6x2MtvVV=dQAVBK0AiX0U_A@mail.gmail.com> (sfid-20170519_085528_522320_B870BEE4)
Subject: Re: [PATCH v2 00/10] rt2x00: rt2x00: improve calling conventions for
 register accessors
To: Tom Psyborg <pozega.tomislav@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        David Miller <davem@davemloft.net>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>,
        Johannes Berg <johannes.berg@intel.com>,
        Serge Vasilugin <vasilugin@yandex.ru>,
        Roman Yeryomin <roman@advem.lv>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jes Sorensen <jes.sorensen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 19, 2017 at 8:44 AM, Tom Psyborg <pozega.tomislav@gmail.com> wrote:
> warning: 'rt2800_bbp_read' used but never defined
>  static u8 rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
>            ^
> /home/ubuntu/Music/openwrt/build_dir/target-mipsel_24kc_musl-1.1.16/linux-ramips_mt7620/compat-wireless-2016-05-12/drivers/net/wireless/ralink/rt2x00/rt2800lib.h:262:13:
> warning: 'rt2800_bbp_write' used but never defined
>  static void rt2800_bbp_write(struct rt2x00_dev *rt2x00dev,
>              ^
>   CC [M]
> /home/ubuntu/Music/openwrt/build_dir/target-mipsel_24kc_musl-1.1.16/linux-ramips_mt7620/compat-wireless-2016-05-12/drivers/net/wireless/ralink/rt2x00/rt2800pci.o
> In file included from
> /home/ubuntu/Music/openwrt/build_dir/target-mipsel_24kc_musl-1.1.16/linux-ramips_mt7620/compat-wireless-2016-05-12/drivers/net/wireless/ralink/rt2x00/rt2800pci.c:43:0:
> /home/ubuntu/Music/openwrt/build_dir/target-mipsel_24kc_musl-1.1.16/linux-ramips_mt7620/compat-wireless-2016-05-12/drivers/net/wireless/ralink/rt2x00/rt2800lib.h:259:11:
> warning: 'rt2800_bbp_read' declared 'static' but never defined
> [-Wunused-function]
>  static u8 rt2800_bbp_read(struct rt2x00_dev *rt2x00dev,
>            ^

On which base version did you apply my patches? There may be a conflict
against patches that are in your tree but not yet in linux-next, as I don't see
the warning and also see no reference to rt2800_bbp_read in rt2800lib.h

      Arnd
