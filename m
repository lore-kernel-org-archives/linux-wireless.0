Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:57792 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbeIDOsX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 10:48:23 -0400
Date: Tue, 4 Sep 2018 12:23:53 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sid Hayn <sidhayn@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4.19] mt76x0: fix remove_interface
Message-ID: <20180904102352.GA978@redhat.com> (sfid-20180904_122359_065781_E39E8870)
References: <1535970381-5526-1-git-send-email-sgruszka@redhat.com>
 <87y3cisq5g.fsf@purkki.adurom.net>
 <CAM0KTbAgj==H9SkoFF7WeSrh=TJHKFtuubf06JKSKoHoa4xV5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAM0KTbAgj==H9SkoFF7WeSrh=TJHKFtuubf06JKSKoHoa4xV5w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 03, 2018 at 09:36:37AM -0400, Sid Hayn wrote:
> Best I can say is that it seemed to happen after a failed connection.  It
> would connect and disconnect a few times and work fine, but if it failed to
> connect for any reason (mostly mismatched settings between AP and
> wpa_supplicant.conf) then the bug would occur. So, wpa_supplicant would up
> the interface, try to connect, fail, down the interface and exit, then the
> next loop of my script (with a different conf file) would start and
> wpa_supplicant would be unable to up the interface.
<snip>
> > For bug fixes please always try to describe the bug and symptoms. I can
> > add it this time. From the other thread I saw that 'ifconfig up' failed
> > like this:
> >
> > SIOCSIFFLAGS: No space left on device
> >
> > But in what cases did that happen? (I assume not always)

Problem will happen when we remove interface more than 8 times.
I'm not sure at how this can be triggerd execpt by doing:

iw dev <devname> interface add <name> type <type>
iw dev <name> del

but looks somehow this is triggerd by Sid scripts
by just by using wpa_supplicant and ifconfig. 

Regards
Stanislaw
