Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48776 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730566AbeHNJLz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 05:11:55 -0400
Date: Tue, 14 Aug 2018 08:26:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Grzegorz =?utf-8?Q?Duszy=C5=84ski?= <gfduszynski@gmail.com>,
        linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: Re: Cpu stall caused by hostapd running two interfaces
Message-ID: <20180814062608.GA5561@redhat.com> (sfid-20180814_082614_604964_4574ED78)
References: <CAD7cUuBrMscCMzLHCdxaAf+m9XHLr6XWD+FmZqNSdAuYnKCZfw@mail.gmail.com>
 <20180813084123.GA18180@redhat.com>
 <87tvnycw2b.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <87tvnycw2b.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2018 at 03:03:56PM +0300, Kalle Valo wrote:
> Stanislaw Gruszka <sgruszka@redhat.com> writes:
> 
> > (cc Haim and Johannes)
> >
> > On Sun, Aug 12, 2018 at 09:54:00PM +0200, Grzegorz Duszyński wrote:
> >> Hello,
> >> 
> >> I'm running into problems while trying to start AP's on 2 interfaces.
> >> Devices are:
> >> - Compex WLE900VX (QCA9880)
> >> - Killer 1535 (QCA6174)
> >> 
> >> The 1535 is a new addition to the system.
> >> Compex by itself runs fine, Killer also can run alone.
> >> 
> >> But when running them together all hell breaks lose.
> >> System is unusable, cannot even reboot.
> >> 
> >> I'm running Arch Linux.
> >> My system was updated before testing & posting.
> >> 
> >> Attachments:
> >> dmesg - https://pastebin.com/wf3Fq8gh
> >> 
> >> Please let me know if additional info is required.
> >
> > This is oops in ieee80211_regulatory_limit_wmm_params().
> > Looks like new regulatory code do not like ath10k.
> > I have another bug report with reg.c WARNING also on ath10k:
> > https://bugzilla.redhat.com/show_bug.cgi?id=1612537
> 
> I think bug #1612537 is with ath9k, not ath10k. But anyway, both use
> ath.ko which has some custom regulatory code.

Actually warning from #1612537 is not driver depended. It can be
reproduced just by loading cfg80211 with ieee80211_regdom parameter,
for example:

sudo modprobe cfg80211 ieee80211_regdom=AQ

Regards
Stanislaw
