Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E3FFECDE44
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 22:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FA2C20856
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 22:42:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=microchiptechnology.onmicrosoft.com header.i=@microchiptechnology.onmicrosoft.com header.b="TyIk/UM/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0FA2C20856
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=microchip.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbeJ0HVX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Oct 2018 03:21:23 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:60313 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbeJ0HVX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Oct 2018 03:21:23 -0400
X-IronPort-AV: E=Sophos;i="5.54,429,1534834800"; 
   d="scan'208";a="22216110"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 26 Oct 2018 15:42:31 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.108) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Fri, 26 Oct 2018 15:42:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WqDZz0AOaJehAPelIJp1/ePBCCQg3+BGgzmKkXhtkwo=;
 b=TyIk/UM/CuVHdgoNVqQYayzHcYZZrRSFRr/zLmdlvxbQs4I4AqXCt/Uglth0BEpCB/nqGszktkXCWP0TbJYMIpOfkoXuktQREjEOiomqIO+CAfSF52g/F7VT1ms2J+Ou+mwKOegUC+p+0BHrL9sKuSO79W/yyzm/sr53WqiiAb0=
Received: from DM2PR11MB0255.namprd11.prod.outlook.com (10.160.135.27) by
 DM2PR11MB0123.namprd11.prod.outlook.com (10.160.27.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1273.25; Fri, 26 Oct 2018 22:42:28 +0000
Received: from DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e]) by DM2PR11MB0255.namprd11.prod.outlook.com
 ([fe80::5cab:d918:f310:6f0e%10]) with mapi id 15.20.1250.028; Fri, 26 Oct
 2018 22:42:28 +0000
From:   <Adham.Abozaeid@microchip.com>
To:     <dan.carpenter@oracle.com>
CC:     <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <Venkateswara.Kaja@microchip.com>, <gregkh@linuxfoundation.org>,
        <Ganesh.Krishna@microchip.com>,
        <Mrutyunjaya.Satapathy@microchip.com>,
        <Aditya.Shankar@microchip.com>, <Sripad.Balwadgi@microchip.com>,
        <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/4] stagign: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Topic: [PATCH 2/4] stagign: wilc1000: validate cfg parameters before
 scheduling the work
Thread-Index: AQHUbKc6eLOkXRU1kU6WoAUOYekHJqUxRX0AgADbM4A=
Date:   Fri, 26 Oct 2018 22:42:27 +0000
Message-ID: <5ce58ee6-0ce2-65bd-8dc7-26df41485c8b@microchip.com>
References: <20181025210849.20006-1-adham.abozaeid@microchip.com>
 <20181025210849.20006-3-adham.abozaeid@microchip.com>
 <20181026093640.4b34wgabx5jmxo47@mwanda>
In-Reply-To: <20181026093640.4b34wgabx5jmxo47@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [198.175.253.81]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:58.0) Gecko/20100101
 Thunderbird/58.0
