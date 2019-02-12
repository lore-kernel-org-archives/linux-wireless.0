Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FBDEC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 19:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC7E7222C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 19:54:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IVd5uCH5";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="V8PRQisc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbfBLTyt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 14:54:49 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60078 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727659AbfBLTys (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 14:54:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9C726607DF; Tue, 12 Feb 2019 19:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550001287;
        bh=R8vUW9ZZ8acUk9GIN7X8ogNMbfGVAgioDCoVhDzN/sg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=IVd5uCH5ZeJ7N6HRWoFrVcr/QzNtzcD6zvLl90s1UGddKeyb4e4zdSvxRmxTp8qJ7
         Ctw9KPyxOjCof2C1bL+Np+RPDOyOYMMYKUxslBYknrodPe3zIY98JuDwcx/wWJ3+T8
         +9JYqG+jMzndel2CshXJKQlh9cTJku+lRjZcM+ss=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E497E6055B;
        Tue, 12 Feb 2019 19:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550001286;
        bh=R8vUW9ZZ8acUk9GIN7X8ogNMbfGVAgioDCoVhDzN/sg=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=V8PRQiscjr4wQIqTyTHTLSBL3rUDMioczqCnxj8jIhQA0CPRVyUbKV8fjdpBAbGdP
         vj4DLCoubRlPg23WjZXbTZ/HcELqyIoD4dkmmJQvRMkq08chk3r/UE5TUIKBqnkUSh
         GV1BcLaOzIxzwynEvT9navQvuc7L8MnAverzKHrg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org E497E6055B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Enable support for beacon interval per VAP
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1549979286-9255-1-git-send-email-dundi@codeaurora.org>
References: <1549979286-9255-1-git-send-email-dundi@codeaurora.org>
To:     Dundi Raviteja <dundi@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Dundi Raviteja <dundi@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190212195447.9C726607DF@smtp.codeaurora.org>
Date:   Tue, 12 Feb 2019 19:54:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dundi Raviteja <dundi@codeaurora.org> wrote:

> Enable support to configure different beacon interval per VAP.
> 
> To support this feature, map different beacon interval service bit
> to wmi tlv service.
> 
> Tested HW: WCN3990
> Tested FW: WLAN.HL.2.0-01188-QCAHLSWMTPLZ-1
> 
> Signed-off-by: Dundi Raviteja <dundi@codeaurora.org>

Does not compile:

In file included from drivers/net/wireless/ath/ath10k/mac.c:34:
drivers/net/wireless/ath/ath10k/wmi-tlv.h: In function 'wmi_tlv_svc_map_ext':
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1571:15: error: 'WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT' undeclared (first use in this function); did you mean 'WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT'?
  SVCMAP(WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
               WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1571:15: note: each undeclared identifier is reported only once for each function it appears in
In file included from drivers/net/wireless/ath/ath10k/wmi.c:26:
drivers/net/wireless/ath/ath10k/wmi-tlv.h: In function 'wmi_tlv_svc_map_ext':
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1571:15: error: 'WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT' undeclared (first use in this function); did you mean 'WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT'?
  SVCMAP(WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
               WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1571:15: note: each undeclared identifier is reported only once for each function it appears in
In file included from drivers/net/wireless/ath/ath10k/wmi-tlv.c:24:
drivers/net/wireless/ath/ath10k/wmi-tlv.h: In function 'wmi_tlv_svc_map_ext':
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1571:15: error: 'WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT' undeclared (first use in this function); did you mean 'WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT'?
  SVCMAP(WMI_TLV_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~     
               WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT
drivers/net/wireless/ath/ath10k/wmi-tlv.h:1571:15: note: each undeclared identifier is reported only once for each function it appears in
make[5]: *** [drivers/net/wireless/ath/ath10k/mac.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[5]: *** [drivers/net/wireless/ath/ath10k/wmi.o] Error 1
make[5]: *** [drivers/net/wireless/ath/ath10k/wmi-tlv.o] Error 1
make[4]: *** [drivers/net/wireless/ath/ath10k] Error 2
make[3]: *** [drivers/net/wireless/ath] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10807921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

