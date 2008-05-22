Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:34208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYEVQxz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 12:53:55 -0400
Received: by rv-out-0506.google.com with SMTP id l9so155078rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 09:53:54 -0700 (PDT)
Message-ID: <1ba2fa240805220953u746d3429q50faa1885104cadb@mail.gmail.com> (sfid-20080522_185359_028598_D17C0097)
Date: Thu, 22 May 2008 19:53:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vincent C Jones" <v.jones@networkingunlimited.com>
Subject: Re: iwl4965 - wpa_supplicant can't see 5Ghz frequencies - 2.6.26-rc1 kernel
Cc: linux-wireless@vger.kernel.org,
	"Emmanuel Grumbach" <egrumbach@gmail.com>
In-Reply-To: <1210617467.3792.4.camel@X61.DFGI.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210352234.3763.23.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805091712gccaec9cibdab621e8d1c9ba7@mail.gmail.com>
	 <1210430367.3778.9.camel@X61.NetworkingUnlimited.com>
	 <1210434402.3787.7.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101156q4dc52c2bt47d2f6e51b611eea@mail.gmail.com>
	 <1210456110.3787.26.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805101506p78c3eeb6q6e980ac4200fd56f@mail.gmail.com>
	 <1210474179.3787.31.camel@X61.NetworkingUnlimited.com>
	 <1ba2fa240805120950mf983e97qac4cdfa2c84b6662@mail.gmail.com>
	 <1210617467.3792.4.camel@X61.DFGI.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 12, 2008 at 9:37 PM, Vincent C Jones
<v.jones@networkingunlimited.com> wrote:
>
> On Mon, 2008-05-12 at 19:50 +0300, Tomas Winkler wrote:
>
>> Meanwhile we've reproduced the wpa_supplicant issue...
>>
>
> That is great news. Let me know when it is time to test again...

Please try this one. I've just pasted that in so it's might be
white-space-wise broken

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7877d3b..5996e3d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4080,17 +4080,18 @@ ieee80211_sta_scan_result(struct net_device *dev,
                                                  IW_EV_UINT_LEN);
        }

+
        memset(&iwe, 0, sizeof(iwe));
        iwe.cmd = SIOCGIWFREQ;
-       iwe.u.freq.m = bss->freq;
-       iwe.u.freq.e = 6;
+       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
+       iwe.u.freq.e = 0;
        current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
                                          IW_EV_FREQ_LEN);

        memset(&iwe, 0, sizeof(iwe));
        iwe.cmd = SIOCGIWFREQ;
-       iwe.u.freq.m = ieee80211_frequency_to_channel(bss->freq);
-       iwe.u.freq.e = 0;
+       iwe.u.freq.m = bss->freq;
+       iwe.u.freq.e = 6;
        current_ev = iwe_stream_add_event(current_ev, end_buf, &iwe,
                                          IW_EV_FREQ_LEN);


Tomas
