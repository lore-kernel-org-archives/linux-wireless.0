Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:2271 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbYKBWmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 17:42:49 -0500
Received: by wf-out-1314.google.com with SMTP id 27so2214577wfd.4
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 14:42:48 -0800 (PST)
Message-ID: <1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com> (sfid-20081102_234254_252416_21A41A2A)
Date: Mon, 3 Nov 2008 00:42:48 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: No ProbeResp - assume out of range
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200811022303.54476.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	 <200811022303.54476.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 3, 2008 at 12:03 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Sunday 02 November 2008 22:05:56 Luis R. Rodriguez wrote:
>> I'm curious if others are getting this frequently as I am:
>>
>> No ProbeResp from current AP 00:DE:AD:BE:EE:FF - assume out of range
>>
>> I get this with ath5k and ath9k, can be triggered easily in ath5k by
>> doing a lot of consecutive:
>>
>> iwlist wlan0 scan
>>
>> I have to check if I can trigger this with ath9k by scanning too. We
>> were seeing this with ath9k but were thinking it was ath9k related as
>> it can be triggered on it after doing a large TX. Wondering if this is
>> more of a generic and mac80211 issue.
>
> IMO this is a mac80211 issue.
> mac80211 immediately assumes the connection is broken, if one probe-resp
> to a keekalife-proberequest is lost.
> So if you scan just after the request got sent, you'll never receive the response
> and mac80211 will terminate the connection.
> It should try a few times, instead, before blowing up things.

I've seen this happening  in high traffic with some APs but it can be
also NIC issue. It needs to really investigate the sniffer capture I
wouldn't assume its only mac80211 issue.  Probe is issued only when RX
is not received for some time so there is some problem, nevertheless
monitoring beacons is a better approach from my experience.

Tomas
