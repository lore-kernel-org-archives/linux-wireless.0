Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0AAC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E3862172C
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 09:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NE5Iy+7A";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iLYVwqp+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E3862172C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729124AbeI1Pug (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 11:50:36 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:32812 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729008AbeI1Puf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 11:50:35 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EA59560274; Fri, 28 Sep 2018 09:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538126862;
        bh=SRZMccSf4G8aO1yeeWBIuVoDZWokz53mFTIt3+Q5ukw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NE5Iy+7AhQz3B4QQOtDf3+jW3n1Q1djIyoB6ua0ST+SXvE1XT/6uzU5lpv5jCgbqR
         kMFnYE3bIJjIThGEftOKVs8UhbvVeGPxWH+xDDlZ/PDwNPzfu8QGV7VWdFK7t4ylGj
         ZpjTSCOF3I97DKNClal3UKpJ35S9oskVaMbqbXSc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id BB28460274;
        Fri, 28 Sep 2018 09:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538126861;
        bh=SRZMccSf4G8aO1yeeWBIuVoDZWokz53mFTIt3+Q5ukw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iLYVwqp+/vpSZRbU4GG+g/x3cGkvQnBG1Z/ESFGRd6xNln6ZphFCEESpNPbGTNr+u
         LDCuxAqdjAFa7EBoKhWgT/urxEFjk0gDu0rDdPjYsA0OZ3RDu93l6u/4eFlLhhLx94
         PcG9Ij30QLXAVUgZd2QjykVnyooLNSFHO1++4NSo=
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_8e33ba183c13be09445629d1ed30ac4e"
Date:   Fri, 28 Sep 2018 02:27:41 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v4 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
 <153711973134.9231.18038849900399644494.stgit@alrua-x1.karlstad.toke.dk>
 <826b6251746ee4d280d532f4ecdc5aa3@codeaurora.org> <87pnx0haud.fsf@toke.dk>
 <8f7145bf5abe50194bced025a5e739b9@codeaurora.org>
 <863bc54fbf04441d38dd53f523300a7e@codeaurora.org>
 <93015743-5D16-4D79-948F-E2F46CF2450A@toke.dk>
Message-ID: <7ba8513b0ec5a7c35b396c7739fc2d7d@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--=_8e33ba183c13be09445629d1ed30ac4e
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

