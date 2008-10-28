Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:24458 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYJ1Xs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 19:48:59 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2892833wfd.4
        for <linux-wireless@vger.kernel.org>; Tue, 28 Oct 2008 16:48:58 -0700 (PDT)
Message-ID: <1ba2fa240810281648wff91b13ree84f41dd9d6ba2@mail.gmail.com> (sfid-20081029_004903_598081_88B9467C)
Date: Wed, 29 Oct 2008 01:48:58 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: remove implicit direct scan
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225234763.1369.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1225214465.3598.27.camel@johannes.berg>
	 <1ba2fa240810281353u4b038cf2gb46cb830b278a278@mail.gmail.com>
	 <1ba2fa240810281454v434182f0t5f42ee6cef6c408d@mail.gmail.com>
	 <1225234763.1369.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 12:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2008-10-28 at 23:54 +0200, Tomas Winkler wrote:
>
>> >> Am I missing something? This seems very strange! What specifies that
>> >> when an SSID is set on an interface the user wants to scan for that one?
>> >> The interface might just have been associated previously to that SSID,
>> >> now disassociated and network manager is asking for a scan to get
>> >> information about networks to let the user select a new one.
>> >
>> > NACK, this is a heuristic that helps connection to configured SSID. It
>> > doesn't mean that other ssid won't be scanned.
>> > This code might be revised again when multiple SSID scan will be implemented
>> > Tomas
>> >
>> Okay I've only now have  seen the real reason for this. The SSID
>> removal from the driver API. It's much better argument for removing
>> this code anyway have to think how this will be substituted.
>
> :)
> Unless somebody can come up with a good argument for requiring the SSID?
> I don't see it being necessary the way beaconing and everything is
> designed in mac80211 now, and this leaves only the BSSID in the
> interface config which I'll move to BSS config and then remove the
> interface config thing completely.
>
> Also, doesn't ieee80211_sta_config_auth already do exactly this
> heuristic thing? If it doesn't know about the BSS it'll initiate a scan
> for the SSID it's looking for?

Yep, you are right.
Tomas
>
> johannes
>
