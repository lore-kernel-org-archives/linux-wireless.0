Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750716AbdJLHZd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 03:25:33 -0400
Date: Thu, 12 Oct 2017 09:25:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Andrey Konovalov <andreyknvl@google.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        syzkaller <syzkaller@googlegroups.com>
Subject: Re: usb/net/rt2x00: warning in rt2800_eeprom_word_index
Message-ID: <20171012072529.GB2686@redhat.com> (sfid-20171012_092608_144072_B1B1D8EA)
References: <CAAeHK+yUNrrNU3Jqrfs7XAT809eyF4nv673cSL8RppbLrDtWNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAAeHK+yUNrrNU3Jqrfs7XAT809eyF4nv673cSL8RppbLrDtWNA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Mon, Oct 09, 2017 at 07:50:53PM +0200, Andrey Konovalov wrote:
> I've got the following report while fuzzing the kernel with syzkaller.
> 
> On commit 8a5776a5f49812d29fe4b2d0a2d71675c3facf3f (4.14-rc4).
> 
> I'm not sure whether this is a bug in the driver, or just a way to
> report misbehaving device. In the latter case this shouldn't be a
> WARN() call, since WARN() means bug in the kernel.

This is about wrong EEPROM, which reported 3 tx streams on
non 3 antenna device. I think WARN() is justified and thanks
to the call trace I was actually able to to understand what
happened.

In general I do not think WARN() only means a kernel bug, it 
can be F/W or H/W bug too.

Thanks
Stanislaw
