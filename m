Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926AbXIXLfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 07:35:19 -0400
Message-ID: <46F7A0F2.7000900@redhat.com>
Date: Mon, 24 Sep 2007 13:35:14 +0200
From: Michal Schmidt <mschmidt@redhat.com>
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-wireless@vger.kernel.org, fabrice@bellet.info
Subject: Re: Problem with Cisco MPI350/airo
References: <Xine.LNX.4.64.0709190051080.29334@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0709190051080.29334@us.intercode.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

James Morris wrote:
> I've got an x31 thinkpad with an MPI350 card, which has worked more or 
> less reliably for several years.
> 
> With current git and Fedora kernels, the wireless dies some time after 
> boot, with the following types of messages ending up in syslog:
> 
> Sep 19 16:36:32 localhost kernel: airo(eth0): cmd:1 status:7f21 rsp0:21 rsp1:0 rsp2:2eab
> Sep 19 16:36:32 localhost kernel: airo(eth0): Bad MAC enable reason=21, rid=0, offset=11947
> Sep 19 16:36:33 localhost kernel: airo(eth0): cmd:2 status:7f02 rsp0:0 rsp1:0 rsp2:2eab
> Sep 19 16:36:33 localhost kernel: airo(eth0): cmd:1 status:7f01 rsp0:2 rsp1:0 rsp2:2eab
> Sep 19 16:36:33 localhost kernel: airo(eth0): Bad MAC enable reason=2, rid=0, offset=11947
> Sep 19 16:36:33 localhost kernel: airo(eth0): cmd:3 status:7f03 rsp0:0 rsp1:0 rsp2:2eab
> 
> NetworkManager seems to lose contact with the card, then fails & asks for 
> a new key (which it doesn't actually need).
> 
> Sep 19 16:37:03 localhost NetworkManager: <info>  Activation 
> (eth0/wireless): association took too long (>20s), asking for
>  new key. 
> 
> Anyone seen this before, and/or know what's happening ?
> 
> 
> - James

Mine doesn't do that. Can you try replacing airo.c with the version from
2.6.22 ?
git-checkout v2.6.22 drivers/net/wireless/airo.c

Does it make it work correctly again?

Michal
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with Red Hat - http://enigmail.mozdev.org

iD8DBQFG96DyxTW/vZef86oRAt+SAJ4oPryHfdOla1nY3HA1khqAqoQfzACgxIuj
UsRaAsu95oo+EiuPZtVh/1k=
=ZB/x
-----END PGP SIGNATURE-----
