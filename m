Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.191]:57506 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYDDLq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Apr 2008 07:46:29 -0400
Received: by rn-out-0910.google.com with SMTP id e24so21291rng.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Apr 2008 04:46:28 -0700 (PDT)
Message-ID: <1ba2fa240804040446r2ad9f7ffrb4ba67f77f1af3a3@mail.gmail.com> (sfid-20080404_124636_768711_AF8FEFFE)
Date: Fri, 4 Apr 2008 14:46:25 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andres Bertens" <abertensu@yahoo.com>
Subject: Re: FW: [ipw3945-devel] iwl3945: disassociation from AP (reason=4) andtimeout, a solution
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Dan Williams" <dcbw@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <47F55436.1070405@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <D936D925018D154694D8A362EEB08920040FA26C@orsmsx416.amr.corp.intel.com>
	 <1206999696.20744.2.camel@localhost.localdomain>
	 <1207051434.5143.58.camel@johannes.berg> <47F23C6B.6060205@yahoo.com>
	 <1207068153.5143.137.camel@johannes.berg> <47F55436.1070405@yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 4, 2008 at 1:03 AM, Andres Bertens <abertensu@yahoo.com> wrote:
>
>
>
>  Johannes Berg wrote:
>
> >
> > > Reason=4 is in fact "Inactivity timer expired and station was
> disassociated". According to my router log:
> > > "Tuesday April 01, 2008 09:08:54 Disassociated: 00-19-D2-4F-22-4D
> because idle 300 seconds"
> > >
> > > Indeed, the default behaviour goes for a reassocation
> > >
> >
> > Right, I just checked, we try to reassociate after one second.
> >
> >
> > > but my hw/sw combination (intel3945/dlink/wep) fails with a status=17
> (AP unable to handle new status).
> > >
> >
> > 17 actually is WLAN_REASON_IE_DIFFERENT, i.e. the WPA/RSN IE we send is
> > no longer appropriate, something for wpa_supplicant to handle then. Are
> > you using encryption?
> >
> >
> > > After 3 tries, it dies with an AP association timeout. From there is no
> recovery till I set the interface down and up.
> > >
> > > That's why I solved it (perhaps not in the best way) ignoring the
> disassociation. Now it works.
> > >
> >
> > Your AP is broken. After it disassociates you and you ignore this
> > status, it complains that it deauthenticated (!) you and then
> > deauthenticates you again (with reason=6 meaning that you weren't
> > authenticated.)
> > The thing is, it's disassociating you and thinks it actually
> > deauthenticated you since when you ignore the disassociation and
> > continue sending it frames it starts complaining that you weren't
> > authenticated (reason=6.)
> >
> > Your fix is obviously wrong, and only fixes the problem for you because
> > it works around your broken AP that needs a re-authentication after it
> > disassociated you.
> >
> > I'm not sure what we can do about that. Assuming we're deauthenticated
> > seems completely wrong, and I fear that if we assume deauthentication if
> > the association times out then we may easily end up in a loop there.
> >
> > johannes
> >
>
>  Hi,
>
>  Taking your advice in order to avoid ignoring disassociation, I looked for
> another way to achieve the same result.
>
>  As you recall, my AP sends a disassociation message due to inactivity
>  after 300 seconds. A plain re-association ends with a AP timeout due to
>  the re-association fails with a code=17 after three tries.
>
>
>  wlan0: RX disassociation from 00:17:9a:63:d2:21 (reason=4)
>  wlan0: disassociated
>  wlan0: associate with AP 00:17:9a:63:d2:21
>  wlan0: RX ReassocResp from 00:17:9a:63:d2:21 (capab=0x431 status=17 aid=1)
>  wlan0: AP denied association (code=17)
>  wlan0: associate with AP 00:17:9a:63:d2:21
>  wlan0: RX AssocResp from 00:17:9a:63:d2:21 (capab=0x431 status=17 aid=1073)
>  wlan0: AP denied association (code=17)
>  wlan0: associate with AP 00:17:9a:63:d2:21
>  wlan0: RX AssocResp from 00:17:9a:63:d2:21 (capab=0x431 status=17 aid=1073)
>  wlan0: AP denied association (code=17)
>  wlan0: association with AP 00:17:9a:63:d2:21 timed out
>
>  When I ignore the disassociation, from the trace I read that process
>  goes through an authentication/association pair and the link is restored
> ok.
>
>  In order to do not ignore disassociation and following the previous
>  sequence, after the disassociation is handled I changed the state to
>  un-authenticated instead of un-associated in order to force an
>  authentication first (I assume I'am already deauthenticated by
>  disassociation). It works and the trace is as follows:
>
>
>  wlan0: RX disassociation from 00:17:9a:63:d2:21 (reason=4)
>  wlan0: disassociated
>  wlan0: authenticate with AP 00:17:9a:63:d2:21
>  wlan0: RX authentication from 00:17:9a:63:d2:21 (alg=0 transaction=2
>  status=0)
>  wlan0: authenticated
>  wlan0: associate with AP 00:17:9a:63:d2:21
>  wlan0: RX ReassocResp from 00:17:9a:63:d2:21 (capab=0x431 status=0 aid=1)
>  wlan0: associated
>
>  Patch attached.
>
>  Is this a better solution than to ignore disassociation?
>
>  Regards,
>  Andres
>
>
> diff -Naur compat-wireless-2008-03-28/net/mac80211/ieee80211_sta.c
> compat-wireless-2008-03-28-new/net/mac80211/ieee80211_sta.c
>  --- compat-wireless-2008-03-28/net/mac80211/ieee80211_sta.c     2008-03-28
> 02:14:15.000000000 -0300
>  +++ compat-wireless-2008-03-28-new/net/mac80211/ieee80211_sta.c 2008-04-03
> 16:47:33.000000000 -0400
>  @@ -1823,6 +1823,16 @@
>         }
>
>         ieee80211_set_disassoc(dev, ifsta, 0);
>  +
>  +       /* Set state to un-authenticated when receive
>  +          a disassociation request from the AP by inactivity */
>  +       if( reason_code == 4 ) {
>  +               ifsta->auth_tries = 0;
>  +               ifsta->flags &= ~IEEE80211_STA_AUTHENTICATED;
>  +               ifsta->state = IEEE80211_AUTHENTICATE;
>  +               mod_timer(&ifsta->timer, jiffies +
>  +                       IEEE80211_RETRY_AUTH_INTERVAL);
>  +       }
>   }

This would be wrong to do there  can be other issues this is happening.
Can you get a sniffer capture of this problem.
1. Is there any traffic activity happaning during.
2. What is the listen interval announced by AP (should be present in
association response)
4. What is the frequency mac8011 sends its probe request?

In general it is OK if AP dissociates inactive station the problem why
is  happening with this driver.
Usually this is triggered if there are many station connected to the
AP or station doesn't ACK traffic.

The sniff capture will be really important here?

Tomas
>
>
>
>
>
>
>
