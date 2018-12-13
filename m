Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FE73C67839
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 16:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55B2F20879
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 16:03:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Ww5x9YFG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Wap0J4HE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55B2F20879
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729455AbeLMQDZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:03:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:58758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729445AbeLMQDZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 11:03:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6E35D60795; Thu, 13 Dec 2018 16:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544717004;
        bh=jMDh11NmuUt7ArxMVeVCv9dtmQAGItLg3t0CTSsIwz0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Ww5x9YFGb6BlZVTfMAh+VC5Gn5csXT7/wcjnSMK4+DcUvZ3HpCfT3younYKlX0R+H
         Belo0Roq/WWp4vP56awbaXOMRCsxMuDCuHtkzLin+y/78dRpkE5cgAs+v46aKp59OC
         rNShND7mOIDJZHf+dBTyPj0mQXZlp7vvwV/myGo0=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6BBDF602FA;
        Thu, 13 Dec 2018 16:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544717003;
        bh=jMDh11NmuUt7ArxMVeVCv9dtmQAGItLg3t0CTSsIwz0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Wap0J4HEW1SSaTMYCqaDywWt96wevW9bLU7r8D73OZ9Fly5SJ8I+oAyZ6xlP7nrK0
         A+Of8G5FTl9QBk4OXNRmnmvyr+LvRnKEi3hA3hbSgtCgr5SyM71QX3eJHN454AdUV4
         z9WZADNkm8S2Ov7MswjpSEUj9tf6oZKXOaATbBvM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6BBDF602FA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stijn Tintel <stijn@linux-ipv6.be>
Cc:     linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com,
        Stable <stable@vger.kernel.org>,
        Jonas Gorski <jonas.gorski@gmail.com>
Subject: Re: [PATCH wireless-drivers] brcmfmac: fix roamoff=1 modparam
References: <20181204182905.32267-1-stijn@linux-ipv6.be>
        <20181213134605.5F09D60312@smtp.codeaurora.org>
Date:   Thu, 13 Dec 2018 18:03:20 +0200
In-Reply-To: <20181213134605.5F09D60312@smtp.codeaurora.org> (Kalle Valo's
        message of "Thu, 13 Dec 2018 13:46:05 +0000 (UTC)")
Message-ID: <877egd8ldj.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Stijn Tintel <stijn@linux-ipv6.be> wrote:
>
>> When the update_connect_param callback is set, nl80211 expects the flag
>> WIPHY_FLAG_SUPPORTS_FW_ROAM to be set as well. However, this flag is
>> only set when modparam roamoff=0, while the callback is set
>> unconditionally. Since commit 7f9a3e150ec7 this causes a warning in
>> wiphy_register, which breaks brcmfmac.
>> 
>> Disable the update_connect_param callback when roamoff=0 to fix this.
>> 
>> Fixes: 7f9a3e150ec7 ("nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS")
>> Cc: Stable <stable@vger.kernel.org> # 4.19+
>> Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
>> Signed-off-by: Stijn Tintel <stijn@linux-ipv6.be>
>
> Should this go to 4.20? Arend?

I talked with Arend offline and we concluded to push this to -next.

-- 
Kalle Valo
