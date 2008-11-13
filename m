Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:14664 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbYKMXHG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2008 18:07:06 -0500
Received: by rn-out-0910.google.com with SMTP id k40so1041978rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 15:07:04 -0800 (PST)
Message-ID: <40f31dec0811131507x7449112cy5746d28c848a2146@mail.gmail.com> (sfid-20081114_000712_974978_C1FCF322)
Date: Fri, 14 Nov 2008 01:07:04 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "RUMI Szabolcs" <rumi_ml@rtfm.hu>
Subject: Re: ath5k master (AP) mode
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20081113235928.3ed79ff6.rumi_ml@rtfm.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	 <1226530010.15173.0.camel@dv>
	 <20081113004632.d8d821c5.rumi_ml@rtfm.hu>
	 <20081113181155.c556bde1.rumi_ml@rtfm.hu>
	 <1226598550.5839.3.camel@johannes.berg>
	 <20081113235928.3ed79ff6.rumi_ml@rtfm.hu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/11/14 RUMI Szabolcs <rumi_ml@rtfm.hu>:
> On Thu, 13 Nov 2008 18:49:10 +0100
> Johannes Berg <johannes@sipsolutions.net> wrote:
>
>> > I have compiled a kernel from wireless-testing git of today (2.6.28-rc4-wl)
>> > then recompiled and tested hostapd-0.6.5 against that,
>>
>> look, you need hostapd from git
>
> If you look a bit further down in that email, I've also tried
> exactly that afterwards but unfortunately it made no difference.
>
> BTW I've made a diff -rduN between hostapd-0.6.5 and todays -git
> but haven't spotted anything relevant to my problem anyway.
>
> To summarize:
>
> 2.6.27 + hostapd-0.6.5 = NO
> 2.6.27 + OpenWRT hack + hostapd-0.6.5 = NO
> compat-wireless-2008-11-12 + hostapd-0.6.5 = NO
> wireless-testing-git + hostapd-0.6.5 = NO
> wireless-testing-git + hostapd-git = NO
>
> In fact I've also tried hostapd-0.6.4 and 0.5.10 at some point
> but they didn't make anything better.
>
> Thanks,
>
> Sab

Have you enabled AP mode on the driver ?

diff --git a/drivers/net/wireless/ath5k/base.c
b/drivers/net/wireless/ath5k/base.c
index e09ed2c..69aad6e 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -488,6 +488,7 @@ ath5k_pci_probe(struct pci_dev *pdev,

      hw->wiphy->interface_modes =
              BIT(NL80211_IFTYPE_STATION) |
+               BIT(NL80211_IFTYPE_AP) |
              BIT(NL80211_IFTYPE_ADHOC) |
              BIT(NL80211_IFTYPE_MESH_POINT);

Code for AP mode is there but it's not enabled yet until we do further
tests (it didn't work on some 5413 hw etc, now after PCU updates it
should work but we still need to test it)


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
