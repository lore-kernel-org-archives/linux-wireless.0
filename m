Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbYFPOgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 10:36:08 -0400
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with
	disable_hw_scan=1
From: Dan Williams <dcbw@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Tor =?ISO-8859-1?Q?H=E5kon?= Haugen
	<tor.hakon.haugen@gmail.com>, Zhu Yi <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <48560359.4090909@gmail.com>
References: <484FEA26.1040305@gmail.com> <48528B63.5030403@gmail.com>
	 <48528CF0.8050204@gmail.com>
	 <1ba2fa240806131304n442972eatfd2f35034476c380@mail.gmail.com>
	 <48551C62.80904@gmail.com>
	 <1ba2fa240806150647mdc97d98oad0b1b02de1fcf87@mail.gmail.com>
	 <48552344.5090801@gmail.com>
	 <1ba2fa240806150809h13c28937nd064230baca8a15d@mail.gmail.com>
	 <1ba2fa240806150947s1ed9391ao4b1d1a91c871ef8f@mail.gmail.com>
	 <4855FF14.9080506@gmail.com>
	 <1ba2fa240806152252v5fdb4f7dn1028a2a02e8d9cd1@mail.gmail.com>
	 <48560359.4090909@gmail.com>
Content-Type: text/plain; charset=utf8
Date: Mon, 16 Jun 2008 10:35:20 -0400
Message-Id: <1213626920.14862.13.camel@localhost.localdomain> (sfid-20080616_163621_523709_6D1924AD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-16 at 09:08 +0300, Maxim Levitsky wrote:
> Tomas Winkler wrote:
> > On Mon, Jun 16, 2008 at 8:50 AM, Maxim Levitsky <maximlevitsky@gmai=
l.com> wrote:
> >> Tomas Winkler wrote:
> >>> On Sun, Jun 15, 2008 at 6:09 PM, Tomas Winkler <tomasw@gmail.com>=
 wrote:
> >>>> On Sun, Jun 15, 2008 at 5:12 PM, Maxim Levitsky <maximlevitsky@g=
mail.com>
> >>>> wrote:
> >>>>> Tomas Winkler wrote:
> >>>>>> On Sun, Jun 15, 2008 at 4:42 PM, Maxim Levitsky
> >>>>>> <maximlevitsky@gmail.com>
> >>>>>> wrote:
> >>>>>>> Tomas Winkler wrote:
> >>>>>>>> On Fri, Jun 13, 2008 at 6:06 PM, Maxim Levitsky
> >>>>>>>> <maximlevitsky@gmail.com>
> >>>>>>>> wrote:
> >>>>>>>>> Tor H=C3=A5kon Haugen wrote:
> >>>>>>>>>> John W. Linville wrote:
> >>>>>>>>>>> On Fri, Jun 13, 2008 at 03:35:23PM +0800, Zhu Yi wrote:
> >>>>>>>>>>>> On Thu, 2008-06-12 at 09:59 -0400, John W. Linville wrot=
e:
> >>>>>>>>>>>>> Honestly I'm tempted to change it to "enable_hw_scan" i=
nstead...
> >>>>>>>>>>>> Give the advantages, I'd like to use it if we can fix th=
e bug (I
> >>>>>>>>>>>> haven't
> >>>>>>>>>>>> seen what the bug is myself). But you are free to change=
 the
> >>>>>>>>>>>> default
> >>>>>>>>>>>> value until it is fixed. There is no such problem for 49=
65,
> >>>>>>>>>>>> right?
> >>>>>>>>>>> AFAICT only the 3945 seems to need it.
> >>>>>>>>>>>
> >>>>>>>>>> I can confirm that this also applies to 4965 as a friend o=
f mine
> >>>>>>>>>> has
> >>>>>>>>>> this card. According to him the card works a lot better wi=
th the
> >>>>>>>>>> parameters "swcrypto=3D1" and "disable_hw_scan=3D1".
> >>>>>>>>> Just to make it clear,
> >>>>>>>>> iwl3945 doesn't work at all without disable_hw_scan=3D1 her=
e.
> >>>>>>>>> The driver just shuts down thee card since it detects micro=
code
> >>>>>>>>> error.
> >>>>>>>>>
> >>>>>>>> It looks like this is all caused by the big rate, band patch=
=2E Looks
> >>>>>>>> like A band scan channels are not configured correctly for t=
he
> >>>>>>>> scanning. This crashes the firmware.
> >>>>>>>>
> >>>>>>>> Tomas
> >>>>>>> Probably, I see that eeprom according to dmesg contains no in=
fo about
> >>>>>>> A
> >>>>>>> channels, so maybe this crashes the firmware.
> >>>>>>>
> >>>>>> Can you please send your dmesg.
> >>>>> I did that
> >>>>> (You mean dmesg without disable_hw_scan=3D1?)
> >>>>>
> >>>>> If not what debug options I should include
> >>>>> (I tried same firmware debug options, but the log wrapped aroun=
d.)
> >>>>>
> >>>>> dmesg without disable_hw_scan=3D1 attached.
> >>>>>
> >>>>>
> >>>>>>> I have few questions:
> >>>>>>>
> >>>>>>> * Is there a software workaround without the need to update t=
he
> >>>>>>> firmware?
> >>>>>> Yes
> >>>>>>
> >>>>>>> * Is the firmware error so harmful, so driver can't continue?
> >>>>>> This is firmware misconfiguration.  Driver should be friendly =
to
> >>>>>> firmware and use correctly API.
> >>>>>>
> >>>>>>> * Can I expect updated version of the firmware with  fix?
> >>>>>> No need so far.
> >>>>>>
> >>>>>>> Sadly this confirms that firmware is worse that I thought, it=
 is
> >>>>>>> closer
> >>>>>>> to
> >>>>>>> closed drivers.
> >>>>>> The firmware API is open, it just wasn't used correctly.
> >>>>> I mean if there is a bug in firmware, nobody expect intel can f=
ix it.
> >>>> Intel is fixing bugs in the firmware. Still this doesn't look li=
ke a
> >>>> firmware error.
> >>>>
> >>>>> BTW you say that firmware api is open,
> >>>>> is there a programming manual for this wireless chip?
> >>>> it's well documented in -commands.h file
> >>>
> >>>
> >>> Please try this one
> >>>
> >>> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> >>> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> >>> @@ -3348,7 +3348,10 @@ static void
> >>> iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
> >>>
> >>>        /* Remove this scanned band from the list
> >>>         * of pending bands to scan */
> >>> -       priv->scan_bands--;
> >>> +       if (priv->cfg->sku & IWL_SKU_A)
> >>> +               priv->scan_bands--;
> >>> +       else
> >>> +               priv->scan_bands =3D 0;
> >>>
> >>>
> >>
> >> I tested this patch, and it fixes this issue, Thanks a lot.
> >>
> > Thanks a lot for helping resolve this. I will post an official patc=
h.
> > Tomas
>=20
> Thanks to you too.
>=20
> I just want to note that hardware scanning doesn't work well here=20
> (something unrelated)
>=20
> First of all I noticed large delays in communications occurring=20
> sometimes, I for example tried pinging Google, and every 20 replies
> I get about 10 lost packets. (this is exactly what hardware scanning=20
> should prevent, but it seems that the opposite happens)
>=20
> I tried that again now, and see no delays, but I reproduced this twic=
e.
>=20
> Then power levels go crazy, the nm-applet shows that my access point=20
> have 23% quality, then 100%, then something low again, and looking li=
st=20
> of networks withing same applet, it shows for example now that all 3=20
> networks (mine, and two neighbors) have 100% quality, which is just w=
rong.

Note that NM will periodically request scans (~ every 2 minutes or so)
which can cause latency in pings.  But AFAIK it shouldn't really cause
_lost_ pings, since the driver and the AP need to work together to avoi=
d
dropping packets when the card isn't on the same channel as the AP is.
I'm pretty sure mac80211 handles this in software (by doing the
powersave poll trick to get the AP to buffer frames for the STA while
not on the associated channel).  Not sure how the hardware handles it,
but frames for the AP should _NOT_ be leaking out when the card isn't o=
n
the same channel as the AP.

dan


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
