Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3FKQRO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 12:17:14 -0400
Date: Tue, 11 Jun 2013 18:19:24 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Pedro Francisco <pedrogfrancisco@gmail.com>
Cc: Tino Keitel <tino.keitel@tikei.de>,
	ML linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Power saving features for iwl4965
Message-ID: <20130611161924.GB1696@redhat.com> (sfid-20130611_181717_487720_33AE472F)
References: <20120418203543.GA16000@x61.home>
 <20120425122554.GD2466@redhat.com>
 <20120503182853.GA12461@mac.home>
 <20121226185425.GA12627@x61.home>
 <20130107110759.GC6931@redhat.com>
 <20130603085239.GA26920@mac.home>
 <20130603141804.GA2146@redhat.com>
 <CAJZjf_xoCOTFsLAB29uLKeW7+O+k255Amspn6GKFMysc7CTsBg@mail.gmail.com>
 <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJZjf_xGdvStOG0=FR2+2WsVcjyizQukH+RxysZf8f9-Tk9L9w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 10, 2013 at 08:31:33PM +0100, Pedro Francisco wrote:
> On Sun, Jun 9, 2013 at 1:28 AM, Pedro Francisco
> <pedrogfrancisco@gmail.com> wrote:
> > On Mon, Jun 3, 2013 at 3:18 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> >> On Mon, Jun 03, 2013 at 10:52:39AM +0200, Tino Keitel wrote:
> >>> (...)
> >>> It would be really nice to have proper power management in a current
> >>> kernel, as the laptop gets noticeably hotter with the current iwlegacy
> >>> driver.  That's why I still use a 3.1.10 kernel with an old
> >>> forward-ported iwlagn driver.
> >>
> >> Could you try this experimental patch? (...)
> >
> > I am trying the iwlegacy powersave patch along with CPU scheduler BFS
> > and IO scheduler BFQ.
> >
> > I've got this today: (...)
> >
> > $ uname -a
> > Linux s2 3.9.4-301.local.fc19.i686
> >
> > I have just made a clean boot (as in, this has not happened after a
> > resume for suspend or hibernation).
> >
> > May it be related to the patch? Or may heavy IO with out-of-tree CPU
> > scheduler BFS and out-of-tree IO scheduler BFQ be responsible for the
> > warnings?
> 
> I also got a SYSASSERT:
> [Jun 9 10:35] iwl3945 0000:02:00.0: Read idx for DMA queue txq_id (2)
> idx 186 is out of range [0-256] 186 186
> (...)
> [  +0,000164] iwl3945 0000:02:00.0: Read idx for DMA queue txq_id (2)
> idx 185 is out of range [0-256] 186 186
> [Jun 9 10:36] iwl3945 0000:02:00.0: Microcode SW error detected.
> Restarting 0x82000008.
> [  +0,000008] iwl3945 0000:02:00.0: Loaded firmware version: 15.32.2.9
> [  +0,000034] iwl3945 0000:02:00.0: Start IWL Error Log Dump:
> [  +0,000004] iwl3945 0000:02:00.0: Status: 0x000302E4, count: 1
> [  +0,000004] iwl3945 0000:02:00.0: Desc       Time       asrtPC
> blink2 ilink1  nmiPC   Line
> [  +0,000224] iwl3945 0000:02:00.0: SYSASSERT     (0x5) 0228106348
> 0x008B6 0x0035E 0x0031C 0x00000 267
> 
> [  +0,000010] iwl3945 0000:02:00.0: Error Reply type 0x00000001 cmd
> UNKNOWN (0xFC) seq 0x2099 ser 0x00FC0000
> [  +0,000466] iwl3945 0000:02:00.0: Can't stop Rx DMA.
> [  +0,001647] ieee80211 phy0: Hardware restart was requested
> [Jun 9 10:38] iwl3945 0000:02:00.0: Read idx for DMA queue txq_id (2)
> idx 186 is out of range [0-256] 186 186
> (...)
> 
> I disabled powersave (but kept running the same kernel) and none of
> the errors appeared again.

Yes, this seems to be iwlegacy PS issue and has to be fixed before
this patch could be applied.

Thanks for testing.
Stanislaw 
