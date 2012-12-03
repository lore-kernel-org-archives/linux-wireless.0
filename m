Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53227 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754869Ab2LCRN5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 12:13:57 -0500
Message-ID: <50BCDDD0.7030308@openwrt.org> (sfid-20121203_181400_400643_C296EE92)
Date: Mon, 03 Dec 2012 18:13:52 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Francisco Pina Martins <f.pinamartins@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 1/2] mac80211: introduce IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL
References: <20121203115632.GA2490@redhat.com> <50BCB3A3.4090708@01019freenet.de>
In-Reply-To: <50BCB3A3.4090708@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-12-03 3:13 PM, Andreas Hartmann wrote:
> Hi Stanislaw!
> 
> Stanislaw Gruszka wrote:
>> Commit f0425beda4d404a6e751439b562100b902ba9c98 "mac80211: retry sending
>> failed BAR frames later instead of tearing down aggr" caused regression
>> on rt2x00 hardware (connection hangs).
> 
> This patch caused a problem, too, with carl9170
> (http://thread.gmane.org/gmane.linux.kernel.wireless.general/92203/focus=92376).
> How did they fix it (the thread unfortunately ends without any solution
> / patch).
> 
>> This regression was fixed by
>> commit be03d4a45c09ee5100d3aaaedd087f19bc20d01 "rt2x00: Don't let
>> mac80211 send a BAR when an AMPDU subframe fails". But the letter
>> commit, caused yet another problem reported in
>> https://bugzilla.kernel.org/show_bug.cgi?id=42828#c22
> 
> This already was a workaround as stated in the removed comment: "TODO:
> Need to tear down BA session here if not successful."
> 
> My general question is:
> Is the behaviour of f0425beda spec conform? Is it implemented correctly
> and w/o demanding any special hardware feature? If both questions can be
> answered with yes, rt2x00 should be fixed to get the same behaviour working.
> 
> If f0425beda isn't spec conform or if it expects special hardware
> features, it would be a more or less a ath9k specific "solution", which
> should be removed from mac80211 and should be moved to the driver. I'm
> thinking of this, because rt2x00 is not the only one having problems and
> Felix comment in
> http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=1383
> 
> "If you want to tear down the BA session in rt2x00, either do it in the
> driver or add a proper flag to ensure that ath9k remains unaffected by
> the change."
> 
> sounds to me really ath9k specific (what about other hardware)?
The commit f0425beda is aimed not specifically at Atheros hardware. It
is meant for any hardware that lets the driver track the Tx BA window
and has a reasonable MAC design.
The 'reasonable MAC design' part is where rt2x00 falls short. BAR Tx
status processing is just one of several places where the hardware
interface design is stupid and limiting, meaning the driver has to do
extra effort to work around that.

- Felix
