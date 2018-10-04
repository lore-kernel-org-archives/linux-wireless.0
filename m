Return-Path: <SRS0=EqeY=MQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FCBC64EB8
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:49:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC4F32082A
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Oct 2018 10:49:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AC4F32082A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbeJDRma (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Oct 2018 13:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45672 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727253AbeJDRma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Oct 2018 13:42:30 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3A50F3082E07;
        Thu,  4 Oct 2018 10:49:48 +0000 (UTC)
Received: from localhost (unknown [10.43.2.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5FAFB5D70A;
        Thu,  4 Oct 2018 10:49:47 +0000 (UTC)
Date:   Thu, 4 Oct 2018 12:49:45 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        pkshih@realtek.com, tehuang@realtek.com,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC v2 06/12] rtw88: fw and efuse files
Message-ID: <20181004104929.GA16819@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-7-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1538553748-26364-7-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Thu, 04 Oct 2018 10:49:48 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

On Wed, Oct 03, 2018 at 04:02:22PM +0800, yhchuang@realtek.com wrote:
> +void rtw_fw_do_iqk(struct rtw_dev *rtwdev, struct rtw_iqk_para *para)
> +{
> +	u8 h2c_pkt[H2C_PKT_SIZE] = {0};

Not sure if '= {0}' work as expected for arrays, you
want to nulify first byte or whole h2c_pkt ?

> +void rtw_add_rsvd_page(struct rtw_dev *rtwdev, enum rtw_rsvd_packet_type type,
> +		       bool txdesc)
> +{
> +	struct rtw_rsvd_page *rsvd_pkt;
> +
> +	list_for_each_entry(rsvd_pkt, &rtwdev->rsvd_page_list, list) {
> +		if (rsvd_pkt->type == type)
> +			return;
> +	}
> +
> +	rsvd_pkt = kmalloc(sizeof(*rsvd_pkt),
> +			   in_interrupt() ? GFP_ATOMIC : GFP_KERNEL);

It's never called from interrupt. You have to check kmalloc output value.

> +	rsvd_pkt->type = type;
> +	rsvd_pkt->add_txdesc = txdesc;
> +	list_add_tail(&rsvd_pkt->list, &rtwdev->rsvd_page_list);
<snip>
> +
> +void rtw_reset_rsvd_page(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_rsvd_page *rsvd_pkt, *tmp;
> +
> +	list_for_each_entry_safe(rsvd_pkt, tmp, &rtwdev->rsvd_page_list, list) {
> +		if (rsvd_pkt->type == RSVD_BEACON)
> +			continue;
> +		list_del(&rsvd_pkt->list);
> +		kfree(rsvd_pkt);
> +	}

It also not clear how the list is protected agains concurrent access.
However seems like much simpler solution would be use array instead of
the list. For example above code could be replaced by:

for (i = RSVD_BEACON + 1; i <= RSVD_QOS_NULL ; i++) {
	kfree(rwdev->rsvd_page_arr[i]));
	rsvd_page_arr[i] = NULL;
}

And other operations like adding / removing / checking if present could
be simplified as well.

Also RSVD_PROBE_RESP page is never created.

> +	*size = (total_page - 1) * page_size + page_margin;
> +	buf = kzalloc(*size, GFP_KERNEL | GFP_ATOMIC);

Those GPF flags contradict to each other :-)
and buf not checked agains NULL.

Thanks
Stanislaw
