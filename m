Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:21499 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbcAEJxb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 04:53:31 -0500
Subject: Re: Mac80211 : Wpa rekeying issue
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	voncken <cedric.voncken@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
 <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
 <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
 <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
 <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
From: Matthias May <matthias.may@neratec.com>
Message-ID: <568B912F.8070100@neratec.com> (sfid-20160105_105338_374511_AC4E183B)
Date: Tue, 5 Jan 2016 10:47:27 +0100
MIME-Version: 1.0
In-Reply-To: <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060604090509040400000305"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060604090509040400000305
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 31/12/15 09:41, Emmanuel Grumbach wrote:
> On Thu, Dec 31, 2015 at 10:12 AM, voncken <cedric.voncken@acksys.fr> wr=
ote:
>>
>>          Hi,
>>
>> I'm not a WPA expert and security expert,
>>
>> Could you explain why the patch sent by Alexander Wetzel break the sec=
urity properties of this code?
>>
>> The Alexander's patch is in attachment.
>>
>> Thanks for your help.
>
> It simply disables the replay attack detection :)
> You could receive the same (encrypted) packet twice and not throw away
> the second one.
> The author of the patch never said that this patch is a "fix", it is
> rather a debug step to understand what happens.
>
> PTK rekeying is a problem from the spec point of view. In Intel, we
> did inquiries and in the end we understood that what we should really
> do whenever we get to a situation where we need to rekey the PTK is to
> disconnect and reconnect. Only weird configuration allow to change the
> PTK more frequently than after X packet (don't remember what X is bu
> something like 2^32 which is big enough to hold the connection for
> days...).
>
> IIRC, Intel devices don't have problems in Tx while we rekey because
> we give the key material along with the packet itself, so that we
> can't get to a situation where we have old PN and new key. The Atheros
> devices separate the key material and the Tx packet (which is a
> perfectly valid design decision), but this introduce the possibility
> to use the old PN with a new key meaning that the recipient could
> decrypt the packet after the new key has been installed, but it would
> also update the PN to be high and discard all the next packets that
> will come with a new (low) PN.
> So essentially, this is a bug in the TX'ing side. Fixing it requires
> to hit the performance which is not something people are willing to
> do, when the bug is really in the spec.
> That's what I remember, but I may be wrong.

We've encountered exactly this problem in a mix of devices where one=20
applies key material faster than the other. (ath9k and aquilla)
As a workaround we check on the STA if we are authorized when=20
updating/checking CCMP. (see attached patches)
Not sure what the performance impact of that is.
Is this something which might be interesting to upstream?

>
>>
>>> -----Message d'origine-----
>>> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>>> owner@vger.kernel.org] De la part de voncken
>>> Envoy=C3=A9 : mardi 29 d=C3=A9cembre 2015 16:24
>>> =C3=80 : 'Emmanuel Grumbach'
>>> Cc : 'linux-wireless'; 'Johannes Berg'
>>> Objet : RE: Mac80211 : Wpa rekeying issue
>>>
>>>        > -----Message d'origine-----
>>>> De : Emmanuel Grumbach [mailto:egrumbach@gmail.com] Envoy=C3=A9 : ma=
rdi 29
>>>> d=C3=A9cembre 2015 15:20 =C3=80 : Cedric VONCKEN Cc : linux-wireless=
 Objet : Re:
>>>> Mac80211 : Wpa rekeying issue
>>>>
>>>> On Tue, Dec 29, 2015 at 3:01 PM, Cedric VONCKEN
>>>> <cedric.voncken@acksys.fr>
>>>> wrote:
>>>>> Hi,
>>>>>
>>>>> My test plateform is:
>>>>> 2 equipements
>>>>> Both equipment used compat version 2015-07-21 from openwrt.
>>>>> Both equipment used security WPA2
>>>>>
>>>>> The equipment #1 is an AP.
>>>>>          The Group rekey interval is set to 3601s
>>>>>          The Pair rekey interval set to 50s (I reduced this value t=
o
>>>>> show the issue often)
>>>>>          The Master rekey interval is set to 86400 s.
>>>>>
>>>>> The equipment #2 is a sta+wds
>>>>>
>>>>> I used a 5GHz channel to have a free channel (without other AP) I
>>>>> connected a computer on each equipment.
>>>>>
>>>>> To reproduce the issue:
>>>>>          I ran iperf udp@50Mbps from computer connected to the AP t=
o
>>>>> the computer connected to the sta. After several WPA2 rekeying,
>>>>> iperf server side didn't received any frame.
>>>>>
>>>>> I investigated in the driver. All packets are dropped in sta side,
>>>>> because the function ieee80211_crypto_ccmp_decrypt return
>>>>> Rx_DROP_UNUSABLE. This function return this code because the test
>>>>> if(memcmp(pn,key->u.ccmp.rx_pn[queue],IEEE8021_CCMP_PN_LEN) <=3D0)
>>>>> return true.
>>>>>
>>>>> Have you any idea to fix this issue?
>>>>>
>>>>
>>>> I don't remember exactly what we had, but you may look at
>>>> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/13774=
2
>>>
>>> Thanks for the link, I think I'm in the same situation.
>>>
>>> How can I fix this issue?
>>>
>>> Because the patch sent by Alexander Wetzel was rejected by Johannes (=
for
>>> security reason), and if I disable the hw crypto I will have performa=
nce
>>> issue.
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess"
>>> in the body of a message to majordomo@vger.kernel.org More majordomo =
info
>>> at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--=20
Matthias May
Software Engineer

Neratec Solutions AG
Postfach 83, CH-8608 Bubikon, Switzerland
Direct: +41 55 253 2074
Office: +41 55 253 2000
Fax:    +41 55 253 2070
email:  matthias.may@neratec.com
Web:   www.neratec.com

--------------060604090509040400000305
Content-Type: text/x-patch;
 name="CC0031-dont-check-ccmp-replay-when-not-authorized.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="CC0031-dont-check-ccmp-replay-when-not-authorized.patch"

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index feb547d..c2adb0d 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -522,7 +522,9 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 		queue = rx->security_idx;
 
 		if (memcmp(pn, key->u.ccmp.rx_pn[queue],
-			   IEEE80211_CCMP_PN_LEN) <= 0) {
+			   IEEE80211_CCMP_PN_LEN) <= 0 &&
+			   !(rx->sta && !test_sta_flag(rx->sta,
+					WLAN_STA_AUTHORIZED))) {
 			key->u.ccmp.replays++;
 			return RX_DROP_UNUSABLE;
 		}

--------------060604090509040400000305
Content-Type: text/x-patch;
 name="CC0031-dont-update-ccmp-replay-when-not-authorized.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="CC0031-dont-update-ccmp-replay-when-not-authorized.patch"

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index e115175..dc9c084 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -538,7 +538,13 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 				return RX_DROP_UNUSABLE;
 		}
 
-		memcpy(key->u.ccmp.rx_pn[queue], pn, IEEE80211_CCMP_PN_LEN);
+		/* If we are a station update the ccmp counter only when we are
+		 * authorised. For all other modes always update. */
+		if (!rx->sta ||
+		    (rx->sta && test_sta_flag(rx->sta, WLAN_STA_AUTHORIZED)) ) {
+			memcpy(key->u.ccmp.rx_pn[queue],
+			       pn, IEEE80211_CCMP_PN_LEN);
+		}
 	}
 
 	/* Remove CCMP header and MIC */

--------------060604090509040400000305--
