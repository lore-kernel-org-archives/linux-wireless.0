Return-Path: <SRS0=Y8Bh=OQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28B6C64EB1
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 11:55:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D6E720672
	for <linux-wireless@archiver.kernel.org>; Fri,  7 Dec 2018 11:55:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="uz+nfe2E"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6D6E720672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbeLGLzp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 7 Dec 2018 06:55:45 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44114 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725989AbeLGLzp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Dec 2018 06:55:45 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wB7Au4VJ031311;
        Fri, 7 Dec 2018 03:55:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=s3+J/SMGikwB1aRo5/HAixHphOdxDKTJsqWeiBPooYk=;
 b=uz+nfe2EjmZJl1doWWpe4kP+2m1diSIkE+ZqeRkeXehqqx9aE+mvrhg3u/Hc6HOHkrWs
 BEC9ZueLoOeUxgqa9nMaE19qZvuBb3LECXX89x8BUSVE8t1Z5N5oytE7TU7vMggyrcNw
 2zpFRqujUxm2XsMsWqR58IEF4uE9BXF5ea+a4zJTTzN291Y8au5WDSsV2XVbuU7Pr/Bp
 2tLYPSU2K2DI9S0Rxt7dwl+FRPEsaPtp7TgS+KTHMEdQGMUhm4rAtOJx+91EvBl2wEeu
 6YVtXsRBahm6SolMShh4DS5iulfqpfakkv76M9Z5cYqHvn9sxwoIgZPmtLv+uxHRfeu7 tQ== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2p7nbtrpkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 07 Dec 2018 03:55:39 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 7 Dec
 2018 03:55:37 -0800
Received: from SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95]) by
 SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95%20]) with mapi id
 15.00.1367.000; Fri, 7 Dec 2018 03:55:37 -0800
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Brian Norris <briannorris@chromium.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Amitkumar Karwar" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [EXT] Re: [RFC PATCH v2 2/2] mwifiex: add
 NL80211_STA_INFO_RX_BITRATE support
Thread-Topic: [EXT] Re: [RFC PATCH v2 2/2] mwifiex: add
 NL80211_STA_INFO_RX_BITRATE support
Thread-Index: AQHUjhquQe7JHkSG80CDLVQJUW6cy6VzKslF
Date:   Fri, 7 Dec 2018 11:55:37 +0000
Message-ID: <1544183734084.87221@marvell.com>
References: <20181207001249.165477-1-briannorris@chromium.org>
        <20181207001249.165477-2-briannorris@chromium.org>,<87ftv9ehla.fsf@codeaurora.org>
In-Reply-To: <87ftv9ehla.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.94.250.30]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-12-07_04:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=712 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1812070095
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle/Brian,=0A=
=0A=
>> RFC: I'd appreciate it if someone from Marvell could double check my wor=
k=0A=
>> here.=0A=
=0A=
>BTW, if we don't hear anything from Marvell I'm going to apply these=0A=
>anyway.=0A=
=0A=
This patch series looks good to us.=0A=
=0A=
Thanks,=0A=
Ganapathi =
