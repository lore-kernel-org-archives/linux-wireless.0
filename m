Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa09-02.prod.phx3.secureserver.net ([173.201.193.231]:47082
	"EHLO p3plsmtpa09-02.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbbIRP5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2015 11:57:05 -0400
From: "William Riba" <wriba@wriba.com>
To: <linux-wireless@vger.kernel.org>
Subject: ath10k RFKILL hard block
Date: Fri, 18 Sep 2015 10:49:58 -0500
Message-ID: <004101d0f229$acc77c80$06567580$@wriba.com> (sfid-20150918_175712_854290_2F3CEFD4)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm currently testing QCA9880/QCA9890 mini-PCIe hardware for an AP
implementation. I've done initial testing with a couple of cards using a
Linux 4.0.5 kernel, ath10k driver and the currently posted firmware blobs.
Everything works fine except for the lack of hardware RFKILL functionality.
This is a regulatory requirement for the project, so soft RKILL cannot be
used in its place (which works fine BTW). Both cards would have you ground
pin 20 of the miniPCIe card to activate the hard block. Doing so however
does nothing, as the radio continues to operate. Contacting the vendors of
these cards has them blaming the firmware.

On older Atheros AR9300 hardware supported by the ath9k driver there was an
EEPROM setting (rfSilent) that activated this option. It required an atheros
config tool to turn it on if turned off by the vendor. My question is how
does one get hard block RFKILL working on QCA9880/QCA9890 hardware?  Thanks
for any advice on this subject.

Regards,
W Riba

