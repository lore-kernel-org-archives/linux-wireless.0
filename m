Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8499C43612
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 09:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06E820645
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 09:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbeLSJ1U convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 04:27:20 -0500
Received: from mga09.intel.com ([134.134.136.24]:64088 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbeLSJ1T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 04:27:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Dec 2018 01:27:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,372,1539673200"; 
   d="scan'208";a="119620867"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Dec 2018 01:27:17 -0800
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 19 Dec 2018 01:27:18 -0800
Received: from HASMSX110.ger.corp.intel.com (10.184.198.28) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 19 Dec 2018 01:27:18 -0800
Received: from hasmsx112.ger.corp.intel.com ([169.254.11.88]) by
 HASMSX110.ger.corp.intel.com ([169.254.6.30]) with mapi id 14.03.0415.000;
 Wed, 19 Dec 2018 11:27:15 +0200
From:   "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "Sharon, Sara" <sara.sharon@intel.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: RE: [PATCH] iwlwifi: add missing break / fall-through in switch
 cases
Thread-Topic: [PATCH] iwlwifi: add missing break / fall-through in switch
 cases
Thread-Index: AQHUl3VEn4jrAIbvaUm/xeH6PO9doKWFywGA
Date:   Wed, 19 Dec 2018 09:27:15 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB3013375FA0A@HASMSX112.ger.corp.intel.com>
References: <20181219083053.17530-1-emmanuel.grumbach@intel.com>
In-Reply-To: <20181219083053.17530-1-emmanuel.grumbach@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMzMwODZlMmMtYWY1YS00ODVmLWFkYzgtMzg1ZmNkZmZlZDU3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaGY0aGp6TEdrWU5iMVhNd1lLOUdhNUVkMWFZRjBcL0UyXC9ZWG4yREczbWxpcmJZTkRscWh6XC9XNXVjYXFydnJMVyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.12.85.150]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


> Subject: [PATCH] iwlwifi: add missing break / fall-through in switch cases
> 
> Two switch cases that were added recently missed break statement and
> explicit fall-through. Fix this.
> 
> Fixes: f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> ---

Please drop this. We have another patch that fixes the problems and adds less noise.
