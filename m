Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47702 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab1JNIMp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 04:12:45 -0400
Received: by bkbzt4 with SMTP id zt4so2510893bkb.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 01:12:44 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH] mac80211: handle HT PHY BSS membership selector value correctly
Date: Fri, 14 Oct 2011 10:12:20 +0200
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
References: <201110132108.50019.chunkeey@googlemail.com> <20111013224532.GA1959@jm.kir.nu> <201110140942.37085.chunkeey@googlemail.com>
In-Reply-To: <201110140942.37085.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110141012.21010.chunkeey@googlemail.com> (sfid-20111014_101250_606662_AC776151)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Hit 'sent' by accident]

On Friday, October 14, 2011 09:42:36 AM Christian Lamparter wrote:
> On Friday, October 14, 2011 12:45:32 AM Jouni Malinen wrote:
> > On Thu, Oct 13, 2011 at 09:08:49PM +0200, Christian Lamparter wrote:
> > > 802.11n-2009 extends the supported rates element with a
> > > magic value which can be used to prevent legacy stations
> > > from joining the BSS.
> > 
> > Well, it can be used to try to make legacy stations not attempt
> > connection, but no guarantees on them actually checking whether they
> > support all the "basic rates".. For example, where is mac80211 (or
> > wpa_supplicant) doing that check? ;-)
> 
Actually, you have already implemented the check in hostapd :)

commit 2944824315b7c74838c551ef08c9843e02de1d46
Author: Jouni Malinen <jouni.malinen@atheros.com>
Date:   Wed Feb 9 15:08:47 2011 +0200

line 682:
        if (hapd->iconf->ieee80211n && hapd->iconf->require_ht &&
            !(sta->flags & WLAN_STA_HT)) {
                hostapd_logger(hapd, sta->addr, HOSTAPD_MODULE_IEEE80211,
                               HOSTAPD_LEVEL_INFO, "Station does not support "
                               "mandatory HT PHY - reject association");
                return WLAN_STATUS_ASSOC_DENIED_NO_HT;
        }

so if a legacy station decides to join a require_ht = 1 BSS
then the AP will refuse it with WLAN_STATUS_ASSOC_DENIED_NO_HT
and the wpa_supp client will blacklist the AP because of that
and it will choose a different AP for the next try.

> > > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > > @@ -1463,6 +1463,38 @@ ieee80211_rx_mgmt_disassoc(struct ieee80211_sub_if_data *sdata,
> > > +static void ieee80211_get_rates(struct ieee80211_supported_band *sband,
> > 
> > > +	for (i = 0; i < supp_rates_len; i++) {
> > > +		int rate = (supp_rates[i] & 0x7f) * 5;
> > > +		bool is_basic = !!(supp_rates[i] & BSS_MEMBERSHIP_SELECTOR);
> > 
> > This looks a bit odd since the BSS_MEMBERSHIP_SELECTOR is not exactly
> > same as basic rate indicator even through they share the same bit. We
> > used to have the magic 0x80 value here which could actually look less
> > confusing than the mixing of basic and BSS membership terms.
So, what's the exact difference between then BasicRate and a MembershipRate
in this context then? Is a rate called "basic rate" when it's one of the
legacy e.g.: 6, 12, 24 Mbit rates [And likewise: is a rate called a MembershipRate
when only in the magic 127 HT PHY case?] 

> > 
> > > +		if (rate > 110)
> > > +			*have_higher_than_11mbit = true;
> > While this is not really introduced by this patch, this looks quite
> > bogus since the higher-than-11Mbps is then used to figure out whether
> > this was a 802.11g network. That is not correct since a network with a
> > single supported rate 6 Mbps should also get that behavior.. More robust
> > mechanism would be to check for any OFDM rate being listed.
Also, there's 22mbit 8-PSK PBCC [I think mwl8k supports it and some TI
stuff could support it as well]. The check is questionable, but fixing
it may no be trivial either. [Anyway, it's a bit outside the scope and
requires another patch]

Regards,
	Chr
