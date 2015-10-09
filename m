Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15173 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570AbbJIQCd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2015 12:02:33 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: add copy engine fast path support
Date: Fri, 9 Oct 2015 16:02:14 +0000
Message-ID: <1444406541089.12284@qti.qualcomm.com> (sfid-20151009_180236_852302_76B89BF6)
References: <1443164016-3612-1-git-send-email-rmanohar@qti.qualcomm.com>,<87612gqcnn.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87612gqcnn.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Below patchset adds fast path support for uplink traffic by bypassing
> > HTC layer processing. This is enabled by making use of unused copy
> > engine 5 to receive HTT messages directly from HIF layer. From initial
> > validation in VHT80/5G mode TCP UL is improved to 900Mbps from ~840Mbps
> > in conducted test.
> >
> > -Rajkumar
> >
> > Rajkumar Manoharan (7):
> >   ath10k: export htc tx rx handlers
> >   ath10k: register per copy engine send completion callbacks
> >   ath10k: register per copy engine receive callbacks
> >   ath10k: export htt tx rx handlers
> >   ath10k: Configure copy engine 5 for HTT messages
> >   ath10k: remove unused dl_is_polled
> >   ath10k: remove htc polling for tx completion
> 
> With these patches I'm seeing a DMA warning every time with qca988x
> during firmware boot (tested three out of three times, rebooted after
> every test):
> 
> [   60.458260] ------------[ cut here ]------------
> [   60.458374] WARNING: CPU: 1 PID: 0 at lib/dma-debug.c:1090 check_unmap+0x815/0x940()
> [   60.458457] ath10k_pci 0000:02:00.0: DMA-API: device driver tries to free an invalid DMA memory address
> [   60.458557] Modules linked in: ath10k_pci ath10k_core ath mac80211 cfg80211 [last unloaded: cfg80211]
> [   60.458941] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 4.3.0-rc3-wl-ath+ #1082
> [   60.458981] Hardware name: Hewlett-Packard HP ProBook 6540b/1722, BIOS 68CDD Ver. F.04 01/27/2010

Thanks for reporting this issue. Will post revised patchset asap.

-Rajkumar