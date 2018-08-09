Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727768AbeHINGB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Aug 2018 09:06:01 -0400
Date: Thu, 9 Aug 2018 12:41:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-drivers] mt76x0: Remove VLA usage
Message-ID: <20180809104137.GA1955@redhat.com> (sfid-20180809_124250_851521_464A29B6)
References: <20180807225040.GA2164@beast>
 <20180808092450.GA25772@redhat.com>
 <871sb942cx.fsf@kamboji.qca.qualcomm.com>
 <CAGXu5jKqeAHDWdNg++QJko5AM4g160kEQ54jLAojpRq6FszqgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5jKqeAHDWdNg++QJko5AM4g160kEQ54jLAojpRq6FszqgA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2018 at 08:41:28AM -0700, Kees Cook wrote:
> >> I thought SPDX line is needed only if file has no license and eeprom.c
> >> file and other mt76x0 files have specified the license. Is SPDX still
> >> needed in that case ?
> 
> I thought all source files needed SPDX: https://lwn.net/Articles/739183/

Ok, goal is to have all kernel source files with SPDX header.

> >>> +#define MT_MAP_READS        DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16)
> >>>  static int
> >>>  mt76x0_efuse_physical_size_check(struct mt76x0_dev *dev)
> >>>  {
> >>> -    const int map_reads = DIV_ROUND_UP(MT_EFUSE_USAGE_MAP_SIZE, 16);
> >>> -    u8 data[map_reads * 16];
> >>
> >> Why this is variable length array? DIV_ROUND_UP can not be calculated
> >> at compile time? But if so, macro do not change the situation either.
> >
> > The commit log mentioned:
> >
> >   "Even with "const" variables, the compiler will generate warnings about
> >    VLA usage."
> >
> > So I guess the compiler (gcc?) is just not smart enough in this case?
> 
> Correct. This is technically a false positive, but with the goal of
> adding -Wvla to the build globally, we have to get rid of these as
> well. It's a little frustrating, I agree, but with all others fixed
> now, these stand out. :)

Then:
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