x-clientproxiedby: BYAPR08CA0009.namprd08.prod.outlook.com
 (2603:10b6:a03:100::22) To DM2PR11MB0255.namprd11.prod.outlook.com
 (2a01:111:e400:3c24::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Adham.Abozaeid@microchip.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-microsoft-exchange-diagnostics: 1;DM2PR11MB0123;6:Dt20OyBdWJnd3dfuN5eFXMBgnIPxIC5ABB2LA43nZwYbWgt+RF2ycpqtCxcnaAmYHMdueMW7JZTCpNQsWB+TXz6OqmP5Nx8xKm5/jn00ZbhjK9ykZJoBzOEhzs3bEl6pEp/w8ET7ZKhDLILOXY5C2IyJHN2/LsZ5UXN/IAuKTZriKsm4USjx8hw4JKxDtgeiY6hLhuMqDrie5IKTNV7D9fh9z3hFmlUhHwCVJnSH6hpLvD5CbEStvY8P6KC7K+jyFgORSuBLDkd5z0UK5LMMoReX4ibLSUHGAGzwRYg3GLwa/LY8HqWdS6VQwsRNvYZouU4av2oT/rDVdoiNtItSY5aaVjnTUBBYArBpfV/pDzPyO2XDp/9EBtT9kt6vHQ4jvQVSRNyxdSThJ33hZ8lD5vmGp5LZJtEF3Tk0uBtqKz5rJ7k4IxR07z/OVI/ZiKAGij5WsE/9JF1eDE+PMJu/lOoqqMilOky9OTNeQkDpQbc=;5:iJUcfj+7weaWod/arYbrNxARzyhEzXX8SWz9fkYSo/7ZzHRkAktllR5vZ1SkfY5Kx3OJcfRBN4jG2SsL2FOiGO63at7NE6lPA9AJ/VScrqIBFmD7XY/KLcTDdu2LQ/bELlrED1AIEJW5RPmFsPIqg2TnunCYNki8M4cZjomhINg=;7:nTJDjSnOA10cpkLjIkRv8/9synYERj7NMVAkZXbGYR4C6Q60TfhExFQvq1xr7PfbCyJ+0vBkrzrqXSCJkV4eSS1pE1IXPYw/xWEzUiMm+aa6LKamO19Mx2so64ps+flLwO2GoGOTHLohj9oAXThyLg==
x-ms-office365-filtering-correlation-id: 2fdca1f8-a0a1-4363-3158-08d63b944e00
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(7020095)(4652040)(8989299)(5600074)(711020)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7153060)(7193020);SRVR:DM2PR11MB0123;
x-ms-traffictypediagnostic: DM2PR11MB0123:
x-ld-processed: 3f4057f3-b418-4d4e-ba84-d55b4e897d88,ExtAddr
x-microsoft-antispam-prvs: <DM2PR11MB0123BD05DE264F25FDB5398A8DF00@DM2PR11MB0123.namprd11.prod.outlook.com>
x-exchange-antispam-report-test: UriScan:;
x-ms-exchange-senderadcheck: 1
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:(6040522)(2401047)(8121501046)(5005006)(3231355)(944501410)(52105095)(3002001)(93006095)(93001095)(10201501046)(148016)(149066)(150057)(6041310)(20161123560045)(20161123564045)(20161123562045)(20161123558120)(201703131423095)(201702281528075)(20161123555045)(201703061421075)(201703061406153)(201708071742011)(7699051)(76991095);SRVR:DM2PR11MB0123;BCL:0;PCL:0;RULEID:;SRVR:DM2PR11MB0123;
x-forefront-prvs: 083751FCA6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(346002)(39860400002)(136003)(376002)(199004)(189003)(5250100002)(99286004)(256004)(76176011)(97736004)(25786009)(81166006)(81156014)(8676002)(4326008)(6916009)(65826007)(102836004)(53546011)(68736007)(26005)(52116002)(14454004)(386003)(72206003)(6506007)(86362001)(54906003)(305945005)(58126008)(7736002)(316002)(71200400001)(71190400001)(31696002)(6486002)(6512007)(5660300001)(6436002)(53936002)(2900100001)(36756003)(106356001)(65956001)(65806001)(66066001)(105586002)(31686004)(446003)(11346002)(486006)(476003)(2616005)(186003)(8936002)(478600001)(229853002)(3846002)(6116002)(6246003)(2906002)(64126003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR11MB0123;H:DM2PR11MB0255.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-microsoft-antispam-message-info: 5laCVoeeKNrJHSQQIjxdNQmUJorQgiIFNc//DoEA3kZNfbMWL3ccK4zofOdeNxOwg7FNt6ChKrB4rjNm49KIpxRiupD5DsPmlRZkSguCCpkBVV/WkGeXvA8CYh/iCF05fJfk6jur92oisQ+wvYGoJG9RtCnf9OiQvtkCfbiKa2ArMINYvz3eppv2/Y2iL73fGfKJyp535JFupeaeZUMIAO2TATA7kALPAtZYK2xVoZJPnkwmBQKNbrhobRDXS1DXfIyXDICwoPAab6SK5kEU2XH9PZHMalGJGN7X4cHK7LheX/BftCgqlxKhTEAJiS6qaSBTQdwVS2RH3nJa7pFXxa1DREP5WhM9hRdqTuD4JuE=
spamdiagnosticoutput: 1:99
spamdiagnosticmetadata: NSPM
Content-Type: text/plain; charset="utf-8"
Content-ID: <A06FCBEF63CD3045B68D4238D92A9236@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fdca1f8-a0a1-4363-3158-08d63b944e00
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2018 22:42:27.6833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM2PR11MB0123
X-OriginatorOrg: microchip.com
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

T24gMTAvMjYvMTggMjozNiBBTSwgRGFuIENhcnBlbnRlciB3cm90ZToNCj4gT24gVGh1LCBPY3Qg
MjUsIDIwMTggYXQgMDk6MTE6MDBQTSArMDAwMCwgQWRoYW0uQWJvemFlaWRAbWljcm9jaGlwLmNv
bSB3cm90ZToNCj4NCj4gWW91J2xsIG5lZWQgdG8gcmVzZW5kIHRoZXNlIGJlY2F1c2UgeW91ciBl
bWFpbCBmcm9tIGhlYWRlciBpcyBpbiB0aGUNCj4gd3JvbmcgZm9ybWF0LiAgQWxzbyB0aGVyZSBp
cyBhIHR5cG8gaW4gdGhlIHN1YmplY3QuICBzL3N0YWdpZ24vc3RhZ2luZy8uDQo+DQpBcG9sb2dp
ZXMgRGFuIGZvciB0aGF0ISBXaWxsIGNvcnJlY3QgdGhlIHN1YmplY3QgYW5kIGVtYWlsIGZyb20g
Zm9ybWF0IGFuZCBzZW5kIHYyLg0KDQpSZWdhcmRzLA0KQWRoYW0NCg0K
