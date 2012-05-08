Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:57396 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab2EHGbA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 02:31:00 -0400
Message-ID: <4FA8BD11.3080703@01019freenet.de> (sfid-20120508_083105_563970_E32F8325)
Date: Tue, 08 May 2012 08:28:33 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>, Jouni Malinen <j@w1.fi>
CC: hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken aggregation
 handling?
References: <4FA75983.9040003@01019freenet.de> <201205070702.q4772uem002960@mail.maya.org> <4FA7A13D.6020405@01019freenet.de> <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com> <20120507135533.GA19222@w1.fi>
In-Reply-To: <20120507135533.GA19222@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni, hi Helmut,

Jouni Malinen wrote:
> On Mon, May 07, 2012 at 01:04:29PM +0200, Helmut Schaa wrote:
>> I'm fine with enabling MFP in rt2800pci but I don't know enough about the
>> necessary requirements.
>>
>> Jouni, are there any special requirements for MFP?
> 
> The main requirements:
> - support CCMP encryption/decryption of unicast robust management frames
>   (subset of Action frames, Deauthentication, Disassociation)

I tested WPA-EAP-SHA256 with group key ccmp.

> - support BIP and IGTK configuration for group addressed robust
>   management frames (TX-only for AP, RX-only for STA); I would expect
>   most drivers to use software implementation on the host CPU for this
>   taken into account that there is only very limited use of group
>   addressed robust management frames

The IGTK is a single key (shared key). There are a maximum of 4 shared
keys designated in rt2x00mac.c for each BSS for use with hw encryption.

Since rt2800usb is working fine with nohwcrypt=1 (but not with
encryption done in hw), I assume, that there is no differentiation
between the encryption / decryption of different frame types. If hw
encryption is turned on, all types of frames are encrypted / decrypted
by hardware and vice versa.

I'm not sure how BIP is secured if hw encryption is enabled. BIP is
implemented in mac80211 as part of decryption. Is BIP done during hw
encryption, too? Or is it done by mac80211 w/ enabled hw encryption, too?

Grrr. Now I know, why I had to disable hw encryption for rt2800usb.
Because it was disabled for rt2800pci (AP), too. If mac80211 is doing
the job, 11w works fine. If encryption is done by hardware (AP), 11w is
broken: the ath9k station doesn't work any more, regardless if hw
encryption is switched on or off for ath9k.

11w		rt2800pci (AP)	ath9k sta		rt2800usb sta
---------------------------------------------------------------------
1,3		nohwcrypt=1	nohwcrypt=[0|1]		nohwcrypt=1
2,4		nohwcrypt=0	nohwcrypt=[0|1]		nohwcrypt=1
2,5		nohwcrypt=0	nohwcrypt=[0|1]		nohwcrypt=0


1 = ath9k fine
2 = ath9k broken
3 = rt2800usb fine
4 = rt2800usb broken
5 = rt2800usb seems to work

This means for rt2x00: to get 11w working with hw encryption enabled,
there needs to be some differentiation for the encryption of management
frames: if management frame, let mac80211 do the job - all other frames
should be encrypted by hw.
Correct?

> - SA Query mechanism (mac80211-based drivers get this pretty much
>   automatically from hostapd for AP mode and mac80211 for STA)
> - ability to configure RSN capabilities into RSN element and to
>   provide the received element to user space (again, most mac80211-based
>   drivers should work as-is)

Thank you very much for your explanations, Jouni!


Regards,
Andreas
