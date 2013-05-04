Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38833 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386Ab3EDKDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 May 2013 06:03:09 -0400
Message-ID: <5184DCCF.9010009@openwrt.org> (sfid-20130504_120314_149501_E1ED6984)
Date: Sat, 04 May 2013 12:02:55 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: Adrian Chadd <adrian@freebsd.org>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: add STBC TX support
References: <1367482308-9882-1-git-send-email-linux@rempel-privat.de> <1367482308-9882-2-git-send-email-linux@rempel-privat.de> <CAJ-Vmo=rZrHmXD0Os-Mb40jSEywbO-7GHSqL=7iMbkzAfS=+UQ@mail.gmail.com> <5182A341.8050704@rempel-privat.de> <5182A9DC.6030203@openwrt.org> <CAJ-Vmo=XYK=Jkc40U_vJO03n+tiA_LDpw8e1QKYRX6-+E9o4fA@mail.gmail.com> <5184AFC2.8060101@rempel-privat.de>
In-Reply-To: <5184AFC2.8060101@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-05-04 8:50 AM, Oleksij Rempel wrote:
> Am 02.05.2013 22:15, schrieb Adrian Chadd:
>> Well, let's dig into the firmware a bit more and tidy up how STBC is handled.
> 
> Does it mean, i should change this patch and provide a patch for 
> firmware too?
> I still do not think, changing peer caps i a good idea in any case.
> I mena this part of patch:
> +               if (sta->ht_cap.cap & IEEE80211_HT_CAP_TX_STBC)
> +                       caps |= WLAN_RC_TX_STBC_FLAG;
> 
> 
> Behaviour with this patch will be fallowing:
> - peer provide caps, even if it is RX-STBC12
> - we pass this information to firmware and ratecontroller of FW, do 
> right decision based on hardware it has.
> 
> You suggestion, if i understand it correctly, is to filter caps:
> - if peer provide more than we can, we should tell firmware the value 
> what we can. So, if peer say it can RX-STBC12, we should tell firmware 
> that peer is RX-STBC1.
> In my opinion, this kind of filter is a source for hidden errors.
I think the discussion regarding RX-STBC12 vs RX-STBC1 is purely
hypothetical. The hardware that this firmware was designed for only
supports sending STBC for MCS0-7. This will not change.

Also, there's no reason to tell the firmware about both rx and tx STBC
capabilities, the only thing it needs to know is what tells the rate
control part to enable/disable STBC.

In addition to that, using the WLAN_RC_* flags is wrong, you need to use
the ATH_RC_* flags, as this is what ath_rate_newassoc_11n checks for in
the firmware. The only STBC related flag that actually gets used (when
passed from the driver) is ATH_RC_RX_STBC_FLAG.

- Felix

