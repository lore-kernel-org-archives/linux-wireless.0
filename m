Return-Path: <SRS0=pcPV=RG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 025ECC43381
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 10:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C471320836
	for <linux-wireless@archiver.kernel.org>; Sun,  3 Mar 2019 10:06:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="UHZH84ki"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfCCKF6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 05:05:58 -0500
Received: from nbd.name ([46.4.11.11]:47036 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726032AbfCCKF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 05:05:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=9oBiZti/vu20O3nlFR+6+BgWj3kr/MO2+a3u5axqI6Y=; b=UHZH84kiliwO1BLeismm5Xbjwf
        N6tI550Fkn10VvhD4togf7dXv/d1H2/vO3X/AmtsKc46adLwKHlWiEQR6C0rQYqerOIF7FTeg+RV6
        h9j96Y5W2eBbDUz8n9EAFuLsivRBzrO5v2zd325TRufyrStDt4cb3DWNV2g5UpBMwYoo=;
Subject: Re: [mt76/mt7603/mac] Question about missing variable assignment
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20190302211046.GA20268@embeddedor.com>
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
Message-ID: <827d2ee6-04de-f4f9-15b4-40dac90bda9c@nbd.name>
Date:   Sun, 3 Mar 2019 11:05:51 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190302211046.GA20268@embeddedor.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-03-02 22:10, Gustavo A. R. Silva wrote:
> Hi all,
> 
> The following piece of code in drivers/net/wireless/mediatek/mt76/mt7603/mac.c
> is missing a variable assignment before line 1058.  Notice that there
> is a potential execution path in which variable *i* is compared against
> magic number 15 at line 1075 without being initialized previously
> (this was reported by Coverity):
> 
> 1055 out:
> 1056         final_rate_flags = info->status.rates[final_idx].flags;
> 1057 
> 1058         switch (FIELD_GET(MT_TX_RATE_MODE, final_rate)) {
> 1059         case MT_PHY_TYPE_CCK:
> 1060                 cck = true;
> 1061                 /* fall through */
> 1062         case MT_PHY_TYPE_OFDM:
> 1063                 if (dev->mt76.chandef.chan->band == NL80211_BAND_5GHZ)
> 1064                         sband = &dev->mt76.sband_5g.sband;
> 1065                 else
> 1066                         sband = &dev->mt76.sband_2g.sband;
> 1067                 final_rate &= GENMASK(5, 0);
> 1068                 final_rate = mt7603_get_rate(dev, sband, final_rate, cck);
> 1069                 final_rate_flags = 0;
> 1070                 break;
> 1071         case MT_PHY_TYPE_HT_GF:
> 1072         case MT_PHY_TYPE_HT:
> 1073                 final_rate_flags |= IEEE80211_TX_RC_MCS;
> 1074                 final_rate &= GENMASK(5, 0);
> 1075                 if (i > 15)
> 1076                         return false;
> 1077                 break;
> 1078         default:
> 1079                 return false;
> 1080         }
> 
> My guess is that such missing assignment should be something similar
> to the one at line 566:
> 
> 	i = FIELD_GET(MT_RXV1_TX_RATE, rxdg0);
> 
> but I'm not sure what the proper arguments for macro FIELD_GET should
> be.
> 
> This code was introduced by commit c8846e1015022d2531ac4c895783e400b3e5babe
> 
> What do you think?
Thanks for reporting this. The fix is simpler than that, the check
should be: if (final_rate > 15)
I will send a fix.

- Felix
