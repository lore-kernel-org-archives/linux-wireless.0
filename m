Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758567Ab0BXXfH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 18:35:07 -0500
Subject: Re: [PATCH] libertas: cfg80211 support
From: Dan Williams <dcbw@redhat.com>
To: David MOUSSAUD <d.moussaud@gmail.com>
Cc: Holger Schurig <holgerschurig@gmail.com>,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@googlemail.com>
In-Reply-To: <cdd918981002240005o1fa50956yfb2a692716c06a55@mail.gmail.com>
References: <20100202000934.GA19847@sortiz.org>
	 <201002151146.48156.holgerschurig@gmail.com>
	 <cdd918981002240005o1fa50956yfb2a692716c06a55@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 15:35:02 -0800
Message-ID: <1267054502.6162.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-02-24 at 09:05 +0100, David MOUSSAUD wrote:
> Hello,
> 
> I'm trying to apply the first patch of this thread to have the
> cfg80211 support to my driver but I do not succeed to select the goot
> git repository or the goot release tarball (linux kernel/compat
> wireless) to start.
> 
> Does someone could help me for that ?
> 
> Furthermore, I have an at91sam9260 atmel evk board with a wi2wi (which
> embeded a 8686 libertas chip) sdio evk. I need to have my board
> running as an Access Point.
> Could someone tell me if, applying this patch, it will works ?
> 
> For my understanding, I think it will because it is written that the
> driver with cfg80111 can now work in monitor mode, which is ok for
> hostapd to act as an AP.

This isn't going to work.  The fullmac Libertas devices (8385, 8388,
8686, etc) do not have the firmware capability to operate in AP mode.
cfg80211 is simply a better configuration interface than WEXT, it does
not magically add AP mode capability.

Dan

> Thanks for your help,
> 
> Best Regards,
> 
> D.MOUSSAUD.
> 
> On Mon, Feb 15, 2010 at 11:46 AM, Holger Schurig
> <holgerschurig@gmail.com> wrote:
>         > +       bss = cfg80211_get_bss(wiphy, sme->channel,
>         sme->bssid,
>         > +                              sme->ssid, sme->ssid_len,
>         > +                              WLAN_CAPABILITY_ESS,
>         WLAN_CAPABILITY_ESS);
>         > +
>         > +       if (!bss) {
>         > +               if (sme->bssid || sme->ssid_len !=
>         IEEE80211_MAX_SSID_LEN) {
>         > +                       DECLARE_SSID_BUF(ssid);
>         > +                       lbs_pr_err("associate: BSS %s not in
>         scan results\n",
>         > +                                  print_ssid(ssid,
>         sme->ssid, sme->ssid_len));
>         > +                       ret = -ENOENT;
>         > +               }
>         > +
>         > +               goto done;
>         > +       }
>         
>         
>         I have again some time for Libertas :-)
>         
>         I'm still not getting this code at all, especially the code
>         inside
>         "if (!bss)". You set "ret = -ENOENT", but only under some
>         circumstances. When they aren't met, we go to label done,
>         but with "ret=0", e.g. we didn't connect, but still we won't
>         return an error.
>         
>         Also, you print the SSID, but name it "BSS". A BSS is
>         kind-of-a-mac-address. So the text in the printk should
>         be "associate: no SSID %s in scan results". Or you print
>         the BSS from sme->
>         
>         And then I don't get why there is a comparison
>         sme->ssid_len != IEEE80211_MAX_SSID_LEN. print_ssid()
>         handles this.
>         
>         
>         
>         Wouldn't this snipped do the work:
>         
>                lbs_deb_enter(LBS_DEB_CFG80211);
>                bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
>                        sme->ssid, sme->ssid_len,
>                        WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
>         
>                if (!bss) {
>         
>                        lbs_pr_err("no matching AP found in last scan
>         \n");
>                        ret = -ENOENT;
>                        goto done;
>                }
>                lbs_deb_assoc("trying %pM", sme->bssid);
>         
>         
>         --
>         http://www.holgerschurig.de
>         --
>         To unsubscribe from this list: send the line "unsubscribe
>         linux-wireless" in
>         the body of a message to majordomo@vger.kernel.org
>         More majordomo info at
>          http://vger.kernel.org/majordomo-info.html
>         
> 


