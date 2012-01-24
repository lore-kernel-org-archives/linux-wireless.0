Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42255 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab2AXIHF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 03:07:05 -0500
Received: by dake40 with SMTP id e40so2070658dak.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 00:07:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201231744.q0NHi68I002597@mail.maya.org>
References: <4EFF12D9.3010602@01019freenet.de>
	<2766356.70ylY68Gqi@helmutmobil.site>
	<4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201200730.q0K7U0oj004966@mail.maya.org>
	<CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
	<4F1D84CE.8020403@maya.org>
	<CAGXE3d_UPmcjgss+xMPBtkM22kBwGD23y8Fzxkr+6286W+EwbQ@mail.gmail.com>
	<201201231744.q0NHi68I002597@mail.maya.org>
Date: Tue, 24 Jan 2012 09:07:04 +0100
Message-ID: <CAGXE3d8P0UjnZ7Z=gg1uoe0WUX+4jWmg=a2i9_nV5E6i-xcfLQ@mail.gmail.com> (sfid-20120124_090709_742081_6970F903)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 23, 2012 at 6:44 PM, Andreas Hartmann
<andihartmann@01019freenet.de> wrote:
> Am Mon, 23 Jan 2012 17:36:57 +0100
> schrieb Helmut Schaa <helmut.schaa@googlemail.com>:
>
>> On Mon, Jan 23, 2012 at 5:03 PM, Andreas Hartmann
>> <andihartmann@freenet.de> wrote:
>> > Helmut Schaa schrieb:
>> >> On Fri, Jan 20, 2012 at 8:29 AM, Andreas Hartmann
>> >> <andihartmann@01019freenet.de> wrote:
>> >>> All in one: Your workaround was a good idea, but unfortunately it
>> >>> doesn't "solve" / workaround the problem introduced with the patch
>> >>> "mac80211: retry sending failed BAR frames later instead of tearing
>> >>> down aggr" [1]. I don't know off any other solution at this time as to revert it.
>> >>
>> >> Ok, so we've got at least one hw issue here: rt2800 is not able to report
>> >> correct ACK state of BARs :(
>> >>
>> >> The interesting bit is that the legacy drivers tear the BA session down as
>> >> soon as the first AMPDU subframe failed. That's the same behavior as
>> >> mac80211 had before the mentioned patch.
>> >>
>> >> So, let's assume the generic way Felix implemented works for other devices
>> >> (like ath9k) we could go with a workaround inside rt2x00 to tear down
>> >> the BA session as soon as the first AMPDU frame failed.
>> >>
>> >> Mind to try that one (not even compile tested though :) ).
>> >
>> > hdr is missing. I tried to derive it like this:
>> >
>> > struct ieee80211_hdr *hdr=(void*)entry->skb->data;
>>
>> Looks correct but you should put it right before the ieee80211_is_data_qos check
>> not at the start of the function ...
>
> I did it like this:
>
> --- drivers/net/wireless/rt2x00/rt2x00dev.c.orig        2012-01-23 16:50:03.188718671 +0100
> +++ drivers/net/wireless/rt2x00/rt2x00dev.c     2012-01-23 18:11:56.248553764 +0100
> @@ -388,8 +388,17 @@
>                tx_info->status.ampdu_len = 1;
>                tx_info->status.ampdu_ack_len = success ? 1 : 0;
>
> -               if (!success)
> -                       tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
> +               struct ieee80211_hdr *hdr = (void*) entry->skb->data;
> +               if (!success && tx_info->control.sta != NULL && ieee80211_is_data_qos(hdr->frame_control)) {
> +                       /*
> +                        * Tear down BA session
> +                        */
> +                       struct ieee80211_sta *sta = tx_info->control.sta;
> +                       u8 *qc = ieee80211_get_qos_ctl(hdr);
> +                       int tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
> +
> +                       ieee80211_stop_tx_ba_session(sta, tid);
> +               }
>        }
>
>        if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
>
>
> but the machine does crash anyway. Could hdr be null, too?

Ok, I'll do some testing as soon as time allows and get back to you then.

Helmut
