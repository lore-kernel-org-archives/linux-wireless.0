Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f172.google.com ([209.85.214.172]:58372 "EHLO
	mail-iw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0LGU5H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 15:57:07 -0500
Received: by iwn40 with SMTP id 40so370625iwn.3
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 12:57:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291755274.3607.59.camel@jlt3.sipsolutions.net>
References: <1291690135-4535-1-git-send-email-lrodriguez@atheros.com>
 <1291690135-4535-6-git-send-email-lrodriguez@atheros.com> <1291714709.3607.2.camel@jlt3.sipsolutions.net>
 <AANLkTikrLweKeSR-=XziaJ5rqDRf_Ny=mg1OD=jC4nqA@mail.gmail.com>
 <1291736887.3607.47.camel@jlt3.sipsolutions.net> <AANLkTimiw074uXxe3nPTNZ0j+NtZbHJU1bwiGsFUXMJ4@mail.gmail.com>
 <1291737298.3607.48.camel@jlt3.sipsolutions.net> <20101207155916.GA1855@tux>
 <1291743121.3607.50.camel@jlt3.sipsolutions.net> <AANLkTi=Sj7YpKzFHQtf2MdUcRDTzfXszbK7gGg_yup1Y@mail.gmail.com>
 <1291745567.3607.52.camel@jlt3.sipsolutions.net> <AANLkTimfLGj1=BnRGvJVkP_Ge6KYAtCLcDpBsVoj9o_T@mail.gmail.com>
 <1291755274.3607.59.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 7 Dec 2010 12:56:45 -0800
Message-ID: <AANLkTik-H0WXWjGjMuc_pE1vvbxFSoD2BoXVG3Wqcorw@mail.gmail.com>
Subject: Re: [PATCH 5/5] mac80211: fix issuing idle calls when device open
 count is 0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amod Bodas <Amod.Bodas@atheros.com>,
	"pstew@google.com" <pstew@google.com>,
	"stable@kernel.org" <stable@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 7, 2010 at 12:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2010-12-07 at 12:49 -0800, Luis R. Rodriguez wrote:
>
>> > In what situation? When you just suspend while things are up&running, or
>> > if you suspend with interfaces down?
>>
>> I believe Paul was suspending when the interface is up and running.
>
> Ok.
>
>> > It doesn't make sense anyway, so
>> > something's going on in the rest of the scan code -- we should be
>> > canceling scans properly when going down and when suspending, well
>> > before any of this becomes relevant.
>>
>> The issue might be we race to stop the device prior to canceling a
>> scan. Do you see that being possible?
>
> Not really, since we do scan_cancel() within suspend()... I guess I'd
> like to find out why that doesn't do what I think it does.

Well lets see, this is only reproducible with the new DBUS APIs, and
frankly I am not sure what these things do. Is it possible we have a
race between how it brings down an interface for suspend and canceling
a scan?

  Luis
