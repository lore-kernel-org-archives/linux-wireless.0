Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 985BCC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:54:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C83B218B0
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 18:54:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rq29J2ZZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732660AbfB1Syd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 13:54:33 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33337 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbfB1Syd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 13:54:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id x9so12768079qkf.0
        for <linux-wireless@vger.kernel.org>; Thu, 28 Feb 2019 10:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PO6VIOuLRkiVuxuTMkQjgBZrtLQmdO5V0JmDv66pSOs=;
        b=Rq29J2ZZURzODFj5DylwwwM4Jc2EsdrOfEeo64e4vfKZxlNYMtSHNgh3p/geDt349n
         LuQQJSDplithlXwvXZkjXSwkDCL5z3eskPjxK1Xdg8YZEa4SmrgKw6FjpUWbPnfiBX/4
         8BfzNnlbA823XTeWQYb7sT9u+oNABETmLDX9lkUoLrh6ywLOUDuTd3z8pUW7XdEu7viG
         WueH//sYB8Gte21W/PwXFR42B6HDYPs8rNGTQYSsp+78juYysaRIWbyofAth9X88BGd6
         boUIirqJeO4Upd72NsO2qbjZKw9uWUh9jSAzssH6mg8OQEjtml40dWkL/pznTOlYvZ2h
         47aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PO6VIOuLRkiVuxuTMkQjgBZrtLQmdO5V0JmDv66pSOs=;
        b=d8bpum2uI3qUwXTpFGXQgaFftJiO/DgnfDVsiuZlTpSvHfqMK+c/LEHoKR3BIqAOg1
         EMN9ztk6uhnjxnnDSW1kiiYOVQI8JOhogCcEvZCk3Sqw0AeGrRfD+116ToMS5OFbrcwP
         1SCb2INQTVZ/C5tzgtL78vx1UhWfzkd2OcBxacO7vd7FH4bt02phdXtspoFSEigGVshK
         hrRlcmI2g0g54BVLn+rk4nnpjzHA9ZBjcr9AgVRCZQGGCKIoCM1EYaD2csLEX4OW+G5f
         g3YOhuRgkkVUpEB4biSbBUyPipRdRUqzOXEidZXTA/diiQHV0Bau4iAwqjQO/fRk3Tr9
         u5rQ==
X-Gm-Message-State: APjAAAXQj8Hjq+stCo8qce1yOb4H+vRjmFlpmzotQCsV2YJNWfQfTAXP
        TKH8AMe4P28oP3S4YQf+XU5LxRPRjSMmGcLTWcwbBjkN
X-Google-Smtp-Source: APXvYqxefFVKIniQfLfnDocZ+FGuMY2udgbqExyR3o/3RhHkdraXnzF5+DVvUlGmmdvgZv24JlSvhmPZnfySX+EHa/w=
X-Received: by 2002:ae9:efcb:: with SMTP id d194mr814018qkg.156.1551380071908;
 Thu, 28 Feb 2019 10:54:31 -0800 (PST)
MIME-Version: 1.0
References: <20190228155823.24749-1-greearb@candelatech.com>
In-Reply-To: <20190228155823.24749-1-greearb@candelatech.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Thu, 28 Feb 2019 19:54:19 +0100
Message-ID: <CABvG-CUTn3aHAUUvQ6P+BtaWPtrBeeO8b3vfm5w=hB753_+g0g@mail.gmail.com>
Subject: Re: [RFC] ath10k: Fix DMA errors related to beacons (CT FW only)
To:     Ben Greear <greearb@candelatech.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 28 Feb 2019 at 16:59, <greearb@candelatech.com> wrote:
>
> From: Ben Greear <greearb@candelatech.com>
>
> I often saw the ath10k-ct wave-1 firmware spit DMA errors and
> hang the entire system, requiring a hard power-cycle to revoer.
>
> It appears the issue is that there is no beacon-tx callback in
> stock firmware, so the driver can delete the beacon DMA buffer
> while firmware is still trying to access it.
>
> So, wave-1 ath10k-ct firmware now sends a beacon-tx-complete
> wmi message and that allows the driver to safely know when it
> can clean up the buffer.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>
> NOTE:  This will not apply or work in upstream kernels since the
> rest of the CT fw support will not be accepted.  But, I'd appreciate
> any technical feedback on this in case I missed any corner cases
> on locking or similar.

For the record this patch seems to be based on code with "ath10k: Free
beacon buf later in vdev teardown" included.


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c
> index 154dcdabc48a..02a8efa2e783 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
[...]
> @@ -6147,6 +6151,16 @@ static void ath10k_remove_interface(struct ieee802=
11_hw *hw,
>                 ath10k_warn(ar, "failed to stop spectral for vdev %i: %d\=
n",
>                             arvif->vdev_id, ret);
>
> +       if (test_bit(ATH10K_FW_FEATURE_BEACON_TX_CB_CT,
> +                     ar->running_fw->fw_file.fw_features)) {
> +               int time_left;
> +
> +               time_left =3D wait_for_completion_timeout(&arvif->beacon_=
tx_done, (3 * HZ));
> +               if (!time_left)
> +                       ath10k_warn(ar, "WARNING: failed to wait for beac=
on tx callback for vdev %i: %d\n",
> +                                   arvif->vdev_id, ret);
> +       }

I think this can race against wmi tx credits replenishment and maybe
other wmi commands if they get issued (not many of them I suppose
though). The ordering would need to be something like this:

cpu0                   cpu1
                       ath10k_wmi_op_ep_tx_credits
                       ieee80211_iterate_active_interfaces_atomic
                       ath10k_wmi_beacon_send_ref_nowait
                       # preempted
ieee80211_do_stop
clear sdata running
drv_remove_interface
wait_for_completion_timeout
ath10k_mac_vif_beacon_cleanup
free/unmap
                       gen_beacon_dma(bcn->xxx)
                       reinit_completion()
                       ath10k_wmi_cmd_send_nowait()

Interestingly, this also shows it has been a possible use-after-free
without your patch. This is probably a unlikely scenario because
there's a disproportionate amount of code between these flows for this
to happen.

There's also a memory leak because ath10k_mac_vif_beacon_free() exits
without freeing arvif->beacon if beacon_state is SENDING, which it
will be in in the above race case.

With the per-skb beaconing case (which is dead code by the way it
seems..) iommu wouldn't be happy either because we'd hand over an
unmapped paddr to ath10k_wmi_cmd_send_nowait(). That's assuming kernel
didn't crash due to use-after-free on arvif->beacon (stored in `bcn`
on stack) before that.

This feels like a candidate for rcu if you wanted to have it fixed
neatly. It would fix both use-after-free and the locking conundrum -
ath10k_remove_interface() could NULL the pointer, call_rcu() and
wait_for_completion() in that call handler, and when its called back
unmap/free the beacon. This would require a refactor to how beacon
stuff is stored/maintained - a helper structure that would need carry
the beacon stuff + rcu_head, and this structure would be allocated and
assigned with rcu_assign_pointer() to a pointer in ath10k_vif. But I
feel like it's asking for unbound allocations or other bugs,
especially since I'm...

Not sure if it makes any sense. I would probably just rip out the
arvif->beacon code completely instead and keep arvif->beacon_buf only
(memcpy on swba and immediatelly free the skbuff). No point in fixing
dead code, is there?

Since you have beacon tx completion you can consider preventing beacon
corruption, similar to how disabled vsync causes frame tearing, by
avoiding memcpy() if completion for previous one didn't come. Not sure
how relevant that is though because if fw/hw are having hard time
transmitting a beacon then the RF condition must be really harsh and
unusably bad anyway.



Micha=C5=82
