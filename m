Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dmz4.indranet.co.nz ([203.97.93.68]:52211 "EHLO
	mail.indranet.co.nz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1761475Ab0GTWRj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 18:17:39 -0400
Date: Wed, 21 Jul 2010 10:11:14 +1200 (NZST)
From: Derek Smithies <derek@indranet.co.nz>
To: Bob Copeland <me@bobcopeland.com>
cc: Jonathan Guerin <jonathan@guerin.id.au>,
	"Ath5k Devel issues." <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] ath5k Ad Hoc Association
In-Reply-To: <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1007211002410.21858@kauri.acheron.indranet.co.nz>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com> <AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
On Mon, 19 Jul 2010, Bob Copeland wrote:

> On Mon, Jul 19, 2010 at 12:35 AM, Jonathan Guerin <jonathan@guerin.id.au> wrote:
>> Hi,
>>
>> I'm trying to get my wireless nodes to associate in ad hoc mode.
[[[snipped]]]
> $ su
> # modprobe -r ath5k
> # modprobe ath5k
> # iw dev wlan0 set type ibss
> # ifconfig wlan0 192.168.10.1 up
> # iw dev wlan0 ibss join myibss 2462
>
> Then on the other machine (Vista) I just located 'myibss' (so beacons
> are working) and selected it, then successfully pinged 192.168.10.1.
Wrong.
If the other machine located your node, then one of the four statements 
is true:
  a)beacons are working
  b)probes are working - which means a scan is happening.
  c)beacons and probes are working
  d)beacons and probes are not working. The vista machine saw a data
    packet, and sent a probe request, which your machine answered.

>>>>>>>>

My colleague here did some work with a slightly older kernel.

He found that the association process worked sometimes - not always.
There was a time dependency - both nodes have to go through this at the 
same time.

Further - scans - it seems that nodes have to scan to find things. 
Old information in the mac80211 has to be expired and removed.

A scan should not be necessary - if both ends are put on channel 2462- a 
scan should not be required - there is no channel changing. Yet - my 
colleague noted a scan helped nodes to associate.

I would say this:::
   I cannot deduce what is happening from the initial posters report. I 
need a packet dump of the beacons/probes and all the other packets on the 
air.

Cheers,
  Derek.
-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/

"How did you make it work??"
       "Oh, the usual, get everything right".
