Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11253ECAAA1
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Sep 2022 09:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234080AbiIFJg3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Sep 2022 05:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiIFJg1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Sep 2022 05:36:27 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1796C65655
        for <linux-wireless@vger.kernel.org>; Tue,  6 Sep 2022 02:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=OwMpiQUXFqyozuzM2kQc6EZpGi0aoImyOXvtdY8QljA=;
        t=1662456986; x=1663666586; b=ivT1pXZw6O3WBewgNW19QfhcZjB9wX5gljXmCEdjNJ5AMNr
        DCT148H2gXqHECf8NPYrhdDAkG53QWNvymN83erYs1jtc9C9htDL6526wMcBpadkcCBhNnfeO310c
        0BlQSoTx2G/RV54xsfLXtEL39dR24xk+ZkoAcHoj0mBJhtyV7dO/VeUzOaBTUc4G0f76bdrIseZeh
        WR7EEGwMS2Tj7RT6yYEod0jqn5lSQR0Fm8B/HlIlfErhyKkj4i+XhYgxbzuM7gIusDicQMtoIQpe+
        sPDezu2uI8nlpMt+ykpehFZZUTbETlv3+PvVon6BCEwe1pxYD8Vbhh40xr67c3aA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oVV0I-009MSM-0V;
        Tue, 06 Sep 2022 11:36:22 +0200
Message-ID: <33a46d12583b540a921f6ce96065c9a177bd044d.camel@sipsolutions.net>
Subject: Re: [PATCH v3 01/12] cfg80211: regulatory: extend regulatory
 support for S1G
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kieran Frewen <kieran.frewen@morsemicro.com>
Cc:     linux-wireless@vger.kernel.org, quic_jjohnson@quicinc.com,
        kernel test robot <lkp@intel.com>
Date:   Tue, 06 Sep 2022 11:36:20 +0200
In-Reply-To: <20220906044812.7609-2-kieran.frewen@morsemicro.com>
References: <20220906044812.7609-1-kieran.frewen@morsemicro.com>
         <20220906044812.7609-2-kieran.frewen@morsemicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2022-09-06 at 16:48 +1200, Kieran Frewen wrote:
> Extend the S1G regulatory information to support all regulatory
> domains. An reg_s1g.h file is included containing structs with key
> regulatory class information. These structs were required to ensure
> the right combination of information was available to a series of
> functions which support the mapping between frequencies, bandwidths,
> and channels.
>=20

Hm. Isn't this type of thing something we'd usually want to keep in the
regulatory database to be able to update it? Who says JP will always
stick to their restrictive scheme, for example.

johannes
