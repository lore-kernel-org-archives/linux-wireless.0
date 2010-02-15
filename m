Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:38903 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab0BOKuK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Feb 2010 05:50:10 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: cfg80211 support
Date: Mon, 15 Feb 2010 11:46:48 +0100
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>,
	Holger Schurig <holgerschurig@googlemail.com>
References: <20100202000934.GA19847@sortiz.org>
In-Reply-To: <20100202000934.GA19847@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <201002151146.48156.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +       bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
> +                              sme->ssid, sme->ssid_len,
> +                              WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
> +
> +       if (!bss) {
> +               if (sme->bssid || sme->ssid_len != IEEE80211_MAX_SSID_LEN) {
> +                       DECLARE_SSID_BUF(ssid);
> +                       lbs_pr_err("associate: BSS %s not in scan results\n",
> +                                  print_ssid(ssid, sme->ssid, sme->ssid_len));
> +                       ret = -ENOENT;
> +               }
> +
> +               goto done;
> +       }

I have again some time for Libertas :-)

I'm still not getting this code at all, especially the code inside
"if (!bss)". You set "ret = -ENOENT", but only under some
circumstances. When they aren't met, we go to label done,
but with "ret=0", e.g. we didn't connect, but still we won't
return an error.

Also, you print the SSID, but name it "BSS". A BSS is
kind-of-a-mac-address. So the text in the printk should
be "associate: no SSID %s in scan results". Or you print
the BSS from sme->

And then I don't get why there is a comparison
sme->ssid_len != IEEE80211_MAX_SSID_LEN. print_ssid()
handles this.



Wouldn't this snipped do the work:

	lbs_deb_enter(LBS_DEB_CFG80211);
        bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
                sme->ssid, sme->ssid_len,
                WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);

        if (!bss) {
                lbs_pr_err("no matching AP found in last scan\n");
                ret = -ENOENT;
                goto done;
        }
        lbs_deb_assoc("trying %pM", sme->bssid);

-- 
http://www.holgerschurig.de
