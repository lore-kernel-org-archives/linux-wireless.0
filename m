Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 801E9C00449
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 09:56:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25ABD20652
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 09:56:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=quantenna.com header.i=@quantenna.com header.b="2w9VJ/Fv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 25ABD20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbeJEQyQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 12:54:16 -0400
Received: from mail-dm3nam03on0083.outbound.protection.outlook.com ([104.47.41.83]:12038
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727036AbeJEQyP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 12:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quantenna.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7vE9lX8ms6dAOCBM2D9iamHKUJ4xS6DIHpBOYVRRns=;
 b=2w9VJ/Fv58AO5Qq9EwbPO2ubBuziRYB8dRcwNt77DHtFXz93GTti1HGejqlPmtJ/jeWbZI72xvq3+J9/IrBPuxyVGbh39cFNZdYSzwL/0mjWDynqLLs9Lg08Ui7RDnm2x4Lbzx3tdoS1Guc/VhRe1ilWWRtp1dtmypz08HDE6Rw=
Received: from BYAPR05MB4597.namprd05.prod.outlook.com (52.135.233.18) by
 BYAPR05MB4485.namprd05.prod.outlook.com (52.135.203.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1207.13; Fri, 5 Oct 2018 09:56:10 +0000
Received: from BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373]) by BYAPR05MB4597.namprd05.prod.outlook.com
 ([fe80::fc58:438:5b30:9373%4]) with mapi id 15.20.1207.021; Fri, 5 Oct 2018
 09:56:10 +0000
From:   Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To:     Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 00/13] qtnfmac: fixes and cleanups for STA mode
Thread-Topic: [PATCH 00/13] qtnfmac: fixes and cleanups for STA mode
Thread-Index: AQHUWjHrLjx3XLjQ3kKbIfunr5n3EaUQU/exgAAa44A=
Date:   Fri, 5 Oct 2018 09:56:10 +0000
Message-ID: <20181005095600.4clm5lrwosx7gyzd@bars>
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
 <87mursrejo.fsf@purkki.adurom.net>
