Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C2C1C43334
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Jun 2022 07:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238412AbiFOHG5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Jun 2022 03:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiFOHG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Jun 2022 03:06:57 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF5FA167EE
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2022 00:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
        Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ejR15jOo17jAqwb9TH1ItkfDwb9HMdVRIrDnKZ/fF08=;
        t=1655276815; x=1656486415; b=UkBfRYmnKio3JIKO7lH60HmdLGlW4vma83UohZGXy/adWN6
        JG65gB6qrXpi4zp6B4CN3SygcXZTf+FcAiOR1gLlOOWuALqz0OcIgr7irWFvgD3W/rNJOPbSdxStR
        EKdg3ytKCnKKEqFgekLwGrGa9ySBu388wVlBuRc3nlPTgn2uIkgftK9817OT2y1LEIjgZ7/DexdID
        xLZvXXB1D3D2aiRo77nZZhkD9+g1e1zUloLi1MctsGUdw+AQDK8ILHjct/UCMm6usTzAu2BzC6taM
        ATC/w/MfRHcH2qeRsXkMMjFWB3Z2WN8YWQ1n1pKwq7Kp4hr9FYlZ9G6vC8Ny4ECw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1o1N76-006MFe-4Q;
        Wed, 15 Jun 2022 09:06:52 +0200
Message-ID: <fe88188dfe37050b097803a4ce175478a794208c.camel@sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: pcie: Fixed integer overflow in
 iwl_write_to_user_buf
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Hyunwoo Kim <imv4bel@gmail.com>, gregory.greenman@intel.com,
        linux-wireless@vger.kernel.org
Date:   Wed, 15 Jun 2022 09:06:51 +0200
In-Reply-To: <20220614173352.GA588327@ubuntu>
References: <20220614173352.GA588327@ubuntu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2022-06-14 at 10:33 -0700, Hyunwoo Kim wrote:
> An integer overflow occurs in the iwl_write_to_user_buf() function,
>    which is called by the iwl_dbgfs_monitor_data_read() function.
>=20

Out of curiosity, how did you find this?

johannes
