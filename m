Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ADE8C64EAD
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:57:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4AECD2064E
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 10:57:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4AECD2064E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbeJISOG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 14:14:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11717 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbeJISOG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 14:14:06 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5E07308213B;
        Tue,  9 Oct 2018 10:57:43 +0000 (UTC)
Received: from localhost (unknown [10.40.205.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7B9CF7553B;
        Tue,  9 Oct 2018 10:57:43 +0000 (UTC)
Date:   Tue, 9 Oct 2018 12:57:42 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/5] rt2x00: rework channel config function
Message-ID: <20181009105731.GA25717@redhat.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com>
 <1537201975-3032-2-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1537201975-3032-2-git-send-email-pozega.tomislav@gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 09 Oct 2018 10:57:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Sep 17, 2018 at 06:32:52PM +0200, Tomislav Požega wrote:
> Enable LNAs only for the current operating band. Change power
> amplifiers enabling style to the one in vco calibration routine
> and drop redundant cap_bt_coexist enable of PA0.
<snip>
> -		rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN,
> -				   rf->channel > 14);
> -		if (rt2x00_has_cap_bt_coexist(rt2x00dev))
> +	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
> +		switch (rt2x00dev->default_ant.tx_chain_num) {
> +		case 3:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A2_EN, 1);
> +		case 2:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A1_EN, 1);
> +		case 1:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_A0_EN, 1);
> +		break;
> +		}
> +	} else {
> +		switch (rt2x00dev->default_ant.tx_chain_num) {
> +		case 3:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN, 1);
> +		case 2:
> +			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G1_EN, 1);
> +		case 1:

So we never disable PA_PE_Gx_EN bits for RT6352 since tx_pin variable
is not nulifed, but read from register. I don't think this was intended.

Thanks
Stanislaw
