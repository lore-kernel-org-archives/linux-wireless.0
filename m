Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:34748 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbbETQZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 12:25:30 -0400
Date: Wed, 20 May 2015 17:24:46 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>,
	linux-security-module@vger.kernel.org, james.l.morris@oracle.com,
	serge@hallyn.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	David Howells <dhowells@redhat.com>,
	Kyle McMartin <kyle@kernel.org>,
	David Woodhouse <david.woodhouse@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joey Lee <jlee@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
	zohar@linux.vnet.ibm.com, mricon@kernel.org
Subject: Re: [RFD] linux-firmware key arrangement for firmware signing
Message-ID: <20150520172446.4dab5399@lxorguk.ukuu.org.uk> (sfid-20150520_182604_155997_C5ED1FEC)
In-Reply-To: <20150520140426.GB126473@ubuntu-hedt>
References: <20150519200232.GM23057@wotan.suse.de>
	<20150520140426.GB126473@ubuntu-hedt>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 May 2015 09:04:26 -0500
Seth Forshee <seth.forshee@canonical.com> wrote:

> On Tue, May 19, 2015 at 10:02:32PM +0200, Luis R. Rodriguez wrote:
> > This begs the question on how we'd manage keys for firmware signing on
> > linux-firmare. Since the keys are x509 keys we need a CA. Based on some initial
> > discussions it would seem we'd need the Linux Foundation to create a key, this
> > would be embedded in the kernel and that key would be used to sign Kyle's key.
> > Kyle would in turn use his key for signing linux-firmware files. David, Kyle,
> > did I summarize this correctly ?
> 
> I raised the question of key revocation when we discussed this on irc,
> but it wasn't answered to my satisfaction. If a key signed by the
> kernel-embedded key is compromised, how can that key be revoked so that
> it is no longer trusted?
> 
> Someone mentioned UEFI blacklists, which I don't know much about, but
> not all systems have UEFI. The only reliable option that comes to mind
> for me is an in-kernel blacklist of keys which should no longer be
> trusted.

More to the point why do you want to sign firmware files ? Leaving aside
the fact that someone will produce a device with GPLv3 firmware just to
p*ss you off there's the rather more relevant fact that firmware for
devices on a so called "trusted" platform already have signed firmware.

For external devices I don't normally have access to read system memory
anyway, and signing firmware would achieve nothing unless you start doing
crazy DRM style key exchanges to prove the endpoint is trusted. Any NSA
trojan wifi stick is simply going to nod as the correct firmware is
uploaded, and then ignore it. And if I'm just out to be a pain I can
already just plug in a fake device claiming to be a usb disk with 256
bytes per sector (boom... exit machine stage right), or for that matter
wire a USB stick with 5v connected to the mains at the nearest wall
socket.

So I don't think I understand the threat model your signing hopes to fix ?

Alan
