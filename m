Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58333 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965559Ab0GSTWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 15:22:16 -0400
Received: by vws5 with SMTP id 5so5028347vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jul 2010 12:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
Date: Mon, 19 Jul 2010 15:22:15 -0400
Message-ID: <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
Subject: Re: ath5k Ad Hoc Association
From: Bob Copeland <me@bobcopeland.com>
To: Jonathan Guerin <jonathan@guerin.id.au>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 19, 2010 at 12:35 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
> Hi,
>
> I'm trying to get my wireless nodes to associate in ad hoc mode.
[...]
> I've built and installed the compat package for this kernel version:
> compat-wireless-2.6.32.16

Ok, I'm not sure which mainline kernel this corresponds to, but I
just tested ath5k adhoc with success in the latest wireless-testing
kernel.  Here's what I did:

(had dnsmasq running dhcp for 192.168.10.x, network manager disabled)

$ su
# modprobe -r ath5k
# modprobe ath5k
# iw dev wlan0 set type ibss
# ifconfig wlan0 192.168.10.1 up
# iw dev wlan0 ibss join myibss 2462

Then on the other machine (Vista) I just located 'myibss' (so beacons
are working) and selected it, then successfully pinged 192.168.10.1.

It may depend on which channel you are trying to use; are you on
a channel that allows beaconing in your regulatory domain?

-- 
Bob Copeland %% www.bobcopeland.com
