Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2DC0C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 07:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F9D5208B3
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 07:07:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="JTH+tV1G";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="TntBUOQL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F9D5208B3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbeJPO4V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 10:56:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:55584 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727335AbeJPO4V (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 10:56:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9305A60227; Tue, 16 Oct 2018 07:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539673639;
        bh=vndiq/ArO8PJmG+qnEsqgyF72yHnVmcsyr99Kw2PqDw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JTH+tV1GufLkPYcT2bCSLTEKlfUq2AE1dpw68GODMK3yrmP6jMdwauLy7kVZ0jEpv
         FVsz49kqXrEKIhHrFGCYDdDUPv9Flq4k9VWtxh56F7S+K2k4peWZjTtazihWfwKox4
         0PbKAoXyfVXjJtQTWxBCXRsmfJzMYMJ+E6h6GKnw=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 6BE156087D;
        Tue, 16 Oct 2018 07:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539673638;
        bh=vndiq/ArO8PJmG+qnEsqgyF72yHnVmcsyr99Kw2PqDw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TntBUOQLCn6tFof8622zfkrRk54LeqCO2uFE8qOWc4I472QVp8//f0+9R98c4vep7
         5DX9vxLvohT5k2VSdKGFOaMu0g3BTSWkg8rBcoMQ2cnoAxfZsbP7IGOdytzRTn3lPA
         RhuIA4yGQOOp5wUQa0ywCRm4fFonXf3TcwHmgksU=
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_bf38c64788d529c390b4e5246d7aa35a"
Date:   Tue, 16 Oct 2018 00:07:18 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <875zy7qxle.fsf@toke.dk>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
 <153908837900.9471.5394468800857658136.stgit@alrua-kau>
 <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org> <87zhvm832s.fsf@toke.dk>
 <187bade306627912c70d800819ef0b87@codeaurora.org> <87pnwg93at.fsf@toke.dk>
 <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org> <875zy7qxle.fsf@toke.dk>
Message-ID: <a582bd5865268ac69b0105c22dd927a3@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--=_bf38c64788d529c390b4e5246d7aa35a
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

On 2018-10-12 03:16, Toke Høiland-Jørgensen wrote:
> 
> - Just loop with the smaller quantum until one of the stations go into
>   the positive (what we do now).
> 
> - Go through all active stations, find the one that is closest being in
>   the positive, and add that amount to the quantum. I.e., something
>   like (assuming no station has positive deficit; if one does, you 
> don't
>   want to add anything anyway):
> 
>   to_add = -(max(stn.deficit) for stn in active stations)
>   for stn in active stations:
>     stn.deficit += to_add + stn.weight
> 
Toke,

Sorry for the delayed response. I did lot of experiments. Below are my 
observations.
Sorry for lengthy reply.

In current model, next_txq() is main routine that serves DRR and 
fairness is
enforced by serving only only first txq. Here the first node could be 
either
newly initiated traffic or returned node by return_txq(). This works 
perfectly
as long as the driver is running any RR algo.

Whereas in ath10k, firmware runs its own RR in pull mode and builds txq 
list
based on driver's hostq table. In this case it can not be simply assumed 
that
firmware always gives fetch request for first node of mac80211's txq 
list.
i.e both RR algo could be out of sync.

Two major differences b/w ath9k and ath10k

1) Serving txqs
The ath9k always serves txq by next_txq and so that the txqs_list is 
rotated to serve
other txq. But in ath10k (pull-mode), first node becomes sticky one 
until it is
picked by firmware via fetch indication and it becomes negative deficit.
The sequence is followed in wake_tx_queue

    - dequeue first node
    - push is not allowed
    - enqueue same txq back to head

2) Refill rate of deficit.

The ath9k refills deficit mostly in hot path by next_txq() in tx & isr 
routine.
In case of ath10k, due to above problem, deficits wont be filled in hot 
path.
Either it should be filled in fetch_ind itself or by scheduling another 
task.
Both the approaches are slower compared to hot path when the driver is 
bursting
aggregation. On an idle condition a single fetch indication can dequeue 
~190 msdus
from each tid of give stn list. This drains the deficit quickly and 
becomes too low.
To speed up this, either refill the station by multiples of stn airtime 
weight or
allows the txqs_list rotation. So that next_txq will be used for 
refilling deficit.

Attaching return_txq() change that helps to get rid of quantum multiple.

