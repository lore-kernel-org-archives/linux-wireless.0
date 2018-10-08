Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2339BC00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6DC52086D
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:15:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6DC52086D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727433AbeJHQ0I (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52308 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbeJHQ0H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:26:07 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6068E30820D4;
        Mon,  8 Oct 2018 09:15:24 +0000 (UTC)
Received: from localhost (ovpn-204-38.brq.redhat.com [10.40.204.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B07891057051;
        Mon,  8 Oct 2018 09:15:23 +0000 (UTC)
Date:   Mon, 8 Oct 2018 11:15:22 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 06/12] rtw88: fw and efuse files
Message-ID: <20181008091519.GB1961@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-7-git-send-email-yhchuang@realtek.com>
 <20181004104929.GA16819@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D172A29B@RTITMBSVM01.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172A29B@RTITMBSVM01.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Mon, 08 Oct 2018 09:15:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 05, 2018 at 09:19:31AM +0000, Tony Chuang wrote:
> > On Wed, Oct 03, 2018 at 04:02:22PM +0800, yhchuang@realtek.com wrote:
> > > +void rtw_fw_do_iqk(struct rtw_dev *rtwdev, struct rtw_iqk_para *para)
> > > +{
> > > +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
> > 
> > Not sure if '= {0}' work as expected for arrays, you
> > want to nulify first byte or whole h2c_pkt ?
> 
> I want to nullify the whole h2c_pkt.
> And I think it works as expected.

Yes indeed. I confused with struct initialization which do
not nullify whole struct when ={0} is used.

> > for (i = RSVD_BEACON + 1; i <= RSVD_QOS_NULL ; i++) {
> > 	kfree(rwdev->rsvd_page_arr[i]));
> > 	rsvd_page_arr[i] = NULL;
> > }
> > 
> > And other operations like adding / removing / checking if present could
> > be simplified as well.
> > 
> > Also RSVD_PROBE_RESP page is never created.
> 
> RSVD_PROBE_RESP will be used for AP/GO mode,
> so I think I might leave it here.
> 
> And change rsvd_list to array is not a good idea if there is more than
> one interfaces running. For this case will need to download more rsvd
> packets, and the order can be changed. Array seems not enough to
> handle that.

I guess this will be changed in the future, because for now order 
is always the same:

	rtw_add_rsvd_page(rtwdev, RSVD_PS_POLL, true);
	rtw_add_rsvd_page(rtwdev, RSVD_QOS_NULL, true);
	rtw_add_rsvd_page(rtwdev, RSVD_NULL, true);

and we can not add more of the same pages because of check 
                
	if (rsvd_pkt->type == type)
		return;

in rtw_add_rsvd_page(). In general this interface does not seem
to be workable with multi vif. But I assume this will be fixed
in the future, so list seems to be fine.

Thanks
Stanislaw
