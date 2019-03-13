Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35625C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:12:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E6A72171F
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 09:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfCMJMz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 05:12:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13899 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726130AbfCMJMy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 05:12:54 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8B6207880A;
        Wed, 13 Mar 2019 09:12:54 +0000 (UTC)
Received: from localhost (unknown [10.40.205.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D5F56064B;
        Wed, 13 Mar 2019 09:12:53 +0000 (UTC)
Date:   Wed, 13 Mar 2019 10:12:53 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
Message-ID: <20190313091252.GB2663@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 13 Mar 2019 09:12:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Požega wrote:
> MFP can work with enabled HW crypt engine, but in this case
> available bandwidth is reduced at least when connecting to
> Archer C7 (QCA9558). Enable the feature for known to work chipsets-
> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
> default to 0 in order to prevent unintentional bandwidth drop.
> 
> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
> ---
>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> index a03b528..bb8204d 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
>  
> +	/* Experimental: Set MFP with HW crypto enabled. */
> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390) ||
> +	    rt2x00_rt(rt2x00dev, RT6352))
> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);

Is not that we support MFP in hardware. We just return -EOPNOTSUPP
in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
(since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
we fallback to software encryption.

Please repost patch that enable MFP unconditionally with
'Cc: stable@vger.kernel.org' tag.

Stanislaw
