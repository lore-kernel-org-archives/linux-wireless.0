Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59553 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734AbXIGGiH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 02:38:07 -0400
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189076408.28781.49.camel@johannes.berg>
References: <1188875058.13078.428.camel@debian.sh.intel.com>
	 <1189076408.28781.49.camel@johannes.berg>
Content-Type: text/plain; charset=GB2312
Date: Fri, 07 Sep 2007 14:31:42 +0800
Message-Id: <1189146702.16788.103.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-09-06 at 13:00 +0200, Johannes Berg wrote:
> I was just looking through the iwlwifi sources to find out whether it
> can encrypt with a key even if the packet isn't unicast... Anybody kn=
ow?
> I myself removed the ability to upload multicast/broadcast keys becau=
se
> it was so unclear, but it seems that maybe the firmware knows about s=
ome
> sort of "virtual broadcast/multicast" station? How about multiple
> broadcast keys for APs with VLANs?
>=20
> In any case, I found this comment:
>=20
>                 /* XXX: ACK flag must be set for CCMP even if it
>                  * is a multicast/broadcast packet, because CCMP
>                  * group communication encrypted by GTK is
>                  * actually done by the AP. */
>                 cmd->cmd.tx.tx_flags |=3D TX_CMD_FLG_ACK_MSK;
>=20
> and it doesn't make any sense at all. Care to explain? If we're a
> station associated to some other AP, then mac80211 will *obviously* s=
et
> the "expect ack" bit on a "multicast data" packet that's being sent
> since it's actually unicast in 802.11 terms to the AP before it resen=
ds
> it using the group key...=20

This is what exactly the above comment tells you. The comment speaks fo=
r
the non-AP STA mode (the AP code was not there at that time). The
tx_flags is used by the firmware, so whatever mac80211 set its flag, it
has to be translated to the firmware's language -- because you are usin=
g
hardware crypto.

> And if we're an AP, this is plain wrong
> (pending a positive answer to the question whether iwlwifi can offloa=
d
> broadcast/multicast encryption...) I suggest you remove the comment a=
nd
> the tx flags manipulation.

The comment is not for AP mode.

> The same comment is present in the #if 0'ed TKIP code and still talks
> about CCMP. Please!

iwlwifi hardware/firmware only supports partial TKIP (ie. it can do [en=
|
de]crypt, but cannot build michael_mic), so we comment out the TKIP
hwcrypto code temporarily at this time. I agree the comment should run =
a
's/CCMP/TKIP/g' though.

> And all the crypto code does:
>=20
>                 cmd->cmd.tx.hdr[0].frame_control |=3D
>                     cpu_to_le16(IEEE80211_FCTL_PROTECTED);
>=20
> This is a no-op. Remove it. And while I'm at it, let me say this once
> more: Do *NOT* work around the 802.11 implementation in mac80211 in t=
he
> driver. Fix bugs where there are any, and otherwise don't do work
> mac80211 has done before.

It might be removed, but let me do some test (especially for EAP
packets) first.

> And then I see things like
>                 cmd->cmd.tx.sec_ctl =3D 1 |       /* WEP */
>                     (ctl->key_idx & 0x3) << 6;
>=20
> Please use proper constants for the shifts and masks like everybody
> else. Can't be too hard can it?

OK.

