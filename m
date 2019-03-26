Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B555C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 10:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F77620857
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 10:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="eHWQg6j3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731148AbfCZKlo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 06:41:44 -0400
Received: from nbd.name ([46.4.11.11]:46608 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbfCZKln (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 06:41:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=AvSTDuySwxkxW60B9eCqqTCC6u1BlFAFAMP7C3TVTLU=; b=eHWQg6j3y1uHk3uMGPlHnDMM7u
        YRgz4c3MMHSyEYbrQtpISKnSYVSXxPYVJaE53bxvQNHn+4DRg1APmnGXR73iGwgJ5m1TvIkySlpAe
        srtESEL1Z/0NioWW9AZSlEgX42E3scBzIfCE4LgaLuSLNK59osXMtKlpsTrz86LdqN/E=;
Received: from p4ff13338.dip0.t-ipconnect.de ([79.241.51.56] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1h8jWU-00029b-UK; Tue, 26 Mar 2019 11:41:39 +0100
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
To:     Tom Psyborg <pozega.tomislav@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com>
 <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
 <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
 <20190313140607.GE2003@redhat.com>
 <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 mQGiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwbQcRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPohgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQuQINBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabiEkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <977a3cf4-3ec5-4aaa-b3d4-eea2e8593652@nbd.name>
Date:   Tue, 26 Mar 2019 11:41:37 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <CAKR_QV+gEJEE2+hwfE1wsF5mdEZVDGtNskivcpFUutGEbwKyKg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-13 15:41, Tom Psyborg wrote:
> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> On Wed, Mar 13, 2019 at 02:48:01PM +0100, Tom Psyborg wrote:
>>> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>> > On Wed, Mar 13, 2019 at 02:02:32PM +0100, Tom Psyborg wrote:
>>> >> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>>> >> > On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Požega wrote:
>>> >> >> MFP can work with enabled HW crypt engine, but in this case
>>> >> >> available bandwidth is reduced at least when connecting to
>>> >> >> Archer C7 (QCA9558). Enable the feature for known to work chipsets-
>>> >> >> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
>>> >> >> default to 0 in order to prevent unintentional bandwidth drop.
>>> >> >>
>>> >> >> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
>>> >> >> ---
>>> >> >>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
>>> >> >>  1 files changed, 7 insertions(+), 4 deletions(-)
>>> >> >>
>>> >> >> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> >> >> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> >> >> index a03b528..bb8204d 100644
>>> >> >> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> >> >> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>>> >> >> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct
>>> >> >> rt2x00_dev
>>> >> >> *rt2x00dev)
>>> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>>> >> >>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
>>> >> >>
>>> >> >> +	/* Experimental: Set MFP with HW crypto enabled. */
>>> >> >> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390)
>>> >> >> ||
>>> >> >> +	    rt2x00_rt(rt2x00dev, RT6352))
>>> >> >> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
>>> >> >
>>> >> > Is not that we support MFP in hardware. We just return -EOPNOTSUPP
>>> >> > in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
>>> >> > (since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
>>> >> > we fallback to software encryption.
>>> >> >
>>> >> > Please repost patch that enable MFP unconditionally with
>>> >> > 'Cc: stable@vger.kernel.org' tag.
>>> >> >
>>> >> > Stanislaw
>>> >> >
>>> >>
>>> >> No, I have not test any other chipsets besides the ones I enabled it
>>> >> for. It is possible this would cause problems on other devices, so
>>> >> just enable it for the known to work ones.
>>> >
>>> > It's just matter of sending already encrypted frames. All chipsets
>>> > handle that.
>>> >
>>> > Stanislaw
>>> >
>>>
>>> The question is how well all chipsets handle that. I've seen some lags
>>> too with MFP enabled connection. While being about 40-50% lower,
>>> throughput would still occasionally drop to very low values, like
>>> 800Kbps.
>>
>> The only reason I can image that might have impact on throughput
>> in this case is limited CPU power since encryption is done in
>> software. Would be good to compare with PA2 with nohwcrypte, if
>> there are similar lags. However MFP can require more CPU power.
>>
>> Stanislaw
>>
> 
> nohwcrypt=y mfp=require: there was no throughput drop, no lag,
> measured about 80-85Mbps but the connection frozen after a minute or
> two. might be related to rekeying.
> 
> CPU power cannot be the problem since I run it on laptop (2x2.20GHz)
The lag is probably caused by failed A-MPDU setup exchanges due to
broken management frames.

I think it's likely that rt28xx chipsets are behaving like mt7612e in
that area (since the MAC design is very similar).
I've spent quite a bit of time making MFP work properly in mt76 on that
chipset, and here are my findings:
Hardware crypto for management frames is broken.
When using management frame protection, the same pairwise encryption key
needs to be used for both data frames and management frames.
There is a flag in mac80211 that allows software-encryption for
management frames only.
That leads us to the next issue: CCMP PN is usually generated in
hardware and stored in on-chip memory, which means the mac80211 key
tx_pn counter will be out of sync and software-encrypted management
packets will trigger replay protection on the other side.
To fix this, you need to enable software generated IV if management
frames are to be sent with the same key.
In that case you need to set TXINFO_W0_WIV and fill TXWI_W2_IV+TXWI_W3_EIV.
Also, for software encrypted frames you need to mask out WCID, since
otherwise the hardware will try to encrypt the frame again.
You can use mt76 as reference for how to do all of this

- Felix
