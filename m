Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E48C433F5
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Mar 2022 16:03:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350619AbiCUQEm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Mar 2022 12:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350611AbiCUQEl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Mar 2022 12:04:41 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A52A19C39
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2022 09:03:16 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1647878595; bh=GIMOQVAlRto1aWif8SmVyJalyhr2DjKsNt00GHMXUW8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZEo8xoSV8XDmtEZlQY9zYnYnvhd3KypzdjSYnzomXa6s9YnhEOvQAjv5DxALchBuq
         EGwckiRUzBfyiBN426V5Gb8HS9tqJmi01k7RoMfn2i/B38PA/mCYFrLkTSOwA7QLhU
         I8e1664F5MHIDzXawaRofms7Vc6+GGfLr+53Sv1qLphJuGZhgac0WkI3/e/T0ju500
         0wgDD7wFgyRf+1WaRRUBh45paxqt/UKPodcMhhMwlm5TDFaGqRbeywBt8QZjxis350
         nXW1XB2cyhhiFOr06MqFOmcMwPfHV7oN/S8qU2tf8x5V9HkTm3d/Qe6ZJT6Zu0DmEB
         mGISeQ4ALuRzQ==
To:     Wenli Looi <wlooi@ucalgary.ca>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Wenli Looi <wlooi@ucalgary.ca>
Subject: Re: [PATCH 5/6] ath9k: refactor ar9003_hw_spur_mitigate_ofdm
In-Reply-To: <20220320233010.123106-6-wlooi@ucalgary.ca>
References: <20220320233010.123106-1-wlooi@ucalgary.ca>
 <20220320233010.123106-6-wlooi@ucalgary.ca>
Date:   Mon, 21 Mar 2022 17:03:15 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8w78f98.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wenli Looi <wlooi@ucalgary.ca> writes:

> Similar to ar9003_hw_spur_mitigate_mrc_cck, simplify the code by using
> ar9003_get_spur_chan_ptr. This may also be required for QCN550x support,
> to provide an abstraction over the underlying EEPROM format.
>
> Signed-off-by: Wenli Looi <wlooi@ucalgary.ca>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
