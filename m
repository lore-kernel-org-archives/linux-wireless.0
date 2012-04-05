Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45291 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab2DEGry convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 02:47:54 -0400
Received: by dake40 with SMTP id e40so1228843dak.11
        for <linux-wireless@vger.kernel.org>; Wed, 04 Apr 2012 23:47:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4F7D1382.2080708@lwfinger.net>
References: <4F7D1382.2080708@lwfinger.net>
Date: Thu, 5 Apr 2012 08:47:54 +0200
Message-ID: <CAGXE3d-kg1Nxo49MN147jU4HQTBum4pHQ3n8gUUMuYNntF7Nxg@mail.gmail.com> (sfid-20120405_084757_628777_7918CCEF)
Subject: Re: Question about setup error in mac80211
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 5, 2012 at 5:37 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In https://bugzilla.kernel.org/show_bug.cgi?id=43044, driver rtl8192ce is
> getting an oops due to a NULL pointer dereference due to NULL being returned
> by ieee80211_get_tx_rate. For reference, the code in question is
>
> static inline struct ieee80211_rate *
> ieee80211_get_tx_rate(const struct ieee80211_hw *hw,
>                      const struct ieee80211_tx_info *c)
> {
>        if (WARN_ON(c->control.rates[0].idx < 0))
>                return NULL;
>        return &hw->wiphy->bands[c->band]->bitrates[c->control.rates[0].idx];

For MCS rates c->control.rates[0].idx contains the MCS rate itself. So, calling
ieee80211_get_tx_rate for an MCS rate might actually cause this ...

Helmut