In-Reply-To: <87mursrejo.fsf@purkki.adurom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM6P191CA0106.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:8a::47) To BYAPR05MB4597.namprd05.prod.outlook.com
 (2603:10b6:a03:4c::18)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [195.182.157.78]
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;BYAPR05MB4485;6:p1sMZgnoHmtUExjigHBKM7Wi39RjDOaPYxJqSQbLCn8AP2W4143K+J995rsU+65dLZj5+RobzRWKZ4hw6KSnpUmBjAS8A0CUa6X62G8cNrVC0ISOeFQIfnEhMX1UEqoFkZKevGaQcekgG2R4z3frCe/+KhNVfC7O7+7s/49fkadtpivqF1cOSnd/AUydtsaP4hLLloDGeLKd7sczG2QeE0cz6Rb+Qt6pl3ZENJpINI+ngwiRIp1w92DK+SBk7C+m1xEY3pl5pL5Sjm4DU8AZneHcg4MSRu/zrpbRj4mpG6jGyVLyAMOA8zHI8gQiwr07nz8AJNPPXWhRerLuOAmDUExUSbpJL64XoH3StbcHre661VUNnVZpIdUCfV8zopnGjbTtDOVVFq0rvBBSQx9/32ylSMS9IoJZL5iACr135cBuXg721GYUQXo1O7L1LxZxtVM6nHDINTNKBS1NqfoAMQ==;5:JvgA3Z8asGSH1Y3Zs5jsXBXIM+5D9yLITQk8t70qpFcWeUJ5AEszU2pWYdg7z7hO9uCdSstlJt/wVsi2uOtEKyFonWwmyiAOhKhc9rx3E6sqYQoJI0eIjQ74AEfViTMnhSsYy8Ufl+kQw35/j54hv2AuVlFxcdk05YZPcHAKAIw=;7:1jYEzHbXgq0fIJfxd9TfuE59ifn8hpyWBT4JmflaaJICdvG8dr9Hbp8k9A2MPNcdIHeSowjlA+YqygAKa6G8kADKpQPkkoljo94WtwsnMcX7TX6z+Lz0GsgoGf2e0XpAvNqscy36ufJY0AT3TQnLDi5zvDgAHkPXEoIKiyqB3SCFCa6ZN2Z68OriObPc/Ob2qDK+TsGmu0WkVBctQ+49yB0CsQgOQsFH84+aLmKvpz50TdgLfqet9QYtnVQRUTwL
x-ms-office365-filtering-correlation-id: ac89865a-898d-4bb0-183d-08d62aa8c6c4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600074)(711020)(2017052603328)(7153060)(7193020);SRVR:BYAPR05MB4485;
x-ms-traffictypediagnostic: BYAPR05MB4485:
x-microsoft-antispam-prvs: <BYAPR05MB4485F212DD20C075466DF5E7A3EB0@BYAPR05MB4485.namprd05.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(149066)(150057)(6041310)(20161123564045)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(20161123558120)(20161123560045)(20161123562045)(201708071742011)(7699051)(76991048);SRVR:BYAPR05MB4485;BCL:0;PCL:0;RULEID:;SRVR:BYAPR05MB4485;
x-forefront-prvs: 0816F1D86E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(39850400004)(376002)(366004)(346002)(136003)(396003)(189003)(199004)(446003)(486006)(105586002)(11346002)(6506007)(102836004)(33896004)(186003)(386003)(107886003)(25786009)(6346003)(99286004)(256004)(54906003)(26005)(71200400001)(6916009)(76176011)(106356001)(316002)(6246003)(4326008)(86362001)(2900100001)(33716001)(478600001)(81156014)(81166006)(66066001)(14454004)(8936002)(305945005)(6512007)(3846002)(5250100002)(71190400001)(8676002)(52116002)(1076002)(7736002)(6116002)(68736007)(97736004)(5660300001)(229853002)(9686003)(53936002)(2906002)(476003)(6486002)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:BYAPR05MB4485;H:BYAPR05MB4597.namprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: quantenna.com does not designate
 permitted sender hosts)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=sergey.matyukevich.os@quantenna.com; 
x-microsoft-antispam-message-info: JvzKXgOo/KNpvDPPTLGoM1HdWvrXGxK3kLxEM4bPWiMNN87xm50KWyD9pZ2bwJgxN8YkmIxD+S3mJUJ9SKsrE6vQ2peWAbvjCbk3zFftg4Opca7JrOzjVodmMMiH+qsHWU6qJtCCm+e8HlAvEs9F25TuQ7lbXR2BwowfGdtSLqpK4XVUoqhVga/FAMxIAZLlSSq4nAfE55HD9OK/Bleg9mRQTWGQBQ7RgxqxLY3oSi9fVJacAQlJl14yq/WrS1WkcRNVtxDCCFY1GljwLZ+FdlUCMEmKmp8IVA33DAx/wd9EbwBmCDUqVw2qeaTBXVYf2kbGNmL1E9Psw9QURJWE2xrE6bv/n/S/MqWGJjV8OOc=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="us-ascii"
Content-ID: <415E5190B9D178449C300F9EC60FF9FB@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: quantenna.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac89865a-898d-4bb0-183d-08d62aa8c6c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Oct 2018 09:56:10.5592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a355dbce-62b4-4789-9446-c1d5582180ff
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR05MB4485
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com> writes:
>=20
> > Hello Kalle and all,
> >
> > Here is the next  patch set with fixes and cleanups for qtnfmac driver.
> > This set mostly consists of multiple fixes and improvements for STA
> > mode. The major changes include the following items:
> > - fixes for 'iw' output: rates for enabled SGI, 'dump station'
> > - expose more scan features to host: scan flush and dwell time
> > - inform host wireless core when OBSS is not supported by firmware
> > - command processing cleanup: unify and get rid of 'unlikely' macros
>=20
> The string "OS" is again in the from field. Can you fix that and resend, =
please?

Ok, thanks for catching. Will do now.

Regards,
Sergey
