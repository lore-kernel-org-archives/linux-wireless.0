Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A84C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C114621924
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 10:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="0PJI/zus"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbfBOKib (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 05:38:31 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60914 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfBOKia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 05:38:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x1FANeCc139150;
        Fri, 15 Feb 2019 10:38:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=QldrALR4WOE5u8AYPiHUu4bYjyORRqQTFdPtufNUQdY=;
 b=0PJI/zusP32fpQD2oUbJS3xR7ZuIw5SPgzEhyOjJHFtOwno8MRo4leysMypM0rrGYOFl
 aeAkA+lfjRcMn037xACX5HcAIBc0vheULXoiU7VESC3duDlzgBxP3jatB1lVcCF8qQaY
 zmf1yES++DrTPmpVNqavfwA1uT2uU9zmCddHAcbUUWWh7Y9nxRkQo/SJ+18pUoTuQC9Q
 2RAejP1nZgo+tTIU9f8aPdWidDW2/u0bXDAtBwV+8V4OllVbHsHriFtTea1vVsD6dlVD
 iTIOmz5Sw73fBhN92VNpXuJOLyv0W+wBsRtclIJe/eCkcytbXGeW8SSeDd5FddyXzBxM VQ== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2qhreed7cg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 10:38:20 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x1FAcFuS021589
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Feb 2019 10:38:15 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x1FAcDYD008533;
        Fri, 15 Feb 2019 10:38:14 GMT
Received: from kadam (/197.157.0.55)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 15 Feb 2019 10:38:13 +0000
Date:   Fri, 15 Feb 2019 13:38:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>, kbuild@01.org, kbuild-all@01.org
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Subject: Re: [PATCH] brcmfmac: use bphy_err() in all wiphy-related code
Message-ID: <20190215103803.GF2304@kadam>
References: <20190215061601.GE2304@kadam>
 <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87bm3dz7tc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9167 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=959 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1902150076
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Feb 15, 2019 at 12:04:31PM +0200, Kalle Valo wrote:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
> 
> > Hi Rafał,
> >
> > url:
> > https://github.com/0day-ci/linux/commits/Rafa-Mi-ecki/brcmfmac-use-bphy_err-in-all-wiphy-related-code/20190214-140004
> > base:
> > https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git
> > master
> >
> > smatch warnings:
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:114
> > brcmf_fweh_call_event_handler() warn: variable dereferenced before
> > check 'ifp' (see line 110)
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:187
> > brcmf_fweh_handle_if_event() error: we previously assumed 'ifp' could
> > be null (see line 184)
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c:189
> > brcmf_fweh_handle_if_event() warn: variable dereferenced before check
> > 'ifp' (see line 187)
> >
> > # https://github.com/0day-ci/linux/commit/e12dba9f5ed77216c5984a4b57ddc31ba23376c9
> > git remote add linux-review https://github.com/0day-ci/linux
> > git remote update linux-review
> > git checkout e12dba9f5ed77216c5984a4b57ddc31ba23376c9
> > vim +/ifp +114 drivers/net/wireless/broadcom/brcm80211/brcmfmac/fweh.c
> >
> > 5c36b99a drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 104
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct
> > brcmf_if *ifp,
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 106 enum brcmf_fweh_event_code code,
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 107 struct brcmf_event_msg *emsg,
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> > Spriel 2012-11-14 108 void *data)
> > 3e0a97e1 drivers/net/wireless/brcm80211/brcmfmac/fweh.c Arend van
> 
> This report is very hard to read as the lines seem to be wrapped.
> 

I feel like removing the filenames would make the reports more legible.
We can get that information from the git hash if we really need it.

Maybe just put the filename at the start:

drivers/net/wireless/brcm80211/brcmfmac/fweh.c
5c36b99a Arend van Spriel 2012-11-14 104
3e0a97e1 Arend van Spriel 2012-11-14 105 static int brcmf_fweh_call_event_handler(struct brcmf_if *ifp,

regards,
dan carpenter
