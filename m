Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.185]:61505 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbYAGTXG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jan 2008 14:23:06 -0500
Received: by rv-out-0910.google.com with SMTP id k20so7188481rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jan 2008 11:23:06 -0800 (PST)
Message-ID: <43e72e890801071123p196d576cpce2a44f240e8f88e@mail.gmail.com> (sfid-20080107_192311_759977_26878949)
Date: Mon, 7 Jan 2008 14:23:06 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Ralph Spitzner" <rasp@spitzner.org>
Subject: Re: ath5k
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47826588.6090106@spitzner.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47826588.6090106@spitzner.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 7, 2008 12:46 PM, Ralph Spitzner <rasp@spitzner.org> wrote:
> Following the Procedures described under:
> http://linuxwireless.org/en/developers/Documentation/git-guide
> or
> http://linuxwireless.org/en/users/Download
>
> While trying to insert the ath5k module I get :
> --------------------------------------------------------------------
>
> root@meepmeep:~# insmod ath5k.ko
> root@meepmeep:~# BUG: unable to handle kernel paging request at virtual
> address fffffdd0
> printing eip: d0c74071 *pde = 00981067 *pte = 00000000
> Oops: 0000 [#1]
> Modules linked in: ath5k snd_seq_dummy snd_seq_oss snd_seq_midi_event
> snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss ipv6 xt_tcpudp
> iptable_filter ip_tables x_tables lp parport_pc parport pcspkr psmouse
> pcmcia battery ac power_supply mac80211 evdev e1000 cfg80211
> yenta_socket rsrc_nonstatic pcmcia_core video output thermal serio_raw
> processor intel_agp button agpgart ata_generic
> i2c_i801 snd_intel8x0 snd_ac97_codec ac97_bus snd_pcm snd_timer iTCO_wdt
> shpchp snd iTCO_vendor_support soundcore snd_page_alloc
> Pid: 3029, comm: ifconfig Not tainted (2.6.24-rc7 #2)
> EIP: 0060:[<d0c74071>] EFLAGS: 00010246 CPU: 0
> EIP is at ieee80211_generic_frame_duration+0x21/0x70 [mac80211]

This is fixed by the patch titled: "[PATCH] ath5k: Fix frame duration
oops" posted on January 4rth, which is pending.

  Luis
