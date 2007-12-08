Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:20863 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752667AbXLHAed (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 19:34:33 -0500
From: bruno randolf <bruno@thinktube.com>
To: ath5k-devel@lists.ath5k.org
Subject: Re: [ath5k-devel] [PATCH 1/1] ath5k: add debugfs entries for registers, tsf, beacon
Date: Sat, 8 Dec 2007 09:34:26 +0900
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	linville@tuxdriver.com
References: <1196839665-14178-1-git-send-email-bruno@thinktube.com> <200712051950.08672.bruno@thinktube.com> <43e72e890712071435l7b20420cq4b13aaaebcd729dd@mail.gmail.com>
In-Reply-To: <43e72e890712071435l7b20420cq4b13aaaebcd729dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200712080934.27228.bruno@thinktube.com> (sfid-20071208_003435_394734_BC540195)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 December 2007 07:35:21 Luis R. Rodriguez wrote:
> Acked-by: Luis R. Rodriguez <mgrof@winlab.rutgers.edu>
>
> Seems the patch may just need to be resent, not sure, but your mailer
> may be messing with it. I'm using gmail --> show-original to retrieve
> this as a patch so not sure if that would have messed the patch up (I
> don't think so). But I get:
>
> mcgrof@nesi:~/devel/compat-wireless-2.6$ patch -p1 <
> /home/mcgrof/patches/new-debug.diff
> patching file drivers/net/wireless/ath5k/debug.c
> patch: **** malformed patch at line 238: *modes)
>
> That hunk looks like this:
>
> @@ -96,9 +294,16 @@ void
>  ath5k_debug_finish_device(struct ath5k_softc *sc)
>  {
>         debugfs_remove(sc->debug.debugfs_debug);
> +       debugfs_remove(sc->debug.debugfs_registers);
> +       debugfs_remove(sc->debug.debugfs_tsf);
> +       debugfs_remove(sc->debug.debugfs_beacon);
> +       debugfs_remove(sc->debug.debugfs_reset);
>         debugfs_remove(sc->debug.debugfs_phydir);
>  }
>
> +
> +/* functions used in other places */
> +
>  void
>  ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode
> *modes)
>  {
>
>
> The last *modes line is the one it is complaining about. After moving
> this line as:
>
>  ath5k_debug_dump_modes(struct ath5k_softc *sc, struct ieee80211_hw_mode
> *modes)

thanks, luis.
i will resend the patch with a few additions later.

bruno
