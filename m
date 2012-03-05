Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49234 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887Ab2CEV7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 16:59:50 -0500
Received: by vbbff1 with SMTP id ff1so3893001vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 05 Mar 2012 13:59:50 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 5 Mar 2012 15:59:50 -0600
Message-ID: <CAMLZHHSgOf9JcEBLxhgkFuM3SEvJUbH=VkDB3pyzPy61HO+mWg@mail.gmail.com> (sfid-20120305_225954_160155_0FF4EC12)
Subject: cfg80211 dump_survey - what is it supposed to measure?
From: Daniel Drake <dsd@laptop.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm working on a bug in libertas. It looks like NetworkManager (or
something related) is calling dump_survey, before a connection has
been established.

libertas does:

	survey->channel = ieee80211_get_channel(wiphy,
		ieee80211_channel_to_frequency(priv->channel,
					       IEEE80211_BAND_2GHZ));

	ret = lbs_get_rssi(priv, &signal, &noise);
	if (ret == 0) {
		survey->filled = SURVEY_INFO_NOISE_DBM;
		survey->noise = noise;
	}

        return ret;

lbs_get_rssi() only works when the card is associated. It then returns
the signal/noise of the last received beacon from the AP. If the card
is not associated (as is true here), lbs_get_rssi returns error 1,
which is then returned to cfg80211, and this looks to cause userspace
to retry the survey request in a seemingly infinite loop.

I'm wondering if dump_survey is intended to return the RSSI of a
specific network in the way that libertas does it, or if it is
supposed to look more generally at the interference on a channel?

In other words, given that libertas hardware doesn't seem to offer
functionality to measure the overall signal level on a channel, I'm
wondering if the correct solution here is to drop the dump_survey
handler altogether.

Thanks,
Daniel
