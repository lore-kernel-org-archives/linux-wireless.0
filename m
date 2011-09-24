Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deltab.zq1.de ([78.46.32.14]:59586 "EHLO delta.zq1.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752082Ab1IXS7c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 14:59:32 -0400
Message-ID: <4E7E2738.6020208@lsmod.de> (sfid-20110924_205940_178086_BCDEABF3)
Date: Sat, 24 Sep 2011 20:53:44 +0200
From: "Bernhard M. Wiedemann" <bernhardout@lsmod.de>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	wireless <linux-wireless@vger.kernel.org>,
	Ivo van Drn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: Bug in rt2800pci on an RT3090
References: <4E7CEE67.2070906@lwfinger.net> <20110924163007.GA10001@redhat.com>
In-Reply-To: <20110924163007.GA10001@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 24.09.2011 18:30, schrieb Stanislaw Gruszka:
> On Fri, Sep 23, 2011 at 03:39:03PM -0500, Larry Finger wrote:
>> A bug was sent to me concerning a scheduling-while-atomic-BUG.
>> This happened shortly after KDE suspended an eeepc1015PE netbook
>> during system update over WLAN. Suspend&resume normally worked
>> allright. The OP is Berhard Wiedemann in the Cc list. Inquiries
>> for more info go to him.
> 
> It looks like we forgot to unlock spinlock somewhere or we do not 
> use _irqsave version of spinlock where needed, but provided
> calltrace is not naught to find the bug.
> 
> I suggest compile kernel with CONFIG_LOCKDEP, try to reproduce and
> see if we do get some more messages.
> 
> Stanislaw

Hi Stanislaw,

the kernel config already has
CONFIG_LOCKDEP_SUPPORT=y
Is that what you meant? Does it need any extra to activate?

meanwhile I had a similar bug on rc6 hours after resuming.

This time it had some additional soft lockup messages ontop. see
http://www.zq1.de/~bernhard/temp/dmesg.bug

Ciao
Bernhard M. Wiedemann
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk5+JzgACgkQSTYLOx37oWQX1QCghshrnkuGt+CVmvVqlyeAD0wk
HMUAoK1GvzR0tvBokCSdZv8elrA2SZCE
=6u+w
-----END PGP SIGNATURE-----
