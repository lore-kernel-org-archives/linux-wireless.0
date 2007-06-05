Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:10849 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755867AbXFECac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 22:30:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: mac80211 TX hangs up
Date: Mon, 4 Jun 2007 19:29:50 -0700
Cc: linux-wireless@vger.kernel.org
References: <4664C9EB.8050106@gentoo.org>
In-Reply-To: <4664C9EB.8050106@gentoo.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2756100.elf6utFDv8";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706041929.55302.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2756100.elf6utFDv8
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 04 June 2007 19:26, Daniel Drake wrote:
> WARNING: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
>   [<f02ad79f>] ieee80211_master_start_xmit+0x19b/0x4b2 [mac80211]
>   [<b011b334>] __wake_up_common+0x32/0x55
>   [<b011b891>] __wake_up+0x32/0x43
>   [<b02e6f54>] dev_hard_start_xmit+0x18a/0x1e9
>   [<b02f121c>] __qdisc_run+0xc5/0x190
>   [<b02e7cbd>] net_tx_action+0xa8/0xd0
>   [<b032ad2d>] wireless_nlevent_process+0x2a/0x31
>
> The line of code in question is
> 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
>
> This was with mac80211 from 2.6.22-rc3, but the problem has also been
> seen with a recent wireless-dev.git.
>
> Any ideas or other reports of this?
>
Do you have CONFIG_NET_SCHED on?

-Michael Wu

--nextPart2756100.elf6utFDv8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGZMqjT3Oqt9AH4aERAjaXAKCsyyNetbmQ2gWAuaNg+5BXz2xMZgCgyUu5
clqpk9wj+Wejc9/pcx+43DY=
=vi+i
-----END PGP SIGNATURE-----

--nextPart2756100.elf6utFDv8--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
