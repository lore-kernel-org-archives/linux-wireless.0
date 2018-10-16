Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2577C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 12:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67AA320869
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 12:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="QnGK5P96"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67AA320869
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbeJPUjU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 16:39:20 -0400
Received: from alexa-out-blr-02.qualcomm.com ([103.229.18.198]:51563 "EHLO
        alexa-out-blr.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726781AbeJPUjU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 16:39:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1539694138; x=1571230138;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pwi89MTTb2Ul4gkcOxihAYgmDpl2AA9Oyj8h2gmFZcg=;
  b=QnGK5P96YNvm3g5c8uyc1PYEN33tyliyfl6h9hJDAgn7Wb7nMSNYbcEK
   VOEO+RgoGLvj/+6t2XHVI2XoQssBf6FjxzWuoiRbA4iip7/xpRavi3ytj
   bIP8M7qdAb2w8cNTsJJdCjm4vSU4p+KzV7/qPUla6OSGbYZKcoc8kUUXn
   c=;
X-IronPort-AV: E=Sophos;i="5.54,388,1534789800"; 
   d="scan'208";a="209693"
Received: from ironmsg02-blr.qualcomm.com ([10.86.208.131])
  by alexa-out-blr.qualcomm.com with ESMTP/TLS/AES256-SHA; 16 Oct 2018 18:17:38 +0530
X-IronPort-AV: E=McAfee;i="5900,7806,9047"; a="2376776"
Received: from aphydexm01b.ap.qualcomm.com ([10.252.127.11])
  by ironmsg02-blr.qualcomm.com with ESMTP/TLS/AES256-SHA; 16 Oct 2018 18:17:38 +0530
Received: from aphydexm01f.ap.qualcomm.com (10.252.127.15) by
 aphydexm01b.ap.qualcomm.com (10.252.127.11) with Microsoft SMTP Server (TLS)
 id 15.0.1365.1; Tue, 16 Oct 2018 18:17:34 +0530
Received: from aphydexm01f.ap.qualcomm.com ([10.252.127.15]) by
 aphydexm01f.ap.qualcomm.com ([10.252.127.15]) with mapi id 15.00.1365.000;
 Tue, 16 Oct 2018 18:17:34 +0530
From:   Tamizh Chelvam Raja <tamizhr@qti.qualcomm.com>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        Tamizh chelvam <tamizhr@codeaurora.org>
CC:     "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [EXTERNAL] Re: [PATCH 1/3] cfg80211: Add support to configure
 station specific RSSI threshold for AP mode
Thread-Topic: [EXTERNAL] Re: [PATCH 1/3] cfg80211: Add support to configure
 station specific RSSI threshold for AP mode
Thread-Index: AQHUZUOD4Uovi4zEWEunRvcK1EQvyKUhxzJw
Date:   Tue, 16 Oct 2018 12:47:33 +0000
Message-ID: <da28e67ec88a488ab62a88d0899657f3@aphydexm01f.ap.qualcomm.com>
References: <1539626250-769-1-git-send-email-tamizhr@codeaurora.org>
 <1539626250-769-2-git-send-email-tamizhr@codeaurora.org>
 <20181016112831.bglm53ydrktjy7i5@bars>
In-Reply-To: <20181016112831.bglm53ydrktjy7i5@bars>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.252.0.6]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> +static int nl80211_set_sta_mon(struct sk_buff *skb, struct genl_info=20
>> +*info) {
>> +       struct cfg80211_registered_device *rdev =3D info->user_ptr[0];
>> +       struct net_device *dev =3D info->user_ptr[1];
>> +       struct nlattr *attrs[NL80211_ATTR_CQM_MAX + 1];
>> +       bool fixed_thold =3D false;
>> +       struct nlattr *sta_mon;
>> +       u8 *addr =3D NULL;
>> +       int err;
>> +
>> +       if (!wiphy_ext_feature_isset(&rdev->wiphy,
>> +                                    NL80211_EXT_FEATURE_STA_MON_RSSI_CO=
NFIG))
>> +               return -EOPNOTSUPP;
>> +
>> +       sta_mon =3D info->attrs[NL80211_ATTR_CQM];
>> +       if (!sta_mon || !(info->attrs[NL80211_ATTR_MAC]))
>> +               return -EINVAL;
>> +
>> +       err =3D nla_parse_nested(attrs, NL80211_ATTR_CQM_MAX, sta_mon,
>> +                              nl80211_attr_cqm_policy, info->extack);
>> +       if (err)
>> +               return err;
>> +
>> +       addr =3D nla_data(info->attrs[NL80211_ATTR_MAC]);
>> +       fixed_thold =3D
>> +              =20
>> + nla_get_flag(info->attrs[NL80211_ATTR_STA_MON_FIXED_THOLD]);
>> +
>> +       if (attrs[NL80211_ATTR_CQM_RSSI_THOLD] &&
>> +           attrs[NL80211_ATTR_CQM_RSSI_HYST]) {
>> +               const s32 *thresholds =3D
>> +                       nla_data(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
>> +               int len =3D nla_len(attrs[NL80211_ATTR_CQM_RSSI_THOLD]);
>> +               u32 hysteresis =3D=20
>> + nla_get_u32(attrs[NL80211_ATTR_CQM_RSSI_HYST]);
>> +
>> +               if (len % 4)
>> +                       return -EINVAL;
>> +
>> +               err =3D nl80211_validate_rssi_tholds(thresholds, len / 4=
);
>> +               if (err)
>> +                       return err;
>> +
>> +               return rdev_set_sta_mon_rssi_config(rdev, dev, addr, thr=
esholds,
>> +                                                   hysteresis, len / 4,
>> +                                                   fixed_thold);
>> +       }
>> +
>> +       return -EINVAL;
>> +}

>IIUC there is a noticeable overlap between this new command and existing n=
l80211_set_cqm_rssi command. Is there any reason why >nl80211_set_cqm_rss c=
an not be adapted for AP case ?

[Tamizh] This new command for AP mode introduced as per the previous discus=
sion.=20

>If there is a reason to handle AP case separately, then it looks like it m=
akes sense to add explicit check for supported iftype in this new command. =
>Besides, it looks like there is no generic way to handle disabling of RSSI=
 monitoring in the new command.
>As a result, we may end up in multiple driver specific implementations.

[Tamizh] thanks for pointing me out. I'll add the ifmode check in the next =
patchset version.

Thanks,
Tamizh.
