Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47794 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946Ab0GTWyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 18:54:41 -0400
Received: by qwh6 with SMTP id 6so2211818qwh.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jul 2010 15:54:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1007211002410.21858@kauri.acheron.indranet.co.nz>
References: <AANLkTilmifjH5Zopo82LhjidzsYfT_xRgKJzjGCZZPlq@mail.gmail.com>
	<AANLkTintLd8YTgMQuzbEB36t_i5AL4TePBSDAa7G2zvl@mail.gmail.com>
	<alpine.DEB.2.00.1007211002410.21858@kauri.acheron.indranet.co.nz>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Wed, 21 Jul 2010 08:54:19 +1000
Message-ID: <AANLkTimkmomMzzolCe7SFJssgbOchjZHcByhJHW1RnA4@mail.gmail.com>
Subject: Re: [ath5k-devel] ath5k Ad Hoc Association
To: Derek Smithies <derek@indranet.co.nz>
Cc: Bob Copeland <me@bobcopeland.com>,
	"Ath5k Devel issues." <ath5k-devel@lists.ath5k.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am happy to provide such data. Tell me what config you want me to
put in place and I'll set up a capture.

Cheers,

--
Jonathan Guerin



On Wed, Jul 21, 2010 at 8:11 AM, Derek Smithies <derek@indranet.co.nz> wrote:
> Hi,
> On Mon, 19 Jul 2010, Bob Copeland wrote:
>
>> On Mon, Jul 19, 2010 at 12:35 AM, Jonathan Guerin <jonathan@guerin.id.au>
>> wrote:
>>>
>>> Hi,
>>>
>>> I'm trying to get my wireless nodes to associate in ad hoc mode.
>
> [[[snipped]]]
>>
>> $ su
>> # modprobe -r ath5k
>> # modprobe ath5k
>> # iw dev wlan0 set type ibss
>> # ifconfig wlan0 192.168.10.1 up
>> # iw dev wlan0 ibss join myibss 2462
>>
>> Then on the other machine (Vista) I just located 'myibss' (so beacons
>> are working) and selected it, then successfully pinged 192.168.10.1.
>
> Wrong.
> If the other machine located your node, then one of the four statements is
> true:
>  a)beacons are working
>  b)probes are working - which means a scan is happening.
>  c)beacons and probes are working
>  d)beacons and probes are not working. The vista machine saw a data
>   packet, and sent a probe request, which your machine answered.
>
>>>>>>>>>
>
> My colleague here did some work with a slightly older kernel.
>
> He found that the association process worked sometimes - not always.
> There was a time dependency - both nodes have to go through this at the same
> time.
>
> Further - scans - it seems that nodes have to scan to find things. Old
> information in the mac80211 has to be expired and removed.
>
> A scan should not be necessary - if both ends are put on channel 2462- a
> scan should not be required - there is no channel changing. Yet - my
> colleague noted a scan helped nodes to associate.
>
> I would say this:::
>  I cannot deduce what is happening from the initial posters report. I need a
> packet dump of the beacons/probes and all the other packets on the air.
>
> Cheers,
>  Derek.
> --
> Derek Smithies Ph.D.
> IndraNet Technologies Ltd.
> ph +64 3 365 6485
> Web: http://www.indranet-technologies.com/
>
> "How did you make it work??"
>      "Oh, the usual, get everything right".
>
