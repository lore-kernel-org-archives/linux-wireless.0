Return-Path: <SRS0=oBLS=NQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DB3C46475
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:42:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F4B020827
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Nov 2018 11:42:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VJaT1pt7"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F4B020827
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729577AbeKEVCJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:02:09 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52828 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Nov 2018 16:02:08 -0500
Received: by mail-wm1-f66.google.com with SMTP id l66-v6so1840089wml.2
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 03:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:subject:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=shmYwTo+gykgr368SEU/+i34i31i2JPV6vj9elmRgFo=;
        b=VJaT1pt7Cxu0xWFoYC3P40C/zJj/wihdt3dNETqDhycn0sQw6wr0lDXaNo7RhCrxA5
         RSIVb/IKkcUXTW+QwLUbu3/fgA/ROy4XV6yLecAAV37wV34NEmXhzblu7M1yilz879oJ
         R9/92QW1bJ9yMjk4Nc+9U6LMbfH+qdp7pvOik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=shmYwTo+gykgr368SEU/+i34i31i2JPV6vj9elmRgFo=;
        b=a0igkkMlB270LKUPIwkV5jZ51V3sh1uN4hjkhznMB7pzXTYaCKngIJQZ7p8BVM6xLe
         209Pd9P4tv3ihI6NS/mChjWjnTGl3/zUR+UXL7/6cv1nf5PuxT+FRaUZ76vjI54Glu98
         YhEQFlkWVg462ub0eEj5E89j1ivEh65pEG3vmcP3BFVcpknL7q7zG8GkjkzP3UbQYsAa
         hl3gtvrJCiwr4uMGmP9yZmz+GSQrrSu/xDmVaBAqXqsSVncnwf2whSaVsud2G4XbNAg1
         XcSSQCm3VPcjQwW4M7XFBzuZcq0JnWRwgdbPCC0v1B2Qe4MSS2HtzV0UxfSBORRCVSAw
         aC7A==
X-Gm-Message-State: AGRZ1gJyCzdghVdOFI2Bi/92hCC67gqZiM4ZIa1Oiv0vLr2ee44WW9T7
        fKQPpLwLSrlbVvPg4J7Eyg/M2A==
X-Google-Smtp-Source: AJdET5eBLafoZDNrQymuwYc2EN9g6RPEAuByPpW6gRfiEB2HHi5JK/V6OLg2P9rj84DHAPMbGAAKWA==
X-Received: by 2002:a1c:9609:: with SMTP id y9-v6mr5718827wmd.67.1541418168153;
        Mon, 05 Nov 2018 03:42:48 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id g10-v6sm3226136wrs.95.2018.11.05.03.42.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 03:42:47 -0800 (PST)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH 6/6] brcmfmac: Cleanup brcmf_fw_request_done()
To:     Hans de Goede <hdegoede@redhat.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
References: <20181009124755.25402-1-hdegoede@redhat.com>
 <20181009124755.25402-6-hdegoede@redhat.com>
Cc:     linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-ID: <9741c4fc-fbe2-c45c-9775-18b71dbcfc85@broadcom.com>
Date:   Mon, 5 Nov 2018 12:42:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <20181009124755.25402-6-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 10/9/2018 2:47 PM, Hans de Goede wrote:
> The "cur" variable is now only used for a debug print and we already
> print the same info from brcmf_fw_complete_request(), so the debug print
> does not provide any extra info and we can remove it.

I guess this could have been collapsed in the first patch introducing 
brcmf_fw_complete_request(). All-in-all a nice cleanup. Thanks.

Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c   | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

