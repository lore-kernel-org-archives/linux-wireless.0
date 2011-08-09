Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:43022 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430Ab1HIJgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:36:05 -0400
Received: by mail-ew0-f54.google.com with SMTP id 1so1123934ewy.41
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:36:03 -0700 (PDT)
Subject: Re: Making sense of cfg80211_scan_request.n_ssids
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Daniel Drake <dsd@laptop.org>
Cc: Pavel Roskin <proski@gnu.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1312792639.4372.7.camel@jlt3.sipsolutions.net>
References: <CAGq3pz40rsMudofq6Njr0_h1G=EqEigGL-NkODj8Rb6h2bMGMQ@mail.gmail.com>
	 <4E3875BE.9070504@gnu.org>
	 (sfid-20110803_001012_532868_0AAF0D7E)  <1312792639.4372.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 12:36:00 +0300
Message-ID: <1312882560.2407.139.camel@cumari> (sfid-20110809_113608_805384_B1B420BC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-08-08 at 10:37 +0200, Johannes Berg wrote: 
> On Tue, 2011-08-02 at 18:10 -0400, Pavel Roskin wrote:
> 
> > > Both of those commands result in libertas being called with
> > > cfg80211_scan_request with n_ssids=1 and the "test" SSID present in
> > > cfg80211_scan_request.ssids[0], as expected.
> > >
> > >
> > >    iwlist eth0 scan
> > >    iw dev eth0 scan
> > >
> > > Both of those commands result in libertas being called with
> > > cfg80211_scan_request with n_ssids=1 and a zero-length SSID present in
> > > cfg80211_scan_request.ssids[0].
> > > Is this a bug? I would expect it to be passed n_ssids=0 in this case.
> > 
> > I believe n_ssids is the number of probe requests to be sent per 
> > channel.  It scanning for all SSIDs, one probe request is sent.  It is 
> > only for passive scanning that we don't need any probes.
> 
> Yeah. "iw dev eth0 scan passive" will cause n_ssids to be 0.

I think the question was slightly different.  As I understand, Daniel
wants to know why the n_ssids is 1 even if no SSID is passed from user
space.

A zero-length SSID is a broadcast SSID.  So probe requests *will* be
sent, but with the broadcast SSID.  If you explicitly ask for a passive
scan (as Johannes mentioned), then n_ssids will be 0 which means that no
probe requests should be sent at all.

The n_ssids field is the number of *different* probe_reqs that will be
sent per channel.  Some drivers will send more than one probe_req with
the same SSID per channel (eg. wl12xx sends 2 probe_reqs per SSID on
each channel).


-- 
Cheers,
Luca.