On 2018-09-28 00:51, Toke Høiland-Jørgensen wrote:
> On 28 September 2018 07:29:03 CEST, Rajkumar Manoharan
> <rmanohar@codeaurora.org> wrote:
>> On 2018-09-26 17:09, Rajkumar Manoharan wrote:
>>> On 2018-09-26 02:22, Toke Høiland-Jørgensen wrote:
>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>> 
>>> :( Yeah... I got confused with attached soft lockup in ARM platform.
>>> 
>> Toke,
>> 
>> Cause for the soft lockup exposed in multi client scenario is due to
>> mixed order of fq_lock and active_txqs_lock. In wake_tx_queue or
>> push_pending
>> case, driver acquires active_txq_lock first by schedule_start and
>> followed by
>> fq_lock in tx_dequeue. The same order should be maintained in sta
>> cleanup.
>> Below change fixed the issue.
> 
> Ah, great find! I'll fold this into the next version, thanks!
> 

One more thing. As I mentioned earlier, scheduling wake_txqs_tasklet
is heavy load and causing random rcu stall issue. Hence I added
another API to schedule throttled txqs once for all. Also I did
a cleanup in kick_airtime by traversing list only once. With these
changes I don't see rcu stall issue. Please review and fold them as 
well.

-Rajkumar


single_iter - clean up kick_airtime
sched_throttle - new API and separate tasklet for throttled txqs
--=_8e33ba183c13be09445629d1ed30ac4e
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=single_iter.patch
Content-Disposition: attachment;
 filename=single_iter.patch;
 size=1700

ZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS91dGlsLmMgYi9uZXQvbWFjODAyMTEvdXRpbC5jCmlu
ZGV4IDQwNGM1ZTgyZTRjYS4uMDIzYmM4MWJkNGEwIDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEv
dXRpbC5jCisrKyBiL25ldC9tYWM4MDIxMS91dGlsLmMKQEAgLTI0MiwxMyArMjQyLDExIEBAIEVY
UE9SVF9TWU1CT0woaWVlZTgwMjExX2N0c3Rvc2VsZl9kdXJhdGlvbik7CiAKIHN0YXRpYyB2b2lk
IF9faWVlZTgwMjExX2tpY2tfYWlydGltZShzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCwg
aW50IGFjKQogewotCWJvb2wgc2Vlbl9lbGlnaWJsZSA9IGZhbHNlOwogCXN0cnVjdCB0eHFfaW5m
byAqdHhxaTsKIAlzdHJ1Y3Qgc3RhX2luZm8gKnN0YTsKIAogCXNwaW5fbG9ja19iaCgmbG9jYWwt
PmFjdGl2ZV90eHFfbG9ja1thY10pOwogCi0gYmVnaW46CiAJaWYgKGxpc3RfZW1wdHkoJmxvY2Fs
LT5hY3RpdmVfdHhxc1thY10pKQogCQlnb3RvIG91dDsKIApAQCAtMjU4LDEyICsyNTYsMTIgQEAg
c3RhdGljIHZvaWQgX19pZWVlODAyMTFfa2lja19haXJ0aW1lKHN0cnVjdCBpZWVlODAyMTFfbG9j
YWwgKmxvY2FsLCBpbnQgYWMpCiAKIAkJc3RhID0gY29udGFpbmVyX29mKHR4cWktPnR4cS5zdGEs
IHN0cnVjdCBzdGFfaW5mbywgc3RhKTsKIAotCQlpZiAoc3RhLT5haXJ0aW1lW2FjXS5kZWZpY2l0
ID49IDApIHsKLQkJCXNlZW5fZWxpZ2libGUgPSB0cnVlOwotCi0JCQlpZiAoIXRlc3RfYW5kX2Ns
ZWFyX2JpdChJRUVFODAyMTFfVFhRX0FJUlRJTUVfVEhST1RUTEUsCi0JCQkJCQkmdHhxaS0+Zmxh
Z3MpKQorCQlpZiAodGVzdF9iaXQoSUVFRTgwMjExX1RYUV9BSVJUSU1FX1RIUk9UVExFLCAmdHhx
aS0+ZmxhZ3MpKSB7CisJCQljbGVhcl9iaXQoSUVFRTgwMjExX1RYUV9BSVJUSU1FX1RIUk9UVExF
LCAmdHhxaS0+ZmxhZ3MpOworCQkJaWYgKHN0YS0+YWlydGltZVthY10uZGVmaWNpdCA8IDApIHsK
KwkJCQlzdGEtPmFpcnRpbWVbYWNdLmRlZmljaXQgKz0gc3RhLT5haXJ0aW1lX3dlaWdodDsKIAkJ
CQljb250aW51ZTsKKwkJCX0KIAogCQkJc3Bpbl91bmxvY2tfYmgoJmxvY2FsLT5hY3RpdmVfdHhx
X2xvY2tbYWNdKTsKIAkJCWRydl93YWtlX3R4X3F1ZXVlKGxvY2FsLCB0eHFpKTsKQEAgLTI3MSwy
MSArMjY5LDYgQEAgc3RhdGljIHZvaWQgX19pZWVlODAyMTFfa2lja19haXJ0aW1lKHN0cnVjdCBp
ZWVlODAyMTFfbG9jYWwgKmxvY2FsLCBpbnQgYWMpCiAJCX0KIAl9CiAKLQkvKiBObyBhY3RpdmUg
cXVldWVzIGhhdmUgcG9zaXRpdmUgZGVmaWNpdCwgd2hpY2ggbWVhbnMgVFggaXMgc3R1Y2s7Ci0J
ICogaW5jcmVhc2UgYWxsIGRlZmljaXRzIHRvIGdldCB0aGluZ3MgdW5zdHVjay4KLQkgKi8KLQlp
ZiAoIXNlZW5fZWxpZ2libGUpIHsKLQkJbGlzdF9mb3JfZWFjaF9lbnRyeSh0eHFpLCAmbG9jYWwt
PmFjdGl2ZV90eHFzW2FjXSwgc2NoZWR1bGVfb3JkZXIpIHsKLQkJCWlmICghdHhxaS0+dHhxLnN0
YSkKLQkJCQljb250aW51ZTsKLQotCQkJc3RhID0gY29udGFpbmVyX29mKHR4cWktPnR4cS5zdGEs
IHN0cnVjdCBzdGFfaW5mbywgc3RhKTsKLQotCQkJc3RhLT5haXJ0aW1lW2FjXS5kZWZpY2l0ICs9
IHN0YS0+YWlydGltZV93ZWlnaHQ7Ci0JCX0KLQotCQlnb3RvIGJlZ2luOwotCX0KICBvdXQ6CiAJ
c3Bpbl91bmxvY2tfYmgoJmxvY2FsLT5hY3RpdmVfdHhxX2xvY2tbYWNdKTsKIAo=
--=_8e33ba183c13be09445629d1ed30ac4e
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=sched_throttle.patch
Content-Disposition: attachment;
 filename=sched_throttle.patch;
 size=4772

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvaHR0X3J4LmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL2h0dF9yeC5jCmluZGV4IDYyNWE0YWIzN2Vh
MC4uYjFiYjM2OWIwOTcxIDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRo
MTBrL2h0dF9yeC5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvaHR0X3J4
LmMKQEAgLTIzNjIsNiArMjM2Miw3IEBAIHN0YXRpYyB2b2lkIGF0aDEwa19odHRfcnhfdHhfZmV0
Y2hfaW5kKHN0cnVjdCBhdGgxMGsgKmFyLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQogCX0KIAogCXJj
dV9yZWFkX3VubG9jaygpOworCWllZWU4MDIxMV90eHFfc2NoZWR1bGVfdGhyb3R0bGVkKGh3KTsK
IAogCXJlc3BfaWRzID0gYXRoMTBrX2h0dF9nZXRfdHhfZmV0Y2hfaW5kX3Jlc3BfaWRzKCZyZXNw
LT50eF9mZXRjaF9pbmQpOwogCWF0aDEwa19odHRfcnhfdHhfZmV0Y2hfcmVzcF9pZF9jb25maXJt
KGFyLCByZXNwX2lkcywgbnVtX3Jlc3BfaWRzKTsKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L21h
YzgwMjExLmggYi9pbmNsdWRlL25ldC9tYWM4MDIxMS5oCmluZGV4IDUwYzEwODJjODZkMy4uODEw
MTkzNmE5YzljIDEwMDY0NAotLS0gYS9pbmNsdWRlL25ldC9tYWM4MDIxMS5oCisrKyBiL2luY2x1
ZGUvbmV0L21hYzgwMjExLmgKQEAgLTYxMjQsNiArNjEyNCw3IEBAIHZvaWQgaWVlZTgwMjExX3R4
cV9zY2hlZHVsZV9zdGFydChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywgdTggYWMpOwogICovCiB2
b2lkIGllZWU4MDIxMV90eHFfc2NoZWR1bGVfZW5kKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1
OCBhYyk7CiAKK3ZvaWQgaWVlZTgwMjExX3R4cV9zY2hlZHVsZV90aHJvdHRsZWQoc3RydWN0IGll
ZWU4MDIxMV9odyAqaHcpOwogLyoqCiAgKiBpZWVlODAyMTFfdHhxX21heV90cmFuc21pdCAtIGNo
ZWNrIHdoZXRoZXIgVFhRIGlzIGFsbG93ZWQgdG8gdHJhbnNtaXQKICAqCmRpZmYgLS1naXQgYS9u
ZXQvbWFjODAyMTEvaWVlZTgwMjExX2kuaCBiL25ldC9tYWM4MDIxMS9pZWVlODAyMTFfaS5oCmlu
ZGV4IGMxMzhiOWQ0NzQ1My4uMzI5ZWJkMmUxNTk0IDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEv
aWVlZTgwMjExX2kuaAorKysgYi9uZXQvbWFjODAyMTEvaWVlZTgwMjExX2kuaApAQCAtMTI1NCw2
ICsxMjU0LDcgQEAgc3RydWN0IGllZWU4MDIxMV9sb2NhbCB7CiAJc3RydWN0IHNrX2J1ZmZfaGVh
ZCBwZW5kaW5nW0lFRUU4MDIxMV9NQVhfUVVFVUVTXTsKIAlzdHJ1Y3QgdGFza2xldF9zdHJ1Y3Qg
dHhfcGVuZGluZ190YXNrbGV0OwogCXN0cnVjdCB0YXNrbGV0X3N0cnVjdCB3YWtlX3R4cXNfdGFz
a2xldDsKKwlzdHJ1Y3QgdGFza2xldF9zdHJ1Y3Qga2lja19haXJ0aW1lOwogCiAJYXRvbWljX3Qg
YWdnX3F1ZXVlX3N0b3BbSUVFRTgwMjExX01BWF9RVUVVRVNdOwogCkBAIC0yMDY4LDYgKzIwNjks
NyBAQCB2b2lkIGllZWU4MDIxMV90eHFfcHVyZ2Uoc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9j
YWwsCiB2b2lkIGllZWU4MDIxMV90eHFfcmVtb3ZlX3ZsYW4oc3RydWN0IGllZWU4MDIxMV9sb2Nh
bCAqbG9jYWwsCiAJCQkgICAgICAgc3RydWN0IGllZWU4MDIxMV9zdWJfaWZfZGF0YSAqc2RhdGEp
Owogdm9pZCBpZWVlODAyMTFfd2FrZV90eHFzKHVuc2lnbmVkIGxvbmcgZGF0YSk7Cit2b2lkIGll
ZWU4MDIxMV9raWNrX2FpcnRpbWUodW5zaWduZWQgbG9uZyBkYXRhKTsKIHZvaWQgaWVlZTgwMjEx
X3NlbmRfYXV0aChzdHJ1Y3QgaWVlZTgwMjExX3N1Yl9pZl9kYXRhICpzZGF0YSwKIAkJCSB1MTYg
dHJhbnNhY3Rpb24sIHUxNiBhdXRoX2FsZywgdTE2IHN0YXR1cywKIAkJCSBjb25zdCB1OCAqZXh0
cmEsIHNpemVfdCBleHRyYV9sZW4sIGNvbnN0IHU4ICpic3NpZCwKZGlmZiAtLWdpdCBhL25ldC9t
YWM4MDIxMS9tYWluLmMgYi9uZXQvbWFjODAyMTEvbWFpbi5jCmluZGV4IGM0YzNmZWFlYTMzNi4u
ZjI3NzJkMTVhNTQxIDEwMDY0NAotLS0gYS9uZXQvbWFjODAyMTEvbWFpbi5jCisrKyBiL25ldC9t
YWM4MDIxMS9tYWluLmMKQEAgLTY3NSw5ICs2NzUsMTIgQEAgc3RydWN0IGllZWU4MDIxMV9odyAq
aWVlZTgwMjExX2FsbG9jX2h3X25tKHNpemVfdCBwcml2X2RhdGFfbGVuLAogCXRhc2tsZXRfaW5p
dCgmbG9jYWwtPnR4X3BlbmRpbmdfdGFza2xldCwgaWVlZTgwMjExX3R4X3BlbmRpbmcsCiAJCSAg
ICAgKHVuc2lnbmVkIGxvbmcpbG9jYWwpOwogCi0JaWYgKG9wcy0+d2FrZV90eF9xdWV1ZSkKKwlp
ZiAob3BzLT53YWtlX3R4X3F1ZXVlKSB7CiAJCXRhc2tsZXRfaW5pdCgmbG9jYWwtPndha2VfdHhx
c190YXNrbGV0LCBpZWVlODAyMTFfd2FrZV90eHFzLAogCQkJICAgICAodW5zaWduZWQgbG9uZyls
b2NhbCk7CisJCXRhc2tsZXRfaW5pdCgmbG9jYWwtPmtpY2tfYWlydGltZSwgaWVlZTgwMjExX2tp
Y2tfYWlydGltZSwKKwkJCSAgICAgKHVuc2lnbmVkIGxvbmcpbG9jYWwpOworCX0KIAogCXRhc2ts
ZXRfaW5pdCgmbG9jYWwtPnRhc2tsZXQsCiAJCSAgICAgaWVlZTgwMjExX3Rhc2tsZXRfaGFuZGxl
ciwKZGlmZiAtLWdpdCBhL25ldC9tYWM4MDIxMS90eC5jIGIvbmV0L21hYzgwMjExL3R4LmMKaW5k
ZXggNWQ3MGY2NGEyMDVjLi43MzI4N2Y1ZWVkZDggMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS90
eC5jCisrKyBiL25ldC9tYWM4MDIxMS90eC5jCkBAIC0zNjk2LDYgKzM2OTYsMTQgQEAgYm9vbCBp
ZWVlODAyMTFfdHhxX21heV90cmFuc21pdChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpodywKIH0KIEVY
UE9SVF9TWU1CT0woaWVlZTgwMjExX3R4cV9tYXlfdHJhbnNtaXQpOwogCit2b2lkIGllZWU4MDIx
MV90eHFfc2NoZWR1bGVfdGhyb3R0bGVkKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3KQoreworCXN0
cnVjdCBpZWVlODAyMTFfbG9jYWwgKmxvY2FsID0gaHdfdG9fbG9jYWwoaHcpOworCisJdGFza2xl
dF9zY2hlZHVsZSgmbG9jYWwtPndha2VfdHhxc190YXNrbGV0KTsKK30KK0VYUE9SVF9TWU1CT0wo
aWVlZTgwMjExX3R4cV9zY2hlZHVsZV90aHJvdHRsZWQpOworCiB2b2lkIGllZWU4MDIxMV90eHFf
c2NoZWR1bGVfc3RhcnQoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IGFjKQogewogCXN0cnVj
dCBpZWVlODAyMTFfbG9jYWwgKmxvY2FsID0gaHdfdG9fbG9jYWwoaHcpOwpAQCAtMzcxMCw3ICsz
NzE4LDYgQEAgdm9pZCBpZWVlODAyMTFfdHhxX3NjaGVkdWxlX2VuZChzdHJ1Y3QgaWVlZTgwMjEx
X2h3ICpodywgdTggYWMpCiAJc3RydWN0IGllZWU4MDIxMV9sb2NhbCAqbG9jYWwgPSBod190b19s
b2NhbChodyk7CiAKIAlzcGluX3VubG9ja19iaCgmbG9jYWwtPmFjdGl2ZV90eHFfbG9ja1thY10p
OwotCXRhc2tsZXRfc2NoZWR1bGUoJmxvY2FsLT53YWtlX3R4cXNfdGFza2xldCk7CiB9CiBFWFBP
UlRfU1lNQk9MKGllZWU4MDIxMV90eHFfc2NoZWR1bGVfZW5kKTsKIApkaWZmIC0tZ2l0IGEvbmV0
L21hYzgwMjExL3V0aWwuYyBiL25ldC9tYWM4MDIxMS91dGlsLmMKaW5kZXggMDIzYmM4MWJkNGEw
Li42OWZjM2M3MjNhZGQgMTAwNjQ0Ci0tLSBhL25ldC9tYWM4MDIxMS91dGlsLmMKKysrIGIvbmV0
L21hYzgwMjExL3V0aWwuYwpAQCAtMjQ2LDYgKzI0Niw3IEBAIHN0YXRpYyB2b2lkIF9faWVlZTgw
MjExX2tpY2tfYWlydGltZShzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICpsb2NhbCwgaW50IGFjKQog
CXN0cnVjdCBzdGFfaW5mbyAqc3RhOwogCiAJc3Bpbl9sb2NrX2JoKCZsb2NhbC0+YWN0aXZlX3R4
cV9sb2NrW2FjXSk7CisJcmN1X3JlYWRfbG9jaygpOwogCiAJaWYgKGxpc3RfZW1wdHkoJmxvY2Fs
LT5hY3RpdmVfdHhxc1thY10pKQogCQlnb3RvIG91dDsKQEAgLTI3MCw2ICsyNzEsNyBAQCBzdGF0
aWMgdm9pZCBfX2llZWU4MDIxMV9raWNrX2FpcnRpbWUoc3RydWN0IGllZWU4MDIxMV9sb2NhbCAq
bG9jYWwsIGludCBhYykKIAl9CiAKICBvdXQ6CisJcmN1X3JlYWRfdW5sb2NrKCk7CiAJc3Bpbl91
bmxvY2tfYmgoJmxvY2FsLT5hY3RpdmVfdHhxX2xvY2tbYWNdKTsKIAogfQpAQCAtMjg0LDEwICsy
ODYsNiBAQCBzdGF0aWMgdm9pZCBfX2llZWU4MDIxMV93YWtlX3R4cXMoc3RydWN0IGllZWU4MDIx
MV9zdWJfaWZfZGF0YSAqc2RhdGEsIGludCBhYykKIAlzdHJ1Y3Qgc3RhX2luZm8gKnN0YTsKIAlp
bnQgaTsKIAotCWlmICh3aXBoeV9leHRfZmVhdHVyZV9pc3NldChsb2NhbC0+aHcud2lwaHksCi0J
CQkJICAgIE5MODAyMTFfRVhUX0ZFQVRVUkVfQUlSVElNRV9GQUlSTkVTUykpCi0JICAgIF9faWVl
ZTgwMjExX2tpY2tfYWlydGltZShsb2NhbCwgYWMpOwotCiAJc3Bpbl9sb2NrX2JoKCZmcS0+bG9j
ayk7CiAKIAlpZiAoc2RhdGEtPnZpZi50eXBlID09IE5MODAyMTFfSUZUWVBFX0FQKQpAQCAtMzM0
LDYgKzMzMiwxNSBAQCBvdXQ6CiAJc3Bpbl91bmxvY2tfYmgoJmZxLT5sb2NrKTsKIH0KIAordm9p
ZCBpZWVlODAyMTFfa2lja19haXJ0aW1lKHVuc2lnbmVkIGxvbmcgZGF0YSkKK3sKKwlzdHJ1Y3Qg
aWVlZTgwMjExX2xvY2FsICpsb2NhbCA9IChzdHJ1Y3QgaWVlZTgwMjExX2xvY2FsICopZGF0YTsK
KwlpbnQgaTsKKworCWZvciAoaSA9IDA7IGkgPCBJRUVFODAyMTFfTlVNX0FDUzsgaSsrKQorCQlf
X2llZWU4MDIxMV9raWNrX2FpcnRpbWUobG9jYWwsIGkpOworfQorCiB2b2lkIGllZWU4MDIxMV93
YWtlX3R4cXModW5zaWduZWQgbG9uZyBkYXRhKQogewogCXN0cnVjdCBpZWVlODAyMTFfbG9jYWwg
KmxvY2FsID0gKHN0cnVjdCBpZWVlODAyMTFfbG9jYWwgKilkYXRhOwo=
--=_8e33ba183c13be09445629d1ed30ac4e--
