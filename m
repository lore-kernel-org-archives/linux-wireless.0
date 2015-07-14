Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36467 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbbGNFNS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 01:13:18 -0400
Received: by widjy10 with SMTP id jy10so88123177wid.1
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2015 22:13:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55A4446C.4090803@candelatech.com>
References: <55A4446C.4090803@candelatech.com>
Date: Tue, 14 Jul 2015 07:13:17 +0200
Message-ID: <CA+BoTQmR-7ShZr3FUh-C+LXmZmgFkz_vK9WTW7fLS6akHrZp9Q@mail.gmail.com> (sfid-20150714_071322_096032_64F33BEA)
Subject: Re: Don't enable PROMISC when adding AP to a bridge?
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 July 2015 at 01:06, Ben Greear <greearb@candelatech.com> wrote:
> I notice some of my WLE900VX cards will lock up and not receive any packets
> after a few seconds of being in PROMISC mode.  This happens on my own
> CT firmware as well as stock firmware-2.bin.  This breaks monitor mode, of
> course, but it also breaks bridged AP mode.
>
> So, I found this patch from way back when:
> http://lists.celinuxforum.org/pipermail/bridge/2008-June/005906.html
>
> I hacked a similar thing into my 4.0.4 kernel, and now bridged mode
> AP seems much more stable (and the radio does not go into PROMISC mode,
> so it should be more efficient in a busy RF environment).
>
> Maybe this feature could be revisited?

This has already been done and mac80211 in 4.2-rc no longer propagates
promisc to drivers[1].

[1]: https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/mac80211?id=df1404650ccbfeb76a84f301f22316be0d00a864


Michał
