Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:49714 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752365AbYAXD0h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2008 22:26:37 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Thu, 24 Jan 2008 12:26:27 +0900
Cc: mcgrof@gmail.com, jirislaby@gmail.com, mickflemm@gmail.com,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Ivo van Doorn <ivdoorn@gmail.com>
References: <20080118125252.6455.41047.stgit@one> <1201099729.3454.17.camel@johannes.berg>
In-Reply-To: <1201099729.3454.17.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200801241226.28394.bruno@thinktube.com> (sfid-20080124_032641_229485_207DDBB9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 January 2008 23:48:49 Johannes Berg wrote:
> > enable IBSS cell merging. if an IBSS beacon with the same ESSID and=
 a TSF
> > higher than the local TSF (mactime) is received, we have to join it=
s
> > BSSID.
>
> Can you back that up with standard references? I see no such requirem=
ent
> in the standard text. I can see that under some circumstances this ma=
y
> be desirable, but maybe not.

sure. the relevant sections of the standard are 11.1.2.3 "Beacon recept=
ion":

"STAs in an IBSS shall use other information in any received Beacon fra=
me for=20
which the IBSS subfield of the Capability field is set to 1 and the con=
tent=20
of the SSID element is equal to the SSID of the IBSS. Use of this infor=
mation=20
is specified in 11.1.4."

and in 11.1.4 "Adjusting STA timers":
(emphasis and brackets mine):

"In an IBSS, a STA shall always adopt the information in the contents o=
f a=20
Beacon or Probe Response frame when that frame contains a matching SSID=
 and=20
the value of the time stamp is later than the STA=E2=80=99s TSF timer. =
[In response=20
to an MLME-Join.request, a STA shall initialize its TSF timer to 0 and =
shall=20
not transmit a beacon or probe response until it hears a beacon or prob=
e=20
response from a member of the IBSS with a matching SSID.]"

"All Beacon and Probe Response frames carry a Timestamp field. A STA re=
ceiving=20
such a frame from another STA in an IBSS with the same SSID shall compa=
re the=20
Timestamp field with its own TSF time. If the Timestamp field of the re=
ceived=20
frame is later than its own TSF time, the STA shall adopt *all* paramet=
ers=20
contained in the Beacon frame."

i can see now how you could interpret this as only applying to timers, =
but i=20
think that does just not make sense - why would you want to sync timers=
 and=20
adapt beacon intervals if you don't share the same BSSID?

i agree that the standard is quite ambigious when it comes to IBSS, but=
=20
practically speaking, it is necessary to merge IBSS cells most of the t=
ime if=20
you want to have IBSS working as expected. therefore i tend to interpre=
t the=20
ambigious parts of the standard in a way that will improve functionalit=
y.

just think about two IBSS nodes which are configured with the same ESSI=
D and=20
which start up at nearly the same time. they would both scan, not find =
an=20
existing BSS and start their own. current mac80211 implementation would=
 after=20
a while detect that they are alone on their BSS and start another scan,=
 which=20
would finally cause one of them to reconfigure its BSSID, but this is n=
ot=20
sufficient: if you happen to have 2 nodes in each BSSID a merge would n=
ever=20
happen.
there are similar situations like this in real life, the most obvious e=
xample=20
beeing a city wide IBSS where you can easily have two separate groups o=
f=20
nodes starting up with a different BSSID. suddenly an obstacle is remov=
ed or=20
a new node comes up in the middle of these two groups (with connections=
 to=20
both) - which BSSID is it supposed to join? the one with the higher TSF=
, but=20
that would leave us with 2 distinct BSSIDs. would all involved nodes re=
start,=20
they would all share the same BSSID now. i think the only sensible answ=
er to=20
this problem is that they all should join the BSSID with the higher TSF=
=2E=20

this is also how all drivers and (also firmware based) cards i know han=
dle=20
IBSS - they will merge in a similar fashion based on the ESSID. (i know=
=2E..=20
that might not be a good argument, since most drivers are broken in one=
 way=20
or the other, especially when it comes to IBSS mode.)

> In fact, this seems to *break* standard behaviour, as per 11.1.3.1:
> (emphasis mine)
>
>         When a STA starts a BSS, that STA shall determine the BSSID o=
f
>         the BSS. If the BSSType indicates an infrastructure BSS, then
>         the STA shall start an infrastructure BSS and the BSSID shall=
 be
>         equal to the STA=E2=80=99s dot11StationID. ***The value of th=
e BSSID
>         shall remain unchanged***, even if the value of dot11StationI=
D
>         is changed after the completion of the MLME-START.request.

i understand this to apply to infrastructure STAs only.

>         If=20
>         the BSSType indicates an IBSS, the STA shall start an IBSS, a=
nd
>         the BSSID shall be an individual locally administered IEEE MA=
C
>         address as defined in 5.2 of IEEE Std 802-1990. The remaining=
 46
>         bits of that MAC address shall be a number selected in a mann=
er
>         that minimizes the probability of STAs generating the same
>         number, even when those STAs are subjected to the same initia=
l
>         conditions.
>
> Comments on the code now.
>
> > --- a/net/mac80211/ieee80211_sta.c
> > +++ b/net/mac80211/ieee80211_sta.c
> > @@ -80,6 +80,9 @@ static void ieee80211_rx_bss_put(struct net_devic=
e
> > *dev, struct ieee80211_sta_bss *bss); static int
> > ieee80211_sta_find_ibss(struct net_device *dev,
> >                                    struct ieee80211_if_sta *ifsta);
> > +static int ieee80211_sta_join_ibss(struct net_device *dev,
> > +                                  struct ieee80211_if_sta *ifsta,
> > +                                  struct ieee80211_sta_bss *bss);
>
> No way, order the code properly, this mess needs to be cleaned up not
> added to.

ok. i just didn't want to make my patch too unclear by moving stuff aro=
und in=20
addition to adding functionality. i'll make 2 separate patches, once we=
=20
agreed that this whole merge behaviour is wanted in mac80211 at all.

> > -	if (bss->probe_resp && beacon) {
> > +	if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
> > +	    bss->probe_resp && beacon) {
> >  		/* Do not allow beacon to override data from Probe Response. */
>
> Ahem. Comment update required.

ok.

> > +	if (sdata->vif.type =3D=3D IEEE80211_IF_TYPE_IBSS && beacon &&
> > +	    !local->sta_sw_scanning && !local->sta_hw_scanning &&
> > +	    mgmt->u.beacon.capab_info & WLAN_CAPABILITY_IBSS &&
> > +	    memcmp(elems.ssid, sdata->u.sta.ssid, sdata->u.sta.ssid_len) =
=3D=3D 0)
> > {
>
> I think that needs a check "&& ssid_len" or something. Someone's boun=
d
> to try making an IBSS with a hidden SSID and we really don't want tha=
t
> to work.

yep.

> > +#ifdef CONFIG_MAC80211_IBSS_DEBUG
> > +		static unsigned long last_tsf_debug;
> > +#endif
>
> Let's just get rid of that, it's not usable with multiple devices.

i'm happy to do that, i just wanted to preserve as much as possible of =
the=20
original code since i wasn't sure if anybody needed it.

> > +		if (rx_status->flag & RX_FLAG_TSFT)
> > +			mactime =3D rx_status->mactime;
> > +		else {
> > +			mactime =3D -1LLU;
> > +			printk(KERN_WARNING "%s: IBSS mode needs mactime for "
> > +				"beacons\n", dev->name);
>
> Very bad, you'll be flooded by this when others send beacons. Also, I
> doubt its truthfulness.

please see my last post where i suggest to use:

+               if (rx_status->flag & RX_FLAG_TSFT)
+                       /* in order for correct IBSS merging we need ma=
ctime*/
+                       mactime =3D rx_status->mactime;
+               else if (local && local->ops && local->ops->get_tsf)
+                       /* second best option: get current TSF */
+                       mactime =3D local->ops->get_tsf(local_to_hw(loc=
al));
+               else
+                       /* can't merge without knowing the TSF */
+                       mactime =3D -1LLU;

instead.

> > +			printk(KERN_DEBUG "%s: beacon TSF higher than local TSF"
> > +				" -> IBSS merge with BSSID %s\n",
> > +				dev->name, print_mac(mac, mgmt->bssid));
>
> No way. At the very least you need to ratelimit this.

ok, i'll add a ratelimit.

bruno
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
