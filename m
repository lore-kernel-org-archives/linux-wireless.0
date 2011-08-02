Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59602 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755405Ab1HBWKJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 18:10:09 -0400
Message-ID: <4E3875BE.9070504@gnu.org> (sfid-20110803_001012_532868_0AAF0D7E)
Date: Tue, 02 Aug 2011 18:10:06 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Making sense of cfg80211_scan_request.n_ssids
References: <CAGq3pz40rsMudofq6Njr0_h1G=EqEigGL-NkODj8Rb6h2bMGMQ@mail.gmail.com>
In-Reply-To: <CAGq3pz40rsMudofq6Njr0_h1G=EqEigGL-NkODj8Rb6h2bMGMQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/02/2011 01:35 PM, Daniel Drake wrote:
> Hi,
>
> I'm looking at libertas scanning code, and I'm wondering exactly what
> the cfg80211_scan_request.n_ssids field is supposed to mean.
>
> I would guess that it is supposed to indicate how many SSIDs should be
> explicitly scanned for. However, this doesn't seem to be the case.
>
>    iwlist eth0 scan essid test
>    iw dev eth0 scan ssid test
>
> Both of those commands result in libertas being called with
> cfg80211_scan_request with n_ssids=1 and the "test" SSID present in
> cfg80211_scan_request.ssids[0], as expected.
>
>
>    iwlist eth0 scan
>    iw dev eth0 scan
>
> Both of those commands result in libertas being called with
> cfg80211_scan_request with n_ssids=1 and a zero-length SSID present in
> cfg80211_scan_request.ssids[0].
> Is this a bug? I would expect it to be passed n_ssids=0 in this case.

I believe n_ssids is the number of probe requests to be sent per 
channel.  It scanning for all SSIDs, one probe request is sent.  It is 
only for passive scanning that we don't need any probes.

-- 
Regards,
Pavel Roskin
