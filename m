Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f11.google.com ([209.85.221.11]:37481 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYLARAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 12:00:43 -0500
Received: by qyk4 with SMTP id 4so2742877qyk.13
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 09:00:42 -0800 (PST)
Message-ID: <1ba2fa240812010900t4781aca2uc33bc26bc1ef161@mail.gmail.com> (sfid-20081201_180047_916153_E27FBC82)
Date: Mon, 1 Dec 2008 19:00:41 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Vivek Natarajan" <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <873ah76fax.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081202011754.GA9382@myhost.users.atheros.com>
	 <1228133121.3478.27.camel@johannes.berg> <873ah76fax.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 1, 2008 at 6:17 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>
>> On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
>>> This patch is based on Kalle's initial RFC patches on dynamic power save.
>>> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
>>> frame, it is appropriate to do it from mac80211.
>>> This patch enables mac80211 to send a null frame and also to
>>> check for tim in the beacon if power save is enabled.
>>
>> One thing I forgot, do we need a special iwlwifi flag to turn this off?
>> Or can iwlwifi be programmed to let the host handle this (*), which
>> might be beneficial for interoperability and uniformity purposes?
>
> Having the null frame handling in firmware is faster and we might get
> some power savings from that. But is the saving observable, that's an
> another question :)

This patch is not much relevant in actual saving , since this is the
waking up part, you are powering the whole nic up anyway.But sending 2
null packets instead of one doesn't really help power save either.

If you want numbers  you can measure power consumption on power lines
of the chip, simple loop and power probe with scope will do the the
trick.

The firmware handling of power save is more relevant in going to sleep
phase and sustaining where decision about sending the null frame is
faster then from host. The NIC is powered down in stages up to state
where only slow clock is ticking so this is rather time sensitive

Hope this helps

Tomas
