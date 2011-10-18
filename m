Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1608 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022Ab1JRKLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 06:11:14 -0400
Message-ID: <4E9D50B4.2030308@broadcom.com> (sfid-20111018_121117_696962_A2EA282B)
Date: Tue, 18 Oct 2011 12:11:00 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Andr=E9s_Garc=EDa_Saavedra?=
	<andres.garcia.saavedra@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>
Subject: Re: brcmfmac driver implementation: Questions
References: <CADxqDgHYu51DQXOLT3eA=6PckSmXc42BFUF=Z7qZ_Cs45T1GjQ@mail.gmail.com>
 <400C43189542CE41BC0A5B252FC90136BC0DF4A03E@SJEXCHCCR02.corp.ad.broadcom.com>
 <CADxqDgGoBq5+6O1XUB1fu6Na3E1Mq2sko9w=PUtK=V+gZcOXjQ@mail.gmail.com>
In-Reply-To: <CADxqDgGoBq5+6O1XUB1fu6Na3E1Mq2sko9w=PUtK=V+gZcOXjQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/18/2011 10:31 AM, Andrés García Saavedra wrote:
> Thank you for your answers, been very helpful.
> 
> What I basically mean here to force the wifi interface stay quiet (or
> sleep) for a certain duration of time (the way Notice of Absence
> protocol proposes or 802.11h's Quiet Element does). For example, the
> ath5k driver  supports quiet elements and the card offers registers
> that can be edited within the driver to force a station be quiet for a
> certain duration at certain intervals of time. A (local) test
> implementation i've performed on ath5k "understands" the NoA IE from a
> beacon and edits those registers accordingly in order to stay quiet
> accordingly for powersaving purposes.

So your question boils down to whether or not the brcmfmac driver
supports NoA or 11h. I have to look into that. As brcmfmac is a cfg80211
driver the beacon processing and any subsequent action is performed on
the device by firmware and not on the host.

> For the case of a potential BCM4329 implementation of NoA, the
> brcmfmac should be the one to trigger those scheduled quiet intervals
> on the HW (or is there a lower layer to interface the HW?) when it
> receives each beacon NoA IE.

> Thanks again, and excuses for my vague knowledge on the bcm4329 drivers.
> Andrés
> 

To clarify: the brcmfmac driver in the linux kernel is different from
the bcm4329 driver that is in the android kernel. For your nexus one you
would probably be using the android kernel and not the main linux kernel.

Gr. AvS

