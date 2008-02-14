Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:29322 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750729AbYBNGUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 01:20:11 -0500
From: bruno randolf <bruno@thinktube.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Thu, 14 Feb 2008 15:19:38 +0900
Cc: ath5k-devel@lists.ath5k.org, mcgrof@gmail.com, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, flamingice@sourmilk.net, jbenc@suse.cz
References: <1202209693.4395.29.camel@johannes.berg> <200802121225.02045.bruno@thinktube.com> <1202809819.11481.87.camel@johannes.berg>
In-Reply-To: <1202809819.11481.87.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200802141519.38971.bruno@thinktube.com> (sfid-20080214_062015_955042_E32B0596)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 February 2008 18:50:19 Johannes Berg wrote:
> > thats a very good point! if everything was calibrated properly and =
all
> > delays taken into account *exactly* that would cause us to go thru =
a
> > merge all the time, on every received beacon. i think we have to ta=
ke
> > that into account, for different bitrates. what about something lik=
e:
> >
> > timestamp >=3D ( mactime + (24 * 8 / beacon_phy_rate_in_mbps ))
>
> Looks reasonable, though I'm not entirely sure how we defined 'mactim=
e'
> and whether it is at the first data or the first phy symbol. I think
> it's at the first data symbol which makes this correct.

hmm, it seems we don't have a strict definition of mactime... the kerne=
ldoc of=20
struct ieee80211_rx_status says:
 * @mactime: MAC timestamp as defined by 802.11

but as far as i understand 802.11, it only defines "timestamp" for beac=
on and=20
probe response frames, where it actually means the timestamp field of t=
he=20
frame.

"Local Time" is defined as: "The value of the STA=E2=80=99s TSF timer a=
t the start of=20
reception of the first octet of the timestamp field of the received fra=
me=20
(probe response or beacon) from the found BSS." [802.11 p. 103]

also in "Process Validate_MPDU: it says:
"Save arrival time of first octet of {what may be a} timestamp field."
[802.11 p 391 and 460]

which could imply that this value is given as a rx timestamp (mactime).=
 in=20
that case we could directly compare timestamp and mactime.

radiotap on the other hand defines it as the first bit of the data (MPD=
U):
 * IEEE80211_RADIOTAP_TSFT              u_int64_t       microseconds
 *
 *      Value in microseconds of the MAC's 64-bit 802.11 Time
 *      Synchronization Function timer when the first bit of the
 *      MPDU arrived at the MAC. For received frames, only.

so i guess right now it depends on the hardware what we actually get as=
=20
mactime...

i could not find any definition when the rx timestamp of atheros hardwa=
re is=20
taken.

do we have that information for other hardware? is mactime
 *) the TSF at the reception of the first phy symbol?
 *) the TSF at the reception of the first data (MPDU) symbol
 *) the TSF at the reception of the byte 24 (where the timestamp field =
of
    beacon and probe response frames is)?

bruno
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
