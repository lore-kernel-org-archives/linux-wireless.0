Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47022C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:47:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04F6820827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:47:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="L5f+1NJn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 04F6820827
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727843AbeKIX2d (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:28:33 -0500
Received: from nbd.name ([46.4.11.11]:46282 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727793AbeKIX2d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 18:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/pC5Y8J0NNSEinXkaZSnmVsXAAYwx49XtnN37SEfLf8=; b=L5f+1NJn8b3PNxrPPYq825cYLZ
        XhQoK74OPM6qz6Y+TJkelGdXjB0mRpUavSAglqjp2z1artbeZxFJ35spGkFtpmXbZQlpeiP+tz4e5
        4pSy9Cxfdq5zqaBHjdOn2pQaqmno8nyeSSX1o6EPtEJuWWlhuPWBcgA4DORTwQyY6SgA=;
Subject: Re: [PATCH 1/5] mt76x02: correct set bssid for STA
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
 <1541758814-2046-2-git-send-email-sgruszka@redhat.com>
 <20181109110949.GD4174@localhost.localdomain>
 <d77ed144-f37a-0612-9c28-398704496aaa@nbd.name>
 <20181109125050.GH4174@localhost.localdomain>
 <20181109132639.GC8054@redhat.com>
 <20181109134208.GB9453@localhost.localdomain>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <197f8905-06e2-0b18-8538-09444a6f4853@nbd.name>
Date:   Fri, 9 Nov 2018 14:47:49 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181109134208.GB9453@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-09 14:42, Lorenzo Bianconi wrote:
>> On Fri, Nov 09, 2018 at 01:50:51PM +0100, Lorenzo Bianconi wrote:
>> > > On 2018-11-09 12:09, Lorenzo Bianconi wrote:
>> > > >> Use MT_MAC_APC_BSSID0_H_EN bit to indicatate we are
>> > > >> setting BSSID for STA.
>> > > >> 
>> > > >> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> > > >> ---
>> > > >>  drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 12 +++++++++---
>> > > >>  1 file changed, 9 insertions(+), 3 deletions(-)
>> > > >> 
>> > > >> diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
>> > > >> index 59b336e34cb5..cfeae5586897 100644
>> > > >> --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
>> > > >> +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
>> > > >> @@ -826,10 +826,16 @@ void mt76x02_mac_work(struct work_struct *work)
>> > > >>  
>> > > >>  void mt76x02_mac_set_bssid(struct mt76x02_dev *dev, u8 idx, const u8 *addr)
>> > > >>  {
>> > > >> +	u32 bssid_h = FIELD_PREP(MT_MAC_APC_BSSID_H_ADDR,
>> > > >> +				 get_unaligned_le16(addr + 4));
>> > > >> +	u32 bssid_l = get_unaligned_le32(addr);
>> > > >> +
>> > > >> +	if (idx > 7)
>> > > >> +		bssid_h |= MT_MAC_APC_BSSID0_H_EN;
>> > > > 
>> > > > This bit is to enable APClient mode and it is valid just for register 0x1094
>> > > > (MT_MAC_APC_BSSID_{L,h}(0)). Moreover IIRC APClient has been disabled because
>> > > > it causes a performance degradation.
>> > > The performance degradation was with MAC_ADDR_EXT, not AP-Client.
>> > > This patch should be fine.
>> > 
>> > Ah, now I remember sorry, you are right :)
>> > Anyway IIRC MT_MAC_APC_BSSID0_H_EN is just for AP_CLIENT_BSSID0 (at least for
>> > 76x2), for others we need to use BIT(31) but just if APClient is disabled, right?
>> > Moreover BSSID filter is currently disabled (BIT(3) in RX_FILTER_CFG).
>> > 
>> > # echo 0x1400 > /sys/kernel/debug/ieee80211/phy0/mt76/regidx
>> > # cat /sys/kernel/debug/ieee80211/phy0/mt76/regval
>> > 0x00017f97
>> > 
>> > Have you tried to enabled it?
>> 
>> I didn't try this yet, but I think it should be enabled to support
>> mulit BSS and MAC address change. 
> 
> I agree we can use multi-BSS for mac filtering in AP mode but my gut feeling in
> STA the hw uses the value in MT_MAC_ADDR_DW{0,1} for unicast packet filtering
> (BIT(2) in RX_FILTER_CFG). Moreover I think there is a relation between
> MT_MAC_ADDR_DW and BSSID values in multiAP mode.
I'm pretty sure that value also gets used for local ACK/BA filtering. We
definitely need to set it up properly.
In the past, I observed cases where a misconfigured MAC address led to
no tx status being reported anymore.

- Felix
