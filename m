Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:57938 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700AbbFEJYc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 05:24:32 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
References: <01eb01d09f64$fd522730$f7f67590$@acksys.fr> <CA+BoTQnehkYETptdaw4VsqKmhAampJ9_Zm_bNfH6PwGX7SqRww@mail.gmail.com>
In-Reply-To: <CA+BoTQnehkYETptdaw4VsqKmhAampJ9_Zm_bNfH6PwGX7SqRww@mail.gmail.com>
Subject: RE: ATH10K and VLAN : Frame with VLAN tag are not sent
Date: Fri, 5 Jun 2015 11:23:27 +0200
Message-ID: <01f701d09f71$47ae9910$d70bcb30$@acksys.fr> (sfid-20150605_112436_816241_33B76AF5)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >         The WDS client mode seems to work with ATH10k, and I have the
> same problem without it.
> >         My problem is not in the AP-VLAN feature. I didn't use the
> encryption in my test. The frames with vlan tag are not sent by ath10k
> wireless card, in Sta mode, AP mode, Sta + wds mode.
> >
> >         My PC1 sends a frame to PC2 with or without VLAN tag.
> >                 If the tag is present the frame is not sent.
> >                 If the tag is not present the frame is sent.
> >
> >         In my test, the frame with VLAN tag should be sent through
> ATH10K.
> >
> >         I enable the debug in ATH10k driver. The frame with the vlan
> tag is sent to the wireless radio card.
> >         I check the frame dump from ath10k_htt_tx function but I didn't
> see any error in frame format.
> >
> >         I paste the dump below (the frame it is an arp frame in the
> vlan 6).
> > ath10k_pci 0000:01:00.0: htt tx flags0 37 flags1 3072 len 70 id 0
> > frags_paddr 06a54000, msdu_paddr 0c158c66 vdev 0 tid 16 freq 0
> > ath10k_pci 0000:01:00.0: htt tx msdu: 00000000: 88 03 00 00 04 f0 21
> > 0e 38 e1 04 f0 21 18 03 a0 ath10k_pci 0000:01:00.0: htt tx msdu:
> > 00000010: ff ff ff ff ff ff a 00 09 90 00 4a 97 aa aa ath10k_pci
> > 0000:01:00.0: htt tx msdu: 00000020: 03 00 00 00 81 00 00 06 08 06 00
> > 01 08 00 06 04 ath10k_pci 0000:01:00.0: htt tx msdu: 00000030: 00 01
> > 00 09 90 00 4a 97 c0 a8 06 fd 00 00 00 00 ath10k_pci 0000:01:00.0: htt
> > tx msdu: 00000040: 00 00 c0 a8 06 01
> 
> Oh. So you actually refer to the dot1q VLAN tagging. I haven't tested
> this but I would expect this to work.
I'm agree with you it should work, but not :-(
> 
> 
> >         Moreover, for each frame sent the Tx status from the cards will
> increment the failed_count counter, but I didn't know what went wrong.
> 
> Perhaps htt tx msdu was completed with failure status code. You didn't
> provide enough logs so I'm just guessing.
I didn't have more log on this point, I'm trying the ath10k debug, the ath10 ftrace. If you know how I can have more log on the failure, I will send these logs.

> 
> 
> >         Any idea ?
> 
> I see no reason why this should fail. The dot1q encapsulation shouldn't
> influence how firmware behaves.. but maybe I'm wrong.
> 
> It's still unclear to me what your topology looks like. Perhaps you're
> having problem with environmental configuration itself? Did you try other
> Wi-Fi device (e.g. ath9k) instead of ath10k?
Yes I tested with ath9k wireless card, the same configuration works.

I did an interesting test. With ostinato software I generate an ICMP frame without vlan tag. I changed the ethertype in the frame.
I tried with the ethertype 0x800 (IP), 0x801, 0x8892 (PROFINET), 0x8100 (dot1q), 0x0600. All frames are sent except when the ethertype is set to 0x8100. It seems the firmware do not accept the ethertype 0x8100.  

> 
> 
> Michał

