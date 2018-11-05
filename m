Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E65F0C0044C
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:39:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8F81F20862
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 08:39:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="MOuieA+q";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="XBnF09r/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8F81F20862
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbeKER57 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 12:57:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43188 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbeKER57 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 12:57:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4A5B96074C; Mon,  5 Nov 2018 08:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541407164;
        bh=TcMS4/GShFEQlHiIN/LcvJVvk2jGbtvxDSi0pPNm9CE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MOuieA+q9eN3mYPhv3MYzYyLmQowVPQqANDITHDbT6ogEmq0PjlqvXhQNlyBk9DXx
         bBk4yt5eRd9gPg6ZFbx0U6NyoD8RpmesZdYsQ3R+jhfFh/9Ezphu6N2+fxle5RkKoj
         odtlXv6lGqQayuuJpug25ymsdM9zNQPp8z5FFIUc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AF3256053D;
        Mon,  5 Nov 2018 08:39:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541407163;
        bh=TcMS4/GShFEQlHiIN/LcvJVvk2jGbtvxDSi0pPNm9CE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XBnF09r/9KlB3LfgOu41L+XNTNtAnA9ZWY5biGYMms0sw/6Yswt4KIZcpGY/a3uE8
         t4fsikal8w9YwD9emCqECIPaOS2oUUJTz518t85aLOV1fG30P43+JGLcYSXjDKjkFc
         AXkWlepUZHNhnhXU8QqkrVOcfui7kiqcLNIYjSQQ=
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="=_a753dfe68d970f93e2816b28d5c38b19"
Date:   Mon, 05 Nov 2018 00:39:23 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
In-Reply-To: <87h8gzpy9t.fsf@toke.dk>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
 <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
 <87woq2843q.fsf@toke.dk> <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org>
 <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org> <87h8gzpy9t.fsf@toke.dk>
Message-ID: <10b644b6c7f436a892e3e9f4fd5e179d@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--=_a753dfe68d970f93e2816b28d5c38b19
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8;
 format=flowed

On 2018-11-02 03:30, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> On 2018-10-28 15:01, Rajkumar Manoharan wrote:
>>> On 2018-10-28 08:48, Toke Høiland-Jørgensen wrote:
>>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>> 
>>>>> 
>>>>> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>>>>> 
>>>>> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)
>>>> 
>>>> So this looks like it's doing *something*, but not like it's
>>>> succeeding
>>>> in achieving the set percentages. Did you check if the actual 
>>>> airtime
>>>> values (in debugfs) corresponds to the configured weights?
>>>> 
>>> No. Will check that.
>>> 
>> Toke,
>> 
>>  From above results, different airtime for each station is reflecting 
>> on
>> output performance. Unfortunately I don't see such tput difference, 
>> when
>> the tx mode is fixed in push-only. Even low weight station is giving
>> same
>> performance. Are you also seeing the same behavior in your setup? 
>> Could
>> you please share your results?
> 
> Sorry, I've been travelling this week; I'll be back in the office next
> week and can run some tests then. I may also have an idea for a
> different algorithm that will work better in pull mode, but need to see
> if it works at all first :)
> 
Wow... :)

Meanwhile we did some more experiments with both modes. The experiment 
was
done in open environment and fixed rate and UDP traffic ran for 60 
seconds.

Seems like push mode not honoring the configured weight. Always the 
airtime
was almost same whereas in pull-mode airtime is changing based on 
configured
weight. Hence I would like to know your results.

		sta1		sta2		sta3		sta4
pull-mode	8s(205us)	18s(3.2ms)	8s(205us)	14s(410us)
		12s(256us)	12s(256us)	13s(256us)	12s(256us)
		14s(4ms)	13s(4ms)	14s(4ms)	13s(4ms)

push-mode	15s(205us)	12s(3.2ms)	16s(205us)	12s(410us)
		15s(256us)	12s(256us)	16s(256us)	12s(256us)
		14s(4ms)	13s(4ms)	16s(4ms)	12s(4ms)


> How do I force ath10k into push mode?
> 
Attaching the change to fix push mode.

-Rajkumar
--=_a753dfe68d970f93e2816b28d5c38b19
Content-Transfer-Encoding: base64
Content-Type: text/x-diff;
 name=push-only.patch
