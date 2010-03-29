Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-220-247-10-204.b-man.svips.gol.ne.jp ([220.247.10.204]:36314
	"EHLO smtp.kamineko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0C2WqA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 18:46:00 -0400
Date: Tue, 30 Mar 2010 07:37:35 +0900
From: Mattia Dongili <malattia@linux.it>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ralph Benzinger <t1@endlos.net>, linux-wireless@vger.kernel.org,
	platform-driver-x86@vger.kernel.org
Subject: Re: Problems with hardware radio kill switch on Sony Vaio notebook
Message-ID: <20100329223735.GC13900@kamineko.org>
References: <20100329152721.GC6445@endlos.net>
 <20100329170604.GC4984@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100329170604.GC4984@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raplh,

On Mon, Mar 29, 2010 at 01:06:05PM -0400, John W. Linville wrote:
> On Mon, Mar 29, 2010 at 05:27:21PM +0200, Ralph Benzinger wrote:
> 
> > My Sony Vaio VPC-Y11S1E notebook has an Atheros AR9285 chip, which is
> > supported just fine by ath9k.  The notebook also has a physical radio
> > kill switch at the front that can be slid into one of two positions.
> > Alas, the rfkill tool shows wlan0 as "hard blocked: yes" for either
> > switch position.  Consequently, txpower is off, and wireless
> > networking cannot be activated.
> > 
> > Could you kindly indicate which part of the kernel would be
> > responsible for handling the radio kill switches -- cfg80211, ath9k,
> > sony-laptop, ...?  Are there any known fixes or workarounds?  I'm
> > using Kubuntu 9.10 with their stock kernel 2.6.31 and the wireless
> > backports modules right now, but tests with Kubuntu 10.4 Beta and
> > 2.6.32 failed as well.
> 
> Generally, sony-laptop would be responsible for correctly reporting
> the rfkill switch state.

Yes, it's most likely that sony-laptop would be the one module to point
fingers at.

Could you send the DSDT from your laptop and the output of dmesg after
loading sony-laptop with debug=1 and switching the rfkill trigger back
and forth?

also the output from:
  $ grep . /sys/class/rfkill/rfkill*/*

Thanks
-- 
mattia
:wq!
