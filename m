Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22C29C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 10:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B20BD2089A
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 10:30:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B20BD2089A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbeJBRMf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 13:12:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43722 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbeJBRMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 13:12:35 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2D4DC049D42;
        Tue,  2 Oct 2018 10:29:59 +0000 (UTC)
Received: from localhost (unknown [10.40.205.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C3BE2010CEC;
        Tue,  2 Oct 2018 10:29:58 +0000 (UTC)
Date:   Tue, 2 Oct 2018 12:29:58 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH 01/12] rtwlan: main files
Message-ID: <20181002102957.GB25116@redhat.com>
References: <1537509847-21087-1-git-send-email-yhchuang@realtek.com>
 <1537509847-21087-2-git-send-email-yhchuang@realtek.com>
 <20180927135040.GA4712@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08D9F56@RTITMBSVM01.realtek.com.tw>
 <20180928092918.GC8323@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D08DB7E3@RTITMBSVM01.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 02 Oct 2018 10:30:00 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Sep 28, 2018 at 11:32:41AM +0000, Tony Chuang wrote:
> > 	if (rtw_hci_tx(rtwdev, &pkt_info, skb))
> > 		dev_kfree_skb_any(skb)
> > 
> > just to remove 'return;' and out label.
> 
> 
> OK, but why not use ieee80211_free_txskb, should it be better for mac80211?

Yes, it is better as it also do some extra thing for dropped frame.

> > > OK, but I think this is needed, our tables have different forms ....
> > 
> > Not sure if that is better solution, but could the tables be pre-prarsed
> > by user-space program and then embed in the driver in ready to send
> > to the hardware from ?
> > 
> > Also there are lot of redundancy in those tables, for example:
> > 
> > +	0x81C, 0xFF000003,
> > +	0x81C, 0xF5000003,
> > +	0x81C, 0xF4020003,
> > +	0x81C, 0xF3040003,
> > +	0x81C, 0xF2060003,
> > +	0x81C, 0xF1080003,
> > +	0x81C, 0xF00A0003,
> > +	0x81C, 0xEF0C0003,
> > +	0x81C, 0xEE0E0003,
> > +	0x81C, 0xED100003,
> > +	0x81C, 0xEC120003,
> > +	0x81C, 0xEB140003,
> > +	0x81C, 0xEA160003,
> > +	0x81C, 0xE9180003,
> > +	0x81C, 0xE81A0003,
> > +	0x81C, 0xE71C0003,
> > +	0x81C, 0xE61E0003,
> > +	0x81C, 0xE5200003,
> > 
> > 0x81C and 0003 repeats in many lines.
> > 
> > This seems to be parse data, not that we have to write 0x81C
> > register many times. Would be possible to remove the redundancy?
> 
> 
> No, they cannot be removed, the sequence matters.
> And it is really writing to 0x81C ...
> It is really magic, I cannot believe to this, too.

This is contradiction for what I asked you before, i.e. doing parsing
in user space, but since we have this parsing mechanism in the driver
perhaps the tables can be coded in some more compact way, for example:

{ prefix, suffix, len, {data} }

{ 0x81C, 0x0003, N ,
  { 0xFF02 , 0xF500 , .... , 0xE520 } }

The rtw8822b_table.c file is quite big. 

Thanks
Stanislaw
 
