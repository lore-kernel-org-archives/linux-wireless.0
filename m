Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:46290 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbXHOERE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 00:17:04 -0400
Date: Tue, 14 Aug 2007 21:16:02 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] hostapd: use eapol frames from ethernet device
Message-ID: <20070815041602.GP1415@jm.kir.nu>
References: <1186789737.4862.3.camel@johannes.berg> <1186790012.4862.8.camel@johannes.berg> <1ba2fa240708120358rb22a2f9me1a1020e669406e7@mail.gmail.com> <1186995104.27916.56.camel@johannes.berg> <1ba2fa240708130346h6175701cr2daab916afaed00f@mail.gmail.com> <1187002921.27916.77.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1187002921.27916.77.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2007 at 01:02:01PM +0200, Johannes Berg wrote:

> The actual technical reason for doing is that subsequent patches totally
> remove the management interface and on the monitor interface the EAPOL
> frames show up undecrypted.

I have to admit that I haven't followed the latest changes on this area,
but before this kind of change goes in, I would like to verify that all
the needed cases will be supported with EAPOL and management frames:

- user space needs to be able to transmit EAPOL frames encrypted
  (WPA/WPA2) and in plain (IEEE 802.1X with dynamic WEP) even if keys
  are configured for the receiver; how is this done for the IEEE 802.1X
  rekeying case?

- plaintext EAPOL frames need to be received in some cases (mainly, IEEE
  802.1X with dynamic WEP) even if there is a configured key for the
  sending; ideally, user space apps would know whether the frame was
  encrypted or not

- management frames will need to be encrypted and decrypted in kernel
  (802.11w), e.g., when user space is sending and receiving action
  frames; i.e., there would need to be a mechanism to receive management
  frames that has been decrypted by the kernel and to be able to send
  management frames with kernel doing encryption; both are optional and
  depend on the key configuration for the sender/receiver


I don't really like the idea of having to implement encryption and
decryption for all these frames in both the user and kernel space.
Furthermore, some things like receiption of unencrypted EAPOL frames
would be quite difficult to do in user space unless the kernel were
actually to help here.

For me, the management frame interface provides a good and working
solution for this. I know that some people do not like the idea of
having yet another network device showing up here, but I want to make
sure that the "solution" for this is not breaking some needed
functionality or making this unnecessarily complex to implement for user
space apps.

-- 
Jouni Malinen                                            PGP id EFC895FA
