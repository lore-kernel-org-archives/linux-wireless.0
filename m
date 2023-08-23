Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B3FEE4993
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Aug 2023 11:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbjHWLGF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Aug 2023 07:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231678AbjHWLGF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Aug 2023 07:06:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED92CDA
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2023 04:05:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2530961CFD
        for <linux-wireless@vger.kernel.org>; Wed, 23 Aug 2023 11:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BAEC433C7;
        Wed, 23 Aug 2023 11:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692788747;
        bh=gWW8ouBNZ/ywTHAIxKHqz4PVMTFAeBtMlVrdT+Q+DP4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cMyxRSpZA91yj3C3SFAnzNDe5yka4NMEXvQE9npk7WhUY7hw9QnnRXquaUKWwTCcu
         TfsH+zN1xfXfBH/9nOSRmk2yxVAjNsF/kZN8vnYxRnojuXhb29t5XdETqIM3IuttJR
         tBRSweUCL9FhKfLJqRvuWhatULs522VDDNlTuRdoHnZTbdUiuhbSBCj57OGLs/D+qR
         ggz53+cguA2bkTti1nFwHHe3+/Io4VT5zbK+qE1rwrRtIMIq0dGtRc911Vh46YpncA
         1/2E0R9VK36KdFxXonESJIwYK+YYnSiotppjEThA2c3RfulJnXXmc2PgSnflj9GTEC
         kKZkjWhPShT1g==
From:   Kalle Valo <kvalo@kernel.org>
To:     <Prasurjya.Rohansaikia@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Ajay.Kathat@microchip.com>,
        <claudiu.beznea@microchip.com>
Subject: Re: [PATCH v2] wifi: wilc1000: Added back-off algorithm to balance
 tx queue packets.
References: <20230816162259.33342-1-prasurjya.rohansaikia@microchip.com>
Date:   Wed, 23 Aug 2023 14:06:46 +0300
In-Reply-To: <20230816162259.33342-1-prasurjya.rohansaikia@microchip.com>
        (Prasurjya Rohansaikia's message of "Wed, 16 Aug 2023 16:22:55 +0000")
Message-ID: <871qfuvwzd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

<Prasurjya.Rohansaikia@microchip.com> writes:

> From: Prasurjya Rohan Saikia <prasurjya.rohansaikia@microchip.com>
>
> Added an algorithm to backoff the Tx Task when low memory scenario is
> triggered at firmware. During high data transfer from host, the firmware
> runs out of VMM memory, which is used to hold the frames from the host.
> So added flow control to delay the transmit from host side when there is
> not enough space to accomodate frames in firmware side.
>
> Signed-off-by: Prasurjya Rohan Saikia <prasurjya.rohansaikia@microchip.com>

[...]

> -		} while (ret == WILC_VMM_ENTRY_FULL_RETRY && !wl->close);
> +			if (ret != WILC_VMM_ENTRY_FULL_RETRY)
> +				break;
> +			/* Back off from sending packets for some time.
> +			 * schedule_timeout will allow RX task to run and free
> +			 * buffers. Setting state to TASK_INTERRUPTIBLE will
> +			 * put the thread back to CPU running queue when it's
> +			 * signaled even if 'timeout' isn't elapsed. This gives
> +			 * faster chance for reserved SK buffers to be freed
> +			 */
> +			set_current_state(TASK_INTERRUPTIBLE);
> +			schedule_timeout(msecs_to_jiffies
> +					 (TX_BACKOFF_WEIGHT_MS));
> +		} while (!wl->close);

Why not msleep_interruptible()?

Also an ack from Ajay would be good.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
