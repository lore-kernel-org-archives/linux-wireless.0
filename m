Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.226]:1841 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXCSELU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 00:11:20 -0400
Received: by wr-out-0506.google.com with SMTP id 41so1270362wry
        for <linux-wireless@vger.kernel.org>; Sun, 18 Mar 2007 21:11:20 -0700 (PDT)
Message-ID: <43e72e890703182111lc2fa029u9180806554ce3bcc@mail.gmail.com>
Date: Mon, 19 Mar 2007 00:11:20 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: prism54pci fails to read eeprom on PowerPC, then bugs in pci code
In-Reply-To: <20070317061502.GA5954@keitarou>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <20070317034607.GA1522@keitarou>
	 <200703170037.14875.flamingice@sourmilk.net>
	 <20070317061502.GA5954@keitarou>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/17/07, Paul TBBle Hampson <Paul.Hampson@pobox.com> wrote:
> On Sat, Mar 17, 2007 at 12:37:10AM -0400, Michael Wu wrote:
> > On Friday 16 March 2007 23:46, Paul TBBle Hampson wrote:
> >> The (built-in) bcm43xx-mac80211 driver works, but when I try to load a
> >> CardBus Atheros card I've got lying around with dadwifi-openhal, it
> >> fails with some sort of hardware error.  (ie. it _might_ be a dodgey
> >> Cardbus port, although both cardbus cards used to work in this machine,
> >> using prism54 hardmac and the dadwifi with atheros hal driver
> >> respectively)
>
> > Can you rule out the port first? Load the fullmac driver first, bring it up &
> > down, unload it, and then try p54.
>
> OK, with the current prism54 as it appears in wireless-dev:
> Mar 17 16:32:41 su kernel: pccard: CardBus card inserted into slot 0
>  ] modprobe prism54
> Mar 17 16:33:04 su kernel: Loaded prism54 driver, version 1.2
> Mar 17 16:33:04 su kernel: PCI: Enabling device 0001:11:00.0 (0000 -> 0002)
> Mar 17 16:33:04 su kernel: prism54: pci_set_mwi(pdev) succeeded
>  ] ifup prism54-0 (fires up wpa_supplicant and tries to associate to local WPA AP)
> Mar 17 16:33:54 su kernel: prism54-0: resetting device...
> Mar 17 16:33:54 su kernel: prism54-0: uploading firmware...
> Mar 17 16:33:54 su kernel: prism54-0: firmware version: 1.0.4.3
> Mar 17 16:33:54 su kernel: prism54-0: firmware upload complete
> Mar 17 16:33:54 su kernel: prism54-0: interface reset complete
> Mar 17 16:33:55 su kernel: prism54-0: WPA IE Attachment was set
> Mar 17 16:34:05 su kernel: prism54-0: no IPv6 routers present
> Mar 17 16:34:08 su kernel: prism54-0: WPA IE Attachment was set
> Mar 17 16:34:21 su kernel: prism54-0: WPA IE Attachment was set
> Mar 17 16:34:34 su kernel: prism54-0: timeout waiting for mgmt response 300, triggering device
> <repeat last two lies x 3>
> Mar 17 16:35:14 su kernel: prism54-0: mgt_commit_list: failure. oid=19000004 err=1
> Mar 17 16:35:14 su kernel: prism54-0: mgt_commit: failure
> Mar 17 16:35:14 su kernel: prism54-0: WPA IE Attachment was set
> <repeat last three lines>
> Mar 17 16:35:30 su kernel: prism54-0: timeout waiting for mgmt response 300, triggering device
> Mar 17 16:35:30 su kernel: prism54-0: mgt_commit_list: failure. oid=19000004 err=1
> Mar 17 16:35:30 su kernel: prism54-0: mgt_commit: failure
> Mar 17 16:35:30 su kernel: prism54-0: WPA IE Attachment was set
> <repeat these four lines a lot>
> Mar 17 16:37:40 su kernel: prism54-0: timeout waiting for mgmt response 300, triggering device

FYI prism54 doesn't yet support WPA. There was a patch lying around
but I just have not had enough time to dedicate its integration.

  Luis
