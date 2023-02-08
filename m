Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3664C636CC
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Feb 2023 09:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjBHJbU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 8 Feb 2023 04:31:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjBHJbF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2023 04:31:05 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D2E1BEF;
        Wed,  8 Feb 2023 01:30:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=s6dqzj8BA1XnHcN0WISnLb28suKP5Mg3V069llIvjTI=;
        t=1675848601; x=1677058201; b=x9CkNL02TGxhnfZ12hmsdT9AzZOq3EXr/wccBd4aUIffbjX
        ZnaVPL2T3XYfb+dCjOTlLyBliuXskz7fg/UKNCOocGCtM9kWDEB5Mrxbzsb6W+9VfunU9KAITXrcj
        ZUNCJ1CCJQXsBDLaY0l76nfJtPT1uQwqVnsyfWcYUyvPajAV9+cN8nVRrG4gxYTyWewUgwuEzMuc4
        swC6YCVAJjdE5AAoDWxvjgchMsu/K9UYOAs6wYSqroGA0nY2WfTWiSlNZ5G4GdhSspG729oHsZsYt
        WdGciCINC+Q0k/fgwAaetKDurPOH4GhYoLcLejgfQBNi5m2WxPoZcED2Sz4RuYPA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pPgm5-006RS0-1S;
        Wed, 08 Feb 2023 10:29:57 +0100
Message-ID: <ecc41929af982862720209eacfa935178a8e0a1b.camel@sipsolutions.net>
Subject: Re: hci0: Malformed MSFT vendor event: 0x02
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arda Demir <ddmirarda@gmail.com>, gregory.greenman@intel.com
Cc:     linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Date:   Wed, 08 Feb 2023 10:29:56 +0100
In-Reply-To: <CALDHRCt5KUezfEZCOWK+zYPM1hP32qwZqcoKw09ZjNw=oQoWKg@mail.gmail.com>
References: <CALDHRCt5KUezfEZCOWK+zYPM1hP32qwZqcoKw09ZjNw=oQoWKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2023-02-08 at 12:21 +0300, Arda Demir wrote:
> Hello,
>=20
> First of all, my bluetooth adapter is;
> 04:00.0 Network controller: Intel Corporation Wi-Fi 6 AX200 (rev 1a)

You've reached the Wi-Fi team here though - adding the BT list.

> I see the following message everytime when i boot the pc on tty.
>=20
> "Bluetooth: hci0: Malformed MSFT vendor event: 0x02"
>=20
> But bluetooth works well. If it is not critical it shouldn't print on
> tty, right?

That's generic from net/bluetooth/hci_event.c, not related to the device
(apart from the fact that the device might be broken if it's sending
this?)

johannes

