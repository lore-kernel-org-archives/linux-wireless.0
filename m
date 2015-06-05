Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp01.msg.oleane.net ([62.161.4.1]:53680 "EHLO
	smtp01.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbbFEH4g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2015 03:56:36 -0400
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Michal Kazior'" <michal.kazior@tieto.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	<ath10k@lists.infradead.org>
Subject: RE: ATH10K and VLAN : Frame with VLAN tag are not sent
Date: Fri, 5 Jun 2015 09:55:28 +0200
Message-ID: <01eb01d09f64$fd522730$f7f67590$@acksys.fr> (sfid-20150605_095640_227338_48D1E138)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	The WDS client mode seems to work with ATH10k, and I have the same problem without it.
	My problem is not in the AP-VLAN feature. I didn't use the encryption in my test. The frames with vlan tag are not sent by ath10k wireless card, in Sta mode, AP mode, Sta + wds mode.

	My PC1 sends a frame to PC2 with or without VLAN tag.
		If the tag is present the frame is not sent. 
		If the tag is not present the frame is sent. 

	In my test, the frame with VLAN tag should be sent through ATH10K.

	I enable the debug in ATH10k driver. The frame with the vlan tag is sent to the wireless radio card.
	I check the frame dump from ath10k_htt_tx function but I didn't see any error in frame format.
	
	I paste the dump below (the frame it is an arp frame in the vlan 6).
ath10k_pci 0000:01:00.0: htt tx flags0 37 flags1 3072 len 70 id 0 frags_paddr 06a54000, msdu_paddr 0c158c66 vdev 0 tid 16 freq 0
ath10k_pci 0000:01:00.0: htt tx msdu: 00000000: 88 03 00 00 04 f0 21 0e 38 e1 04 f0 21 18 03 a0   
ath10k_pci 0000:01:00.0: htt tx msdu: 00000010: ff ff ff ff ff ff a 00 09 90 00 4a 97 aa aa  
ath10k_pci 0000:01:00.0: htt tx msdu: 00000020: 03 00 00 00 81 00 00 06 08 06 00 01 08 00 06 04  
ath10k_pci 0000:01:00.0: htt tx msdu: 00000030: 00 01 00 09 90 00 4a 97 c0 a8 06 fd 00 00 00 00  
ath10k_pci 0000:01:00.0: htt tx msdu: 00000040: 00 00 c0 a8 06 01
	
	Moreover, for each frame sent the Tx status from the cards will increment the failed_count counter, but I didn't know what went wrong.

	Any idea ?

	Regards.

Cedric.
> -----Message d'origine-----
> De : Michal Kazior [mailto:michal.kazior@tieto.com]
> Envoyé : vendredi 5 juin 2015 07:42
> À : Cedric VONCKEN
> Cc : linux-wireless
> Objet : Re: ATH10K and VLAN
> 
> On 3 June 2015 at 16:46, Cedric VONCKEN <cedric.voncken@acksys.fr> wrote:
> >         I'm testing to send a VLAN frame through ATH10K device.
> >         I'm using compat wireless 2015-03-09 from openWRT. The ATH10K
> > firmware used is 10.2.4.45
> >
> >         My test platform is:
> >                 Pc1 : IP 10.101.4.3 (without VLAN)
> >                         VLAN 1 : IP 192.168.5.1
> >
> >                 Equipment in AP mode. The netdev is bridged with eth0
> >
> >                 Equipment in client mode with WDS mode enables. The
> client is connected to the AP. The netdev is bridged with eth0.
> >                 AP and client use ATH10K wireless card.
> >
> >                 PC2: IP 10.101.4.4 (without VLAN)
> >                         VLAN 1 : IP 192.168.5.2
> >
> >                 The PC1 is connected to the equipment in AP mode and
> the PC2 is connected to the equipment in client mode.
> >
> >
> >         I can ping from PC1 to PC2 without vlan (ping 10.101.4.4).
> >         I cannot ping from PC1 to PC2 with VLAN.
> >         With tcpdump I checked the vlan frame is sent to the netdev but
> this frame is not send to the air.
> >
> >         Is it possible to send a VLAN frame through ATH10K? If no, is
> it a driver limitation or firmware limitation?
> 
> I'm not sure if IFTYPE_WDS works with ath10k but IFTYPE_AP_VLAN works
> fine for me on latest github.com/kvalo/ath master branch. Can you test if
> it works with no encryption, please?
> 
> 
> Michał

