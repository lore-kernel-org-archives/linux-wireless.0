Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8408C61DA4
	for <linux-wireless@archiver.kernel.org>; Mon,  6 Mar 2023 16:59:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCFQ7X (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Mar 2023 11:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbjCFQ7W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Mar 2023 11:59:22 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71EF72B1;
        Mon,  6 Mar 2023 08:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=SxbMoQQPxHfcnBkJaY71vHmUIwCAJ+r28LHb2xDJ7o4=;
        t=1678121934; x=1679331534; b=VWQ+BGPo2ziiJXcDPZXcfuUJhIIxGZZI8EKb5YCvEmmC7mB
        mUIGJluYVJumauGz2ylXUE9804/pS9LLsmpqMXZR5+DkxI461orb6S/xPuQD1YXDX28ZCbx3c/OyG
        3C94JESa/ZrkilqFdiOE+D82PQSXNG+GjVCXxi6hJd7b0WbSfbJEbGwjo9wZpSbtG2qp5s//B2yWr
        Z/RrGarT7TYNg94VBw8HHTdAyXSlDFRLgnD0Onm57Qc6IGFQ/98tJyTRhHKusPEOOpNNv3q5HIpbi
        wfnHqQ1bCD961pPNIUtlCx/CoT+LX2JLd+wd0/Ax3PLFYb3M+Ow8GcxFo1vX/r5A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pZEAY-00DXYB-2j;
        Mon, 06 Mar 2023 17:58:38 +0100
Message-ID: <addaa95e4c2e840ac041efcedc99a235af90c6c1.camel@sipsolutions.net>
Subject: Re: [PATCH v8 1/5] mac80211_hwsim: add PMSR capability support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Simon Horman <simon.horman@corigine.com>,
        Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Date:   Mon, 06 Mar 2023 17:58:37 +0100
In-Reply-To: <ZAYa4oteaDVPGOLp@corigine.com>
References: <20230302160310.923349-1-jaewan@google.com>
         <20230302160310.923349-2-jaewan@google.com> <ZAYa4oteaDVPGOLp@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>=20
> > @@ -3186,6 +3218,7 @@ struct hwsim_new_radio_params {
> >  	u32 *ciphers;
> >  	u8 n_ciphers;
> >  	bool mlo;
> > +	const struct cfg80211_pmsr_capabilities *pmsr_capa;
>=20
> nit: not related to this patch,
>      but there are lots of holes in hwsim_new_radio_params.
>      And, I think that all fields, other than the new pmsr_capa field,
>      could fit into one cacheline on x86_64.
>=20
>      I'm unsure if it is worth cleaning up or not.
>=20

Probably not. It's just a temporary thing there, I don't think we even
have it for longer than temporarily on the stack.

johannes
