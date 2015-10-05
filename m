Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbbJETEn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 15:04:43 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
	<wrfj4mjcqn3x.fsf@redhat.com> <wrfjvbbsp6ot.fsf@redhat.com>
	<1441275474.2565.18.camel@sipsolutions.net>
	<wrfjmvx2gi0m.fsf@redhat.com>
	<21994.26976.882903.355191@gargle.gargle.HOWL>
	<1442508413.2821.11.camel@sipsolutions.net>
	<wrfjk2r1b16i.fsf@redhat.com>
	<1444071403.21467.0.camel@sipsolutions.net>
Date: Mon, 05 Oct 2015 15:04:42 -0400
In-Reply-To: <1444071403.21467.0.camel@sipsolutions.net> (Johannes Berg's
	message of "Mon, 05 Oct 2015 20:56:43 +0200")
Message-ID: <wrfj8u7hb0hh.fsf@redhat.com> (sfid-20151005_210446_984035_F8182D77)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Mon, 2015-10-05 at 14:49 -0400, Jes Sorensen wrote:
>> 
>> Finally went back to look at this - I believe this is exactly what I am
>> doing in the driver right now. Pulling the short_preamble info from
>> BSS_CHANGED_ERP_PREAMBLE and storing it sta->drv_priv for use in the
>> tx function.
>> 
>
> You can't really be doing that since you don't get a sta pointer with
> BSS_CHANGED_ERP_PREAMBLE?

I have this in the code - that said, I may not be getting a pointer back
ever?

	if (changed & BSS_CHANGED_ERP_PREAMBLE) {
		dev_dbg(dev, "Changed ERP_PREAMBLE: Use short preamble %i\n",
			bss_conf->use_short_preamble);
		val32 = rtl8xxxu_read32(priv, REG_RESPONSE_RATE_SET);
		if (bss_conf->use_short_preamble)
			val32 |= RSR_ACK_SHORT_PREAMBLE;
		else
			val32 &= ~RSR_ACK_SHORT_PREAMBLE;
		rtl8xxxu_write32(priv, REG_RESPONSE_RATE_SET, val32);

		rcu_read_lock();
		sta = ieee80211_find_sta(vif, bss_conf->bssid);
		if (sta) {
			sta_priv = (struct rtl8xxxu_sta_priv *)sta->drv_priv;
			if (bss_conf->use_short_preamble)
				sta_priv->short_preamble = true;
			else
				sta_priv->short_preamble = false;
		}
		rcu_read_unlock();
	}

So what was it you were suggesting instead? I think I am confused now.

Cheers,
Jes
