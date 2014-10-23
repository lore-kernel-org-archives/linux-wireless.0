Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38039 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495AbaJWQCG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 12:02:06 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
	by gateway2.nyi.internal (Postfix) with ESMTP id C65D02088A
	for <linux-wireless@vger.kernel.org>; Thu, 23 Oct 2014 12:02:05 -0400 (EDT)
Message-Id: <1414080125.164673.182502929.61AF3AB1@webmail.messagingengine.com> (sfid-20141023_180211_454745_18D26E47)
From: =?UTF-8?Q?Lauren=C8=9Biu=20Nicola?= <lnicola@dend.ro>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: poma <pomidorabelisima@gmail.com>, Dan Williams <dcbw@redhat.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Subject: Re: iwlwifi: Reason 7 periodic disconnect
Date: Thu, 23 Oct 2014 19:02:05 +0300
In-Reply-To: <CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
 <1413510814.22769.6.camel@dcbw.local>
 <1413751717.2510219.180809145.0E693C29@webmail.messagingengine.com>
 <CANUX_P2RHVRorVABRfWVg39d4D8dj35v3fBpY3=3jvQ1U+mfEA@mail.gmail.com>
 <1413783023.2710583.180921653.10DFFCEE@webmail.messagingengine.com>
 <CANUX_P0Q7cNeBzQa=2WVZFJXPTLx8F6YQk9bGCf_3uYhc5RcGA@mail.gmail.com>
 <CANUX_P3EqgTX7cPJvQ3fWH1yijekE0G_8TiH2_OCS7nFASGtkA@mail.gmail.com>
 <1413789724.3063896.180943829.3F15F453@webmail.messagingengine.com>
 <CANUX_P1REqkSqN0dtak34OQ_pSGMtPvV3Vj61tW5wb1+n2A7mg@mail.gmail.com>
 <1413833365.2949853.181221645.22D54845@webmail.messagingengine.com>
 <CANUX_P3XzYBp7E=hScmc837TpuCr9VrxEYauG=sGMKfOCpX=qA@mail.gmail.com>
 <54461740.5000903@openwrt.org>
 <1413879792.3500640.181427549.198E9452@webmail.messagingengine.com>
 <54461AEF.7040304@openwrt.org> <54463CE9.3060400@gmail.com>
 <1413921415.3763081.181696749.20A0A495@webmail.messagingengine.com>
 <CANUX_P0LRRczVCSFR7RE5coaYFxwFXyqC90pdm=oVwEiEt-7zw@mail.gmail.com>
 <1414014805.4127522.182191541.14C8B4DF@webmail.messagingengine.com>
 <CANUX_P0tGagXsN6XCeb_itQehqD3O9fmqknU6iSMO432NQtATA@mail.gmail.com>
 <1414049448.32460.182326557.1A0A85A4@webmail.messagingengine.com>
 <CANUX_P3usjdccnsYPQXzKbJ1PTH91fasf6BpcsCRYZH_yq2tww@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry, but I only saw a two-line change [1] to
`ieee80211_rx_mgmt_beacon` (which already had a log message). Am I
missing something?

[1] http://www.spinics.net/lists/linux-wireless/msg128340.html

Laurentiu

On Thu, Oct 23, 2014, at 11:07, Emmanuel Grumbach wrote:
> On Thu, Oct 23, 2014 at 10:30 AM, Laurențiu Nicola <lnicola@dend.ro>
> wrote:
> > I did; the card still gets disconnected and the message doesn't show up
> > in dmesg.
> >
> 
> You had *none* of the many prints I added in the log?
> 
> That seems really weird...
> 
> > Laurentiu
> >
> > On Thu, Oct 23, 2014, at 08:21, Emmanuel Grumbach wrote:
> >> On Thu, Oct 23, 2014 at 12:53 AM, Laurențiu Nicola <lnicola@dend.ro>
> >> wrote:
> >> > Nope. It seems that code doesn't get executed when my issue occurs (or
> >> > in my five or ten minutes of uptime). I've seen
> >> > `ieee80211_reset_ap_probe` get called by `ieee80211_rx_mgmt_probe_resp`,
> >> > but (if I'm not wrong) not on every disconnect.
> >> >
> >> > And as far as I can tell, force_cam is set to true.
> >>
> >> Can you please try with the patch attached and send the logs?
> >> I again need MAC80211_MLME_DEBUG.
> >>
> >> Thanks.
> >>
> >> >
> >> > Laurentiu
> >> >
> >> > On Wed, Oct 22, 2014, at 12:10, Emmanuel Grumbach wrote:
> >> >> On Tue, Oct 21, 2014 at 10:56 PM, Laurențiu Nicola <lnicola@dend.ro>
> >> >> wrote:
> >> >> > Yep! `scb_timeout` is 60 on my router.
> >> >> >
> >> >> > On Tue, Oct 21, 2014, at 14:00, poma wrote:
> >> >> >> On 21.10.2014 10:35, Felix Fietkau wrote:
> >> >> >> > On 2014-10-21 10:23, Laurențiu Nicola wrote:
> >> >> >> >> It's an ASUS RT-N66U running NEWD-2/K3X from r24160.
> >> >> >> > This is a Broadcom based device, so it should behave in the same way as
> >> >> >> > other APs/Routers running the Broadcom drivers.
> >> >> >> > The driver should only send Reason 7 when receiving a PS-Poll, BlockAck,
> >> >> >> > BlockAckReq or Action frame from a station that's not associated, so
> >> >> >> > probably it has already kicked out your iwlwifi client earlier. Not sure
> >> >> >> > why that doesn't show up in the log though.
> >> >> >> >
> >> >> >>
> >> >> >> Whether this might refer to the Station Control Block Timeout value
> >> >> >>
> >> >> >> http://www.dd-wrt.com/wiki/index.php/Wl#scb_timeout
> >> >> >> ...
> >> >> >> scb_timeout
> >> >> >>
> >> >> >> AP only: inactivity timeout value for authenticated stas
> >> >> >>
> >> >>
> >> >> Actually, mac80211 should be probing the AP every 30 seconds but a
> >> >> beacon might abort the probe...
> >> >> Can you try something like this:
> >> >>
> >> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> >> >> index 75df184..c9db7cf 100644
> >> >> --- a/net/mac80211/mlme.c
> >> >> +++ b/net/mac80211/mlme.c
> >> >> @@ -3295,7 +3295,8 @@ static void ieee80211_rx_mgmt_beacon(struct
> >> >> ieee80211_sub_if_data *sdata,
> >> >>         if (ifmgd->flags & IEEE80211_STA_CONNECTION_POLL) {
> >> >>                 mlme_dbg_ratelimited(sdata,
> >> >>                                      "cancelling AP probe due to a
> >> >> received beacon\n");
> >> >> -               ieee80211_reset_ap_probe(sdata);
> >> >> +               pr_err("Not cancelling the probe to make sure the AP
> >> >> hears us from time to time\n");
> >> >> +               //ieee80211_reset_ap_probe(sdata);
> >> >>         }
> >> >>
> >> >>         /*
> >> >>
> >> >>
> >> >>
> >> >> >>
> >> >> >> poma
> >> >> >>
> >> >> >>
> >> >> >> --
> >> >> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> >> >> >> in
> >> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> >> --
> >> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> >> >> in
> >> >> the body of a message to majordomo@vger.kernel.org
> >> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> >> in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
