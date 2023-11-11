Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0458BC4167B
	for <linux-wireless@archiver.kernel.org>; Sat, 11 Nov 2023 00:58:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjKKA6C (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 10 Nov 2023 19:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjKKA6B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Nov 2023 19:58:01 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 415F1448C;
        Fri, 10 Nov 2023 16:57:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=x4QXI7bVNMeTlHpfe00+GeKDmQHX7YuFlvHKFeG+0Nw=;
        t=1699664278; x=1700873878; b=SbGV64Rzgkvj4nqN2yYahBTyqWbYa7DVTMncsRLJRo24GvX
        mCtniDPUP9sVN39/Aq/SKiSyZE6+a+qEuSdWDlzZnl0mPlh5Q3/m5JJZR0eGBCIzbj1AGw1pZV6EV
        0FgPuOF77NURWw0DXrvnb5Qn5fwx2T7IiBiaPe6mnLf46x0vSoOmeltNQ0Xx+tLzsw/ZF+jGmbqI/
        WcAuWSsWEZAL8Kn2blrBghplb8JCaG0j0pFNCK2hUUg0SBgvNJIqdeBL8xytr94oyT5Gy0EUcr9aB
        QK/g0EwyPCjwUuN+5zSbhZ7xL+MRVOfxRYyYXG0NTO2migWS4jGFfD/1EYKBq8LQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.97)
        (envelope-from <johannes@sipsolutions.net>)
        id 1r1cJu-00000003Jqc-48AE;
        Sat, 11 Nov 2023 01:57:55 +0100
Message-ID: <455eae9e8a583d1ea5b8a3c59e134b85538fff39.camel@sipsolutions.net>
Subject: Re: [PATCH] mwifiex: clean up some inconsistent indenting
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jeff Johnson <quic_jjohnson@quicinc.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        briannorris@chromium.org
Cc:     kvalo@kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Date:   Sat, 11 Nov 2023 01:57:53 +0100
In-Reply-To: <76eeb452-dd61-44ce-ae9c-a8f8afa83fb8@quicinc.com>
References: <20231110083327.7022-1-jiapeng.chong@linux.alibaba.com>
         <76eeb452-dd61-44ce-ae9c-a8f8afa83fb8@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2023-11-10 at 16:38 -0800, Jeff Johnson wrote:
> > drivers/net/wireless/marvell/mwifiex/sta_event.c:789 mwifiex_process_st=
a_event() warn: inconsistent indenting.
> >=20
> > Reported-by: Abaci Robot <abaci@linux.alibaba.com>

> >  		if (!adapter->pps_uapsd_mode &&
> >  		    (priv->port_open ||
> > -		     (priv->bss_mode =3D=3D NL80211_IFTYPE_ADHOC)) &&
> > +		    (priv->bss_mode =3D=3D NL80211_IFTYPE_ADHOC)) &&
>=20
> this change looks incorrect to me
> this condition is *inside* the parenthesis from the beginning of the
> previous line, and hence this should align after that parenthesis, not
> with that parenthesis, which is what the existing code is doing

Hah, you're right, I completely missed that! I guess someone should fix
their tools :)

johannes
