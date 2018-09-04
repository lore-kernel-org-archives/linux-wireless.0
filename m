Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:38311 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727136AbeIDSmZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 14:42:25 -0400
Received: by mail-io0-f195.google.com with SMTP id y3-v6so3089238ioc.5
        for <linux-wireless@vger.kernel.org>; Tue, 04 Sep 2018 07:17:08 -0700 (PDT)
MIME-Version: 1.0
References: <1535970381-5526-1-git-send-email-sgruszka@redhat.com>
 <87y3cisq5g.fsf@purkki.adurom.net> <CAM0KTbAgj==H9SkoFF7WeSrh=TJHKFtuubf06JKSKoHoa4xV5w@mail.gmail.com>
 <20180904102352.GA978@redhat.com>
In-Reply-To: <20180904102352.GA978@redhat.com>
From: Sid Hayn <sidhayn@gmail.com>
Date: Tue, 4 Sep 2018 14:16:57 +0000
Message-ID: <CAM0KTbBSC8EZB+40DsaPj-DJhrQCuRGH2=T=XvE+71bPtXFwbg@mail.gmail.com> (sfid-20180904_161711_116271_14F82A0F)
Subject: Re: [PATCH 4.19] mt76x0: fix remove_interface
To: sgruszka@redhat.com
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

confirmed, I didn't intentionally remove the interface, but I do see
something about the interface being removed in wpa_supplicant output.

Thanks,
Zero
On Tue, Sep 4, 2018 at 10:23 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> On Mon, Sep 03, 2018 at 09:36:37AM -0400, Sid Hayn wrote:
> > Best I can say is that it seemed to happen after a failed connection.  It
> > would connect and disconnect a few times and work fine, but if it failed to
> > connect for any reason (mostly mismatched settings between AP and
> > wpa_supplicant.conf) then the bug would occur. So, wpa_supplicant would up
> > the interface, try to connect, fail, down the interface and exit, then the
> > next loop of my script (with a different conf file) would start and
> > wpa_supplicant would be unable to up the interface.
> <snip>
> > > For bug fixes please always try to describe the bug and symptoms. I can
> > > add it this time. From the other thread I saw that 'ifconfig up' failed
> > > like this:
> > >
> > > SIOCSIFFLAGS: No space left on device
> > >
> > > But in what cases did that happen? (I assume not always)
>
> Problem will happen when we remove interface more than 8 times.
> I'm not sure at how this can be triggerd execpt by doing:
>
> iw dev <devname> interface add <name> type <type>
> iw dev <name> del
>
> but looks somehow this is triggerd by Sid scripts
> by just by using wpa_supplicant and ifconfig.
>
> Regards
> Stanislaw
