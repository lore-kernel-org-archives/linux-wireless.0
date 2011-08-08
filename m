Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1HHIhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 04:37:24 -0400
Subject: Re: Making sense of cfg80211_scan_request.n_ssids
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Daniel Drake <dsd@laptop.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4E3875BE.9070504@gnu.org> (sfid-20110803_001012_532868_0AAF0D7E)
References: <CAGq3pz40rsMudofq6Njr0_h1G=EqEigGL-NkODj8Rb6h2bMGMQ@mail.gmail.com>
	 <4E3875BE.9070504@gnu.org> (sfid-20110803_001012_532868_0AAF0D7E)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Aug 2011 10:37:19 +0200
Message-ID: <1312792639.4372.7.camel@jlt3.sipsolutions.net> (sfid-20110808_103727_853756_44BFE4CB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-02 at 18:10 -0400, Pavel Roskin wrote:

> > Both of those commands result in libertas being called with
> > cfg80211_scan_request with n_ssids=1 and the "test" SSID present in
> > cfg80211_scan_request.ssids[0], as expected.
> >
> >
> >    iwlist eth0 scan
> >    iw dev eth0 scan
> >
> > Both of those commands result in libertas being called with
> > cfg80211_scan_request with n_ssids=1 and a zero-length SSID present in
> > cfg80211_scan_request.ssids[0].
> > Is this a bug? I would expect it to be passed n_ssids=0 in this case.
> 
> I believe n_ssids is the number of probe requests to be sent per 
> channel.  It scanning for all SSIDs, one probe request is sent.  It is 
> only for passive scanning that we don't need any probes.

Yeah. "iw dev eth0 scan passive" will cause n_ssids to be 0.

johannes

