Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35074 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754528AbdEKIk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 May 2017 04:40:29 -0400
Received: by mail-wm0-f53.google.com with SMTP id b84so32176682wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 May 2017 01:40:28 -0700 (PDT)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: akolli@qti.qualcomm.com
Cc: ath10k@lists.infradead.org, akolli@codeaurora.org,
        linux-wireless@vger.kernel.org,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: Re: [PATCHv3 1/2] ath10k: add per peer htt tx stats support for 10.4
Date: Thu, 11 May 2017 10:40:21 +0200
Message-ID: <7221834.hsAT2eXtLP@bentobox> (sfid-20170511_104033_136391_C2F8E8F8)
In-Reply-To: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
References: <1479227849-10042-1-git-send-email-akolli@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart9769987.Uq7SiOCO7v"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart9769987.Uq7SiOCO7v
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Dienstag, 15. November 2016 22:07:29 CEST akolli@qti.qualcomm.com wrote:
> From: Anilkumar Kolli <akolli@qti.qualcomm.com>
> 
> Per peer tx stats are part of 'HTT_10_4_T2H_MSG_TYPE_PEER_STATS'
> event, Firmware sends one HTT event for every four PPDUs.
> HTT payload has success pkts/bytes, failed pkts/bytes, retry
> pkts/bytes and rate info per ppdu.
> Peer stats are enabled through 'WMI_SERVICE_PEER_STATS',
> which are nowadays enabled by default.
> 
> Parse peer stats and update the tx rate information per STA.
> 
> tx rate, Peer stats are tested on QCA4019 with Firmware version
> 10.4-3.2.1-00028.
> 
> Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
> ---

Just played a little bit around with it and an 802.11n client (2x2x). The 
thing I've observed was that MCS 0-7 was reported as MCS rate but the client 
received mostly MCS 8-15.

Guessing from this section

>	if (((txrate.flags == WMI_RATE_PREAMBLE_HT) ||
>	     (txrate.flags == WMI_RATE_PREAMBLE_VHT)) && txrate.mcs > 9) {
>		ath10k_warn(ar, "Invalid mcs %hhd peer stats", txrate.mcs);
>		return;
>	}

it looks like HT rates are reported as 0-9 with an NSS setting (yes, as odd as 
this is). I've printed the values to check it:

[   68.529197] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 5
[   68.529500] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 4
[   68.535225] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 4
[   68.542290] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 4
[   68.549507] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 4
[   68.555627] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 4
[   68.562652] XXXXX txrate.flags 2, txrate.bw 1, txrate.nss 2, txrate.mcs 4

I don't know this for sure but my next guess is now that following change is 
missing:

@@ -2231,8 +2231,10 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 	sgi = ATH10K_HW_GI(peer_stats->flags);
 
 	if (((txrate.flags == WMI_RATE_PREAMBLE_HT) ||
-	     (txrate.flags == WMI_RATE_PREAMBLE_VHT)) && txrate.mcs > 9) {
-		ath10k_warn(ar, "Invalid mcs %hhd peer stats", txrate.mcs);
+	     (txrate.flags == WMI_RATE_PREAMBLE_VHT)) &&
+	    (txrate.mcs > 9 || txrate.nss < 1)) {
+		ath10k_warn(ar, "Invalid mcs %hhd nss %hhd peer stats",
+			    txrate.mcs, txrate.nss);
 		return;
 	}
 
@@ -2255,7 +2257,7 @@ ath10k_update_per_peer_tx_stats(struct ath10k *ar,
 		arsta->txrate.legacy = rate;
 	} else if (txrate.flags == WMI_RATE_PREAMBLE_HT) {
 		arsta->txrate.flags = RATE_INFO_FLAGS_MCS;
-		arsta->txrate.mcs = txrate.mcs;
+		arsta->txrate.mcs = txrate.mcs + 8 * (txrate.nss - 1);
 	} else {
 		arsta->txrate.flags = RATE_INFO_FLAGS_VHT_MCS;
 		arsta->txrate.mcs = txrate.mcs;

Funny enough, I was spamming following with my 802.11n!!!! 2x2 client:

[  115.694987] XXXXX txrate.flags 3, txrate.bw 1, txrate.nss 4, txrate.mcs 15
[  115.701851] ath10k_ahb a800000.wifi: Invalid mcs 15 peer stats

Firmware was 10.4-3.2.1-00050 on an Dakota (IPQ401X) board.

Kind regards,
	Sven
--nextPart9769987.Uq7SiOCO7v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlkUI3UACgkQXYcKB8Em
e0ZqUw//W4oxfk4gRGNQAGZTXR/zm5NuM4S319wmfbXBouKCO/o+7GwoQvn7m6Pw
PWbfD1cCLhemBDZq2WqhYgri0xdK3giZORZSqfmK2mc+uBfR6wDZCnf+7nIAE4XI
MtGTI2w+9DOE44VJRGR4APtLBGYQn1vWobJ95PLjuve4cDfzp1a8XC8Ut7COB4Jk
UfkwywU2UsKXLoVKOSZTkde8k/qiDOEQObIzXN26yGmFa758pm+flyVhs7qhAXFn
LWuxnTmB1U0XFPNtEqzKNpxzAU6gha48t8epWjP2P7dwb8oTYM02wtXW5WEKCJXz
9blFCc8SghW+kZg833tcGb8ctL92u+XgZteLe+kQxqDzBRQlZvX7I/xDrgCQw3gT
rOHdFu1L6eQThDI5pL+zKrPp/5bt3rk2bmaOrLoUtEuZTl07td0mdZ8U9jKNzOY8
WZoGUPRN1qiFvyyoXUxAPTqU5A7ksmxfit8gCb+uBzePxqCmLLoNdkhHdtNm7R3V
n6x7jPTp9OxgO8CnAbv7wTs5TsYp+f/TXv8WKk6zdcDTgSez7wWTlBf9n7TWa5Ik
MljHfl0KuOhquYJoHi6bsYFjEqQy+9LpHTLROAm6fVdtPmmwHUM8DUyW+gamA7Ey
6HQBv1zXfkGHPyR61HfXgctRfhbRMwFyE1NB++uYJ0UuyLqKWdg=
=wAx5
-----END PGP SIGNATURE-----

--nextPart9769987.Uq7SiOCO7v--
