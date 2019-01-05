Return-Path: <SRS0=nI2m=PN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0644C43387
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 19:44:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66EAD222FB
	for <linux-wireless@archiver.kernel.org>; Sat,  5 Jan 2019 19:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="fNm9edF/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726282AbfAEToP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 5 Jan 2019 14:44:15 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40692 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfAEToP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Jan 2019 14:44:15 -0500
Received: by mail-ed1-f67.google.com with SMTP id g22so34500820edr.7
        for <linux-wireless@vger.kernel.org>; Sat, 05 Jan 2019 11:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UKlw6eRib9cLl6qrw+jWUT8Rk/gudPLkz5QMl/ABkCM=;
        b=fNm9edF/JPlovAnBGJ2Q5idFj7sePJDqap1a4rSm9LGENeLmRBb7BwEJD3oEByTcsB
         Aj6XIi/4bWMkznnABWm1MGYw/wbbeGX43XOw0T2HL3Xri0x0bzC4+i8dHxXEuuaukFKh
         b0UGMsKEcfh9aaEI3YRH1cQnGRN79km2Nqrsk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UKlw6eRib9cLl6qrw+jWUT8Rk/gudPLkz5QMl/ABkCM=;
        b=h9fbUk5A1Go8m+q6u13eIY09flwStnP5D/9kzQjH4NCW2L0HyNRYki9zb/iGYYZ7iT
         wcSYUzMxYJdW3oPqpTuyYGqiUhiq8gz1u9sTzsjJNNTQEL57AKQHry9fB0TRRhNJdQta
         0pp1rbqwPR/sldaaBYrIFheZVmE10KWo+62n1U2iVtDrsjL71mYGbg4dIrgwZ/8KDFqb
         MSPKUu5SSBtRmTA50tkUbGnGg+ltZpOu0VjrgeIw3/mzFvbhKz95gT3QTg7BKKeCcj7q
         KoIQxDy3YQHQLy2TLJd0+19eXEuEqOOxF+Bvcqd1ymEnF3Dj+XBuVSjHHd6KlbgLWcGc
         Q8Qg==
X-Gm-Message-State: AA+aEWbF2+kHvW1GM778kj+oho+y5KhR5nbCn/6xhaouVX67bg1BDrwt
        tkEvmPB97QyA21EHiaLLha8sSQ==
X-Google-Smtp-Source: AFSGD/XBuDDUyqnL5wuvI2UOvJIXBTsG0mO6wI/y5tO5XhigVQp0GoSaINq78+3mRoY9IBpaBXm1zg==
X-Received: by 2002:a50:ae64:: with SMTP id c91mr50146564edd.222.1546717452755;
        Sat, 05 Jan 2019 11:44:12 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id t9sm27498568edd.25.2019.01.05.11.44.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 05 Jan 2019 11:44:12 -0800 (PST)
Subject: Re: Kernel oops / WiFi connection failure with wpa_supplicant 2.7
To:     Jouni Malinen <j@w1.fi>, Eric Blau <eblau@eblau.com>
Cc:     hostap@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Denis Kenzior <denkenz@gmail.com>
References: <CADU241PtPeiTQWHwb=uF6Ohuua_asOwCarCAKVC8jdVVNAsByA@mail.gmail.com>
 <20190103154921.GA25015@w1.fi>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <41e7ccaf-c73d-b404-69fe-ad17433add37@broadcom.com>
Date:   Sat, 5 Jan 2019 20:44:11 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190103154921.GA25015@w1.fi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/3/2019 4:49 PM, Jouni Malinen wrote:
> On Thu, Jan 03, 2019 at 10:38:32AM -0500, Eric Blau wrote:
>> Since upgrading to wpa_supplicant 2.7, myself and many others have hit
>> issues with wpa_supplicant failing to connect due to invalid arguments
>> being passed to the underlying kernel driver. Reverting to version 2.6
>> makes these issues go away.
> 
>> kernel: WARNING: CPU: 0 PID: 16169 at
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:5130
>> brcmf_cfg80211_set_pmk+0x50/0x70 [brcmfmac]
> 
> Which is this WARN_ON in the driver:
> 
>      /* expect using firmware supplicant for 1X */
>      ifp = netdev_priv(dev);
>      if (WARN_ON(ifp->vif->profile.use_fwsup != BRCMF_PROFILE_FWSUP_1X))
> 	return -EINVAL;

Yes. It means the firmware is not configured to use the 1x offload so it 
rejects the PMK setting here.

>> Notice that the oops references wpa_supplicant as the offending
>> process, although maybe the firmware or driver is at fault for
>> advertising 4-way handshake offload support.
> 
> That's not an oops and wpa_supplicant is not the "offending process", it
> is just the user space process in which context the driver hits this
> issue.

Well, I beg to differ but I will get to that.

>> Any ideas what the issue could be here? If there's anything else I can
>> do to help track down the problem, please let me know.
> 
> That should be reported to the maintainers of the kernel driver that has
> this issue:

So the issue is that the nl80211 api requires wpa_supplicant to provide 
an attribute in the NL80211_CMD_CONNECT to indicate that driver/firmware 
should do the 1x offload which is described in the second paragraph below:

/**
  * DOC: WPA/WPA2 EAPOL handshake offload
  *
  * By setting @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_PSK flag drivers
  * can indicate they support offloading EAPOL handshakes for WPA/WPA2
  * preshared key authentication. In %NL80211_CMD_CONNECT the preshared
  * key should be specified using %NL80211_ATTR_PMK. Drivers supporting
  * this offload may reject the %NL80211_CMD_CONNECT when no preshared
  * key material is provided, for example when that driver does not
  * support setting the temporal keys through %CMD_NEW_KEY.
  *
  * Similarly @NL80211_EXT_FEATURE_4WAY_HANDSHAKE_STA_1X flag can be
  * set by drivers indicating offload support of the PTK/GTK EAPOL
  * handshakes during 802.1X authentication. In order to use the offload
  * the %NL80211_CMD_CONNECT should have %NL80211_ATTR_WANT_1X_4WAY_HS
  * attribute flag. Drivers supporting this offload may reject the
  * %NL80211_CMD_CONNECT when the attribute flag is not present.
  *
  * For 802.1X the PMK or PMK-R0 are set by providing %NL80211_ATTR_PMK
  * using %NL80211_CMD_SET_PMK. For offloaded FT support also
  * %NL80211_ATTR_PMKR0_NAME must be provided.
  */

For testing I had modified the wpa_supplicant to add the required flag 
in CONNECT command, but it was a bit too hacky to submit. I will rebase 
those changes and clean it up.

However, there is more to it. When these offloads were introduced, we 
discussed about having a PORT_AUTHORIZED event or not. It was decided 
passing an attribute in CONNECT and ROAMED event would suffice and that 
is what was implemented in brcmfmac. However, it seems time passed and 
the need for an explicit PORT_AUTHORIZED was there (probably Denis 
knows), which wpa_supplicant now supports thus ignoring the attribute in 
the CONNECT and ROAMED events. The brcmfmac driver was not changed 
accordingly. For this there are patches pending in linux-wireless which 
are necessary to have a working connection.

Regards,
Arend
