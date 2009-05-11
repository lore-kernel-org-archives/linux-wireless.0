Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:58123 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbZEKEqS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2009 00:46:18 -0400
Subject: Re: [PATCH 2/3] mac80211: Add a timeout for frames in the RX
 reorder buffer
From: Marcel Holtmann <marcel@holtmann.org>
To: Jouni Malinen <j@w1.fi>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1241914138.2783.4.camel@localhost.localdomain>
References: <20090505173512.349795688@atheros.com>
	 <20090505173550.273830766@atheros.com>
	 <1241709323.4903.25.camel@localhost.localdomain>
	 <1241833703.4903.83.camel@localhost.localdomain>
	 <20090509080838.GA1206@jm.kir.nu>
	 <1241914138.2783.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 10 May 2009 21:45:50 -0700
Message-Id: <1242017150.3384.5.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

> > > so I finally got the debug output for you. Took only over a day :)
> > 
> > Thanks! Would you happen to have timing information available for these
> > (e.g., from klogd)? It looks like the AP is sending out an ADDBA Request
> > to update some parameters, but we currently ignore that request.
> > However, at least in this particular case, our RX reorder bug head_seq
> > matches with the ssn from the ADDBA Request, so I'm not sure whether
> > ignoring the ADDBA contents is really causing harm here (anyway, we
> > should really process these updates, too).
> > 
> > The timeouts on RX reorder frames look similar to what I have seen in my
> > tests and the workaround was indeed trying to address that type of
> > issue, so it is nice to hear that it helped in this case, too.
> 
> so I enabled timing information for dmesg and got another report. It is
> not exactly the same and I don't know how and why it happened.
> 
> [  249.579036] phy0: AddBA: ssn=50, dialog_token=1 tid=0 timeout=0ba_policy=1
> [  249.579046] addba: d0 00 40 01 00 16 eb 05 46 5c 00 1c f0 62 88 5b 
> [  249.579052] addba: 00 1c f0 62 88 5b 30 8f 03 00 01 02 10 00 00 20 
> [  249.579057] addba: 03 
> [  249.579073] Rx A-MPDU request on tid 0 result 0
> [  250.572022] phy0: AddBA: ssn=178, dialog_token=2 tid=0 timeout=0ba_policy=1
> [  250.572032] addba: d0 00 40 01 00 16 eb 05 46 5c 00 1c f0 62 88 5b 
> [  250.572038] addba: 00 1c f0 62 88 5b e0 8f 03 00 02 02 10 00 00 20 
> [  250.572042] addba: 0b 
> [  250.572048] phy0: RX reorder buf: head_seq=178 ssn=50 buf_size=64 stored_mpdu_num=0 timeout=0 index=0; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
> [  250.572108] unexpected AddBA Req from 00:1c:f0:xx:xx:xx on tid 0
> [  266.263651] Open BA session requested for 00:1c:f0:xx:xx:xx tid 0
> [  266.263659] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1c:f0:xx:xx:xx tid = 0
> [  266.263726] activated addBA response timer on tid 0
> [  266.265534] wrong addBA response token, tid 0
> [  267.263467] addBA response timer expired on tid 0
> [  267.263516] Stopping Tx BA session for 00:1c:f0:xx:xx:xx tid 0
> [  326.083081] Open BA session requested for 00:1c:f0:xx:xx:xx tid 0
> [  326.083097] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1c:f0:xx:xx:xx tid = 0
> [  326.083197] activated addBA response timer on tid 0
> [  326.088517] wrong addBA response token, tid 0
> [  327.080206] addBA response timer expired on tid 0
> [  327.080262] Stopping Tx BA session for 00:1c:f0:xx:xx:xx tid 0
> 
> This kernel is running latest wireless-testing.git with debug patch and
> the disassoc change (for testing) from Johannes.

I had problems with my DIR-615 and Intel 5350 card. No stable connection
at all. No idea why it breaks down. Worked fine for the last few days
and today it breaks after a few bytes. Maybe my environment is not clean
enough. So I switched to use a Time Capsule in A-band only mode. Seems
more stable with exactly the same kernel. The reorder details from the
debug patch are still showing up:

[20236.165674] Open BA session requested for 00:1f:f3:xx:x:xx tid 0
[20236.165688] iwlagn 0000:03:00.0: iwl_tx_agg_start on ra = 00:1f:f3:xx:xx:xx tid = 0
[20236.165769] activated addBA response timer on tid 0
[20236.166197] switched off addBA timer for tid 0 
[20236.166202] Aggregation is on for tid 0 
[21108.747984] phy0: AddBA: ssn=347, dialog_token=1 tid=0 timeout=0ba_policy=1
[21108.747994] addba: d0 00 3c 00 00 16 eb 05 46 5c 00 1f f3 c3 a3 21 
[21108.748000] addba: 00 1f f3 c3 a3 21 20 7e 03 00 01 02 10 00 00 b0 
[21108.748005] addba: 15 
[21108.748021] Rx A-MPDU request on tid 0 result 0
[21108.996253] phy0: AddBA: ssn=609, dialog_token=2 tid=0 timeout=0ba_policy=1
[21108.996264] addba: d0 00 3c 00 00 16 eb 05 46 5c 00 1f f3 c3 a3 21 
[21108.996270] addba: 00 1f f3 c3 a3 21 50 7e 03 00 02 02 10 00 00 10 
[21108.996274] addba: 26 
[21108.996281] phy0: RX reorder buf: head_seq=609 ssn=347 buf_size=64 stored_mpdu_num=0 timeout=0 index=6; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
[21108.996342] unexpected AddBA Req from 00:1f:f3:xx:xx:xx on tid 0
[21114.164106] phy0: AddBA: ssn=686, dialog_token=3 tid=1 timeout=0ba_policy=1
[21114.164110] addba: d0 00 3c 00 00 16 eb 05 46 5c 00 1f f3 c3 a3 21 
[21114.164112] addba: 00 1f f3 c3 a3 21 f0 81 03 00 03 06 10 00 00 e0 
[21114.164114] addba: 2a 
[21114.164122] Rx A-MPDU request on tid 1 result 0
[21122.003948] delba from 00:1f:f3:c3:a3:21 (initiator) tid 1 reason code 1
[21122.003958] Rx BA session stop requested for 00:1f:f3:xx:xx:xx tid 1

Regards

Marcel


