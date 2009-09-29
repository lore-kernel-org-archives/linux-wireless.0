Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46576 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753237AbZI2Jpf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 05:45:35 -0400
From: Malte Gell <malte.gell@gmx.de>
To: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	ndiswrapper-general@lists.sourceforge.net
Subject: Re: compat-wireless tracepoint error Re: [Ndiswrapper-general] Need help to create driver for Netgear WN111v2
Date: Tue, 29 Sep 2009 11:45:35 +0200
Cc: linux-wireless@vger.kernel.org
References: <999306.93095.qm@web23102.mail.ird.yahoo.com> <200909291058.43765.malte.gell@gmx.de> <3ace41890909290206g3019a9cbv29048837804f830@mail.gmail.com>
In-Reply-To: <3ace41890909290206g3019a9cbv29048837804f830@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <200909291145.35972.malte.gell@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


"Hin-Tak Leung" <hintak.leung@gmail.com> wrote

> > So, no need to modify compat-2.6.28.c? Does it automatically happen?
> 
> You may or may not  see any errors at the linker stage (the LD part in
> stage 2). If you get to that point without further error, then, well,
> count yourself lucky and just give "make install ; make unload;
> modprobe -v ar9170" a go.

Ho ho ;-) I got a lot of warnings like this:

 include/linux/tracepoint.h:86:1: warning: this is the location of the 
previous definition

But, it DID compile! Thanx a lot.

To be sure I did a find . -name "*.ko" and got these modules:

./drivers/net/wireless/ath/ath.ko
./net/rfkill/rfkill_backport.ko
./net/wireless/cfg80211.ko
./net/mac80211/mac80211.ko

I just wonder, where is ar9170usb !? I did ./scripts/driver-select ar9170

Malte
