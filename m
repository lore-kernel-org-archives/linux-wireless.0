Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79717C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 07:41:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33EAD20878
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 07:41:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TCioNrrt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PxgSbbXA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 33EAD20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbeJBOX0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 10:23:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36824 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbeJBOXZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 10:23:25 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 380EF60C67; Tue,  2 Oct 2018 07:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538466091;
        bh=JqZp3wL8slHFAsRVPA6Vb8msICG7F3i/qdfQdP13OHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TCioNrrtj339y1IHhRE5pe1y7HvH6azS+m9Zr5I+YGRrTvk7iher7cFoCZ1gjBbM/
         9oUo4xGAjcGDH0EgKRZGWoXkipL8AzgUFZjhfFt4UXhgNXFBG7DRPsX4h/CdBw3odo
         zJnw0xHF+wcDiTSwA4jes25QKnuxcTnNiNZRbFOo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 8670660C67;
        Tue,  2 Oct 2018 07:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538466089;
        bh=JqZp3wL8slHFAsRVPA6Vb8msICG7F3i/qdfQdP13OHA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PxgSbbXA6cwtFCoi/VjUHON+HttUCj/WJyQnaVi7jhPsE4CuRyhVHl3hJoDK2ZoWe
         0Z2LHoXG5rHe6Gi0mxlrNcHbPu/bkF0Afb4MD1L/+mCNGax95CJawolJa8xQjquQfI
         iubTSS1LgNvPPmwrW53XayzNDNugXFBT/bQMMgRs=
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_ff19f85654fe7333b979b09369163517"
Date:   Tue, 02 Oct 2018 00:41:28 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Jonathan Morton <chromatix99@gmail.com>, Kan Yan <kyan@google.com>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [PATCH RFC v4 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
In-Reply-To: <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
 <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org> <87zhw2eyfo.fsf@toke.dk>
 <5d961a5f61de45b85b1b037bcef9270d@codeaurora.org>
 <44B09168-C08F-4C85-8D74-D576CCC79880@gmail.com>
 <586459da6ec36edc2284df8533915d62@codeaurora.org>
 <4929C006-3452-4C17-9500-8D7485EB538E@toke.dk>
 <0531def170ef7f9cadcf85a6dc9af22b@codeaurora.org>
Message-ID: <f2b31489b65fc0ce106b45e9938b4794@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--=_ff19f85654fe7333b979b09369163517
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII;
 format=flowed

On 2018-10-01 23:58, Rajkumar Manoharan wrote:
>> Great! I'll fold in the rest, test it with ath9k and submit as a 
>> proper patch :)
>> 
> Toke,
> 
> I noticed a race condition b/w sta cleanup and kick_airtime tasklet. 
> How do you
> plan to exit kick_airtime gracefully during sta_cleanup?
> 
If kick_airtime tasklet is only used for adjusting deficit for all 
throttled txq,
then below rcu lock issue is not observed. I am testing with 50 clients 
and the
crash happens only during sta cleanup. Releasing active_txq_lock from 
tasklet is
yielding handle to txq_purge(). I am thinking of get rid of tasklet and 
handle
adjustment directly in API.


diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 0bb590928dd0..277dbf8e0a4b 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -261,14 +261,7 @@ static void __ieee80211_kick_airtime(struct 
ieee80211_local *local, int ac)

                 if (sta->airtime[ac].deficit >= 0) {
                         seen_eligible = true;
-
-                       if 
(!test_and_clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE,
-                                               &txqi->flags))
-                               continue;
-
-                       spin_unlock_bh(&local->active_txq_lock[ac]);
-                       drv_wake_tx_queue(local, txqi);
-                       spin_lock_bh(&local->active_txq_lock[ac]);
+                       clear_bit(IEEE80211_TXQ_AIRTIME_THROTTLE, 
&txqi->flags);

-Rajkumar

--=_ff19f85654fe7333b979b09369163517
Content-Transfer-Encoding: base64
Content-Type: text/plain;
 name=rcu_race.txt
Content-Disposition: attachment;
 filename=rcu_race.txt;
 size=2571

