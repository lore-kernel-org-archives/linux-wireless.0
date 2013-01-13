Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3435 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3AMHd6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jan 2013 02:33:58 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: Kalle Valo <kvalo@adurom.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Q: how to update platform power state for the network driver
Date: Sun, 13 Jan 2013 09:33:54 +0200
Message-ID: <1550342.hytzsOV4KI@lx-vladimir> (sfid-20130113_083410_553786_121E7FB3)
In-Reply-To: <87ehhsu38q.fsf@purkki.adurom.net>
References: <6929081.7c7blFVDp4@lx-vladimir> <87ehhsu38q.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 10, 2013 11:39:33 PM Kalle Valo wrote:
> Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com> writes:
> 
> > in 60g spec (802.11ad, references to this doc.), station should set "power source" bit in the:
[skip]
> 
> Scary! Just of curiosity, how is this bit supposed to be used in real life?
> 

In 60g, you have new ah-hoc network type, PBSS, that should be used for P2P (spec mandates it)
In PBSS, there is AP-like entity called PCP. Instead of P2P GO negotiation, GO choosen before,
on lower layer, when selecting PCP. In this decision, "best suitable" candidate selected PCP,
based on "PCP factor" calculated for each peer. Most significant bit there is "power" since
one who is AC powered is better candidate.

Bottom line - this is to elect as P2P GO AC-powered one (if there is such peer).

Thanks, Vladimir
