Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:44847 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab2EHHfF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 03:35:05 -0400
Date: Tue, 8 May 2012 10:34:46 +0300
From: Jouni Malinen <j@w1.fi>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>, hostap@lists.shmoo.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [rt2800pci (AP) - ath9k] 802.11w: broken
 aggregation handling?
Message-ID: <20120508073446.GA2887@w1.fi> (sfid-20120508_093510_507972_95E415AA)
References: <4FA75983.9040003@01019freenet.de>
 <201205070702.q4772uem002960@mail.maya.org>
 <4FA7A13D.6020405@01019freenet.de>
 <CAGXE3d-pwTraDvC6yOKt7hHPTXL5LtaHFovD_SFmaPgajJbS9g@mail.gmail.com>
 <20120507135533.GA19222@w1.fi>
 <4FA8BD11.3080703@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA8BD11.3080703@01019freenet.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 08, 2012 at 08:28:33AM +0200, Andreas Hartmann wrote:
> > The main requirements:
> > - support CCMP encryption/decryption of unicast robust management frames
> >   (subset of Action frames, Deauthentication, Disassociation)
> 
> I tested WPA-EAP-SHA256 with group key ccmp.

The key point here is to test whether at least one of those management
frames gets encrypted and decrypted correctly. Deauthentication frames
may be easiest for that purpose and you can request the station to
disconnect to test AP's capability of receiving the frame and then use
hostapd_cli deauthenticate <addr> command on the AP to request the
station to be disconnected.

> The IGTK is a single key (shared key). There are a maximum of 4 shared
> keys designated in rt2x00mac.c for each BSS for use with hw encryption.

BIP uses key indexes 4 and 5 (i.e., the 5th and 6th index).. Anyway,
this would most likely be handled in software so the main point here is
to prevent hardware from doing anything additional to the frames.

> Since rt2800usb is working fine with nohwcrypt=1 (but not with
> encryption done in hw), I assume, that there is no differentiation
> between the encryption / decryption of different frame types. If hw
> encryption is turned on, all types of frames are encrypted / decrypted
> by hardware and vice versa.

BIP is kind of special since it doesn't actually even set the Protected
field in the frame header which may make this easier.. The frames are
not actually encrypted, i.e., BIP protects only authenticity of the
frames.

> I'm not sure how BIP is secured if hw encryption is enabled. BIP is
> implemented in mac80211 as part of decryption. Is BIP done during hw
> encryption, too? Or is it done by mac80211 w/ enabled hw encryption, too?

With most drivers, yes, I would expect mac80211 to handle both TX and RX
side. The driver should just return -EOPNOTSUPP in the set_key() handler
for WLAN_CIPHER_SUITE_AES_CMAC to leave BIP for mac80211 and CCMP for
hwardware.

> This means for rt2x00: to get 11w working with hw encryption enabled,
> there needs to be some differentiation for the encryption of management
> frames: if management frame, let mac80211 do the job - all other frames
> should be encrypted by hw.
> Correct?

Well, if you are saying that the issues shows up with unicast robust
management frames, too, and not just BIP (group addressed robust
management frames), then you are in problems.. With good luck, you could
be able to make the hardware not mess up with unicast robust management
frames and handle them in mac80211. This may be easier for TX, but RX
can be a bit complex. It may go to the point of having to use the
driver to workaround the mess that hardware did (i.e., re-encrypted the
frame in incorrect way to get back to the correctly encrypted form and
then sent that to mac80211).. All this depends on the exact behavior of
the hardware with a frame that was designed after the hardware was, so
good luck figuring that out ;-).

-- 
Jouni Malinen                                            PGP id EFC895FA
