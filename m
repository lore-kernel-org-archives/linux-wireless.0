Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C36EE7E652
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Sep 2023 16:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbjIZQoN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Sep 2023 12:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231300AbjIZQoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2023 12:44:11 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56D7B3
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2023 09:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=COVzJlCjkIJzEAzNkBevFRzBhs8gP5wTdIzIYOr5xsM=;
        t=1695746644; x=1696956244; b=RzbzzZBE3tlOB/pnJHZJlJpIVcEjwxSAf/QBgUm/HMzDe20
        pZ/XdKru3ZkTaEC4UVzVhMA9HyVXbwxP397Z9vq/KUvgTagvbOnhI+M+TC1k2arRMjPwqQuE7xZVl
        Abbh5sG+OUs6j9Yd+mKvHmlDrdyt4kuoWj/ltOonOqTMUtFsx+QnXPyfnmIbpkOVtFX80xtNzsPqT
        mJFv7huk83OP4L5H2X8NCWzwHBnDtpM8e9InWmyLzBOJQcC554J/gr0DjdtSesbHjqYC1mdRhZNW9
        PTwuqCBloOMLCNwv9dQvhs8Xknm2QagLx+b7+ASUZ4qysq+Lx9sbLv1t9+SxszRQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qlBAD-005qwV-1s;
        Tue, 26 Sep 2023 18:43:57 +0200
Message-ID: <49b5de54ca00f5521ceaa8210f587f2af48d6835.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wifi: ath11k: mac: fix struct
 ieee80211_sband_iftype_data handling
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@kernel.org>, ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 26 Sep 2023 18:43:56 +0200
In-Reply-To: <20230926163350.2641064-1-kvalo@kernel.org>
References: <20230926163350.2641064-1-kvalo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2023-09-26 at 19:33 +0300, Kalle Valo wrote:
>=20
> -	he_mcs_map =3D le16_to_cpu(ath11k_mac_get_tx_mcs_map(&sband->iftype_dat=
a->he_cap));
> +	he_cap =3D ieee80211_get_he_iftype_cap_vif(sband, arvif->vif);
> +	he_mcs_map =3D le16_to_cpu(ath11k_mac_get_tx_mcs_map(he_cap));

Technically, ieee80211_get_he_iftype_cap_vif() could return NULL if you
didn't actually configure/enable HE for this iftype, the static checkers
might complain here.

johannes
