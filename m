Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f115.google.com ([209.85.222.115]:64884 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbZENTHy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 15:07:54 -0400
Received: by pzk13 with SMTP id 13so736814pzk.33
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 12:07:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242327298.4227.25.camel@localhost.localdomain>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	<1242327298.4227.25.camel@localhost.localdomain>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 May 2009 12:07:35 -0700
Message-ID: <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
Subject: Re: Scan while TX/RX'ing a lot of data
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 11:54 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Thu, 2009-05-14 at 10:52 -0700, Luis R. Rodriguez wrote:
>> I'm told Network Manager scans every 60 seconds. When TX'ing or RX'ing
>> a lot of data you will see a big dip in throughput and sometimes it
>> may cause issues with some connections. Jouni pointed out a possible
>> nice option here: split the scans per channel through time. Now with
>> nl80211 this is possible but right now Network Manager uses wext
>> through wpa_supplicant in many distributions and this won't change for
>> a bit (maybe by the next major distribution releases?). Since we're
>> stuck with wext for the current distribution releases I'd like to hear
>> feedback on a possible nice solution. Should we simply cancel scan?
>
> Libertas

libertas_tf (the mac80211 driver) ? Or the fullmac one?

> splits scans up into 3 parts with a short return to the
> operating channel between each part.  There's nothing that requires
> cfg80211 for that to work...

We can do tricks in drivers but I'd like to see this handled in mac80211.

> Something I've tossed around for a while is counting traffic on the
> device and if its over a certain bitrate for a period of time, postpone
> the scan for a while.  But after a certain amount of time, there's going
> to be a scan no matter what.

Sure, makes sense. I take it the effort to make this more intelligent
is part of the the roaming intelligence we need to enhance.

> The problem here is that at any time an application (say, wifi location
> app) could ask for the list of access points.  If you don't scan
> periodically, all APs other than your associated AP (and others on the
> same channel) will gradually drop off because their beacons are
> received.  Hard to wifi position or get area statistics if there's only
> one AP in the list.

Makes sense.

> Secondarily, scanning is a tradeoff between better roaming latency and
> continuous high throughput.  If you don't scan, you have no idea what's
> around, and when you move and the current AP becomes marginal, you
> *have* to take the hit no matter what, so you can scan and find a new AP
> to associate with.

True however I'm inclined to believe that generally when you are
sending or receiving a lot of data you are stationary so roaming might
not be that urgent. For 802.11p (vehicle stuff) I suppose this may be
a bit different but I have yet to see this take off.

> I would have though that the periodic scanning would be more of an
> annoyance when doing VOIP or SSH other latency sensitive tasks, but when
> just downloading a file, a few second drop in transfer rate gets lost in
> the bucket in the grand scheme of things.

Good point, how about we use pm_qos for disabling scan when we are
sending a lot of data (whatever we define this to mean)? Then
applications can just write to this pm_qos stuff and you won't see
this.

I forget when pm_qos was introduced though.

  Luis
