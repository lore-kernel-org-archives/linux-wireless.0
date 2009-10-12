Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55511 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753549AbZJLLZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 07:25:47 -0400
Message-ID: <4AD31213.6020006@imap.cc>
Date: Mon, 12 Oct 2009 13:25:07 +0200
From: Tilman Schmidt <tilman@imap.cc>
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: tilman@imap.cc, johannes@sipsolutions.net,
	hidave.darkstar@gmail.com, linux-kernel@vger.kernel.org,
	tglx@linutronix.de, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org, netdev@vger.kernel.org, paulus@samba.org
Subject: Re: NOHZ: local_softirq_pending 08
References: <4AD1BF06.3050103@phoenixsoftware.de>	<1255261251.4095.143.camel@johannes.local>	<4AD2E8C8.4060205@imap.cc> <20091012.033246.56701176.davem@davemloft.net>
In-Reply-To: <20091012.033246.56701176.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Mon, 12 Oct 2009 03:32:46 -0700 (PDT), David Miller wrote:
> The PPP receive paths in ppp_generic.c do a local_bh_disable()/
> local_bh_enable() around packet receiving (via ppp_recv_lock()/
> ppp_recv_unlock() in ppp_do_recv).
> 
> So at least that part is perfectly fine.
> 
> ppp_input(), as called from ppp_sync_process(), also disables BH's
> around ppp_do_recv() calls (via read_lock_bh()/read_unlock_bh()).
> 
> So that's fine too.
> 
> Do you have a bug report or are you just scanning around looking
> for trouble? :-)

I have encountered the message in the subject during a test of
the Gigaset CAPI driver, and would like to determine whether
it's a bug in the driver, a bug somewhere else, or no bug at
all. The test scenario was PPP over ISDN with pppd+capiplugin.
In an alternative scenario, also PPP over ISDN but with
smpppd+capidrv, the message did not occur.

Johannes' answer pointed me to the netif_rx() function.
The Gigaset driver itself doesn't call that function at all.
In the scenario where I saw the message, it was the SYNC_PPP
line discipline that did. But from your explanation I gather
that the cause cannot lie there.

So now I'm looking for other possible causes of that message.

- --
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFK0xITQ3+did9BuFsRAmXGAKCIiqJffUnuKw9rPjxHwbj9AnXOigCdGgS9
MpxRNGs0A4GTydYJaylbjyo=
=LFxi
-----END PGP SIGNATURE-----
