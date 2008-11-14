Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nexus.dynaweb.hu ([195.70.37.87]:60323 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbYKNKQD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 05:16:03 -0500
Date: Fri, 14 Nov 2008 11:15:59 +0100
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20081114111559.56530874.rumi_ml@rtfm.hu> (sfid-20081114_111614_780887_4CB0CC41)
In-Reply-To: <40f31dec0811131507x7449112cy5746d28c848a2146@mail.gmail.com>
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	<1226530010.15173.0.camel@dv>
	<20081113004632.d8d821c5.rumi_ml@rtfm.hu>
	<20081113181155.c556bde1.rumi_ml@rtfm.hu>
	<1226598550.5839.3.camel@johannes.berg>
	<20081113235928.3ed79ff6.rumi_ml@rtfm.hu>
	<40f31dec0811131507x7449112cy5746d28c848a2146@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Fri__14_Nov_2008_11_15_59_+0100_r=onjtiixQVVcqQ="
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Fri__14_Nov_2008_11_15_59_+0100_r=onjtiixQVVcqQ=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 14 Nov 2008 01:07:04 +0200
"Nick Kossifidis" <mickflemm@gmail.com> wrote:

> Have you enabled AP mode on the driver ?
> 
> diff --git a/drivers/net/wireless/ath5k/base.c
> b/drivers/net/wireless/ath5k/base.c
> index e09ed2c..69aad6e 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -488,6 +488,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
> 
>       hw->wiphy->interface_modes =
>               BIT(NL80211_IFTYPE_STATION) |
> +               BIT(NL80211_IFTYPE_AP) |
>               BIT(NL80211_IFTYPE_ADHOC) |
>               BIT(NL80211_IFTYPE_MESH_POINT);
> 
> Code for AP mode is there but it's not enabled yet until we do further
> tests (it didn't work on some 5413 hw etc, now after PCU updates it
> should work but we still need to test it)

YES, that did the trick! :)
With partial success. To summarize:

- Open System worked (only basic IPv4 tested, eg. ICMP ping)
- MAC filtering from hostapd didn't work
- WEP didn't work
- WPA and WPA2 weren't tested

I have attached a hostapd log (concatenated, commented, and gzipped)
of my testing runs.

In the end I need this to work properly as an AP with WPA2
so I'm willing to test further if somebody is willing to try to
fix the whole thing...

Thanks,

Sab

--Multipart=_Fri__14_Nov_2008_11_15_59_+0100_r=onjtiixQVVcqQ=
Content-Type: application/x-gzip;
 name="ath5k_hostapd_081114.txt.gz"
Content-Disposition: attachment;
 filename="ath5k_hostapd_081114.txt.gz"
Content-Transfer-Encoding: base64

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
CGN7Wp4kvyvK/wHX6YaRsRwBAA==

--Multipart=_Fri__14_Nov_2008_11_15_59_+0100_r=onjtiixQVVcqQ=--
