Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:43182 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932379AbeGDNhm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 09:37:42 -0400
Received: by mail-oi0-f47.google.com with SMTP id b15-v6so10762163oib.10
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2018 06:37:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180704130448.pta7t5joj5qrxlpq@mwanda>
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
 <20180704130448.pta7t5joj5qrxlpq@mwanda>
From: Daniel Drake <drake@endlessm.com>
Date: Wed, 4 Jul 2018 08:37:41 -0500
Message-ID: <CAD8Lp45wgsqxx+qYvAWCuRuAMEChK-aPeFNdN1LE28qeoEWu4A@mail.gmail.com> (sfid-20180704_153746_539185_44B5F72D)
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jian-Hong Pan <jian-hong@endlessm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        devel@driverdev.osuosl.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 4, 2018 at 8:04 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I really prefer to see the whole dmesg instead of an edited ... in the
> middle.

Full log:
https://gist.github.com/dsd/20c05f0c6d66ee2ef9bfbb17f93f18ba

> I agree that it feels like the default aspm setting should be 2 (use
> what the chip says).  Although I don't know the device well enough to
> say if that will break anyone's system.  Perhaps someone who knows
> better will be able to respond.

Looking at the code for _rtl_pci_update_default_setting(), the meaning
of value 2 actually seems to be "enable ASPM on Intel platforms, and
disable on others".

But I suspect that code is not working right, because the system we
are using here is Intel-based and so my expectation would be that
value 2 leaves ASPM on and we would continue seeing the issue.
However, Jian-Hong reports it as working.

There are also some other reports that this driver doesn't work until
aspm is disabled:
https://bugzilla.redhat.com/show_bug.cgi?id=1464731#c21
https://ubuntuforums.org/showthread.php?t=2364383&page=4&p=13748721#post13748721
https://bugzilla.kernel.org/show_bug.cgi?id=199651

Daniel