Content-Disposition: attachment;
 filename=push-only.patch;
 size=2239

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvY29yZS5jIGIvZHJp
dmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0aDEway9jb3JlLmMKaW5kZXggYzhkYmJmYTkwMWFmLi4x
OTgxZTBlYThjN2UgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsv
Y29yZS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvY29yZS5jCkBAIC00
MSw2ICs0MSw3IEBACiBzdGF0aWMgYm9vbCB1YXJ0X3ByaW50Owogc3RhdGljIGJvb2wgc2tpcF9v
dHA7CiBzdGF0aWMgYm9vbCByYXdtb2RlOworYm9vbCBwZWVyX2Zsb3dfY3RsID0gZmFsc2U7CiAK
IHVuc2lnbmVkIGxvbmcgYXRoMTBrX2NvcmVkdW1wX21hc2sgPSBCSVQoQVRIMTBLX0ZXX0NSQVNI
X0RVTVBfUkVHSVNURVJTKSB8CiAJCQkJICAgICBCSVQoQVRIMTBLX0ZXX0NSQVNIX0RVTVBfQ0Vf
REFUQSk7CkBAIC01Miw2ICs1Myw3IEBACiBtb2R1bGVfcGFyYW0oc2tpcF9vdHAsIGJvb2wsIDA2
NDQpOwogbW9kdWxlX3BhcmFtKHJhd21vZGUsIGJvb2wsIDA2NDQpOwogbW9kdWxlX3BhcmFtX25h
bWVkKGNvcmVkdW1wX21hc2ssIGF0aDEwa19jb3JlZHVtcF9tYXNrLCB1bG9uZywgMDQ0NCk7Citt
b2R1bGVfcGFyYW0ocGVlcl9mbG93X2N0bCwgYm9vbCwgMDY0NCk7CiAKIE1PRFVMRV9QQVJNX0RF
U0MoZGVidWdfbWFzaywgIkRlYnVnZ2luZyBtYXNrIik7CiBNT0RVTEVfUEFSTV9ERVNDKHVhcnRf
cHJpbnQsICJVYXJ0IHRhcmdldCBkZWJ1Z2dpbmciKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGgxMGsvY29yZS5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvYXRoL2F0
aDEway9jb3JlLmgKaW5kZXggZTZmNTk3ZDlmMjI2Li5iZjJlNzA0MTFkOTAgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvY29yZS5oCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGgxMGsvY29yZS5oCkBAIC0xMjAxLDYgKzEyMDEsNyBAQCBzdGF0aWMg
aW5saW5lIGJvb2wgYXRoMTBrX3BlZXJfc3RhdHNfZW5hYmxlZChzdHJ1Y3QgYXRoMTBrICphcikK
IH0KIAogZXh0ZXJuIHVuc2lnbmVkIGxvbmcgYXRoMTBrX2NvcmVkdW1wX21hc2s7CitleHRlcm4g
Ym9vbCBwZWVyX2Zsb3dfY3RsOwogCiBzdHJ1Y3QgYXRoMTBrICphdGgxMGtfY29yZV9jcmVhdGUo
c2l6ZV90IHByaXZfc2l6ZSwgc3RydWN0IGRldmljZSAqZGV2LAogCQkJCSAgZW51bSBhdGgxMGtf
YnVzIGJ1cywKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvbWFj
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL21hYy5jCmluZGV4IGQ3NGI1NWJh
OTkxNC4uZDVhZDg4Yjg1YjY5IDEwMDY0NAotLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoMTBrL21hYy5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvbWFjLmMK
QEAgLTIxNiw2ICsyMTYsOSBAQCBpbnQgYXRoMTBrX21hY19leHRfcmVzb3VyY2VfY29uZmlnKHN0
cnVjdCBhdGgxMGsgKmFyLCB1MzIgdmFsKQogCWVsc2UKIAkJcGxhdGZvcm1fdHlwZSA9IFdNSV9I
T1NUX1BMQVRGT1JNX0hJR0hfUEVSRjsKIAorCWlmICghcGVlcl9mbG93X2N0bCkKKwkJcGxhdGZv
cm1fdHlwZSA9IFdNSV9IT1NUX1BMQVRGT1JNX0xPV19QRVJGX05PX0ZFVENIOworCiAJcmV0ID0g
YXRoMTBrX3dtaV9leHRfcmVzb3VyY2VfY29uZmlnKGFyLCBwbGF0Zm9ybV90eXBlLCB2YWwpOwog
CiAJaWYgKHJldCAmJiByZXQgIT0gLUVPUE5PVFNVUFApIHsKZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLmggYi9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgv
YXRoMTBrL3dtaS5oCmluZGV4IGY3YmFkZDA3OTA1MS4uNjk1OGQ0ZjU4YTIxIDEwMDY0NAotLS0g
YS9kcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTBrL3dtaS5oCisrKyBiL2RyaXZlcnMvbmV0
L3dpcmVsZXNzL2F0aC9hdGgxMGsvd21pLmgKQEAgLTcxMjgsNiArNzEyOCw3IEBAIHN0cnVjdCB3
bWlfcG5vX3NjYW5fcmVxIHsKIGVudW0gd21pX2hvc3RfcGxhdGZvcm1fdHlwZSB7CiAJV01JX0hP
U1RfUExBVEZPUk1fSElHSF9QRVJGLAogCVdNSV9IT1NUX1BMQVRGT1JNX0xPV19QRVJGLAorCVdN
SV9IT1NUX1BMQVRGT1JNX0xPV19QRVJGX05PX0ZFVENILAogfTsKIAogZW51bSB3bWlfYnNzX3N1
cnZleV9yZXFfdHlwZSB7Cg==
--=_a753dfe68d970f93e2816b28d5c38b19--
