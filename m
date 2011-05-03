Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60921 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383Ab1ECLor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 07:44:47 -0400
Received: by wwa36 with SMTP id 36so7330759wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 04:44:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <570950.1322951304422032629.JavaMail.defaultUser@defaultHost>
References: <570950.1322951304422032629.JavaMail.defaultUser@defaultHost>
Date: Tue, 3 May 2011 17:14:46 +0530
Message-ID: <BANLkTim3-ve4BD6wghA=F-asEqJmcDip6Q@mail.gmail.com> (sfid-20110503_134450_791068_EF66219F)
Subject: Re: WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150
 [mac80211]()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "rossi.f@inwind.it" <rossi.f@inwind.it>, yogeshp@marvell.com
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 3, 2011 at 4:57 PM, rossi.f@inwind.it <rossi.f@inwind.it> wrote:
>>Da: yogeshp@marvell.com
>>Data: 03/05/2011 12.51
>>A: "rossi.f@inwind.it"<rossi.f@inwind.it>, "johannes@sipsolutions.net"
> <johannes@sipsolutions.net>
>>Cc: "linux-wireless@vger.kernel.org"<linux-wireless@vger.kernel.org>
>>Ogg: RE: WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150
> [mac80211]()
>>
>>>I get the warning every few seconds.
>>>
>>>Fabio
>>I failed to regenerate the issue on my setup. I am using WEP40 on
>>Ath5k as station on 32 bit machine. I even tried disabling hw encryption.
>>
>>Some more details would be helpful.
>>
>>Thanks
>>Yogesh
>
> I'm using WEP with 128bit key on a 64bit system using ath5k driver. The hw
> encryption is configured with the default value. I don't have access right now
> to the machine, I can provide more details tonight if needed. I can test
> patches to diagnose the problem.
>
> Regards,
> Fabio

this also hits ath9k i think.
just running a traffic between WEP secured AP will reproduce this issue.
saw in set_key call back in ath9k/ath5k

            key->hw_key_idx = ret;
                        /* push IV and Michael MIC generation to stack */
                        key->flags |= IEEE80211_KEY_FLAG_GENERATE_IV;
                        if (key->cipher == WLAN_CIPHER_SUITE_TKIP)
                                key->flags |= IEEE80211_KEY_FLAG_GENERATE_MM

so may will this help? I don't know whether its a correct and with a
quick test the warning gets fixed.

diff --git a/net/mac80211/key.c b/net/mac80211/key.c
index ca3c626..49444c8 100644
--- a/net/mac80211/key.c
+++ b/net/mac80211/key.c
@@ -102,7 +102,8 @@ static int ieee80211_key_enable_hw_accel(struct
ieee80211_key *key)
        if (!ret) {
                key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;

-               if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+               if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)||
+                                       (key->conf.flags &
IEEE80211_KEY_FLAG_GENERATE_IV)))
                        key->local->crypto_tx_tailroom_needed_cnt--;

                return 0;
@@ -161,7 +162,8 @@ static void ieee80211_key_disable_hw_accel(struct
ieee80211_key *key)

        key->flags &= ~KEY_FLAG_UPLOADED_TO_HARDWARE;

-       if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
+               if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC)||
+                                       (key->conf.flags &
IEEE80211_KEY_FLAG_GENERATE_IV)))
                key->local->crypto_tx_tailroom_needed_cnt++;
 }



>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
