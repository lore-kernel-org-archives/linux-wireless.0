Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36419 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbeGDPdo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:33:44 -0400
Received: by mail-oi0-f42.google.com with SMTP id r16-v6so11458623oie.3
        for <linux-wireless@vger.kernel.org>; Wed, 04 Jul 2018 08:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net>
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
 <f3bf0687-76fb-9411-6fa2-e8ef312efb58@lwfinger.net> <20180704140933.3dk2ylbntltz6jqd@mwanda>
 <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net>
From: Daniel Drake <drake@endlessm.com>
Date: Wed, 4 Jul 2018 10:33:42 -0500
Message-ID: <CAD8Lp44EG73XQ9omQhH6XiHfm2rMypmndSFyffnf_PVMueTvEA@mail.gmail.com> (sfid-20180704_173407_430633_0C6F7C99)
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Jian-Hong Pan <jian-hong@endlessm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        devel@driverdev.osuosl.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Arnd Bergmann <arnd@arndb.de>, yhchuang@realtek.com,
        birming@realtek.com,
        "shaofu@realtek.com >> shaofu" <shaofu@realtek.com>,
        steventing@realtek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 4, 2018 at 10:13 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> We will have to agree to disagree.
>
> I have no idea what the vendors are doing that cause some motherboards to
> need a different aspm value. What I do know is that we have had to live with
> the idiocy of some vendors saving a few pennies by only including a single
> antenna, rather than two, and then making a problem by miscoding the EFUSE
> bit that indicates which connector is actually in use. As we have no means
> that I know about to detect which boxes have the problem, a module parameter
> was created, just as in this case.
>
> I agree that drivers should work "out of the box", but finite resources and
> lack of vendor cooperation make this a goal that may not be attainable.

As you touched on, the ideal situation is that Realtek solve the
issue. Ping-Ke Shih is on CC and I am adding a few more contacts from
the commit log. The context is that the r8822 driver fails on several
platforms unless setting aspm=0 (the default is 1).

https://gist.github.com/dsd/20c05f0c6d66ee2ef9bfbb17f93f18ba
https://bugzilla.kernel.org/show_bug.cgi?id=199651


If we don't get a timely fix from Realtek though, I think there is a
key difference between the antenna selection headache and this one. In
the antenna case, there isn't a good value that you can set that will
work on all systems. If you change the default behaviour you will
solve the issue for some users while simultanously introducing the
problem on other systems that were previously fine.

However in this case, it's highly likely that setting aspm=0 (off) by
default would work for everyone. It has the disadvantage of using a
bit more power, but especially with the indications that this issue
affects a significant number of systems, I think that having the
driver working out of the box everywhere is more important. The module
parameter can be left in place so that unaffected users that want to
save power can set aspm=1.

Daniel
