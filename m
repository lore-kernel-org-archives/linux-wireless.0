Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE06C04EB8
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 03:27:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 431C320659
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 03:27:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="ZBctNL0d"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 431C320659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbeLJD1x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 9 Dec 2018 22:27:53 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:38160 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726292AbeLJD1x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 9 Dec 2018 22:27:53 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wBA3KCIV011282;
        Sun, 9 Dec 2018 19:27:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=d278vmBV1ucY0g7q6ltxCSbhetzDuemSjmXitIX0dUE=;
 b=ZBctNL0dj/8Mtk/PIM1Tr5zssa43E7WdmvnGkefJdF9u2h2qDdBDz8JFG03JQecWTFwE
 dQH2CekrHptY8OkOKpHOapzdqmHvFKHByaJodKkdM8INOT+yM+Lns2DqYNQCiTyPcmC6
 Kd7ntzmHxk8vyg2b9x5dXCXycovjnSWWnbExagAj5Dzb3LcsAC6683st8Wo+jlgs2C6o
 y48fIhTfdBLrr9asg1cHHhGboYfDoWL/YXBoQGetGyfs6qKMm14sNe/xm+IrRcdWai9k
 whpXyXkookw7bmfgJQn5WulwQZkBJ4tx+kqv1kKhegiTrfajCN83EkQ2ZVdAIs9tuft3 5w== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0b-0016f401.pphosted.com with ESMTP id 2p8ebpdmfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 09 Dec 2018 19:27:49 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Sun, 9 Dec
 2018 19:27:47 -0800
Received: from SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95]) by
 SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95%20]) with mapi id
 15.00.1367.000; Sun, 9 Dec 2018 19:27:47 -0800
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: RE: [EXT] Re: [PATCH] mwifiex: fix nested rtnl locking on
 BG_SCAN_STOPPED
Thread-Topic: [EXT] Re: [PATCH] mwifiex: fix nested rtnl locking on
 BG_SCAN_STOPPED
Thread-Index: AQHT3FUBvEyAzS8+9E+klcCqjB5/U6QREieFgAAKo0CBZNLrgIACxx1w
Date:   Mon, 10 Dec 2018 03:27:46 +0000
Message-ID: <02a4b750980145d7b6afbf69ee7cc734@SC-EXCH02.marvell.com>
References: <1524633572-5588-1-git-send-email-gbhat@marvell.com>
 <87in8fbvrr.fsf@purkki.adurom.net>
 <47b96e61ff234dacbe5da02f0730fb84@SC-EXCH02.marvell.com>
 <CA+ASDXNShxiJXVOa3fHGKGy0iHFTpUNEbGAdSb3QOpSqj0P6wg@mail.gmail.com>
In-Reply-To: <CA+ASDXNShxiJXVOa3fHGKGy0iHFTpUNEbGAdSb3QOpSqj0P6wg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.93.176.43]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-10_01:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=717 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812100030
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

SGkgQnJpYW4sDQo+IA0KPiBJSVVDLCBpdCdzIG5vdCBleGFjdGx5IGEgbmVzdGVkIGxvY2ssIGJ1
dCBhIGxvY2sgaW52ZXJzaW9uIGlzc3VlLg0KPiANCj4gIzENCj4gTkw4MDIxMV9DTURfR0VUX0lO
VEVSRkFDRSB0aHJlYWQgaXMgaG9sZGluZyBydG5sIGxvY2sgYW5kIGxhdGVyIHdhaXRpbmcNCj4g
b24gb25lIG9mIGl0cyBIb3N0Q21kX0NNRF8qIHRvIGNvbXBsZXRlDQo+IA0KPiBJbiB0aGUgbWVh
bnRpbWU6DQo+ICMyDQo+IGEgRVZFTlRfQkdfU0NBTl9TVE9QUEVEIGlzIHF1ZXVlZCwgYW5kIGl0
IGdyYWJzIHRoZSBydG5sIGxvY2sNCj4gDQo+IEJlY2F1c2UgZXZlbnRzIGFyZSBzZXJ2ZWQgb24g
dGhlIHNhbWUgdGhyZWFkIGFzIGNvbW1hbmRzLCB5b3UgZ2V0ICMxDQo+IHdhaXRpbmcgb24gIzIs
IHdoaWNoIGlzIHdhaXRpbmcgb24gdGhlIGxvY2sgaGVsZCBpbiAjMS4gaS5lLiwgQUJCQS4NCj4g
DQo+IFRoZSB3YXkgdG8gcmVzb2x2ZSB0aGlzIGlzIHRvIGVpdGhlciBtb3ZlIGV2ZW50IHByb2Nl
c3NpbmcgdG8gYSBkaWZmZXJlbnQNCj4gdGhyZWFkIHRoYW4gY29tbWFuZCBwcm9jZXNzaW5nICh0
aGF0IGxvb2tzIGl0IHdvdWxkIGJlIHZlcnkgZGlmZmljdWx0IHRvIGRvDQo+IGNvcnJlY3RseSwg
Z2l2ZW4gdGhlIG9zc2lmaWVkIHN0cnVjdHVyZSBvZiB5b3VyIGRyaXZlcjsgYnV0IHRoYXQgbWln
aHQgYmUgYSB3aXNlDQo+IG1vdmUgaW4gdGhlIGxvbmcgdGVybSkuLi4NCj4gLi4ub3IgZWxzZSBt
YXliZSB5b3UgY291bGQgZGVmZXIgdGhpcyBzcGVjaWZpYyBwaWVjZSBvZiB3b3JrIHRvIGl0cyBv
d24gdGhyZWFkLg0KPiBUaGF0IG1pZ2h0IHJlcXVpcmUgeWV0IGFub3RoZXIgd29ya3F1ZXVlPw0K
WWVzLCB3aXRoIGN1cnJlbnQgZGVzaWduIHdlIHNob3VsZCBiZSBkb2luZyB0aGlzLiBXZSB3aWxs
IHRyeSB0byBnZXQgdGhpcyBjaGFuZ2UuDQo+IA0KPiBBbnl3YXksIHRoZSBrZXkgcG9pbnQgaXMg
dGhhdCB5b3UgcmVhbGx5IGRvbid0IHdhbnQgdG8gaG9sZCBydG5sX2xvY2sgaW4geW91cg0KPiBt
YWluIHdvcmtxdWV1ZSwgb3IgaW4gYW55IG90aGVyIHdheSB0aGF0IG1pZ2h0IGJsb2NrIHRoZSBy
ZXN0IG9mIHRoZQ0KPiBvcGVyYXRpb24gb2YgeW91ciBkcml2ZXIuDQpPay4gVGhhbmtzIGZvciBj
bGFyaWZ5aW5nIHRoZSBzY2VuYXJpby4gSSBtaXNzZWQgb3V0IHRoZSBmYWN0IHRoYXQgc2FtZSB0
aHJlYWQgaXMgYmxvY2tlZCBieSB0aGUgbG9jay4NCj4gDQo+IEJyaWFuDQo=
