Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.235]:44952 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308AbYKUMEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2008 07:04:49 -0500
Received: by qb-out-0506.google.com with SMTP id f11so1011022qba.17
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2008 04:04:48 -0800 (PST)
Message-ID: <8e92b4100811210346r125519d0gb5a71108719e1768@mail.gmail.com> (sfid-20081121_130455_699776_BA76C01F)
Date: Fri, 21 Nov 2008 17:16:19 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Look out for some other AP when disassoc is received.
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	linville@tuxdriver.com
In-Reply-To: <1227186290.14852.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081120000322.GA2828@myhost.users.atheros.com>
	 <1227095716.26243.20.camel@johannes.berg>
	 <8e92b4100811190433l24ab5043nd4e14ff7c7124e20@mail.gmail.com>
	 <1227186290.14852.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Johannes Berg <johannes@sipsolutions.net> wrote:

>> * After receiving a disassoc, mac80211 moves to ASSOCIATE state in which scanning
>>    is disabled. So, for the first scan request from wpa_supplicant(scan duration of 30sec),
>>    it tries to send probe   request to the same AP instead of scanning for other APs.
>>    Then it moves to DISABLED  state since there will be no probe response.
>> * The next scan request comes only after 30sec and now it will scan for all available APs
>>    since scanning  is supported in DISABLED state.
>>     So, it takes atleast 30sec to connect to some other AP.

> we block scans for a short time while trying to probe/associate and
> wpa supplicant request one exactly then.
> However, I still think going to disabled is wrong. We should be in a
> different state

If the AP has explicitly told us that it is leaving the bss, what is the
point in retrying in associate state? DISABLED state would be ideal
for fresh scanning & assocation. What do you think?

> Ok, I understand the scenario, I think. But I don't understand why going
> to DISABLED fixes this. In DISABLED the mlme does nothing at all, I
> think, so how can that fix it?
> I think you've also not accounted for the possibility that the AP simply
> lost power for some reason and didn't send a deauth frame at all.

If AP loses power, probe request times out and we directly move to
disabled state. Hence we don't spend time in ASSOCIATE/DIRECT-PROBE
state. The same behaviour is expected when we receive a disassoc
frame with reason code as "AP leaving BSS". There should not be any
intermediate state like ASSOCIATE.

Thanks for your time,
 Vivek.
