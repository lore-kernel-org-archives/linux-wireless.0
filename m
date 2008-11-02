Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f12.google.com ([209.85.217.12]:57211 "EHLO
	mail-gx0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbYKBW3g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 17:29:36 -0500
Received: by gxk5 with SMTP id 5so687084gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 02 Nov 2008 14:29:35 -0800 (PST)
Message-ID: <43e72e890811021429u27f46dcbjd79d3a639fcc4c22@mail.gmail.com> (sfid-20081102_232940_949511_924B3075)
Date: Sun, 2 Nov 2008 14:29:35 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: No ProbeResp - assume out of range
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <200811022303.54476.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	 <200811022303.54476.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 2, 2008 at 2:03 PM, Michael Buesch <mb@bu3sch.de> wrote:
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

Agreed, and I can trigger this without scanning BTW, do we simply bail
out immediately if *one* probe response was not received?

  Luis
