Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B825CC25B0C
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Aug 2022 18:42:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245479AbiHISmY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Aug 2022 14:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347919AbiHISl3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Aug 2022 14:41:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E646810F4
        for <linux-wireless@vger.kernel.org>; Tue,  9 Aug 2022 11:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=tE0XMQILqhYQ+1XeOo06dyc11O7obDyIEuaiBH7MHO8=;
        t=1660068925; x=1661278525; b=esxugo8kC5cE+aa05yJ5OIXprc/4HmUhJB8zWxVoytw9/O6
        +4OimqZZBIMqcXzyhKHYYStjU+588c/DelBTlzJzNFKrGopkK+vybiVfdB0qd5/aCArLdqzqyB6qE
        qMXsaSO9hZ5BPxT+pOoCUSrqBc4h1/F4/bnuHazm9tClz13Fd9iiguLaulF6Zm2h+mvgtOekGB2Ba
        p4eYdhN+IymR20hhAMXmJPptNcRtSIIG+xS1qWMj/MIBcUjFNecT9uWIQ9v0gxUkDUYx3BrzOYsTc
        YCclYC+MztwCMp84cj7cvwF3q3mmqjDuene/Et2FlHm/cXc22wRQtsfjP42ENZaA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oLTlA-003Hgk-2w;
        Tue, 09 Aug 2022 20:15:21 +0200
Message-ID: <103f62efc89d86773fbd07729326f3ba08f4ea23.camel@sipsolutions.net>
Subject: Re: [RFC 2/2] wifi: mac80211: use link_id from ieee80211_rx_status
 to retrieve rx link
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 09 Aug 2022 20:15:20 +0200
In-Reply-To: <20220802065019.20791-3-quic_vthiagar@quicinc.com>
References: <20220802065019.20791-1-quic_vthiagar@quicinc.com>
         <20220802065019.20791-3-quic_vthiagar@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2022-08-02 at 12:20 +0530, Vasanthakumar Thiagarajan wrote:
> Fill rx.link with respective data_link from the reported link_id
> in rx_status. Any link_id > 15 is invalid. Non-MLO connections
> can use either 0 or 15 as the link_id. Please note that link_id
> 0 is used with non-MLO connections to avoid changes in the
> drivers not supporting MLO. For a 802.11 MLD address translated
> frame, driver must report the right link_id for the
> frame to get processed. When processing 802.3 frame format,
> link_id is not that critical, used only with stats update.
> In such case, all the stats will be updated for the deflink.

I think it might be worth splitting this patch a bit different - putting
some parts into the first patch already (that fill rx.link_id), and
keeping some others (statistics etc.) in this patch, which is then more
related to statistics?

>=20
>  	if (rx->link_id >=3D 0) {
> -		link =3D rcu_dereference(rx->sdata->link[rx->link_id]);
> -
> +		link =3D  rcu_dereference(sdata->link[rx->link_id]);

that has some spurious whitespace changes

> +	/*
> +	 * TODO: In MLO, should the frame be dropped if the right link_id is no=
t
> +	 * available? Or may be it is fine in the current form to proceed with
> +	 * the frame processing because with frame being in 802.3 format,
> +	 * link_id is used only for stats purpose and updating the stats on
> +	 * the deflink is fine?
> +	 */
> +	if (pubsta->mlo && status->link_id !=3D IEEE80211_LINK_UNSPECIFIED)
> +		rx.link_id =3D status->link_id;

If the driver *does* give a link ID, it better be valid?

OTOH, could there be races, e.g. while disabling a link?

johannes
