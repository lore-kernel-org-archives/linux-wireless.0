Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65310 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab1DURYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 13:24:44 -0400
Received: by iyb14 with SMTP id 14so1563542iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 10:24:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimvT-9mSQ8n1zyDYpioxJEv=Kc7Jg@mail.gmail.com>
References: <BANLkTimvT-9mSQ8n1zyDYpioxJEv=Kc7Jg@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 21 Apr 2011 10:24:23 -0700
Message-ID: <BANLkTimpp5hU3X17yfCrcBzmfqaO7T8OJA@mail.gmail.com>
Subject: Re: Mesh broken
To: Qasim Javed <qasimj@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org, devel@lists.open80211s.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2011 at 2:18 PM, Qasim Javed <qasimj@gmail.com> wrote:
> Hi all,
>
> We have a 6 node mesh setup, with one node acting as a mesh portal.
> All the nodes are in direct range of each other, so every node has 5
> peer links. The node that acts as a mesh portal has another laptop
> connected to it via an Ethernet cable which runs an iperf TCP server.
> Every mesh node runs an iperf TCP client where the transmit data rate
> is limited to about 500Kbps.
>
> When we run the iperf client on all the mesh nodes while using
> compat-wireless from 18th Jan, 2011, things seem to work fine. There
> is rarely a connection loss. However, the peak data rate at the laptop
> which is connected to the mesh portal (via Ethernet) goes much higher
> than the expected 3Mbps (6*500Kbps).
>
> When we use compat-wireless from 28th March, 2011, and repeat the
> above experiment again, the results we get are quite disappointing.
> The TCP connections from all 6 nodes constantly break. Also, if only
> one mesh node is communicating with the laptop connected to the mesh
> portal, the connection does not break. If using the same
> compat-wireless, we force the max plinks to 1 (one) at each node, the
> TCP connections do not break. Everything works fine.
>
> If we use compat-wireless from 31st march, 2011, the mesh nodes are
> not even able to establish plinks with each other.
>
> "iw dev mesh station dump"
>
> returns nothing.
>
> Switching to compat-wireless from 14th April, 2011 results in plinks
> alternating between LISTEN and OPN_SNT states. The displayed beacon
> signal strength (in station dump) is very low (close to -80dbm).
>
> Infrastructure mode works fine.
>
> Can anyone please elaborate on what could be happening here?

I have no clue, but FWIW we tested a recent version of
wireless-testing (1d4af019d920c838e4de81afa0b5d67879090fd5) on ath9k
hardware (AR5418) and worked well¹.

Javier

[1] We had to apply a fix to that particular card that
(http://o11s.org/trac/wiki/ath9kFilteringIssueFix) but that does not
seem to apply to your hardware as you were running in mesh mode
before.