DQoNCnJvb3RAT3BlbldydDovIyBbICAzNjMuMDk0NzAyXSBJTkZPOiByY3VfcHJlZW1wdCBzZWxm
LWRldGVjdGVkIHN0YWxsIG9uIENQVSB7IDB9DQogICh0PTIxMDEgamlmZmllcyBnPTI2NzkgYz0y
Njc4IHE9MTM0KQ0KWyAgMzYzLjEwMjcwOV0gQ1BVOiAwIFBJRDogMCBDb21tOiBzd2FwcGVyLzAg
Tm90IHRhaW50ZWQgMy4xNC43NyAjOQ0KWyAgMzYzLjEwNDcxN10gSU5GTzogcmN1X3ByZWVtcHQg
ZGV0ZWN0ZWQgc3RhbGxzIG9uIENQVXMvdGFza3M6IHsgMH0gKGRldGVjdGVkIGINCnkgMSwgdD0y
MTAyIGppZmZpZXMsIGc9MjY3OSwgYz0yNjc4LCBxPTEzNCkNClsgIDM2My4xMDQ3MjNdIFRhc2sg
ZHVtcCBmb3IgQ1BVIDA6DQpbICAzNjMuMTA0NzM0XSBzd2FwcGVyLzAgICAgICAgUiBydW5uaW5n
ICAgICAgMCAgICAgMCAgICAgIDAgMHgwMDAwMTAwMg0KWyAgMzYzLjEwNDc2M10gWzxjMDIwZWMy
MD5dIChfX3NjaGVkdWxlKSBmcm9tIFs8YzAyMTgzMDQ+XSAoYXJjaF9jcHVfaWRsZSsweDM4LzAN
Cng1YykNClsgIDM2My4xMDQ4NTJdIFs8YzAyMTgzMDQ+XSAoYXJjaF9jcHVfaWRsZSkgZnJvbSBb
PGZmZmZmZmZmPl0gKDB4ZmZmZmZmZmYpDQpbICAzNjMuMTQzMTY3XSBbPGMwMjFkOWFjPl0gKHVu
d2luZF9iYWNrdHJhY2UpIGZyb20gWzxjMDIxYWE0MD5dIChzaG93X3N0YWNrKzB4MQ0KMC8weDE0
KQ0KWyAgMzYzLjE1MDg5Ml0gWzxjMDIxYWE0MD5dIChzaG93X3N0YWNrKSBmcm9tIFs8YzAzYzU5
ZDQ+XSAoZHVtcF9zdGFjaysweDgwLzB4YTANCikNClsgIDM2My4xNTgwOTldIFs8YzAzYzU5ZDQ+
XSAoZHVtcF9zdGFjaykgZnJvbSBbPGMwMjZlMWRjPl0gKHJjdV9jaGVja19jYWxsYmFja3MrDQow
eDIzMC8weDZhOCkNClsgIDM2My4xNjYyNThdIFs8YzAyNmUxZGM+XSAocmN1X2NoZWNrX2NhbGxi
YWNrcykgZnJvbSBbPGMwMjM4ODE0Pl0gKHVwZGF0ZV9wcm9jDQplc3NfdGltZXMrMHgzOC8weDU4
KQ0KWyAgMzYzLjE3NTExMF0gWzxjMDIzODgxND5dICh1cGRhdGVfcHJvY2Vzc190aW1lcykgZnJv
bSBbPGMwMjc2NzgwPl0gKHRpY2tfc2NoZWQNCl90aW1lcisweDQ0LzB4NzQpDQpbICAzNjMuMTgz
NzAyXSBbPGMwMjc2NzgwPl0gKHRpY2tfc2NoZWRfdGltZXIpIGZyb20gWzxjMDI0YTgyOD5dIChf
X3J1bl9ocnRpbWVyKw0KMHg1MC8weGM4KQ0KWyAgMzYzLjE5MTY4Nl0gWzxjMDI0YTgyOD5dIChf
X3J1bl9ocnRpbWVyKSBmcm9tIFs8YzAyNGFmZjg+XSAoaHJ0aW1lcl9pbnRlcnJ1cHQNCisweDEz
MC8weDI3YykNClsgIDM2My4xOTk5MzZdIFs8YzAyNGFmZjg+XSAoaHJ0aW1lcl9pbnRlcnJ1cHQp
IGZyb20gWzxjMDUxNzVhYz5dIChtc21fdGltZXJfaW50DQplcnJ1cHQrMHgzOC8weDQ0KQ0KWyAg
MzYzLjIwODUyOF0gWzxjMDUxNzVhYz5dIChtc21fdGltZXJfaW50ZXJydXB0KSBmcm9tIFs8YzAy
NjhhNmM+XSAoaGFuZGxlX3BlcmMNCnB1X2RldmlkX2lycSsweDY4LzB4ODQpDQpbICAzNjMuMjE3
NjQ1XSBbPGMwMjY4YTZjPl0gKGhhbmRsZV9wZXJjcHVfZGV2aWRfaXJxKSBmcm9tIFs8YzAyNjUz
ZTA+XSAoZ2VuZXJpYw0KX2hhbmRsZV9pcnErMHgyMC8weDMwKQ0KWyAgMzYzLjIyNjY3MV0gWzxj
MDI2NTNlMD5dIChnZW5lcmljX2hhbmRsZV9pcnEpIGZyb20gWzxjMDIxODAzYz5dIChoYW5kbGVf
SVJRKzANCng2OC8weDkwKQ0KWyAgMzYzLjIzNDU2N10gWzxjMDIxODAzYz5dIChoYW5kbGVfSVJR
KSBmcm9tIFs8YzAyMDg0ZTA+XSAoZ2ljX2hhbmRsZV9pcnErMHgzYy8NCjB4NjApDQpbICAzNjMu
MjQyMTIwXSBbPGMwMjA4NGUwPl0gKGdpY19oYW5kbGVfaXJxKSBmcm9tIFs8YzAyMDk1YzA+XSAo
X19pcnFfc3ZjKzB4NDAvMA0KeDcwKQ0KWyAgMzYzLjI0OTU4MV0gRXhjZXB0aW9uIHN0YWNrKDB4
YzA4NWRlNjggdG8gMHhjMDg1ZGViMCkNClsgIDM2My4yNTQ2MTZdIGRlNjA6ICAgICAgICAgICAg
ICAgICAgIDAwMDAwMDA0IGRiN2U1MGEwIDAwMDAwMDlkIDAwMDAwMDAwIGQ4YmI4DQpkMTggZDhi
YjhkMDANClsgIDM2My4yNjI3NzddIGRlODA6IGQ4YmI4YzIwIDAwMDAwMDAyIDAwMDAwMDMwIDAw
MDAwMDE4IGRiN2U1MDAwIDAwMDAwMDA2IDAwMDAwDQowMDAgYzA4NWRlYjANClsgIDM2My4yNzA5
MzVdIGRlYTA6IGJmYjY4Yzk4IGMwMjBjYWU4IDYwMDAwMTEzIGZmZmZmZmZmDQpbICAzNjMuMjc1
OTc3XSBbPGMwMjA5NWMwPl0gKF9faXJxX3N2YykgZnJvbSBbPGMwMjBjYWU4Pl0gKF90ZXN0X2Fu
ZF9jbGVhcl9iaXQrMA0KeDAvMHg0OCkNClsgIDM2My4yODM4NTBdIFs8YzAyMGNhZTg+XSAoX3Rl
c3RfYW5kX2NsZWFyX2JpdCkgZnJvbSBbPGJmYjY4Yzk4Pl0gKGllZWU4MDIxMV9rDQppY2tfYWly
dGltZSsweDg4LzB4MTg4IFttYWM4MDIxMV0pDQpbICAzNjMuMjkzOTYzXSBbPGJmYjY4Yzk4Pl0g
KGllZWU4MDIxMV9raWNrX2FpcnRpbWUgW21hYzgwMjExXSkgZnJvbSBbPGMwMjMzMWVjPg0KXSAo
dGFza2xldF9hY3Rpb24rMHg4Yy8weGVjKQ0KWyAgMzYzLjMwMzQwNl0gWzxjMDIzMzFlYz5dICh0
YXNrbGV0X2FjdGlvbikgZnJvbSBbPGMwMjMyN2U0Pl0gKF9fZG9fc29mdGlycSsweDENCjA0LzB4
Mjk0KQ0K
--=_ff19f85654fe7333b979b09369163517--
