Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99457C282CE
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:56:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64DA62084F
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:56:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MWo93o8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbfDIL4J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:56:09 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:60746 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfDIL4J (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:56:09 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x39Bmxvb167358;
        Tue, 9 Apr 2019 11:55:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=K9NT4H6etaliOftI2I7VlNB98ZvZITw3AZwIqxMlYSU=;
 b=MWo93o8NkTm+oTed1TsyEwEQTSIziFKczWqXZv4sgu5bTJwn3SPA1qUYWAa4p88uGFKW
 Hngthba2FaitaARlPz0PX6Dh6j9Z5i48vQd34r+YzS1YSoCx/s9mNMompIrftq1W+oSG
 87ccLpCDO4HPb9NfG4C+VPrbnjiFPhsFTGgSl+f+cnvoO8XGxLYEg0KJ8cuL8Wgava46
 tbo1w5MUHAXBZqX0nmijKuCs0lTOpbjH2Ob6uylzQvpEnAnbPMBgg2R0HUxVaJXI20mM
 bAopCaCQ1fR3aY4r0IHAX9UKee6FAJRhZPZcAHiR9CYxZAPnjIFPaLq4qaK/aTsTdKZw SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 2rphmeckxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Apr 2019 11:55:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x39BsRch026035;
        Tue, 9 Apr 2019 11:55:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2rph7shf6k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Apr 2019 11:55:58 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x39BtvpP026903;
        Tue, 9 Apr 2019 11:55:57 GMT
Received: from kadam (/197.157.0.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Apr 2019 04:55:57 -0700
Date:   Tue, 9 Apr 2019 14:55:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Colin King <colin.king@canonical.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][V2] brcmfmac: fix leak of mypkt on error return path
Message-ID: <20190409115544.GC6095@kadam>
References: <20190409114333.24342-1-colin.king@canonical.com>
 <e0d984a7-6a6d-b902-6f75-26ee6f530efe@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0d984a7-6a6d-b902-6f75-26ee6f530efe@broadcom.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9221 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904090077
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9221 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904090077
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 09, 2019 at 01:50:38PM +0200, Arend Van Spriel wrote:
> On 4/9/2019 1:43 PM, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Currently if the call to brcmf_sdiod_set_backplane_window fails then
> > then error return path leaks mypkt. Fix this by returning by a new
> > error path labelled 'out' that calls brcmu_pkt_buf_free_skb to free
> > mypkt.  Also remove redundant check on err before calling
> > brcmf_sdiod_skbuff_write.
> > 
> > Addresses-Coverity: ("Resource Leak")
> > Fixes: a7c3aa1509e2 ("brcmfmac: Remove brcmf_sdiod_addrprep()")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> > 
> > V2: Remove  redundant check on err before calling
> > brcmf_sdiod_skbuff_write, kudos to Dan Carpenter and Arend Van Spriel
> > for spotting this.
> > 
> > ---
> >   drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 8 +++-----
> >   1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> > index ec129864cc9c..60aede5abb4d 100644
> > --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> > +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
> > @@ -628,15 +628,13 @@ int brcmf_sdiod_send_buf(struct brcmf_sdio_dev *sdiodev, u8 *buf, uint nbytes)
> >   	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
> >   	if (err)
> > -		return err;
> > +		goto out;
> >   	addr &= SBSDIO_SB_OFT_ADDR_MASK;
> >   	addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
> > -	if (!err)
> > -		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr,
> > -					       mypkt);
> > -
> > +	err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2, addr, mypkt);
> > +out:
> 
> I am fine with it, but my suggestion was a bit different:
> 
> 	err = brcmf_sdiod_set_backplane_window(sdiodev, addr);
> 	if (!err) {
> 		addr &= SBSDIO_SB_OFT_ADDR_MASK;
> 		addr |= SBSDIO_SB_ACCESS_2_4B_FLAG;
> 		err = brcmf_sdiod_skbuff_write(sdiodev, sdiodev->func2,
> 					       addr, mypkt);
> 	}

Success handling always leads to extra indenting like this...  It's
less confusing to do failure handling keep the normal/success path at
indent level 1.

regards,
dan carpenter

