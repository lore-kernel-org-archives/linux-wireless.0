Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:33239 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbbHDNnr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 09:43:47 -0400
Received: by obdeg2 with SMTP id eg2so7246806obd.0
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2015 06:43:46 -0700 (PDT)
Date: Tue, 4 Aug 2015 08:43:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: wireless-regdb <wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 4/5] wireless-regdb: Update 5GHz rules for US
Message-ID: <20150804134317.GB78399@ubuntu-hedt> (sfid-20150804_154350_718558_7737DF3B)
References: <1437622380-4154-1-git-send-email-wens@csie.org>
 <1437622380-4154-5-git-send-email-wens@csie.org>
 <20150803183422.GD21180@ubuntu-hedt>
 <CAGb2v650TmbAtkvK8YWQvzcoxkgB21=Lr6LXZ4uOZe9OGzqSpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGb2v650TmbAtkvK8YWQvzcoxkgB21=Lr6LXZ4uOZe9OGzqSpw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 04, 2015 at 09:31:58AM +0800, Chen-Yu Tsai wrote:
> On Tue, Aug 4, 2015 at 2:34 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> > On Thu, Jul 23, 2015 at 11:32:59AM +0800, Chen-Yu Tsai wrote:
> >> The FCC increased the maximum conducted transmission power for the
> >> U-NII-1 (5150 ~ 5250 MHz) band to 30 dBm or 1 W for master devices
> >> and 24 dBm or 250 mW for mobile/portable devices.
> >>
> >> Effective 6/2/2014.
> >>
> >> See FCC KDB 905462 D06.
> >>
> >> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >> ---
> >>  db.txt | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/db.txt b/db.txt
> >> index cadd52c..29ba4b6 100644
> >> --- a/db.txt
> >> +++ b/db.txt
> >> @@ -1160,7 +1160,7 @@ country UG: DFS-FCC
> >>
> >>  country US: DFS-FCC
> >>       (2402 - 2472 @ 40), (30)
> >> -     (5170 - 5250 @ 80), (17), AUTO-BW
> >> +     (5170 - 5250 @ 80), (30), AUTO-BW
> >
> > The 30 dB limit is for devices in master mode, for clients the limit
> > seems to be 250 mW (about 24 dB). Given the TPC requirement for U-NII
> > devices the most it could be bumped up to is 21 dB, unless there's some
> > other reason I don't know about to keep it at 17 dB.
> 
> I suppose we have no way to differentiate between master mode and clients?
> I'll drop it down to 24 dBm and add a comment above it.

We don't have any way to specify differing rules for APs and clients
today.

Probably the limit should be 23 dBm instead, since 250 mW comes out to
just less than 24 dBm. Better to be conservative, and besides that is
consistent with other ranges which have a 250 mW limit.

> As for 17 dB, that was the original limit prior to the bump, as seen in
> the FCC KDB attachment "905462 D05 802.11 Channel Plans Old Rules v01".

Ah, okay.

Thanks,
Seth
