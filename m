Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:36341 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbbHDNhn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 09:37:43 -0400
Received: by oibv126 with SMTP id v126so5036986oib.3
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2015 06:37:42 -0700 (PDT)
Date: Tue, 4 Aug 2015 08:37:12 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	wireless-regdb <wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] wireless-regdb: Update U-NII-2c (5470 ~ 5725 MHz)
 rules for Taiwan (TW)
Message-ID: <20150804133712.GA78399@ubuntu-hedt> (sfid-20150804_153747_129531_9CA7220B)
References: <1437622380-4154-1-git-send-email-wens@csie.org>
 <1437622380-4154-2-git-send-email-wens@csie.org>
 <20150803182730.GC21180@ubuntu-hedt>
 <CAGb2v66U87FeBvE+PDAhz11=knyGBwaztoqqwcNQeceQsSN3pg@mail.gmail.com>
 <CAGb2v667QvWzFvrYBWwZU8eGxMHfgh2LmsQUoYziD6UhEuQk3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGb2v667QvWzFvrYBWwZU8eGxMHfgh2LmsQUoYziD6UhEuQk3A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 04, 2015 at 09:55:06AM +0800, Chen-Yu Tsai wrote:
> On Tue, Aug 4, 2015 at 9:26 AM, Chen-Yu Tsai <wens@csie.org> wrote:
> > On Tue, Aug 4, 2015 at 2:27 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> >> On Thu, Jul 23, 2015 at 11:32:56AM +0800, Chen-Yu Tsai wrote:
> >>> Taiwan's Ministry of Transportation and Communications revised its
> >>> frequency allocation rules [1] on 2014/11/17, allowing usage of 5600 ~
> >>> 5650 MHz, previously allocated to weather radars, to U-NII applications
> >>> with DFS support.
> >>>
> >>> Also, the technical regulations [2] show that for 5470 ~ 5725 MHz U-NII
> >>> applications, the peak transmit power shall not exceed the lesser of
> >>> 250 mW (slightly less than 24 dBm) or 11 dBm + 10log B, where B is the
> >>> 26dB emission bandwidth in MHz. This is slightly more than 23 dBm for
> >>> 20 MHz channels.
> >>>
> >>> This patch updates both. Also add links to the two documents into the
> >>> database.
> >>>
> >>> [1] http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc&filedisplay=Table+of+radio+frequency+allocation.doc
> >>> [2] http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
> >>>
> >>> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> >>
> >> Sorry for the slow response to these patches.
> >>
> >>> ---
> >>>  db.txt | 10 ++++++++--
> >>>  1 file changed, 8 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/db.txt b/db.txt
> >>> index 982db34..5114557 100644
> >>> --- a/db.txt
> >>> +++ b/db.txt
> >>> @@ -1118,11 +1118,17 @@ country TT: DFS-FCC
> >>>       (5490 - 5730 @ 160), (24), DFS
> >>>       (5735 - 5835 @ 80), (30)
> >>>
> >>> +# Source:
> >>> +# Table of Frequency Allocations of Republic of China (Taiwan) / Nov 2014:
> >>> +#   http://www.motc.gov.tw/websitedowndoc?file=post/201411171137330.doc& \
> >>> +#      filedisplay=Table+of+radio+frequency+allocation.doc
> >>> +# LP0002 Low-power Radio-frequency Devices Technical Regulations / 28 Jun 2011:
> >>> +#   http://www.ncc.gov.tw/english/show_file.aspx?table_name=news&file_sn=681
> >>> +#   (section 3.10.1, 4.7)
> >>>  country TW: DFS-JP
> >>>       (2402 - 2472 @ 40), (30)
> >>>       (5270 - 5330 @ 40), (17), DFS
> >>> -     (5490 - 5590 @ 80), (30), DFS
> >>> -     (5650 - 5710 @ 40), (30), DFS
> >>> +     (5470 - 5725 @ 160), (23), DFS
> >>
> >> Based on [2], it looks like this range requires TPC, in which case the
> >> power limit should be dropped by 3 dB on account of our not supporting
> >> TPC.
> >
> > Will fix.
> >
> > Is there any plan to support multiple rules per band? Such as different
> > power limits with vs without TPC, or something like DFS vs indoor only?

Not that I know of. Currently the binary database format is a constraint
on doing anything like that.

> BTW, this band has the exact same restrictions as the US, as specified
> by the FCC. The relevant rules were added in
> 
>     f894543 wireless-regdb: Add back regulatory rules for US
> 
> and expanded to cover the whole band in
> 
>     3c61549 wireless-regdb: Update 5GHz rules for US
> 
> These show the power limit at 23 dBm as well. Any comments on this?

Good question. Afaict this probably originates with commit 31dc1c5e
which defines the limit for 5250-5330 MHz in the US, then using the same
limit for the 5490-5730 MHz rule seemed logical. The 5250-5330 MHz rule
came from QCA then. Adding Jouni to the Cc to see if he can help clarify
how they arrived at 23 dBm.

Hmm, I see now that 15.407(h)(1) says that TPC is not required for
systems with an EIRP of less than 500 mW. In that case I guess maybe we
don't need to drop the power limit by 3 dB, so in light of that 23 dBm
does make sense. The documents you linked to say the same, seemingly
word-for-word, so in all likelihood 23 dBm is actually okay.

Thanks,
Seth
