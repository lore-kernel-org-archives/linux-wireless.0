Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.189]:9145 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYLBM7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 07:59:00 -0500
Received: by mu-out-0910.google.com with SMTP id g7so2543924muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 04:58:57 -0800 (PST)
Message-ID: <8e92b4100812020458l29d96527g71bf9f5fb9a5993@mail.gmail.com> (sfid-20081202_135911_063096_D77D54E7)
Date: Tue, 2 Dec 2008 18:28:57 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Vivek Natarajan" <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240812010900t4781aca2uc33bc26bc1ef161@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081202011754.GA9382@myhost.users.atheros.com>
	 <1228133121.3478.27.camel@johannes.berg> <873ah76fax.fsf@nokia.com>
	 <1ba2fa240812010900t4781aca2uc33bc26bc1ef161@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Dec 1, 2008 at 6:17 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>
>>> On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
>>>> This patch is based on Kalle's initial RFC patches on dynamic power save.
>>>> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
>>>> frame, it is appropriate to do it from mac80211.
>>>> This patch enables mac80211 to send a null frame and also to
>>>> check for tim in the beacon if power save is enabled.
>>>
>>> One thing I forgot, do we need a special iwlwifi flag to turn this off?
>>> Or can iwlwifi be programmed to let the host handle this (*), which
>>> might be beneficial for interoperability and uniformity purposes?
>>
>> Having the null frame handling in firmware is faster and we might get
>> some power savings from that. But is the saving observable, that's an
>> another question :)
>
> This patch is not much relevant in actual saving , since this is the
> waking up part, you are powering the whole nic up anyway.

 I agree but with PM bit on-off, this is what one can do to reduce some power
 consumption although not significant. If more significant savings is needed,
 we may need to implement PS-POLL or the APSD mechanism. But this
 is a good start to power save in mac80211.

> The firmware handling of power save is more relevant in going to sleep
> phase and sustaining where decision about sending the null frame is
> faster then from host. The NIC is powered down in stages up to state
> where only slow clock is ticking so this is rather time sensitive

AFAIK, only iwlwifi has this firmware support and we need mac80211's
support in this for ath9k/ath5k,stlc45xx and b43. I believe a powerful
2GHz host processor can manage these timings as a Windows driver
for these vendor cards seems to support power save without firmware support.

--
Vivek.
