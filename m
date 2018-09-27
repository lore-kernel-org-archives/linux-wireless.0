Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CFEC43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 04:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A8B02150D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 04:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B9jLdK25";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="B9jLdK25"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A8B02150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbeI0KxL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 06:53:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbeI0KxL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 06:53:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DC3CE60B73; Thu, 27 Sep 2018 04:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538023015;
        bh=CuNpMT27x7rbtjV2R+ibfnanTbbjVshv8Mi+LORWMNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B9jLdK25KqecuNwOQMwQlW8ztha5P2aZVTem6QMcgsdHcbM/h6rf5iT1jIuusEhJd
         vfWMSibR3Jy2CZUqrK3AwYRaEW2j/PdkfxB+lUM4tCVqny/YfI3fUQkKLgkNe9cgJj
         dgwzujlUVySUMj1DACPORelbUShtxT2kdrBVWmcc=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5C52D607DD;
        Thu, 27 Sep 2018 04:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538023015;
        bh=CuNpMT27x7rbtjV2R+ibfnanTbbjVshv8Mi+LORWMNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B9jLdK25KqecuNwOQMwQlW8ztha5P2aZVTem6QMcgsdHcbM/h6rf5iT1jIuusEhJd
         vfWMSibR3Jy2CZUqrK3AwYRaEW2j/PdkfxB+lUM4tCVqny/YfI3fUQkKLgkNe9cgJj
         dgwzujlUVySUMj1DACPORelbUShtxT2kdrBVWmcc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 27 Sep 2018 10:06:55 +0530
From:   Maharaja Kennadyrajan <mkenna@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: Add debugfs support to get power save state
 change of STA
In-Reply-To: <20180926141208.0A87160C86@smtp.codeaurora.org>
References: <1537252467-17353-1-git-send-email-mkenna@codeaurora.org>
 <20180926141208.0A87160C86@smtp.codeaurora.org>
Message-ID: <7a0f6d9724f75bda6d0554810b4efcb7@codeaurora.org>
X-Sender: mkenna@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-26 7:42 pm, Kalle Valo wrote:
> Maharaja Kennadyrajan <mkenna@codeaurora.org> wrote:
> 
>> This patch helps to get the power save state change of each peer
>> connected to the AP. With WMI_10_4_PEER_STA_PS_STATECHG_EVENTID
>> event, ps state of each peer is reported to user space via
>> debugfs.
>> 
>> Use the below command to get the ps state of each sta:
>> cat /sys/kernel/debug/ieee80211/phyX/netdev::wlanX/stations/
>> XX:XX:XX:XX:XX:XX/peer_ps_state
>> 
>> If STA is in power save state, we get the peer_ps_state value as 1.
>> if STA is not in power save state, we get the peer_ps_state value as 
>> 0.
>> If ps_state event is disabled, we get the peer_ps_state value as 2.
>> 
>> We can enable/disable the ps_state events using the debugfs flag
>> "ps_state_enable"
>> 
>> echo Y > /sys/kernel/debug/ieee80211/phyX/ath10k/ps_state_enable
>> 
>> Y = 1 to enable and Y = 0 to disable
>> 
>> Tested in QCA4019 with firmware ver 10.4-3.2.1.1-00011
>> 
>> Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> This introduced a new warning:
> 
> drivers/net/wireless/ath/ath10k/wmi.c:5061:1: warning: symbol
> 'ath10k_wmi_event_peer_sta_ps_state_chg' was not declared. Should it
> be static?

[Maha]: Yes, it should be static.

> I fixed this in the pending branch.
[Maha]: Thanks Kalle.

-- 
Regards,
Maha
