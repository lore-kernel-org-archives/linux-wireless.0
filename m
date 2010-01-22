Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38000 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab0AVVxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 16:53:43 -0500
Message-ID: <3ef14e53bb12298507dbaec4bb0b98d3.squirrel@secure.sipsolutions.net>
In-Reply-To: <1264196526.3040.3.camel@mj>
References: <loom.20100122T205326-794@post.gmane.org>
    <1264193623.2593.17.camel@johannes.local>
    <1264196526.3040.3.camel@mj>
Date: Fri, 22 Jan 2010 22:53:41 +0100
Subject: Re: Starting hostapd causes kernel panic
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Pavel Roskin" <proski@gnu.org>
Cc: "Markus Baier" <markus_baier@web.de>,
	linux-wireless@vger.kernel.org, kalle.valo@iki.fi
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Fri, 2010-01-22 at 21:53 +0100, Johannes Berg wrote:
>
>> Try this please.
>
> I'm still getting a panic in ieee80211_tx_h_select_key():
>
> BUG: unable to handle kernel NULL pointer dereference at 00000000000001cf
> IP: [<ffffffffa0167e1a>] ieee80211_tx_h_select_key+0x26a/0x300 [mac80211]
> PGD 12a7f8067 PUD 126450067 PMD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:02:02.0/irq
> CPU 0
> Pid: 19396, comm: hostapd Not tainted 2.6.33-rc4-wl #239 G31T-M/G31T-M
> RIP: 0010:[<ffffffffa0167e1a>]  [<ffffffffa0167e1a>]
> ieee80211_tx_h_select_key+0x26a/0x300 [mac80211]
>
> (gdb) l *(ieee80211_tx_h_select_key+0x26a)
> 0x16e4a is in ieee80211_tx_h_select_key
> (/home/proski/src/linux-2.6/net/mac80211/tx.c:550).
> 545                     case ALG_CCMP:
> 546                             if
> (!ieee80211_is_data_present(hdr->frame_control) &&
> 547                                 !ieee80211_use_mfp(hdr->frame_control,
> tx->sta,
> 548                                                    tx->skb))
> 549                                     tx->key = NULL;
> 550                             skip_hw = (tx->key->conf.flags &
> 551
> IEEE80211_KEY_FLAG_SW_MGMT) &&
> 552
> ieee80211_is_mgmt(hdr->frame_control);
> 553                             break;
> 554                     case ALG_AES_CMAC:
>
> I assume it's another case where tx->key should be checked for being
> NULL.  In fact, it's set to NULL on the preceding line!

or an else inserted.

> --
> Regards,
> Pavel Roskin
>
>

