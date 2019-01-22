Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5386DC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB7720855
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 12:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RDnVvRhc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gWULOa2i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbfAVMxr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 07:53:47 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40766 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbfAVMxq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 07:53:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0E3F760791; Tue, 22 Jan 2019 12:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548161626;
        bh=JZRynTwKsTZPqrhI4CFdiBj/DseI5Pwciv1jCD0NyBg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RDnVvRhcjHFS+oDrbDXRghFbNW5CnJ6Wa6UY6WN+oKFneIigvHv2BW0GrzHQ24M/S
         3RsYn/X9w4aFXD5Enq6DNw6NDi/zI7r4uMCjRBD/wcwvXtWO0AD4vcOoUShEiCbcIc
         PUfwaI6Oqv2RsuDQTnlGz3Fvt4jy/J7BfszcPrjY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 787B76044E;
        Tue, 22 Jan 2019 12:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548161625;
        bh=JZRynTwKsTZPqrhI4CFdiBj/DseI5Pwciv1jCD0NyBg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gWULOa2iHj5aq77igZyd3sjfTJcol6SJ4KIxz/Xbmkl6LCq6xqCTGiqJXwlSisOw+
         IvWLzrZJlTq4kFdSqnFAqWwwQtiXEts70nFot+bJHk4BH/QIipQXrlWdhCUn23IhPJ
         +rk9G5kU0QxVEl1GuEAKlNTAW2S0yxIUJoOzBwd8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 787B76044E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 01/16] iwlwifi: mvm: support mac80211 AMSDU
References: <20190121075026.25059-1-luca@coelho.fi>
        <20190121075026.25059-2-luca@coelho.fi>
Date:   Tue, 22 Jan 2019 14:53:41 +0200
In-Reply-To: <20190121075026.25059-2-luca@coelho.fi> (Luca Coelho's message of
        "Mon, 21 Jan 2019 09:50:11 +0200")
Message-ID: <87va2gn99m.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> From: Sara Sharon <sara.sharon@intel.com>
>
> Support getting mac80211 building AMSDUs for us. Remove GSO
> support from mvm - we don't need it anymore.
>
> Signed-off-by: Sara Sharon <sara.sharon@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

[...]

> +static bool iwl_mvm_can_hw_csum(struct sk_buff *skb)
> +{
> +#if IS_ENABLED(CONFIG_INET)
> +	u8 protocol = ip_hdr(skb)->protocol;
> +
> +	return protocol == IPPROTO_TCP || protocol == IPPROTO_UDP;
> +#else
> +	return false;
> +#endif
> +}

I remember Andrew Morton a long time ago saying "Write in C, not in CPP"
or something like that. So would this work instead:

	u8 protocol = ip_hdr(skb)->protocol;

        if (!IS_ENABLED(CONFIG_INET))
                return false;

	return protocol == IPPROTO_TCP || protocol == IPPROTO_UDP;

Totally untested, of course :)

-- 
Kalle Valo
