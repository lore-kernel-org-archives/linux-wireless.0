Return-Path: <SRS0=cMLu=Q2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D60FC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 11:29:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BB9B206DD
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Feb 2019 11:29:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UZCEY9B9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727496AbfBSL31 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Feb 2019 06:29:27 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41082 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbfBSL31 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Feb 2019 06:29:27 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1JBTDIq012560;
        Tue, 19 Feb 2019 11:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=AJ1BvetCefdwPGbBunjdzoYFXF2ZCay35WaiVeVSjP8=;
 b=UZCEY9B9cDl9facXJJVd1+xS1VVZmrfPo4peouKE389tJcg7lsc1tjxapXoD/fVXE4NW
 HPqaFHHpo9FXDDq4+4ndKTjKPvdl8GtqV+zHC48hKt8LslCIqh+B9C2IudRXmECvoz54
 jNmbLnW6a7VTMTxmew5i2JEJc89ZijPufqvYWyw8Z94k6bN0QlEySwudHidg5Y/jedcj
 WPQl2txug/YmNYaXC69Jq4C7qo18md3P6LoA09MOHU52hEStl5yGKo1ejuz3iRh8XjlF
 dG2WI2ZwYmVBuggCeXWeOy9PlVPCtpB7LzICLeZsz7r0feqoM5SOvaO0dCAmGDbeGNiD rA== 
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2130.oracle.com with ESMTP id 2qp9xttn1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Feb 2019 11:29:13 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x1JBT46c014390
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Feb 2019 11:29:04 GMT
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x1JBT3F5007487;
        Tue, 19 Feb 2019 11:29:03 GMT
Received: from kadam (/10.175.25.58)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Feb 2019 03:29:02 -0800
Date:   Tue, 19 Feb 2019 14:28:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>, kbuild@01.org, kbuild-all@01.org
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        brcm80211-dev-list@cypress.com
Subject: Re: [kbuild] [PATCH] brcmfmac: use bphy_err() in all wiphy-related
 code
Message-ID: <20190219112853.GV2304@kadam>
References: <20190215061601.GE2304@kadam>
 <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
 <20190215103803.GF2304@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215103803.GF2304@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9171 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=965 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902190086
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 15, 2019 at 01:38:03PM +0300, Dan Carpenter wrote:
> On Fri, Feb 15, 2019 at 12:04:31PM +0200, Kalle Valo wrote:
> > > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > > Spriel 2012-11-14 108 void *data)
> > > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > 
> > This report is very hard to read as the lines seem to be wrapped.
> > 
> 
> I feel like removing the filenames would make the reports more legible.
> We can get that information from the git hash if we really need it.
> 
> Maybe just put the filename at the start:
> 
> drivers/net/wireless/brcm80211/brcmfmac/fweh.c
> 5c36b99a Arend van Spriel 2012-11-14 104
> 3e0a97e1 Arend van Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,

These emails are actually from the Intel zero day devs.  I just hit
forward on them.  They have silently implemented the formatting changes
we asked for.

:)

Thanks so much!

regards,
dan carpenter