-Rajkumar
--=_bf38c64788d529c390b4e5246d7aa35a
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=return_tail.patch
Content-Disposition: attachment;
 filename=return_tail.patch;
 size=5268

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvaHR0X3J4LmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2h0dF9yeC5jCmluZGV4IDYyNWE0YWIzN2Vh
MC4uMjY5YWU4MzExMDU2IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
MTBrL2h0dF9yeC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvaHR0X3J4
LmMKQEAgLTIzNTIsNyArMjM1Miw3IEBAIHN0YXRpYyB2b2lkIGF0aDEwa19odHRfcnhfdHhfZmV0
Y2hfaW5kKHN0cnVjdCBhdGgxMGsgKmFyLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCQkJbnVtX21z
ZHVzKys7CiAJCQludW1fYnl0ZXMgKz0gcmV0OwogCQl9Ci0JCWllZWU4MDIxMV9yZXR1cm5fdHhx
KGh3LCB0eHEpOworCQlpZWVlODAyMTFfcmV0dXJuX3R4cShodywgdHhxLCB0cnVlKTsKIAkJaWVl
ZTgwMjExX3R4cV9zY2hlZHVsZV9lbmQoaHcsIHR4cS0+YWMpOwogCiAJCXJlY29yZC0+bnVtX21z
ZHVzID0gY3B1X3RvX2xlMTYobnVtX21zZHVzKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dp
cmVsZXNzL2F0aC9hdGgxMGsvbWFjLmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBr
L21hYy5jCmluZGV4IGNmNjRkOWUwMmEyNC4uZDM5YmM4NDFlYTA0IDEwMDY0NAotLS0gYS9kcml2
ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL21hYy5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2F0aC9hdGgxMGsvbWFjLmMKQEAgLTQyMDYsNyArNDIwNiw3IEBAIHN0YXRpYyBpbnQgYXRo
MTBrX21hY19zY2hlZHVsZV90eHEoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHUzMiBhYykKIAkJ
CWlmIChyZXQgPCAwKQogCQkJCWJyZWFrOwogCQl9Ci0JCWllZWU4MDIxMV9yZXR1cm5fdHhxKGh3
LCB0eHEpOworCQlpZWVlODAyMTFfcmV0dXJuX3R4cShodywgdHhxLCB0cnVlKTsKIAkJYXRoMTBr
X2h0dF90eF90eHFfdXBkYXRlKGh3LCB0eHEpOwogCQlpZiAocmV0ID09IC1FQlVTWSkKIAkJCWJy
ZWFrOwpAQCAtNDQ3NSwxOCArNDQ3NSwyMSBAQCBzdGF0aWMgdm9pZCBhdGgxMGtfbWFjX29wX3dh
a2VfdHhfcXVldWUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCiB7CiAJdTggYWMgPSB0eHEtPmFj
OwogCWludCByZXQgPSAwOworCWJvb2wgcHVzaGVkID0gZmFsc2U7CiAKKwlhdGgxMGtfaHR0X3R4
X3R4cV91cGRhdGUoaHcsIHR4cSk7CiAJaWVlZTgwMjExX3R4cV9zY2hlZHVsZV9zdGFydChodywg
YWMpOwogCXR4cSA9IGllZWU4MDIxMV9uZXh0X3R4cShodywgYWMpOwogCWlmICghdHhxKQogCQln
b3RvIG91dDsKIAogCXdoaWxlIChhdGgxMGtfbWFjX3R4X2Nhbl9wdXNoKGh3LCB0eHEpKSB7CisJ
CXB1c2hlZCA9IHRydWU7CiAJCXJldCA9IGF0aDEwa19tYWNfdHhfcHVzaF90eHEoaHcsIHR4cSk7
CiAJCWlmIChyZXQgPCAwKQogCQkJYnJlYWs7CiAJfQotCWllZWU4MDIxMV9yZXR1cm5fdHhxKGh3
LCB0eHEpOworCWllZWU4MDIxMV9yZXR1cm5fdHhxKGh3LCB0eHEsIHB1c2hlZCk7CiAJYXRoMTBr
X2h0dF90eF90eHFfdXBkYXRlKGh3LCB0eHEpOwogb3V0OgogCWllZWU4MDIxMV90eHFfc2NoZWR1
bGVfZW5kKGh3LCBhYyk7CmRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
OWsveG1pdC5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDlrL3htaXQuYwppbmRleCA2
YWFiMDY5MDllNzYuLjQwZmYwYmRiZjdjOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvYXRoL2F0aDlrL3htaXQuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoOWsv
eG1pdC5jCkBAIC0xMTcsNyArMTE3LDcgQEAgdm9pZCBhdGhfdHhfcXVldWVfdGlkKHN0cnVjdCBh
dGhfc29mdGMgKnNjLCBzdHJ1Y3QgYXRoX2F0eF90aWQgKnRpZCkKIAlzdHJ1Y3QgaWVlZTgwMjEx
X3R4cSAqcXVldWUgPSBjb250YWluZXJfb2YoCiAJCSh2b2lkICopdGlkLCBzdHJ1Y3QgaWVlZTgw
MjExX3R4cSwgZHJ2X3ByaXYpOwogCi0JaWVlZTgwMjExX3JldHVybl90eHEoc2MtPmh3LCBxdWV1
ZSk7CisJaWVlZTgwMjExX3JldHVybl90eHEoc2MtPmh3LCBxdWV1ZSwgZmFsc2UpOwogfQogCiB2
b2lkIGF0aDlrX3dha2VfdHhfcXVldWUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBp
ZWVlODAyMTFfdHhxICpxdWV1ZSkKQEAgLTE5MTMsNyArMTkxMyw3IEBAIHZvaWQgYXRoX3R4cV9z
Y2hlZHVsZShzdHJ1Y3QgYXRoX3NvZnRjICpzYywgc3RydWN0IGF0aF90eHEgKnR4cSkKIAkJcmV0
ID0gYXRoX3R4X3NjaGVkX2FnZ3Ioc2MsIHR4cSwgdGlkKTsKIAkJYXRoX2RiZyhjb21tb24sIFFV
RVVFLCAiYXRoX3R4X3NjaGVkX2FnZ3IgcmV0dXJuZWQgJWRcbiIsIHJldCk7CiAKLQkJaWVlZTgw
MjExX3JldHVybl90eHEoaHcsIHF1ZXVlKTsKKwkJaWVlZTgwMjExX3JldHVybl90eHEoaHcsIHF1
ZXVlLCBmYWxzZSk7CiAJfQogCiBvdXQ6CmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9tYWM4MDIx
MS5oIGIvaW5jbHVkZS9uZXQvbWFjODAyMTEuaAppbmRleCA5Y2FkZmE0MDhmNTAuLjk5NWUxOWUy
OWQ5ZSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvbWFjODAyMTEuaAorKysgYi9pbmNsdWRlL25l
dC9tYWM4MDIxMS5oCkBAIC02MTAyLDcgKzYxMDIsNyBAQCBzdHJ1Y3QgaWVlZTgwMjExX3R4cSAq
aWVlZTgwMjExX25leHRfdHhxKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1OCBhYyk7CiAgKiBT
aG91bGQgb25seSBiZSBjYWxsZWQgYmV0d2VlbiBjYWxscyB0byBpZWVlODAyMTFfdHhxX3NjaGVk
dWxlX3N0YXJ0KCkKICAqIGFuZCBpZWVlODAyMTFfdHhxX3NjaGVkdWxlX2VuZCgpLgogICovCi12
b2lkIGllZWU4MDIxMV9yZXR1cm5fdHhxKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCBzdHJ1Y3Qg
aWVlZTgwMjExX3R4cSAqdHhxKTsKK3ZvaWQgaWVlZTgwMjExX3JldHVybl90eHEoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcsIHN0cnVjdCBpZWVlODAyMTFfdHhxICp0eHFpLCBib29sIHRvX3RhaWwp
OwogCiAvKioKICAqIGllZWU4MDIxMV90eHFfc2NoZWR1bGVfc3RhcnQgLSBhY3F1aXJlIGxvY2tz
IGZvciBzYWZlIHNjaGVkdWxpbmcgb2YgYW4gQUMKZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS9k
cml2ZXItb3BzLmggYi9uZXQvbWFjODAyMTEvZHJpdmVyLW9wcy5oCmluZGV4IDM5ZGM0MGFjNWFi
ZS4uNTMwMjcwZjhjYzUyIDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvZHJpdmVyLW9wcy5oCisr
KyBiL25ldC9tYWM4MDIxMS9kcml2ZXItb3BzLmgKQEAgLTExNzUsNyArMTE3NSw3IEBAIHN0YXRp
YyBpbmxpbmUgdm9pZCBzY2hlZHVsZV9hbmRfd2FrZV90eHEoc3RydWN0IGllZWU4MDIxMV9sb2Nh
bCAqbG9jYWwsCiAJCQkJCSBzdHJ1Y3QgdHhxX2luZm8gKnR4cWkpCiB7CiAJc3Bpbl9sb2NrX2Jo
KCZsb2NhbC0+YWN0aXZlX3R4cV9sb2NrW3R4cWktPnR4cS5hY10pOwotCWllZWU4MDIxMV9yZXR1
cm5fdHhxKCZsb2NhbC0+aHcsICZ0eHFpLT50eHEpOworCWllZWU4MDIxMV9yZXR1cm5fdHhxKCZs
b2NhbC0+aHcsICZ0eHFpLT50eHEsIGZhbHNlKTsKIAlzcGluX3VubG9ja19iaCgmbG9jYWwtPmFj
dGl2ZV90eHFfbG9ja1t0eHFpLT50eHEuYWNdKTsKIAlkcnZfd2FrZV90eF9xdWV1ZShsb2NhbCwg
dHhxaSk7CiB9CmRpZmYgLS1naXQgYS9uZXQvbWFjODAyMTEvdHguYyBiL25ldC9tYWM4MDIxMS90
eC5jCmluZGV4IGQ4NjgyOTMwYTQ2OS4uYWNmMDUwNWJkZDdmIDEwMDY0NAotLS0gYS9uZXQvbWFj
ODAyMTEvdHguYworKysgYi9uZXQvbWFjODAyMTEvdHguYwpAQCAtMzYyMyw3ICszNjIzLDggQEAg
c3RydWN0IGllZWU4MDIxMV90eHEgKmllZWU4MDIxMV9uZXh0X3R4cShzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgdTggYWMpCiBFWFBPUlRfU1lNQk9MKGllZWU4MDIxMV9uZXh0X3R4cSk7CiAKIHZv
aWQgaWVlZTgwMjExX3JldHVybl90eHEoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsCi0JCQkgICAg
c3RydWN0IGllZWU4MDIxMV90eHEgKnR4cSkKKwkJCSAgc3RydWN0IGllZWU4MDIxMV90eHEgKnR4
cSwKKwkJCSAgYm9vbCB0b190YWlsKQogewogCXN0cnVjdCBpZWVlODAyMTFfbG9jYWwgKmxvY2Fs
ID0gaHdfdG9fbG9jYWwoaHcpOwogCXN0cnVjdCB0eHFfaW5mbyAqdHhxaSA9IHRvX3R4cV9pbmZv
KHR4cSk7CkBAIC0zNjQxLDcgKzM2NDIsNyBAQCB2b2lkIGllZWU4MDIxMV9yZXR1cm5fdHhxKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkgKi8KIAkJaWYgKHdpcGh5X2V4dF9mZWF0dXJlX2lz
c2V0KGxvY2FsLT5ody53aXBoeSwKIAkJCQkJICAgIE5MODAyMTFfRVhUX0ZFQVRVUkVfQUlSVElN
RV9GQUlSTkVTUykKLQkJICAgICYmIHR4cWktPnR4cS5zdGEpCisJCSAgICAmJiB0eHFpLT50eHEu
c3RhICYmICF0b190YWlsKQogCQkJbGlzdF9hZGQoJnR4cWktPnNjaGVkdWxlX29yZGVyLAogCQkJ
CSAmbG9jYWwtPmFjdGl2ZV90eHFzW3R4cS0+YWNdKTsKIAkJZWxzZQpAQCAtMzY1Miw3ICszNjUz
LDYgQEAgdm9pZCBpZWVlODAyMTFfcmV0dXJuX3R4cShzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywK
IH0KIEVYUE9SVF9TWU1CT0woaWVlZTgwMjExX3JldHVybl90eHEpOwogCi0jZGVmaW5lIElFRUU4
MDIxMV9UWFFfTUFZX1RYX1FVQU5UVU0gIDIwCiBib29sIGllZWU4MDIxMV90eHFfbWF5X3RyYW5z
bWl0KHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LAogCQkJCXN0cnVjdCBpZWVlODAyMTFfdHhxICp0
eHEpCiB7CkBAIC0zNjcwLDEzICszNjcwLDggQEAgYm9vbCBpZWVlODAyMTFfdHhxX21heV90cmFu
c21pdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIAlpZiAoc3RhLT5haXJ0aW1lW2FjXS5kZWZp
Y2l0ID49IDApCiAJCWdvdG8gb3V0OwogCi0JbGlzdF9mb3JfZWFjaF9lbnRyeSh0eHFpLCAmbG9j
YWwtPmFjdGl2ZV90eHFzW2FjXSwgc2NoZWR1bGVfb3JkZXIpIHsKLQkJaWYgKCF0eHFpLT50eHEu
c3RhKQotCQkJY29udGludWU7Ci0JCXN0YSA9IGNvbnRhaW5lcl9vZih0eHFpLT50eHEuc3RhLCBz
dHJ1Y3Qgc3RhX2luZm8sIHN0YSk7Ci0JCXN0YS0+YWlydGltZVthY10uZGVmaWNpdCArPQotCQkJ
KElFRUU4MDIxMV9UWFFfTUFZX1RYX1FVQU5UVU0gKiBzdGEtPmFpcnRpbWVfd2VpZ2h0KTsKLQl9
CisJc3RhLT5haXJ0aW1lW2FjXS5kZWZpY2l0ICs9IHN0YS0+YWlydGltZV93ZWlnaHQ7CisJbGlz
dF9tb3ZlX3RhaWwoJnR4cWktPnNjaGVkdWxlX29yZGVyLCAmbG9jYWwtPmFjdGl2ZV90eHFzW2Fj
XSk7CiAKIAlyZXR1cm4gZmFsc2U7CiAK
--=_bf38c64788d529c390b4e5246d7aa35a--
