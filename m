Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B343C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:54:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33BA821928
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 16:54:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ixoXB4BQ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="AD26PMMn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405554AbfBNQy0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 11:54:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbfBNQyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 11:54:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2704960B22; Thu, 14 Feb 2019 16:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550163265;
        bh=uMrztItdzlQVqAwoMH2X6y5Bbo0Fiy6PgbNCGsvSi4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ixoXB4BQAlaEN7Rw5M0E8a22UsDGOeRt6NHhBQ5NkVdIe3vsF7TkpA46bVdadXM/y
         lQgZx4cvYtcwm2JjZPOHn5mMi8BMZZDy5wALYX20ri7DYeCn0sbm1H9vqSQYxT+6Tb
         lseKFPLVxBbHq9aFHthg3k0w8hyVSLpTI54QP0AE=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id BE1DF60985;
        Thu, 14 Feb 2019 16:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550163263;
        bh=uMrztItdzlQVqAwoMH2X6y5Bbo0Fiy6PgbNCGsvSi4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AD26PMMn3ium46kamFPMVqLiYxFip2MlnORK0ZkSItYRuLKfBK+c9ziTrKAK/IoPp
         X8QguyFMJgUl6y/mhapmSnG5GyzfXnr/zD8UrDo8tZK+lv8u2MsRcYhz9rF1naJ9C9
         JgebdqAPTKiVUkm+gfDrgLeX1SNscVRBHQbuxesA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 14 Feb 2019 18:54:23 +0200
From:   merez@codeaurora.org
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2 01/12] wil6210: remove rtap_include_phy_info module
 param
In-Reply-To: <20190213164052.9C00A608D2@smtp.codeaurora.org>
References: <1548689786-23288-2-git-send-email-merez@codeaurora.org>
 <20190213164052.9C00A608D2@smtp.codeaurora.org>
Message-ID: <55aa3438f980cf239001aeb98cae3bd5@codeaurora.org>
X-Sender: merez@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-02-13 18:40, Kalle Valo wrote:
> Maya Erez <merez@codeaurora.org> wrote:
> 
>> rtap_include_phy_info is not in use, hence can be removed.
>> 
>> Signed-off-by: Maya Erez <merez@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Kbuild bot reported a warning:
> 
>    drivers/net/wireless/ath/wil6210/txrx.c: In function 
> 'wil_vring_reap_rx':
>>> drivers/net/wireless/ath/wil6210/txrx.c:341:25: warning: 'rtap' may 
>>> be used uninitialized in this function [-Wmaybe-uninitialized]
>      rtap->rthdr.it_version = PKTHDR_RADIOTAP_VERSION;

The assignment line was deleted by mistake:
rtap = skb_push(skb, rtap_len);
I'll fix that.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