> Generally, the driver needs *LOTS* more comments. While hacking on
> mac80211 it is sometimes important to know what the hardware can hand=
le,
> and I'm unable to answer my initial question using the iwlwifi code. =
We
> know a lot more about all the chipsets we've reverse engineered and a=
re
> able to judge their capabilities MUCH better than we'll ever be able =
to
> by looking at the iwlwifi code :(

It is obviously clear, both in the comment and the code: when you get a
GTK, you have already got a PTK anyway. In the non-AP STA mode, you
encypt your packets with PTK (whatever for unicast, broadcast), the AP
receives it and rencrypts them with GTK. Your GTK is used to decrypt fo=
r
multicast, broadcast packets.

> I can only guess this is intentional. While I applaud Intel's efforts=
 in
> wireless especially in the light of how some other vendors behave, th=
is
> is suboptimal and basically requires reverse engineering too to figur=
e
> out how things work.

Intentional for what? When you are not able to follow a piece of code,
you think the author intentional mislead you, instead of blaming your
own capability? Arrogant!

> Oh don't get me wrong. There are some comments explaining how things
> work, for example the one about DMA queues. Except that it's not even
> correct:
>=20
>  * The four transmit queues allow for performing quality of service (=
qos)
>  * transmissions as per the 802.11 protocol.  Currently Linux does no=
t
>  * provide a mechanism to the user for utilizing prioritized queues, =
so
>  * we only utilize the first data transmit queue (queue1).
>=20
> No? Why do we have an 802.11 qdisc then and all that stuff?

iwlwifi _does_ honor the ieee80211_tx_control->queue field, I'll delete
the old comment. BTW=A3=AC the whole 802.11 qdisc hack will be removed =
with
the multiqueue supported in .24. =20

> Further comments below while I'm at it.
>=20
>  * mac80211 should also be examined to determine if sta_info is dupli=
cating
>  * the functionality provided here
>=20
> absolutely. It also needs a good description of how the firmware mana=
ges
> stations. And is this for AP case or just for remote APs?
>=20
> In fact, come to think of it, the only thing it does to the hardware =
is
> iwl_send_add_station so what you really want is a notification from
> mac80211 when a sta_info is added/removed. And for that you build a h=
uge
> amount of station management code into the driver? That all needs to =
go
> and new features like HT must be folded into mac80211 instead.
>=20
>  * NOTE: This initializes the table for a single retry per data rate
>  * which is not optimal.  Setting up an intelligent retry per rate =20
>  * requires feedback from transmission, which isn't exposed through=20
>  * rc80211_simple which is what this driver is currently using.
>=20
> cute. No comment really, speaks for itself.
>=20
> iwl_is_fat_tx_allowed and similar stuff needs to be in mac80211.
>=20
> static struct ieee80211_ops iwl_hw_ops =3D {
>         .ht_tx_agg_start =3D iwl_mac_ht_tx_agg_start,
>         .ht_tx_agg_stop =3D iwl_mac_ht_tx_agg_stop,
>         .ht_rx_agg_start =3D iwl_mac_ht_rx_agg_start,
>         .ht_rx_agg_stop =3D iwl_mac_ht_rx_agg_stop,
>=20
> That doesn't seem to be in my mac80211? Did you actually start
> implementing HT features in mac80211? Why are they not available? Why
> clutter the driver with #idef CONFIG_..._HT_AGG when that cannot
> possibly be defined?

We have the HT AGG support in our mac80211. Will submit the patch for
review when we are ready.

>         /* Hard coded to start at the highest retry fallback position
>          * until the 4965 specific rate control algorithm is tied in =
*/
>         tx->initial_rate_index =3D LINK_QUAL_MAX_RETRY_NUM - 1;
>=20
>         /* Alternate between antenna A and B for successive frames */
>         if (priv->use_ant_b_for_management_frame) {
>                 priv->use_ant_b_for_management_frame =3D 0;
>                 rate_flags =3D RATE_MCS_ANT_B_MSK;
>         } else {
>                 priv->use_ant_b_for_management_frame =3D 1;
>                 rate_flags =3D RATE_MCS_ANT_A_MSK;
>         }
>=20
> Again, you were telling us that you absolutely need the rate control
> algorithm tied in with things etc., yet you're not doing it.

I have sent a proposal to reorganize the header files so that we can
export a rate scale interface to the drivers. It is not perfect but it
works. Then we don't like it here and there. If you have a better idea,
why don't you speak it out?

> iwl4965_sign_extend can be implemented a lot better like such:
>=20
> static inline s32 sign_extend(u32 value, u8 bits)
> {
> 	u8 shift =3D 32 - bits;
>=20
> 	return (s32)(value << shift) >> shift;
> }

Really? Are you sure this work?

> Note the renamed variables.
>=20
>         struct ieee80211_rx_status stats =3D {
>                 .mactime =3D le32_to_cpu(rx_start->beacon_time_stamp)=
,
>=20
> That beacon_time_start variable looks rather misnamed. Or it shouldn'=
t
> be used here.

OK. I assuem you mentioned the beacon_time_stamp, it should be
->timestamp.

> Enough for now again.=20

Please don't. We have given you enough time for commenting the code.
Please do it in a batch like other people did. Don't squeeze a little i=
n
-rc2 and another little in -rc4, ... You are wasting people's time.

> I suggest when you run into problems like the rate
> control algorithm not working well or HT mode missing, you start by
> describing the hardware functionality and the resulting software prob=
lem
> to linux-wireless so we can give advice on how to best implement thin=
gs,
> instead of stuffing tons of code into the driver and then pushing it =
out

James had done this several months ago. We did everything the mac80211
people suggested, but the patch is still not merged. Do you think we'd
really like to workaound the mac80211 issues in the driver, or even hav=
e
our own mac80211 package? Absolutely not, if you mac80211 guys are easy
to work with. Without creating our own mac80211 package, today, the
users are still no better rate scale algorithm selection, no advanced
wireless QoS, no 11N support, not even mention about link aggregation.

> as "hey this works can it be merged?"

Something working is always better than something not working whatever
how beautiful the code looks like. And I believe the current iwlwifi
driver has reached the quality to be merged mainline (both it looks and
it works).

Thanks,
-yi
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
